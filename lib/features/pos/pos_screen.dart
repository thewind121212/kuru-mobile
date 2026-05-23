// flutter_tabler_icons uses snake_case symbols.
// ignore_for_file: non_constant_identifier_names
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
import 'package:kuru_mobile/core/auth/auth_providers.dart';
import 'package:kuru_mobile/core/feedback/k_notify.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/design/core/input/k_text_field.dart';
import 'package:kuru_mobile/design/core/scanner/k_barcode_scan_button.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_list_filter.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_summary.dart';
import 'package:kuru_mobile/features/catalog/products/providers/product_providers.dart';
import 'package:kuru_mobile/features/orders/data/order_repository.dart';
import 'package:kuru_mobile/features/orders/models/order_line_item.dart';
import 'package:kuru_mobile/features/orders/models/order_payment_method.dart';
import 'package:kuru_mobile/features/orders/providers/order_providers.dart';
import 'package:kuru_mobile/features/pos/data/pos_barcode_repository.dart';

enum _PosView { sale, payment, success }

class PosScreen extends ConsumerStatefulWidget {
  const PosScreen({super.key});

  @override
  ConsumerState<PosScreen> createState() => _PosScreenState();
}

class _PosScreenState extends ConsumerState<PosScreen> {
  final _search = TextEditingController();
  final _amount = TextEditingController();
  _PosView _view = _PosView.sale;
  OrderPaymentMethod _method = OrderPaymentMethod.cash;
  bool _submitting = false;
  bool _barcodeLoading = false;
  String? _completedOrderId;
  String? _paymentRef;

  @override
  void initState() {
    super.initState();
    _search.addListener(_refresh);
    _amount.addListener(_refresh);
  }

  @override
  void dispose() {
    _search.removeListener(_refresh);
    _amount.removeListener(_refresh);
    _search.dispose();
    _amount.dispose();
    super.dispose();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  NumberFormat get _money =>
      NumberFormat.currency(locale: 'vi_VN', symbol: 'đ', decimalDigits: 0);

  String _format(double amount) => _money.format(amount);

  void _addProduct(ProductSummary product, {String? barcode}) {
    ref
        .read(orderCartProvider.notifier)
        .addLine(
          OrderLineItem(
            productId: product.id,
            productName: product.name,
            imageUrl: product.imageUrl,
            baseUnitCode: product.baseUnitCode,
            qty: 1,
            unitPrice: product.sellPricePerUnit.toDouble(),
            barcode: barcode,
          ),
        );
    _search.clear();
    HapticFeedback.selectionClick();
  }

  Future<void> _addBarcode(String barcode) async {
    final l = AppLocalizations.of(context);
    setState(() => _barcodeLoading = true);
    final result = await ref.read(posBarcodeRepositoryProvider).lookup(barcode);
    if (!mounted) return;
    setState(() => _barcodeLoading = false);
    switch (result) {
      case ApiSuccess<PosBarcodeLookup>(:final data):
        ref
            .read(orderCartProvider.notifier)
            .addLine(
              OrderLineItem(
                productId: data.productId,
                productName: data.productName,
                variantId: data.variantId,
                variantName: data.variantName,
                imageUrl: data.variantImageUrl ?? data.imageUrl,
                barcode: data.barcodeValue,
                baseUnitCode: data.baseUnitCode,
                qty: 1,
                unitPrice: data.uomSellPrice ?? data.sellPrice,
              ),
            );
        _search.clear();
        KNotify.success(context, l.posBarcodeAdded);
      case ApiFailure<PosBarcodeLookup>(:final err):
        _search.text = barcode;
        KNotify.warning(context, err.message);
    }
  }

  void _openPayment() {
    final totals = ref.read(orderCartTotalsProvider);
    if (totals.total <= 0 || ref.read(orderCartProvider).items.isEmpty) return;
    setState(() {
      _method = OrderPaymentMethod.cash;
      _amount.text = NumberFormat('#').format(totals.total);
      _paymentRef = null;
      _view = _PosView.payment;
    });
  }

  void _setMethod(OrderPaymentMethod method) {
    final totals = ref.read(orderCartTotalsProvider);
    setState(() {
      _method = method;
      if (method != OrderPaymentMethod.cash) {
        _amount.text = NumberFormat('#').format(totals.total);
      }
      if (method == OrderPaymentMethod.bankTransfer) {
        _paymentRef ??= _generatePaymentReference();
      }
    });
  }

  double _paymentAmount() {
    return double.tryParse(_amount.text.replaceAll(',', '').trim()) ?? 0;
  }

  Future<void> _submitPayment() async {
    final l = AppLocalizations.of(context);
    final cart = ref.read(orderCartProvider);
    final totals = ref.read(orderCartTotalsProvider);
    final orgId = ref.read(currentOrgIdProvider);
    if (cart.items.isEmpty || orgId == null || _submitting) return;
    final amount = _method == OrderPaymentMethod.cash
        ? _paymentAmount()
        : totals.total;
    if (amount <= 0) return;

    final orderRepo = ref.read(orderRepositoryProvider);
    ref
        .read(orderCartProvider.notifier)
        .ensureIdempotencyKey(orderRepo.newIdempotencyKey);
    final key = ref.read(orderCartProvider).idempotencyKey!;

    setState(() => _submitting = true);
    final result = await orderRepo.createOrder(
      orgId: orgId,
      idempotencyKey: key,
      draft: cart,
      payment: OrderPaymentInput(
        method: _method,
        amount: amount,
        reference: _method == OrderPaymentMethod.bankTransfer
            ? _paymentRef
            : null,
      ),
    );
    if (!mounted) return;
    setState(() => _submitting = false);
    switch (result) {
      case ApiSuccess<String>(:final data):
        ref.invalidate(orderListProvider);
        ref.read(orderCartProvider.notifier).clear();
        setState(() {
          _completedOrderId = data;
          _view = _PosView.success;
        });
      case ApiFailure<String>(:final err):
        final message = err.message.trim().isEmpty
            ? l.posPaymentFailed
            : err.message;
        KNotify.warning(context, message);
    }
  }

  void _newSale() {
    ref.read(orderCartProvider.notifier).clear();
    setState(() {
      _completedOrderId = null;
      _paymentRef = null;
      _search.clear();
      _amount.clear();
      _view = _PosView.sale;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final c = kuruColors(context);
    final title = switch (_view) {
      _PosView.sale => l.posTitle,
      _PosView.payment => l.posPayment,
      _PosView.success => l.posSuccess,
    };
    return Scaffold(
      backgroundColor: c.pageBg,
      appBar: AppBar(
        backgroundColor: c.pageBg,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          title,
          style: TextStyle(
            color: c.textPrimary,
            fontSize: 17,
            fontWeight: FontWeight.w800,
          ),
        ),
        leading: _view == _PosView.payment
            ? IconButton(
                tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                icon: const Icon(TablerIcons.arrow_left),
                onPressed: () => setState(() => _view = _PosView.sale),
              )
            : null,
        actions: [
          if (_view == _PosView.sale)
            IconButton(
              tooltip: l.posViewOrders,
              icon: const Icon(TablerIcons.receipt),
              onPressed: () => context.go('/orders'),
            ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: switch (_view) {
          _PosView.sale => _SaleView(
            search: _search,
            barcodeLoading: _barcodeLoading,
            onScan: _addBarcode,
            onAddProduct: _addProduct,
            onCharge: _openPayment,
            format: _format,
          ),
          _PosView.payment => _PaymentView(
            method: _method,
            amount: _amount,
            paymentRef: _paymentRef,
            submitting: _submitting,
            onMethodChanged: _setMethod,
            onSubmit: _submitPayment,
            onAmountChanged: () => setState(() {}),
            format: _format,
          ),
          _PosView.success => _SuccessView(
            orderId: _completedOrderId,
            onNewSale: _newSale,
          ),
        },
      ),
    );
  }
}

class _SaleView extends ConsumerWidget {
  const _SaleView({
    required this.search,
    required this.barcodeLoading,
    required this.onScan,
    required this.onAddProduct,
    required this.onCharge,
    required this.format,
  });

  final TextEditingController search;
  final bool barcodeLoading;
  final ValueChanged<String> onScan;
  final void Function(ProductSummary product, {String? barcode}) onAddProduct;
  final VoidCallback onCharge;
  final String Function(double amount) format;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final c = kuruColors(context);
    final query = search.text.trim();
    final cart = ref.watch(orderCartProvider);
    final totals = ref.watch(orderCartTotalsProvider);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
          child: KTextField(
            label: l.posSearchLabel,
            controller: search,
            placeholder: l.posSearchHint,
            leadingIcon: const Icon(TablerIcons.search),
            trailingIcon: barcodeLoading
                ? const Padding(
                    padding: EdgeInsets.all(14),
                    child: SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : KBarcodeScanButton(
                    onScan: onScan,
                    tooltip: l.posScanBarcode,
                    title: l.posScanBarcode,
                    hint: l.posScanHint,
                  ),
            textInputAction: TextInputAction.search,
          ),
        ),
        Expanded(
          child: ListView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            children: [
              if (query.isEmpty)
                _EmptySearchPanel()
              else
                _ProductResults(
                  query: query,
                  format: format,
                  onAdd: onAddProduct,
                ),
              const SizedBox(height: 18),
              _CartPanel(format: format),
              const SizedBox(height: 12),
              if (cart.items.isEmpty)
                Text(
                  l.posCartHint,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: c.textMuted,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
        ),
        _ChargeBar(
          itemCount: cart.items.length,
          total: totals.total,
          onCharge: onCharge,
          format: format,
        ),
      ],
    );
  }
}

class _ProductResults extends ConsumerWidget {
  const _ProductResults({
    required this.query,
    required this.format,
    required this.onAdd,
  });

  final String query;
  final String Function(double amount) format;
  final void Function(ProductSummary product, {String? barcode}) onAdd;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final c = kuruColors(context);
    final products = ref.watch(
      productListProvider(ProductListFilter(search: query)),
    );
    return products.when(
      data: (page) {
        if (page.items.isEmpty) return _PlainState(text: l.posNoProducts);
        return Container(
          decoration: BoxDecoration(
            color: c.surfaceElev,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: c.borderSoft),
          ),
          child: Column(
            children: [
              for (var i = 0; i < math.min(page.items.length, 12); i++) ...[
                _ProductRow(
                  product: page.items[i],
                  format: format,
                  onTap: () => onAdd(page.items[i]),
                ),
                if (i < math.min(page.items.length, 12) - 1)
                  Divider(height: 1, thickness: 0.5, color: c.borderSoft),
              ],
            ],
          ),
        );
      },
      loading: () => const _PlainState(loading: true),
      error: (e, _) => _PlainState(text: '$e'),
    );
  }
}

class _ProductRow extends StatelessWidget {
  const _ProductRow({
    required this.product,
    required this.format,
    required this.onTap,
  });

  final ProductSummary product;
  final String Function(double amount) format;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final stock = product.currentStock;
    final stockDigits = stock.truncateToDouble() == stock ? 0 : 2;
    final stockLabel = stock.toStringAsFixed(stockDigits);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: c.pageBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: product.hasImage
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          product.imageUrl!,
                          fit: BoxFit.cover,
                          width: 42,
                          height: 42,
                          errorBuilder: (_, __, ___) =>
                              Icon(TablerIcons.package, color: c.textMuted),
                        ),
                      )
                    : Icon(TablerIcons.package, color: c.textMuted),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: c.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${format(product.sellPricePerUnit.toDouble())} · '
                      '$stockLabel ${product.baseUnitCode}',
                      style: TextStyle(
                        color: c.textMuted,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Icon(TablerIcons.plus, color: c.accent600, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _CartPanel extends ConsumerWidget {
  const _CartPanel({required this.format});

  final String Function(double amount) format;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final c = kuruColors(context);
    final cart = ref.watch(orderCartProvider);
    final notifier = ref.read(orderCartProvider.notifier);
    return Container(
      decoration: BoxDecoration(
        color: c.surfaceElev,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: c.borderSoft),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 13, 14, 10),
            child: Row(
              children: [
                Icon(TablerIcons.shopping_cart, color: c.accent600, size: 19),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${l.posCart} (${cart.items.length})',
                    style: TextStyle(
                      color: c.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                if (cart.items.isNotEmpty)
                  TextButton(
                    onPressed: notifier.clear,
                    child: Text(l.posClearCart),
                  ),
              ],
            ),
          ),
          if (cart.items.isEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 22, 16, 28),
              child: _PlainState(text: l.posEmptyCart),
            )
          else
            for (var i = 0; i < cart.items.length; i++) ...[
              _CartRow(
                item: cart.items[i],
                format: format,
                onIncrement: () => notifier.updateLineAt(
                  i,
                  cart.items[i].copyWith(qty: cart.items[i].qty + 1),
                ),
                onDecrement: () {
                  final nextQty = cart.items[i].qty - 1;
                  if (nextQty <= 0) {
                    notifier.removeLineAt(i);
                  } else {
                    notifier.updateLineAt(
                      i,
                      cart.items[i].copyWith(qty: nextQty),
                    );
                  }
                },
                onRemove: () => notifier.removeLineAt(i),
              ),
              if (i < cart.items.length - 1)
                Divider(height: 1, thickness: 0.5, color: c.borderSoft),
            ],
        ],
      ),
    );
  }
}

class _CartRow extends StatelessWidget {
  const _CartRow({
    required this.item,
    required this.format,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  });

  final OrderLineItem item;
  final String Function(double amount) format;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final qty = item.qty == item.qty.truncate()
        ? item.qty.toStringAsFixed(0)
        : item.qty.toStringAsFixed(2);
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: c.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '$qty x ${format(item.unitPrice)}',
                  style: TextStyle(
                    color: c.textMuted,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          _QtyButton(icon: TablerIcons.minus, onPressed: onDecrement),
          SizedBox(
            width: 34,
            child: Text(
              qty,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: c.textPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          _QtyButton(icon: TablerIcons.plus, onPressed: onIncrement),
          IconButton(
            tooltip: AppLocalizations.of(context).posRemoveLine,
            icon: Icon(TablerIcons.trash, color: c.danger, size: 19),
            onPressed: onRemove,
          ),
        ],
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  const _QtyButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return IconButton.filledTonal(
      icon: Icon(icon, size: 17),
      onPressed: onPressed,
      style: IconButton.styleFrom(
        backgroundColor: c.pageBg,
        foregroundColor: c.textPrimary,
        minimumSize: const Size.square(34),
        fixedSize: const Size.square(34),
        padding: EdgeInsets.zero,
      ),
    );
  }
}

class _ChargeBar extends StatelessWidget {
  const _ChargeBar({
    required this.itemCount,
    required this.total,
    required this.onCharge,
    required this.format,
  });

  final int itemCount;
  final double total;
  final VoidCallback onCharge;
  final String Function(double amount) format;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final c = kuruColors(context);
    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        12 + MediaQuery.paddingOf(context).bottom,
      ),
      decoration: BoxDecoration(
        color: c.surfaceElev,
        border: Border(top: BorderSide(color: c.borderSoft)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l.posTotal,
                  style: TextStyle(
                    color: c.textMuted,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  format(total),
                  style: TextStyle(
                    color: c.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          FilledButton.icon(
            onPressed: itemCount == 0 ? null : onCharge,
            icon: const Icon(TablerIcons.cash),
            label: Text(l.posCharge),
            style: FilledButton.styleFrom(
              minimumSize: const Size(132, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentView extends ConsumerWidget {
  const _PaymentView({
    required this.method,
    required this.amount,
    required this.paymentRef,
    required this.submitting,
    required this.onMethodChanged,
    required this.onSubmit,
    required this.onAmountChanged,
    required this.format,
  });

  final OrderPaymentMethod method;
  final TextEditingController amount;
  final String? paymentRef;
  final bool submitting;
  final ValueChanged<OrderPaymentMethod> onMethodChanged;
  final VoidCallback onSubmit;
  final VoidCallback onAmountChanged;
  final String Function(double amount) format;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final c = kuruColors(context);
    final totals = ref.watch(orderCartTotalsProvider);
    final paid = method == OrderPaymentMethod.cash
        ? double.tryParse(amount.text.replaceAll(',', '').trim()) ?? 0
        : totals.total;
    final change = method == OrderPaymentMethod.cash
        ? math.max<double>(0, paid - totals.total)
        : 0.0;
    final remaining = math.max<double>(0, totals.total - paid);
    return ListView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        _PaymentTotal(total: totals.total, format: format),
        const SizedBox(height: 18),
        _MethodPicker(value: method, onChanged: onMethodChanged),
        const SizedBox(height: 18),
        if (method == OrderPaymentMethod.cash) ...[
          KTextField(
            label: l.posAmountReceived,
            controller: amount,
            keyboardType: TextInputType.number,
            leadingIcon: const Icon(TablerIcons.cash),
            onSubmitted: (_) => onAmountChanged(),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final pick in _quickPicks(totals.total))
                ActionChip(
                  label: Text(format(pick)),
                  onPressed: () {
                    amount.text = NumberFormat('#').format(pick);
                    onAmountChanged();
                  },
                ),
            ],
          ),
          if (change > 0) ...[
            const SizedBox(height: 14),
            _PaymentInfoRow(
              label: l.posChange,
              value: format(change),
              positive: true,
            ),
          ],
          if (remaining > 0 && paid > 0) ...[
            const SizedBox(height: 14),
            _PaymentInfoRow(label: l.posRemaining, value: format(remaining)),
          ],
        ] else if (method == OrderPaymentMethod.bankTransfer &&
            paymentRef != null) ...[
          _ReferenceBox(reference: paymentRef!),
        ],
        const SizedBox(height: 24),
        FilledButton.icon(
          onPressed: submitting || paid <= 0 ? null : onSubmit,
          icon: submitting
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(TablerIcons.check),
          label: Text(l.posConfirmPayment),
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          l.posPaymentNote,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: c.textMuted,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _PaymentTotal extends StatelessWidget {
  const _PaymentTotal({required this.total, required this.format});

  final double total;
  final String Function(double amount) format;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final c = kuruColors(context);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: c.surfaceElev,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: c.borderSoft),
      ),
      child: Column(
        children: [
          Text(
            l.posTotal,
            style: TextStyle(
              color: c.textMuted,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            format(total),
            style: TextStyle(
              color: c.textPrimary,
              fontSize: 30,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _MethodPicker extends StatelessWidget {
  const _MethodPicker({required this.value, required this.onChanged});

  final OrderPaymentMethod value;
  final ValueChanged<OrderPaymentMethod> onChanged;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return SegmentedButton<OrderPaymentMethod>(
      segments: [
        ButtonSegment(
          value: OrderPaymentMethod.cash,
          icon: const Icon(TablerIcons.cash),
          label: Text(l.orderPaymentMethodCash),
        ),
        ButtonSegment(
          value: OrderPaymentMethod.bankTransfer,
          icon: const Icon(TablerIcons.building_bank),
          label: Text(l.orderPaymentMethodBankTransfer),
        ),
        ButtonSegment(
          value: OrderPaymentMethod.card,
          icon: const Icon(TablerIcons.credit_card),
          label: Text(l.orderPaymentMethodCard),
        ),
        ButtonSegment(
          value: OrderPaymentMethod.other,
          icon: const Icon(TablerIcons.dots),
          label: Text(l.orderPaymentMethodOther),
        ),
      ],
      selected: {value},
      onSelectionChanged: (values) => onChanged(values.first),
      showSelectedIcon: false,
      style: const ButtonStyle(visualDensity: VisualDensity.compact),
    );
  }
}

class _PaymentInfoRow extends StatelessWidget {
  const _PaymentInfoRow({
    required this.label,
    required this.value,
    this.positive = false,
  });

  final String label;
  final String value;
  final bool positive;

  @override
  Widget build(BuildContext context) {
    final color = positive ? const Color(0xFF047857) : const Color(0xFFB45309);
    final bg = positive ? const Color(0xFFE6F7F0) : const Color(0xFFFEF6E5);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 17,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReferenceBox extends StatelessWidget {
  const _ReferenceBox({required this.reference});

  final String reference;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final c = kuruColors(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: c.surfaceElev,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: c.borderSoft),
      ),
      child: Row(
        children: [
          Icon(TablerIcons.qrcode, color: c.accent600),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.posPaymentReference,
                  style: TextStyle(
                    color: c.textMuted,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  reference,
                  style: TextStyle(
                    color: c.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SuccessView extends StatelessWidget {
  const _SuccessView({required this.orderId, required this.onNewSale});

  final String? orderId;
  final VoidCallback onNewSale;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final c = kuruColors(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 78,
              height: 78,
              decoration: BoxDecoration(
                color: const Color(0xFFE6F7F0),
                borderRadius: BorderRadius.circular(24),
              ),
              alignment: Alignment.center,
              child: const Icon(
                TablerIcons.circle_check,
                size: 42,
                color: Color(0xFF047857),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              l.posSuccessTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: c.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l.posSuccessBody,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: c.textMuted,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 22),
            FilledButton.icon(
              onPressed: onNewSale,
              icon: const Icon(TablerIcons.plus),
              label: Text(l.posNewSale),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: orderId == null
                  ? null
                  : () => context.go('/orders/$orderId'),
              icon: const Icon(TablerIcons.receipt),
              label: Text(l.posViewOrder),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptySearchPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final c = kuruColors(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 18),
      decoration: BoxDecoration(
        color: c.surfaceElev,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: c.borderSoft),
      ),
      child: Column(
        children: [
          Icon(TablerIcons.barcode, size: 34, color: c.textMuted),
          const SizedBox(height: 10),
          Text(
            l.posEmptySearch,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: c.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l.posEmptySearchMeta,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: c.textMuted,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _PlainState extends StatelessWidget {
  const _PlainState({this.text, this.loading = false});

  final String? text;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    if (loading) {
      return const SizedBox(
        height: 86,
        child: Center(child: CircularProgressIndicator()),
      );
    }
    return SizedBox(
      height: 86,
      child: Center(
        child: Text(
          text ?? '',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: c.textMuted,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

List<double> _quickPicks(double total) {
  if (total <= 0) return const [];
  const bills = [10000, 20000, 50000, 100000, 200000, 500000];
  final picks = <double>{total};
  for (final bill in bills) {
    final rounded = (total / bill).ceil() * bill.toDouble();
    if (rounded > total) picks.add(rounded);
  }
  return picks.toList()..sort();
}

String _generatePaymentReference() {
  final now = DateTime.now();
  final date =
      '${(now.year % 100).toString().padLeft(2, '0')}'
      '${now.month.toString().padLeft(2, '0')}'
      '${now.day.toString().padLeft(2, '0')}';
  const alphabet = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
  final rng = math.Random.secure();
  final suffix = List.generate(
    6,
    (_) => alphabet[rng.nextInt(alphabet.length)],
  ).join();
  return 'DH$date$suffix';
}
