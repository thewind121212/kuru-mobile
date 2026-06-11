// flutter_tabler_icons uses snake_case symbols.
// ignore_for_file: non_constant_identifier_names
import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
import 'package:kuru_mobile/core/auth/auth_providers.dart';
import 'package:kuru_mobile/core/env/env.dart';
import 'package:kuru_mobile/core/feedback/k_notify.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/design/core/input/k_currency_field.dart';
import 'package:kuru_mobile/design/core/scanner/k_barcode_scanner_sheet.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_detail.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_list_filter.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_summary.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_variant.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_warehouse_option.dart';
import 'package:kuru_mobile/features/catalog/products/providers/product_providers.dart';
import 'package:kuru_mobile/features/main_shell/kuru_bottom_nav.dart';
import 'package:kuru_mobile/features/orders/data/order_repository.dart';
import 'package:kuru_mobile/features/orders/models/discount_type.dart';
import 'package:kuru_mobile/features/orders/models/order_cart_totals.dart';
import 'package:kuru_mobile/features/orders/models/order_line_item.dart';
import 'package:kuru_mobile/features/orders/models/order_payment_method.dart';
import 'package:kuru_mobile/features/orders/providers/order_providers.dart';
import 'package:kuru_mobile/features/pos/data/pos_barcode_repository.dart';
import 'package:kuru_mobile/features/pos/data/pos_customer_display_repository.dart';
import 'package:kuru_mobile/features/pos/data/pos_payment_qr_repository.dart';
import 'package:kuru_mobile/features/pos/providers/pos_branch_provider.dart';
import 'package:kuru_mobile/features/pos/providers/pos_customer_display_providers.dart';
import 'package:lottie/lottie.dart';

enum _PosView { sale, payment, success }

String? _resolveProductImageUrl(String? imageUrl) {
  final raw = imageUrl?.trim();
  if (raw == null || raw.isEmpty) return null;
  if (raw.startsWith('http://') || raw.startsWith('https://')) return raw;
  return '${Env.imageBaseUrl}/product-avatar/$raw';
}

String _productDetailPath(String productId, {String? variantId}) {
  final rawVariantId = variantId?.trim();
  if (rawVariantId != null && rawVariantId.isNotEmpty) {
    return '/products/$productId/variants/$rawVariantId';
  }
  return '/products/$productId';
}

class PosScreen extends ConsumerStatefulWidget {
  const PosScreen({super.key});

  @override
  ConsumerState<PosScreen> createState() => _PosScreenState();
}

class _PosScreenState extends ConsumerState<PosScreen> {
  final _search = TextEditingController();
  final _amount = TextEditingController();
  final _saleScroll = ScrollController();
  _PosView _view = _PosView.sale;
  OrderPaymentMethod _method = OrderPaymentMethod.cash;
  bool _submitting = false;
  bool _barcodeLoading = false;
  String? _completedOrderId;
  String? _paymentRef;
  PosPaymentQr? _paymentQr;
  bool _paymentQrLoading = false;
  String? _paymentQrError;
  bool _displayInUse = false;
  bool _displayChecking = false;
  Timer? _displayDebounce;
  Timer? _displayHeartbeat;
  String? _mirroredDisplayTerminalId;
  String? _checkedDisplayTerminalId;

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
    _displayDebounce?.cancel();
    _displayHeartbeat?.cancel();
    _search.dispose();
    _amount.dispose();
    _saleScroll.dispose();
    super.dispose();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  NumberFormat get _money =>
      NumberFormat.currency(locale: 'vi_VN', symbol: 'đ', decimalDigits: 0);

  String _format(double amount) => _money.format(amount);

  String? _selectedDisplayTerminalId() {
    final branchId = _effectiveBranchId(
      ref.read(productWarehouseOptionsProvider).valueOrNull,
      ref.read(posSelectedBranchIdProvider),
    );
    if (branchId == null) return null;
    final selected = ref.read(posSelectedTerminalIdProvider(branchId));
    if (selected == null || selected.isEmpty) return null;
    return selected;
  }

  void _cancelDisplaySync() {
    _displayDebounce?.cancel();
    _displayDebounce = null;
    _displayHeartbeat?.cancel();
    _displayHeartbeat = null;
  }

  void _scheduleDisplayPush() {
    _displayDebounce?.cancel();
    _displayHeartbeat?.cancel();
    final terminalId = _selectedDisplayTerminalId();
    final cart = ref.read(orderCartProvider);
    final previousTerminalId = _mirroredDisplayTerminalId;
    if (previousTerminalId != null && previousTerminalId != terminalId) {
      unawaited(_releaseDisplayTerminal(previousTerminalId));
      _mirroredDisplayTerminalId = null;
      _checkedDisplayTerminalId = null;
    }
    if (_view != _PosView.sale || terminalId == null) {
      if (mounted && (_displayInUse || _displayChecking)) {
        setState(() {
          _displayInUse = false;
          _displayChecking = false;
        });
      }
      return;
    }
    if (_checkedDisplayTerminalId != null &&
        _checkedDisplayTerminalId != terminalId) {
      _checkedDisplayTerminalId = null;
    }
    final needsOwnershipCheck = _checkedDisplayTerminalId != terminalId;
    if (needsOwnershipCheck && mounted && !_displayChecking) {
      setState(() => _displayChecking = true);
    }
    _mirroredDisplayTerminalId = terminalId;

    _displayDebounce = Timer(const Duration(milliseconds: 350), () {
      _pushDisplayCart(takeOver: false);
    });

    if (cart.items.isNotEmpty) {
      _displayHeartbeat = Timer.periodic(const Duration(seconds: 30), (_) {
        _pushDisplayCart(takeOver: false);
      });
    }
  }

  Future<void> _pushDisplayCart({required bool takeOver}) async {
    if (!mounted || _view != _PosView.sale) return;
    final terminalId = _selectedDisplayTerminalId();
    if (terminalId == null) return;
    final needsOwnershipCheck =
        takeOver || _checkedDisplayTerminalId != terminalId;
    if (needsOwnershipCheck && !_displayChecking) {
      setState(() => _displayChecking = true);
    }
    _mirroredDisplayTerminalId = terminalId;
    final cart = ref.read(orderCartProvider);
    final totals = ref.read(orderCartTotalsProvider);
    final result = await _sendDisplayCart(
      terminalId: terminalId,
      items: cart.items.map(_displayCartItemFromLine).toList(),
      subtotal: totals.subtotal,
      discount: totals.orderDiscountAmount,
      total: totals.total,
      takeOver: takeOver,
      customerName: cart.customerName,
    );
    if (!mounted) return;
    if (result == null) {
      setState(() => _displayChecking = false);
      return;
    }
    _checkedDisplayTerminalId = terminalId;
    if (cart.items.isEmpty) {
      _mirroredDisplayTerminalId = result.accepted ? null : terminalId;
      setState(() {
        _displayInUse = !result.accepted;
        _displayChecking = false;
      });
      return;
    }
    setState(() {
      _displayInUse = !result.accepted;
      _displayChecking = false;
    });
  }

  Future<void> _releaseDisplayTerminal(String terminalId) async {
    final trimmed = terminalId.trim();
    if (trimmed.isEmpty) return;
    await _sendDisplayCart(
      terminalId: trimmed,
      items: const [],
      subtotal: 0,
      discount: 0,
      total: 0,
      takeOver: false,
    );
  }

  Future<PosDisplayPushResult?> _sendDisplayCart({
    required String terminalId,
    required List<PosDisplayCartItem> items,
    required double subtotal,
    required double discount,
    required double total,
    required bool takeOver,
    String? customerName,
  }) async {
    final result = await ref
        .read(posCustomerDisplayRepositoryProvider)
        .pushCart(
          terminalId: terminalId,
          items: items,
          subtotal: subtotal,
          discount: discount,
          total: total,
          sessionId: ref.read(posDisplaySessionIdProvider),
          takeOver: takeOver,
          customerName: customerName,
        );
    switch (result) {
      case ApiSuccess<PosDisplayPushResult>(:final data):
        return data;
      case ApiFailure<PosDisplayPushResult>():
        return null;
    }
  }

  PosDisplayCartItem _displayCartItemFromLine(OrderLineItem item) {
    final rawVariantId = item.variantId ?? '';
    return PosDisplayCartItem(
      id: '${item.productId}:$rawVariantId',
      name: item.productName,
      qty: item.qty,
      unitPrice: item.unitPrice,
      lineTotal: computeLineTotal(item),
      imageUrl: item.imageUrl,
      variant: item.variantName,
    );
  }

  void _addLine(OrderLineItem item) {
    ref.read(orderCartProvider.notifier).addLine(item);
    _search.clear();
    HapticFeedback.selectionClick();
    _scrollSaleToCartEnd();
  }

  void _scrollSaleToCartEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_saleScroll.hasClients) return;
      final target = _saleScroll.position.maxScrollExtent;
      _saleScroll.animateTo(
        target,
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
      );
    });
  }

  Future<void> _addProduct(ProductSummary product, {String? barcode}) async {
    if (product.variantCount <= 0) {
      _addLine(
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
      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();
    final result = await ref
        .read(productRepositoryProvider)
        .getById(product.id);
    if (!mounted) return;

    switch (result) {
      case ApiSuccess<ProductDetail>(:final data):
        final customVariants = data.variants
            .where((variant) => !variant.isDefault)
            .toList();
        final variants = customVariants.isEmpty
            ? data.variants
            : customVariants;
        if (variants.isEmpty) {
          _addLine(
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
          return;
        }

        if (variants.length == 1) {
          final selected = variants.single;
          _addLine(
            OrderLineItem(
              productId: data.id,
              productName: data.name,
              variantId: selected.id,
              variantName: selected.name,
              imageUrl: selected.imageUrl ?? data.imageUrl ?? product.imageUrl,
              barcode: selected.barcode ?? barcode,
              baseUnitCode: data.baseUnitCode,
              qty: 1,
              unitPrice: (selected.sellPrice ?? data.sellPrice).toDouble(),
            ),
          );
          return;
        }

        final selected = await _showVariantPicker(data, variants);
        if (!mounted || selected == null) return;
        _addLine(
          OrderLineItem(
            productId: data.id,
            productName: data.name,
            variantId: selected.id,
            variantName: selected.name,
            imageUrl: selected.imageUrl ?? data.imageUrl ?? product.imageUrl,
            barcode: selected.barcode ?? barcode,
            baseUnitCode: data.baseUnitCode,
            qty: 1,
            unitPrice: (selected.sellPrice ?? data.sellPrice).toDouble(),
          ),
        );
      case ApiFailure<ProductDetail>(:final err):
        KNotify.warning(context, err.message);
    }
  }

  Future<ProductVariant?> _showVariantPicker(
    ProductDetail product,
    List<ProductVariant> variants,
  ) {
    final c = kuruColors(context);
    return showModalBottomSheet<ProductVariant>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: c.surfaceElev,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.78,
      ),
      builder: (sheetContext) {
        return _ProductVariantPickerSheet(
          product: product,
          variants: variants,
          format: _format,
        );
      },
    );
  }

  Future<void> _addBarcode(String barcode) async {
    final l = AppLocalizations.of(context);
    setState(() => _barcodeLoading = true);
    final result = await ref.read(posBarcodeRepositoryProvider).lookup(barcode);
    if (!mounted) return;
    setState(() => _barcodeLoading = false);
    switch (result) {
      case ApiSuccess<PosBarcodeLookup>(:final data):
        _addLine(
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
        KNotify.success(context, l.posBarcodeAdded);
      case ApiFailure<PosBarcodeLookup>(:final err):
        _search.text = barcode;
        KNotify.warning(context, err.message);
    }
  }

  void _openPayment() {
    final l = AppLocalizations.of(context);
    final totals = ref.read(orderCartTotalsProvider);
    if (totals.total <= 0 || ref.read(orderCartProvider).items.isEmpty) return;
    final branchId = _effectiveBranchId(
      ref.read(productWarehouseOptionsProvider).valueOrNull,
      ref.read(posSelectedBranchIdProvider),
    );
    if (branchId == null) {
      KNotify.warning(context, l.posBranchRequired);
      return;
    }
    final terminals = ref
        .read(posDisplayTerminalsProvider(branchId))
        .valueOrNull;
    final selectedTerminalId = ref.read(
      posSelectedTerminalIdProvider(branchId),
    );
    if ((terminals?.length ?? 0) >= 2 && selectedTerminalId == null) {
      KNotify.warning(context, l.posDisplaySelectRequired);
      return;
    }
    _cancelDisplaySync();
    setState(() {
      _method = OrderPaymentMethod.cash;
      _amount.text = NumberFormat('#').format(totals.total);
      _paymentRef = null;
      _paymentQr = null;
      _paymentQrLoading = false;
      _paymentQrError = null;
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
        _paymentQr = null;
        _paymentQrError = null;
      } else {
        _paymentQr = null;
        _paymentQrLoading = false;
        _paymentQrError = null;
      }
    });
    if (method == OrderPaymentMethod.bankTransfer) {
      _loadPaymentQr(totals.total);
    }
  }

  Future<void> _loadPaymentQr(double amount) async {
    final orgId = ref.read(currentOrgIdProvider);
    final refNumber = _paymentRef;
    if (orgId == null || refNumber == null || refNumber.isEmpty) return;
    setState(() {
      _paymentQrLoading = true;
      _paymentQrError = null;
    });
    final result = await ref
        .read(posPaymentQrRepositoryProvider)
        .generate(orgId: orgId, refNumber: refNumber, amount: amount);
    if (!mounted || _paymentRef != refNumber) return;
    switch (result) {
      case ApiSuccess<PosPaymentQr>(:final data):
        setState(() {
          _paymentQr = data;
          _paymentQrLoading = false;
        });
      case ApiFailure<PosPaymentQr>(:final err):
        setState(() {
          _paymentQr = null;
          _paymentQrLoading = false;
          _paymentQrError = err.message;
        });
        KNotify.warning(context, err.message);
    }
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
    final branchId = _effectiveBranchId(
      ref.read(productWarehouseOptionsProvider).valueOrNull,
      ref.read(posSelectedBranchIdProvider),
    );
    if (branchId == null) {
      KNotify.warning(context, l.posBranchRequired);
      return;
    }
    final selectedTerminalId = ref.read(
      posSelectedTerminalIdProvider(branchId),
    );
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
      storeId: branchId,
      terminalId: selectedTerminalId == null || selectedTerminalId.isEmpty
          ? null
          : selectedTerminalId,
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
        final releaseTerminalId =
            selectedTerminalId == null || selectedTerminalId.isEmpty
            ? _mirroredDisplayTerminalId
            : selectedTerminalId;
        _cancelDisplaySync();
        _mirroredDisplayTerminalId = null;
        ref.read(orderCartProvider.notifier).clear();
        if (releaseTerminalId != null && releaseTerminalId.isNotEmpty) {
          unawaited(_releaseDisplayTerminal(releaseTerminalId));
        }
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
      _paymentQr = null;
      _paymentQrLoading = false;
      _paymentQrError = null;
      _search.clear();
      _amount.clear();
      _view = _PosView.sale;
    });
    _scheduleDisplayPush();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(orderCartProvider, (_, __) {
      if (_view == _PosView.sale) _scheduleDisplayPush();
    });
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
                onPressed: () {
                  setState(() => _view = _PosView.sale);
                  _scheduleDisplayPush();
                },
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
        bottom: false,
        child: switch (_view) {
          _PosView.sale => _SaleView(
            search: _search,
            scrollController: _saleScroll,
            barcodeLoading: _barcodeLoading,
            displayInUse: _displayInUse,
            displayChecking: _displayChecking,
            onScan: _addBarcode,
            onAddProduct: _addProduct,
            onCharge: _openPayment,
            onDisplayChanged: _scheduleDisplayPush,
            onTakeOverDisplay: () => _pushDisplayCart(takeOver: true),
            format: _format,
          ),
          _PosView.payment => _PaymentView(
            method: _method,
            amount: _amount,
            paymentRef: _paymentRef,
            paymentQr: _paymentQr,
            paymentQrLoading: _paymentQrLoading,
            paymentQrError: _paymentQrError,
            submitting: _submitting,
            onMethodChanged: _setMethod,
            onSubmit: _submitPayment,
            onRetryQr: () =>
                _loadPaymentQr(ref.read(orderCartTotalsProvider).total),
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
    required this.scrollController,
    required this.barcodeLoading,
    required this.displayInUse,
    required this.displayChecking,
    required this.onScan,
    required this.onAddProduct,
    required this.onCharge,
    required this.onDisplayChanged,
    required this.onTakeOverDisplay,
    required this.format,
  });

  final TextEditingController search;
  final ScrollController scrollController;
  final bool barcodeLoading;
  final bool displayInUse;
  final bool displayChecking;
  final ValueChanged<String> onScan;
  final Future<void> Function(ProductSummary product, {String? barcode})
  onAddProduct;
  final VoidCallback onCharge;
  final VoidCallback onDisplayChanged;
  final VoidCallback onTakeOverDisplay;
  final String Function(double amount) format;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final c = kuruColors(context);
    final query = search.text.trim();
    final cart = ref.watch(orderCartProvider);
    final totals = ref.watch(orderCartTotalsProvider);
    final branches = ref.watch(productWarehouseOptionsProvider);
    final selectedBranchId = ref.watch(posSelectedBranchIdProvider);
    final effectiveBranch = _effectiveBranch(
      branches.valueOrNull,
      selectedBranchId,
    );
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
          child: Column(
            children: [
              _BranchSelector(
                branches: branches,
                selectedBranch: effectiveBranch,
                onBranchChanged: onDisplayChanged,
              ),
              const SizedBox(height: 8),
              _DisplaySelector(
                branch: effectiveBranch,
                displayInUse: displayInUse,
                displayChecking: displayChecking,
                onChanged: onDisplayChanged,
                onTakeOver: onTakeOverDisplay,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
          child: _PosInputField(
            hint: l.posSearchHint,
            controller: search,
            leadingIcon: const Icon(TablerIcons.search),
            trailingIcon: IconButton(
              tooltip: l.posScanPrimary,
              icon: Icon(TablerIcons.barcode, color: c.accent600),
              onPressed: barcodeLoading
                  ? null
                  : () async {
                      final value = await showKBarcodeScannerSheet(
                        context,
                        title: l.posScanBarcode,
                        hint: l.posScanHint,
                      );
                      if (value != null && value.isNotEmpty) onScan(value);
                    },
            ),
            textInputAction: TextInputAction.search,
          ),
        ),
        Expanded(
          child: ListView(
            controller: scrollController,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            children: [
              if (query.isNotEmpty) ...[
                _ProductResults(
                  query: query,
                  branchId: effectiveBranch?.warehouseId,
                  format: format,
                  onAdd: onAddProduct,
                ),
                const SizedBox(height: 18),
              ],
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
        _PosBottomDock(
          itemCount: cart.items.length,
          total: totals.total,
          barcodeLoading: barcodeLoading,
          onScan: onScan,
          onCharge: onCharge,
          format: format,
        ),
      ],
    );
  }
}

class _BranchSelector extends ConsumerWidget {
  const _BranchSelector({
    required this.branches,
    required this.selectedBranch,
    required this.onBranchChanged,
  });

  final AsyncValue<List<ProductWarehouseOption>> branches;
  final ProductWarehouseOption? selectedBranch;
  final VoidCallback onBranchChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    return branches.when(
      data: (items) {
        if (items.isEmpty) {
          return _BranchChip(label: l.posBranchMissing, muted: true);
        }
        final selected = selectedBranch ?? items.first;
        return _BranchChip(
          label: selected.name,
          onTap: () => _showBranchPicker(context, ref, items, selected),
        );
      },
      loading: () => _BranchChip(label: l.posBranchLoading, muted: true),
      error: (_, __) => _BranchChip(label: l.posBranchMissing, muted: true),
    );
  }

  Future<void> _showBranchPicker(
    BuildContext context,
    WidgetRef ref,
    List<ProductWarehouseOption> branches,
    ProductWarehouseOption selected,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        final l = AppLocalizations.of(sheetContext);
        final c = kuruColors(sheetContext);
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
            children: [
              Text(
                l.posBranchPickerTitle,
                style: TextStyle(
                  color: c.textPrimary,
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 10),
              for (final branch in branches)
                _BranchPickerRow(
                  branch: branch,
                  selected: branch.warehouseId == selected.warehouseId,
                  onTap: () async {
                    await ref
                        .read(posSelectedBranchIdProvider.notifier)
                        .setBranch(branch.warehouseId);
                    onBranchChanged();
                    if (sheetContext.mounted) Navigator.of(sheetContext).pop();
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}

class _BranchChip extends StatelessWidget {
  const _BranchChip({required this.label, this.onTap, this.muted = false});

  final String label;
  final VoidCallback? onTap;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final c = kuruColors(context);
    final fg = muted ? c.textMuted : c.textPrimary;
    return Material(
      color: c.surfaceElev,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: c.borderSoft),
          ),
          child: Row(
            children: [
              Icon(TablerIcons.building_store, color: c.accent600, size: 31),
              const SizedBox(width: 8),
              Text(
                l.posBranchLabel,
                style: TextStyle(
                  color: c.textMuted,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: fg,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              if (onTap != null)
                Icon(TablerIcons.chevron_down, color: c.textMuted, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}

class _BranchPickerRow extends StatelessWidget {
  const _BranchPickerRow({
    required this.branch,
    required this.selected,
    required this.onTap,
  });

  final ProductWarehouseOption branch;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Material(
      color: selected ? c.accent100 : Colors.transparent,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              Icon(
                TablerIcons.building_store,
                color: selected ? c.accent700 : c.textMuted,
                size: 31,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      branch.name,
                      style: TextStyle(
                        color: c.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    if (branch.address?.isNotEmpty ?? false) ...[
                      const SizedBox(height: 2),
                      Text(
                        branch.address!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: c.textMuted,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DisplaySelector extends ConsumerStatefulWidget {
  const _DisplaySelector({
    required this.branch,
    required this.displayInUse,
    required this.displayChecking,
    required this.onChanged,
    required this.onTakeOver,
  });

  final ProductWarehouseOption? branch;
  final bool displayInUse;
  final bool displayChecking;
  final VoidCallback onChanged;
  final VoidCallback onTakeOver;

  @override
  ConsumerState<_DisplaySelector> createState() => _DisplaySelectorState();
}

class _DisplaySelectorState extends ConsumerState<_DisplaySelector> {
  Timer? _presenceTimer;
  String? _renderCheckedTerminalKey;

  @override
  void initState() {
    super.initState();
    _configurePresenceTimer();
  }

  @override
  void didUpdateWidget(covariant _DisplaySelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.branch?.warehouseId != widget.branch?.warehouseId) {
      _configurePresenceTimer();
    }
  }

  @override
  void dispose() {
    _presenceTimer?.cancel();
    super.dispose();
  }

  void _configurePresenceTimer() {
    _presenceTimer?.cancel();
    final branchId = widget.branch?.warehouseId;
    if (branchId == null || branchId.isEmpty) return;
    _presenceTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      if (!mounted) return;
      ref.invalidate(posPairedDisplaysProvider(branchId));
    });
  }

  void _checkSelectedDisplayOnRender({
    required String branchId,
    required String terminalId,
  }) {
    final key = '$branchId:$terminalId';
    if (_renderCheckedTerminalKey == key) return;
    _renderCheckedTerminalKey = key;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final current = ref.read(posSelectedTerminalIdProvider(branchId));
      if (current == terminalId) widget.onChanged();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final branchId = widget.branch?.warehouseId;
    if (branchId == null || branchId.isEmpty) {
      return _DisplayChip(label: l.posDisplayMissing, muted: true);
    }

    final terminalsAsync = ref.watch(posDisplayTerminalsProvider(branchId));
    final displaysAsync = ref.watch(posPairedDisplaysProvider(branchId));
    final displays = displaysAsync.valueOrNull ?? const <PosPairedDisplay>[];
    final displaysLoading = displaysAsync.isLoading && !displaysAsync.hasValue;
    final selectedId = ref.watch(posSelectedTerminalIdProvider(branchId));

    return terminalsAsync.when(
      data: (terminals) {
        if (terminals.isEmpty) {
          return _DisplayChip(label: l.posDisplayMissing, muted: true);
        }
        if (selectedId == null && terminals.length == 1) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            if (!mounted) return;
            final current = ref.read(posSelectedTerminalIdProvider(branchId));
            if (current == null) {
              await ref
                  .read(posSelectedTerminalIdProvider(branchId).notifier)
                  .setTerminal(terminals.single.id);
              widget.onChanged();
            }
          });
        }

        final selectedTerminal = selectedId == null || selectedId.isEmpty
            ? null
            : _terminalById(terminals, selectedId);
        final selectedDisplay = selectedId == null || selectedId.isEmpty
            ? null
            : _displayForTerminal(displays, selectedId);
        final renderCheckPending =
            selectedTerminal != null &&
            _renderCheckedTerminalKey != '$branchId:${selectedTerminal.id}';
        if (selectedTerminal != null) {
          _checkSelectedDisplayOnRender(
            branchId: branchId,
            terminalId: selectedTerminal.id,
          );
        }
        final hasSelectedTerminal = selectedTerminal != null;
        final label = selectedId == null
            ? l.posDisplaySelect
            : selectedId.isEmpty
            ? l.posDisplayNone
            : selectedDisplay?.name ??
                  selectedTerminal?.name ??
                  l.posDisplaySelect;

        final status =
            hasSelectedTerminal &&
                (renderCheckPending ||
                    widget.displayChecking ||
                    displaysLoading)
            ? _DisplayPresenceStatus.checking
            : widget.displayInUse
            ? _DisplayPresenceStatus.inUse
            : _displayStatus(selectedDisplay);
        return _DisplayChip(
          label: label,
          status: status,
          onTakeOver:
              widget.displayInUse && selectedId != null && selectedId.isNotEmpty
              ? widget.onTakeOver
              : null,
          onTap: () => _showTerminalPicker(
            context: context,
            branchId: branchId,
            terminals: terminals,
            displays: displays,
            selectedId: selectedId,
          ),
        );
      },
      loading: () => _DisplayChip(label: l.posDisplayLoading, muted: true),
      error: (_, __) => _DisplayChip(label: l.posDisplayMissing, muted: true),
    );
  }

  Future<void> _showTerminalPicker({
    required BuildContext context,
    required String branchId,
    required List<PosDisplayTerminal> terminals,
    required List<PosPairedDisplay> displays,
    required String? selectedId,
  }) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.86,
      ),
      builder: (sheetContext) {
        final l = AppLocalizations.of(sheetContext);
        final c = kuruColors(sheetContext);
        final height = math.min<double>(
          MediaQuery.sizeOf(sheetContext).height * 0.78,
          198 + terminals.length * 82,
        );
        return SafeArea(
          top: false,
          child: SizedBox(
            height: height,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
              children: [
                Text(
                  l.posDisplayPickerTitle,
                  style: TextStyle(
                    color: c.textPrimary,
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l.posDisplayPickerSubtitle,
                  style: TextStyle(
                    color: c.textMuted,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                _DisplayPickerNoneRow(
                  selected: selectedId == '',
                  onTap: () async {
                    await ref
                        .read(posSelectedTerminalIdProvider(branchId).notifier)
                        .setTerminal('');
                    widget.onChanged();
                    if (sheetContext.mounted) Navigator.of(sheetContext).pop();
                  },
                ),
                const SizedBox(height: 8),
                for (final terminal in terminals)
                  _DisplayPickerTerminalRow(
                    terminal: terminal,
                    display: _displayForTerminal(displays, terminal.id),
                    selected: selectedId == terminal.id,
                    onTap: () async {
                      await ref
                          .read(
                            posSelectedTerminalIdProvider(branchId).notifier,
                          )
                          .setTerminal(terminal.id);
                      widget.onChanged();
                      if (sheetContext.mounted) {
                        Navigator.of(sheetContext).pop();
                      }
                    },
                    onPair: () {
                      Navigator.of(sheetContext).pop();
                      _showPairSheet(
                        context: context,
                        branchId: branchId,
                        terminal: terminal,
                        existing: _displayForTerminal(displays, terminal.id),
                      );
                    },
                  ),
                const SizedBox(height: 10),
                Text(
                  l.posDisplayPairHint,
                  style: TextStyle(
                    color: c.textMuted,
                    fontSize: 12,
                    height: 1.35,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showPairSheet({
    required BuildContext context,
    required String branchId,
    required PosDisplayTerminal terminal,
    required PosPairedDisplay? existing,
  }) async {
    final existingName = existing?.name.trim();
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => _PairDisplaySheet(
        branchId: branchId,
        terminal: terminal,
        existing: existing,
        displayName: existingName == null || existingName.isEmpty
            ? ''
            : existingName,
      ),
    );
    if (!mounted) return;
    ref.invalidate(posPairedDisplaysProvider(branchId));
    widget.onChanged();
  }
}

class _DisplayChip extends StatelessWidget {
  const _DisplayChip({
    required this.label,
    this.status = _DisplayPresenceStatus.none,
    this.onTap,
    this.onTakeOver,
    this.muted = false,
  });

  final String label;
  final _DisplayPresenceStatus status;
  final VoidCallback? onTap;
  final VoidCallback? onTakeOver;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final c = kuruColors(context);
    final fg = muted ? c.textMuted : c.textPrimary;
    final isChecking = status == _DisplayPresenceStatus.checking;
    final isInUse = status == _DisplayPresenceStatus.inUse;
    final statusText = switch (status) {
      _DisplayPresenceStatus.checking => null,
      _DisplayPresenceStatus.online => null,
      _DisplayPresenceStatus.offline => l.posDisplayOffline,
      _DisplayPresenceStatus.inUse => l.posDisplayInUseShort,
      _DisplayPresenceStatus.none => null,
    };
    final showStatusRow = statusText != null || onTakeOver != null;
    return Material(
      color: c.surfaceElev,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isInUse ? const Color(0xFFFCD34D) : c.borderSoft,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Icon(
                    TablerIcons.device_tablet,
                    color: isInUse
                        ? c.warning
                        : isChecking
                        ? c.textMuted
                        : status == _DisplayPresenceStatus.offline
                        ? c.danger
                        : status == _DisplayPresenceStatus.none
                        ? c.textMuted
                        : c.accent600,
                    size: 28,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    l.posDisplayLabel,
                    style: TextStyle(
                      color: c.textMuted,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(width: 6),
                  _DisplayPresenceDot(status: status),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: fg,
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  if (onTap != null)
                    Icon(
                      TablerIcons.chevron_down,
                      color: c.textMuted,
                      size: 18,
                    ),
                ],
              ),
              if (showStatusRow) ...[
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: statusText == null
                          ? const SizedBox.shrink()
                          : Text(
                              statusText,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: isChecking
                                    ? c.textMuted
                                    : isInUse
                                    ? c.warning
                                    : status == _DisplayPresenceStatus.offline
                                    ? c.danger
                                    : c.textMuted,
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                    ),
                    if (onTakeOver != null) ...[
                      const SizedBox(width: 8),
                      TextButton(
                        onPressed: onTakeOver,
                        style: TextButton.styleFrom(
                          foregroundColor: c.warning,
                          visualDensity: VisualDensity.compact,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          minimumSize: const Size(0, 32),
                        ),
                        child: Text(
                          l.posDisplayTakeOver,
                          style: const TextStyle(fontWeight: FontWeight.w900),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _DisplayPresenceDot extends StatelessWidget {
  const _DisplayPresenceDot({required this.status});

  final _DisplayPresenceStatus status;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    if (status == _DisplayPresenceStatus.checking) {
      return SizedBox(
        width: 10,
        height: 10,
        child: CircularProgressIndicator(strokeWidth: 1.8, color: c.textMuted),
      );
    }
    final color = switch (status) {
      _DisplayPresenceStatus.checking => c.textMuted,
      _DisplayPresenceStatus.online => const Color(0xFF10B981),
      _DisplayPresenceStatus.offline => c.danger,
      _DisplayPresenceStatus.inUse => c.warning,
      _DisplayPresenceStatus.none => c.textMuted.withValues(alpha: 0.45),
    };
    return Container(
      width: 7,
      height: 7,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _DisplayPickerNoneRow extends StatelessWidget {
  const _DisplayPickerNoneRow({required this.selected, required this.onTap});

  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final c = kuruColors(context);
    return Material(
      color: selected ? c.accent100 : Colors.transparent,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              Icon(TablerIcons.device_tablet_off, color: c.textMuted, size: 28),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l.posDisplayNone,
                      style: TextStyle(
                        color: c.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l.posDisplayNoneDesc,
                      style: TextStyle(
                        color: c.textMuted,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DisplayPickerTerminalRow extends StatelessWidget {
  const _DisplayPickerTerminalRow({
    required this.terminal,
    required this.display,
    required this.selected,
    required this.onTap,
    required this.onPair,
  });

  final PosDisplayTerminal terminal;
  final PosPairedDisplay? display;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onPair;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final c = kuruColors(context);
    final status = _displayStatus(display);
    final displayName = display?.name.trim();
    final title = displayName == null || displayName.isEmpty
        ? terminal.name
        : displayName;
    final statusText = switch (status) {
      _DisplayPresenceStatus.checking => l.posDisplayLoading,
      _DisplayPresenceStatus.online => l.posDisplayOnline,
      _DisplayPresenceStatus.offline => l.posDisplayOffline,
      _DisplayPresenceStatus.inUse => l.posDisplayInUseShort,
      _DisplayPresenceStatus.none => l.posDisplayNoScreen,
    };
    final statusColor = switch (status) {
      _DisplayPresenceStatus.checking => c.textMuted,
      _DisplayPresenceStatus.online => const Color(0xFF059669),
      _DisplayPresenceStatus.offline => c.danger,
      _DisplayPresenceStatus.inUse => c.warning,
      _DisplayPresenceStatus.none => c.textMuted,
    };
    return Material(
      color: selected ? c.accent100 : Colors.transparent,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              Icon(
                TablerIcons.device_desktop,
                color: status == _DisplayPresenceStatus.offline
                    ? c.danger
                    : selected
                    ? c.accent700
                    : c.textMuted,
                size: 29,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: c.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    if (terminal.isDefault) ...[
                      const SizedBox(height: 2),
                      Text(
                        l.posDisplayDefault,
                        style: TextStyle(
                          color: c.textMuted,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        _DisplayPresenceDot(status: status),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            statusText,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: statusColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: onPair,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(0, 34),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  visualDensity: VisualDensity.compact,
                  side: BorderSide(color: c.borderSoft),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  display == null ? l.posDisplayPair : l.posDisplayRepair,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PairDisplaySheet extends ConsumerStatefulWidget {
  const _PairDisplaySheet({
    required this.branchId,
    required this.terminal,
    required this.existing,
    required this.displayName,
  });

  final String branchId;
  final PosDisplayTerminal terminal;
  final PosPairedDisplay? existing;
  final String displayName;

  @override
  ConsumerState<_PairDisplaySheet> createState() => _PairDisplaySheetState();
}

class _PairDisplaySheetState extends ConsumerState<_PairDisplaySheet> {
  Timer? _countdown;
  Timer? _poll;
  PosPairSession? _session;
  bool _generating = false;
  bool _paired = false;
  int _remainingSec = 0;
  Set<String> _baselineIds = const {};
  DateTime? _rebindBaselinePairedAt;

  @override
  void dispose() {
    _countdown?.cancel();
    _poll?.cancel();
    super.dispose();
  }

  Future<void> _generate() async {
    final l = AppLocalizations.of(context);
    final displayName = widget.displayName.trim();
    setState(() => _generating = true);
    final baselineResult = await ref
        .read(posCustomerDisplayRepositoryProvider)
        .listPairedDisplays(storeId: widget.branchId);
    if (!mounted) return;
    switch (baselineResult) {
      case ApiSuccess<List<PosPairedDisplay>>(:final data):
        _baselineIds = data.map((display) => display.id).toSet();
        _rebindBaselinePairedAt = widget.existing == null
            ? null
            : _displayById(data, widget.existing!.id)?.pairedAt;
      case ApiFailure<List<PosPairedDisplay>>():
        _baselineIds = const {};
        _rebindBaselinePairedAt = widget.existing?.pairedAt;
    }

    final result = await ref
        .read(posCustomerDisplayRepositoryProvider)
        .createPairSession(
          terminalId: widget.terminal.id,
          name: displayName.isEmpty ? null : displayName,
          rebindDeviceId: widget.existing?.id,
        );
    if (!mounted) return;
    setState(() => _generating = false);
    switch (result) {
      case ApiSuccess<PosPairSession>(:final data):
        setState(() {
          _session = data;
          _paired = false;
        });
        _startCountdown();
        _startPolling();
      case ApiFailure<PosPairSession>(:final err):
        KNotify.warning(
          context,
          err.message.trim().isEmpty ? l.posPairError : err.message,
        );
    }
  }

  void _startCountdown() {
    _countdown?.cancel();
    void tick() {
      final expiresAt = _session?.expiresAt;
      final remaining = expiresAt == null
          ? 0
          : math.max(0, expiresAt.difference(DateTime.now()).inSeconds);
      if (mounted) setState(() => _remainingSec = remaining);
    }

    tick();
    _countdown = Timer.periodic(const Duration(seconds: 1), (_) => tick());
  }

  void _startPolling() {
    _poll?.cancel();
    _poll = Timer.periodic(const Duration(seconds: 3), (_) async {
      if (!mounted || _session == null || _paired || _remainingSec <= 0) {
        return;
      }
      final result = await ref
          .read(posCustomerDisplayRepositoryProvider)
          .listPairedDisplays(storeId: widget.branchId);
      if (!mounted) return;
      switch (result) {
        case ApiSuccess<List<PosPairedDisplay>>(:final data):
          final detected = _detectPaired(data);
          if (detected) {
            setState(() => _paired = true);
            _poll?.cancel();
            ref.invalidate(posPairedDisplaysProvider(widget.branchId));
            KNotify.success(
              context,
              AppLocalizations.of(context).posPairConnected,
            );
          }
        case ApiFailure<List<PosPairedDisplay>>():
          break;
      }
    });
  }

  bool _detectPaired(List<PosPairedDisplay> current) {
    final existingId = widget.existing?.id;
    if (existingId != null && existingId.isNotEmpty) {
      final target = current.where((display) => display.id == existingId);
      if (target.isEmpty) return false;
      final pairedAt = target.first.pairedAt;
      return pairedAt != null && pairedAt != _rebindBaselinePairedAt;
    }
    return current.any((display) => !_baselineIds.contains(display.id));
  }

  Future<void> _cancelCode() async {
    await ref
        .read(posCustomerDisplayRepositoryProvider)
        .cancelPairSession(terminalId: widget.terminal.id);
    if (!mounted) return;
    _countdown?.cancel();
    _poll?.cancel();
    setState(() {
      _session = null;
      _paired = false;
      _remainingSec = 0;
    });
    KNotify.success(context, AppLocalizations.of(context).posPairCancelled);
  }

  Future<void> _copyCode(String code) async {
    final l = AppLocalizations.of(context);
    try {
      await Clipboard.setData(ClipboardData(text: code));
      if (mounted) KNotify.success(context, l.posPairCopied);
    } on Object {
      if (mounted) KNotify.warning(context, l.posPairCopyFailed);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final c = kuruColors(context);
    final code = _session?.code;
    final displayName = widget.displayName.trim();
    final isRepair = widget.existing != null;
    final isExpired = code != null && !_paired && _remainingSec <= 0;
    final minutes = (_remainingSec ~/ 60).toString().padLeft(2, '0');
    final seconds = (_remainingSec % 60).toString().padLeft(2, '0');
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 2, 16, 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    isRepair ? l.posPairRepairTitle : l.posPairTitle,
                    style: TextStyle(
                      color: c.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                  icon: const Icon(TablerIcons.x),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              displayName.isEmpty ? l.posDisplayNoScreen : displayName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: c.textMuted,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 14),
            if (code == null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: c.accent100,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: c.accent200),
                ),
                child: Text(
                  isRepair
                      ? l.posPairRepairInstructions
                      : l.posPairInstructions,
                  style: TextStyle(
                    color: c.accent700,
                    fontSize: 12,
                    height: 1.35,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              FilledButton(
                onPressed: _generating ? null : _generate,
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: _generating
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.4,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        l.posPairGenerate,
                        style: const TextStyle(fontWeight: FontWeight.w900),
                      ),
              ),
            ] else if (_paired) ...[
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFECFDF5),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFA7F3D0)),
                ),
                child: Row(
                  children: [
                    const Icon(
                      TablerIcons.circle_check,
                      color: Color(0xFF059669),
                      size: 30,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        l.posPairConnected,
                        style: const TextStyle(
                          color: Color(0xFF047857),
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  l.posPairDone,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
              ),
            ] else ...[
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 34,
                    ),
                    decoration: BoxDecoration(
                      color: isExpired
                          ? const Color(0xFFFEF2F2)
                          : c.surfaceElev,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: isExpired
                            ? const Color(0xFFFCA5A5)
                            : c.borderSoft,
                      ),
                    ),
                    child: Text(
                      _formatPairCode(code),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isExpired ? c.danger : c.textPrimary,
                        fontSize: 46,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: IconButton(
                      tooltip: l.posPairCodeCopy,
                      icon: const Icon(TablerIcons.copy, size: 19),
                      onPressed: isExpired ? null : () => _copyCode(code),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                isExpired
                    ? l.posPairExpired
                    : l.posPairExpiresIn('$minutes:$seconds'),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isExpired ? c.danger : c.textMuted,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 14),
              TextButton(
                onPressed: _cancelCode,
                style: TextButton.styleFrom(foregroundColor: c.danger),
                child: Text(
                  l.posPairCancel,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ProductResults extends ConsumerWidget {
  const _ProductResults({
    required this.query,
    required this.branchId,
    required this.format,
    required this.onAdd,
  });

  final String query;
  final String? branchId;
  final String Function(double amount) format;
  final Future<void> Function(ProductSummary product, {String? barcode}) onAdd;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final c = kuruColors(context);
    final products = ref.watch(
      productListProvider(
        ProductListFilter(
          search: query,
          warehouseIds: branchId == null ? const [] : [branchId!],
        ),
      ),
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
                  onAdd: () => onAdd(page.items[i]),
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
    required this.onAdd,
  });

  final ProductSummary product;
  final String Function(double amount) format;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final stock = product.currentStock;
    final stockDigits = stock.truncateToDouble() == stock ? 0 : 2;
    final stockLabel = stock.toStringAsFixed(stockDigits);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onAdd,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
          child: Row(
            children: [
              _ProductThumb(imageUrl: product.imageUrl, size: 42),
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
                        fontSize: 13,
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
              IconButton.filledTonal(
                tooltip: AppLocalizations.of(context).addLineSheetAdd,
                icon: const Icon(TablerIcons.plus, size: 19),
                onPressed: onAdd,
                style: IconButton.styleFrom(
                  backgroundColor: c.accent100,
                  foregroundColor: c.accent700,
                  minimumSize: const Size.square(38),
                  fixedSize: const Size.square(38),
                  padding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductVariantPickerSheet extends StatelessWidget {
  const _ProductVariantPickerSheet({
    required this.product,
    required this.variants,
    required this.format,
  });

  final ProductDetail product;
  final List<ProductVariant> variants;
  final String Function(double amount) format;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final c = kuruColors(context);
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l.addLineSheetVariantPick,
              style: TextStyle(
                color: c.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              product.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: c.textMuted,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 14),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: variants.length,
                separatorBuilder: (_, __) =>
                    Divider(height: 1, thickness: 0.5, color: c.borderSoft),
                itemBuilder: (context, index) {
                  final variant = variants[index];
                  final attrs = variant.attributes.values
                      .where((value) => value.trim().isNotEmpty)
                      .toList();
                  return _ProductVariantRow(
                    variant: variant,
                    attrs: attrs,
                    imageUrl: variant.imageUrl ?? product.imageUrl,
                    price: format(
                      (variant.sellPrice ?? product.sellPrice).toDouble(),
                    ),
                    onTap: () => Navigator.of(context).pop(variant),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductVariantRow extends StatelessWidget {
  const _ProductVariantRow({
    required this.variant,
    required this.attrs,
    required this.imageUrl,
    required this.price,
    required this.onTap,
  });

  final ProductVariant variant;
  final List<String> attrs;
  final String? imageUrl;
  final String price;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 11),
          child: Row(
            children: [
              _ProductThumb(imageUrl: imageUrl, size: 44),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      variant.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: c.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    if (attrs.isNotEmpty) ...[
                      const SizedBox(height: 5),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          for (final attr in attrs.take(4))
                            _VariantAttrPill(label: attr),
                        ],
                      ),
                    ],
                    const SizedBox(height: 5),
                    Text(
                      price,
                      style: TextStyle(
                        color: c.accent700,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Icon(TablerIcons.chevron_right, color: c.textMuted, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}

class _VariantAttrPill extends StatelessWidget {
  const _VariantAttrPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: c.accent100,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: c.accent700,
          fontSize: 11,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _ProductThumb extends StatelessWidget {
  const _ProductThumb({required this.imageUrl, required this.size});

  final String? imageUrl;
  final double size;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final resolvedUrl = _resolveProductImageUrl(imageUrl);
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: size,
        height: size,
        color: const Color(0xFFEFF1F4),
        alignment: Alignment.center,
        child: resolvedUrl == null
            ? const Icon(
                TablerIcons.package,
                color: Color(0xFF94A3B8),
                size: 22,
              )
            : Image.network(
                resolvedUrl,
                fit: BoxFit.cover,
                width: size,
                height: size,
                errorBuilder: (_, __, ___) =>
                    Icon(TablerIcons.package, color: c.textMuted, size: 22),
              ),
      ),
    );
  }
}

class _PosInputField extends StatelessWidget {
  const _PosInputField({
    required this.hint,
    required this.controller,
    this.leadingIcon,
    this.trailingIcon,
    this.keyboardType,
    this.textInputAction,
    this.onSubmitted,
  });

  final String hint;
  final TextEditingController controller;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onSubmitted: onSubmitted,
      style: TextStyle(
        color: c.textPrimary,
        fontSize: 14,
        fontWeight: FontWeight.w700,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: c.textMuted,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        prefixIcon: leadingIcon == null
            ? null
            : IconTheme(
                data: IconThemeData(color: c.textMuted, size: 18),
                child: leadingIcon!,
              ),
        suffixIcon: trailingIcon,
        filled: true,
        fillColor: c.surfaceElev,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 15,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: c.borderSoft),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: c.borderSoft),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: c.accent500, width: 1.5),
        ),
      ),
    );
  }
}

class _CartPanel extends ConsumerWidget {
  const _CartPanel({required this.format});

  final String Function(double amount) format;

  Future<void> _showLineSheet(
    BuildContext context,
    WidgetRef ref,
    int index,
    OrderLineItem item,
  ) async {
    final c = kuruColors(context);
    final detailPath = _productDetailPath(
      item.productId,
      variantId: item.variantId,
    );
    final router = GoRouter.of(context);
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: c.surfaceElev,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.9,
      ),
      builder: (sheetContext) {
        return _CartLineSheet(
          item: item,
          format: format,
          onSave: (next) {
            final current = ref.read(orderCartProvider);
            if (index < current.items.length) {
              ref.read(orderCartProvider.notifier).updateLineAt(index, next);
            }
            Navigator.of(sheetContext).pop();
          },
          onRemove: () {
            final current = ref.read(orderCartProvider);
            if (index < current.items.length) {
              ref.read(orderCartProvider.notifier).removeLineAt(index);
            }
            Navigator.of(sheetContext).pop();
          },
          onViewDetail: () {
            router.push(detailPath);
          },
        );
      },
    );
  }

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
                    style: TextButton.styleFrom(foregroundColor: c.danger),
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
                onTap: () => _showLineSheet(context, ref, i, cart.items[i]),
                onViewDetail: () => context.push(
                  _productDetailPath(
                    cart.items[i].productId,
                    variantId: cart.items[i].variantId,
                  ),
                ),
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
    required this.onTap,
    required this.onViewDetail,
    required this.onRemove,
  });

  final OrderLineItem item;
  final String Function(double amount) format;
  final VoidCallback onTap;
  final VoidCallback onViewDetail;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final qty = item.qty == item.qty.truncate()
        ? item.qty.toStringAsFixed(0)
        : item.qty.toStringAsFixed(2);
    final lineTotal = computeLineTotal(item);
    final saleUnitPrice = computeLineSaleUnitPrice(item);
    final lineDiscount = computeLineDiscountAmount(item);
    final hasDiscount = lineDiscount > 0;
    final shownUnitPrice = hasDiscount ? saleUnitPrice : item.unitPrice;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
          child: Row(
            children: [
              InkWell(
                onTap: onViewDetail,
                borderRadius: BorderRadius.circular(12),
                child: _ProductThumb(imageUrl: item.imageUrl, size: 46),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.productName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: c.textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (item.variantName?.isNotEmpty ?? false) ...[
                      const SizedBox(height: 2),
                      Text(
                        item.variantName!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: c.accent700,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                    const SizedBox(height: 3),
                    Text(
                      '$qty x ${format(shownUnitPrice)}',
                      style: TextStyle(
                        color: c.textMuted,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (hasDiscount) ...[
                      const SizedBox(height: 2),
                      Text(
                        'Giá gốc ${format(item.unitPrice)}',
                        style: TextStyle(
                          color: c.textMuted,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    format(lineTotal),
                    style: TextStyle(
                      color: c.textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  if (hasDiscount) ...[
                    const SizedBox(height: 2),
                    Text(
                      '-${format(lineDiscount)}',
                      style: TextStyle(
                        color: c.danger,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                  const SizedBox(height: 5),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        tooltip: AppLocalizations.of(context).posRemoveLine,
                        icon: Icon(
                          TablerIcons.trash,
                          color: c.danger,
                          size: 18,
                        ),
                        onPressed: onRemove,
                        style: IconButton.styleFrom(
                          minimumSize: const Size.square(30),
                          fixedSize: const Size.square(30),
                          padding: EdgeInsets.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                      Icon(
                        TablerIcons.chevron_right,
                        color: c.textMuted,
                        size: 18,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CartLineSheet extends StatefulWidget {
  const _CartLineSheet({
    required this.item,
    required this.format,
    required this.onSave,
    required this.onRemove,
    required this.onViewDetail,
  });

  final OrderLineItem item;
  final String Function(double amount) format;
  final ValueChanged<OrderLineItem> onSave;
  final VoidCallback onRemove;
  final VoidCallback onViewDetail;

  @override
  State<_CartLineSheet> createState() => _CartLineSheetState();
}

class _CartLineSheetState extends State<_CartLineSheet> {
  late final TextEditingController _qty;
  late int _unitReduction;

  @override
  void initState() {
    super.initState();
    _qty = TextEditingController(text: _formatNumberInput(widget.item.qty));
    _unitReduction = _initialUnitReduction();
    _qty.addListener(_refresh);
  }

  @override
  void dispose() {
    _qty
      ..removeListener(_refresh)
      ..dispose();
    super.dispose();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  double? get _parsedQty {
    final value = _parsePositiveNumber(_qty.text);
    if (value == null || value <= 0) return null;
    return value;
  }

  int get _baseUnitPrice => math.max(0, widget.item.unitPrice.round());

  int get _saleUnitPrice => math.max(0, _baseUnitPrice - _unitReduction);

  int _initialUnitReduction() {
    if (widget.item.qty <= 0) return 0;
    final discount = computeLineDiscountAmount(widget.item);
    return _clampReduction((discount / widget.item.qty).round());
  }

  int _clampReduction(int value) {
    return math.min(_baseUnitPrice, math.max(0, value));
  }

  bool get _canSave => _parsedQty != null;

  double get _lineTotal => (_parsedQty ?? 0) * _saleUnitPrice;

  void _stepQty(double delta) {
    final current = _parsedQty ?? widget.item.qty;
    final next = math.max<double>(1, current + delta);
    _qty.text = _formatNumberInput(next);
  }

  void _save() {
    final qty = _parsedQty;
    if (qty == null) return;
    final discount = _unitReduction * qty;
    widget.onSave(
      widget.item.copyWith(
        qty: qty,
        unitPrice: widget.item.unitPrice,
        discountType: discount > 0 ? DiscountType.fixed : null,
        discountValue: discount > 0 ? discount : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final c = kuruColors(context);
    final keyboardInset = MediaQuery.viewInsetsOf(context).bottom;
    return SafeArea(
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: EdgeInsets.only(bottom: keyboardInset),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      l.posAdjustLineTitle,
                      style: TextStyle(
                        color: c.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: MaterialLocalizations.of(
                      context,
                    ).closeButtonTooltip,
                    icon: const Icon(TablerIcons.x),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: c.surfaceElev,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: c.borderSoft),
                ),
                child: Row(
                  children: [
                    InkWell(
                      onTap: widget.onViewDetail,
                      borderRadius: BorderRadius.circular(12),
                      child: _ProductThumb(
                        imageUrl: widget.item.imageUrl,
                        size: 54,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.item.productName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: c.textPrimary,
                              fontSize: 14,
                              height: 1.15,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          if (widget.item.variantName?.isNotEmpty ?? false) ...[
                            const SizedBox(height: 4),
                            Text(
                              widget.item.variantName!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: c.accent700,
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    IconButton.filledTonal(
                      tooltip: l.posViewProductDetail,
                      icon: const Icon(TablerIcons.external_link, size: 18),
                      onPressed: widget.onViewDetail,
                      style: IconButton.styleFrom(
                        backgroundColor: c.surfaceElev,
                        foregroundColor: c.textPrimary,
                        minimumSize: const Size.square(38),
                        fixedSize: const Size.square(38),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Text(
                l.posAdjustQty,
                style: TextStyle(
                  color: c.textMuted,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _SheetStepButton(
                    icon: TablerIcons.minus,
                    onPressed: () => _stepQty(-1),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _SheetNumberField(
                      label: l.posAdjustQty,
                      controller: _qty,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 10),
                  _SheetStepButton(
                    icon: TablerIcons.plus,
                    onPressed: () => _stepQty(1),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _LineReductionEditor(
                baseUnitPrice: _baseUnitPrice,
                unitReduction: _unitReduction,
                format: widget.format,
                onChanged: (value) {
                  setState(() => _unitReduction = _clampReduction(value));
                },
              ),
              const SizedBox(height: 12),
              _LineTotalBand(
                label: l.posLineTotal,
                value: widget.format(_lineTotal),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  SizedBox(
                    width: 96,
                    child: OutlinedButton(
                      onPressed: widget.onRemove,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: c.danger,
                        minimumSize: const Size(96, 50),
                        side: BorderSide(
                          color: c.danger.withValues(alpha: 0.35),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Icon(TablerIcons.trash),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FilledButton(
                      onPressed: _canSave ? _save : null,
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        l.posSaveLine,
                        style: const TextStyle(fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SheetStepButton extends StatelessWidget {
  const _SheetStepButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return IconButton.filled(
      icon: Icon(icon, size: 22),
      onPressed: onPressed,
      style: IconButton.styleFrom(
        backgroundColor: c.accent600,
        foregroundColor: Colors.white,
        minimumSize: const Size.square(52),
        fixedSize: const Size.square(52),
        padding: EdgeInsets.zero,
      ),
    );
  }
}

class _LineReductionEditor extends StatelessWidget {
  const _LineReductionEditor({
    required this.baseUnitPrice,
    required this.unitReduction,
    required this.format,
    required this.onChanged,
  });

  final int baseUnitPrice;
  final int unitReduction;
  final String Function(double amount) format;
  final ValueChanged<int> onChanged;

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _PriceFactRow(
            label: l.posBaseUnitPrice,
            value: format(baseUnitPrice.toDouble()),
            icon: TablerIcons.lock,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1, thickness: 0.5, color: c.borderSoft),
          ),
          Text(
            l.posUnitReduction,
            style: TextStyle(
              color: c.textMuted,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          KCurrencyField(
            label: l.posReductionAmount,
            value: unitReduction,
            allowZero: true,
            shrinkWrapSheet: true,
            previewBaseValue: baseUnitPrice,
            previewZeroText: l.posReductionPrompt,
            reductionReferenceValue: baseUnitPrice,
            reductionPercents: const [1, 5, 10],
            hideChevron: true,
            hideMultipliers: true,
            resetText: l.posResetReduction,
            onReset: () => onChanged(0),
            onChanged: (value) => onChanged(value ?? 0),
          ),
        ],
      ),
    );
  }
}

class _PriceFactRow extends StatelessWidget {
  const _PriceFactRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Row(
      children: [
        Icon(icon, color: c.textPrimary, size: 17),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: c.textMuted,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: c.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _LineTotalBand extends StatelessWidget {
  const _LineTotalBand({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      decoration: BoxDecoration(
        color: c.accent100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: c.accent200),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: c.accent700,
                fontSize: 13,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: c.accent700,
              fontSize: 19,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _SheetNumberField extends StatelessWidget {
  const _SheetNumberField({
    required this.label,
    required this.controller,
    this.textAlign = TextAlign.start,
  });

  final String label;
  final TextEditingController controller;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9,.]'))],
      textAlign: textAlign,
      style: TextStyle(
        color: c.textPrimary,
        fontSize: 15,
        fontWeight: FontWeight.w800,
      ),
      decoration: InputDecoration(
        hintText: label,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        hintStyle: TextStyle(
          color: c.textMuted,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 15,
        ),
        filled: true,
        fillColor: c.surfaceElev,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: c.borderSoft),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: c.borderSoft),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: c.accent500, width: 1.5),
        ),
      ),
    );
  }
}

String _formatNumberInput(double value) {
  return value.truncateToDouble() == value
      ? value.toStringAsFixed(0)
      : value.toStringAsFixed(2);
}

double? _parsePositiveNumber(String input) {
  var value = input.trim().replaceAll(' ', '');
  if (value.isEmpty) return null;
  value = value.replaceAll(RegExp('[^0-9,.]'), '');
  final comma = value.lastIndexOf(',');
  final dot = value.lastIndexOf('.');
  final separator = math.max(comma, dot);
  if (separator < 0) return double.tryParse(value);

  final decimals = value.length - separator - 1;
  final hasBoth = comma >= 0 && dot >= 0;
  if (!hasBoth && decimals == 3) {
    return double.tryParse(value.replaceAll(RegExp('[,.]'), ''));
  }

  final integer = value.substring(0, separator).replaceAll(RegExp('[,.]'), '');
  final fraction = value
      .substring(separator + 1)
      .replaceAll(RegExp('[,.]'), '');
  final normalized = '$integer.$fraction';
  return double.tryParse(normalized);
}

class _PosBottomDock extends StatelessWidget {
  const _PosBottomDock({
    required this.itemCount,
    required this.total,
    required this.barcodeLoading,
    required this.onScan,
    required this.onCharge,
    required this.format,
  });

  final int itemCount;
  final double total;
  final bool barcodeLoading;
  final ValueChanged<String> onScan;
  final VoidCallback onCharge;
  final String Function(double amount) format;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final c = kuruColors(context);
    return KuruBottomBarFrame(
      action: _ScanPrimaryGlyph(loading: barcodeLoading),
      actionTooltip: l.posScanPrimary,
      onActionPressed: barcodeLoading
          ? null
          : () async {
              final value = await showKBarcodeScannerSheet(
                context,
                title: l.posScanBarcode,
                hint: l.posScanHint,
              );
              if (value != null && value.isNotEmpty) onScan(value);
            },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 12, 22, 12),
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
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      format(total),
                      maxLines: 1,
                      style: TextStyle(
                        color: c.textPrimary,
                        fontSize: 21,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 86),
            FilledButton(
              onPressed: itemCount == 0 ? null : onCharge,
              style: FilledButton.styleFrom(
                minimumSize: const Size(104, 48),
                padding: const EdgeInsets.symmetric(horizontal: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: Text(
                l.posCharge,
                style: const TextStyle(fontWeight: FontWeight.w900),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScanPrimaryGlyph extends StatelessWidget {
  const _ScanPrimaryGlyph({required this.loading});

  final bool loading;

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const SizedBox(
        width: 22,
        height: 22,
        child: CircularProgressIndicator(strokeWidth: 2.4, color: Colors.white),
      );
    }
    return ColorFiltered(
      colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
      child: Lottie.asset(
        'assets/lottie/scan.json',
        width: 44,
        height: 44,
        fit: BoxFit.contain,
        repeat: true,
        errorBuilder: (_, __, ___) =>
            const Icon(TablerIcons.barcode, color: Colors.white, size: 31),
      ),
    );
  }
}

class _PaymentView extends ConsumerWidget {
  const _PaymentView({
    required this.method,
    required this.amount,
    required this.paymentRef,
    required this.paymentQr,
    required this.paymentQrLoading,
    required this.paymentQrError,
    required this.submitting,
    required this.onMethodChanged,
    required this.onSubmit,
    required this.onRetryQr,
    required this.onAmountChanged,
    required this.format,
  });

  final OrderPaymentMethod method;
  final TextEditingController amount;
  final String? paymentRef;
  final PosPaymentQr? paymentQr;
  final bool paymentQrLoading;
  final String? paymentQrError;
  final bool submitting;
  final ValueChanged<OrderPaymentMethod> onMethodChanged;
  final VoidCallback onSubmit;
  final VoidCallback onRetryQr;
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
        const SizedBox(height: 20),
        if (method == OrderPaymentMethod.cash) ...[
          _PosInputField(
            hint: l.posAmountReceived,
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
                _CashQuickPick(
                  label: format(pick),
                  selected: paid == pick,
                  onTap: () {
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
          _ReferenceBox(
            reference: paymentRef!,
            qr: paymentQr,
            loading: paymentQrLoading,
            error: paymentQrError,
            amount: totals.total,
            format: format,
            onRetry: onRetryQr,
          ),
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
    final c = kuruColors(context);
    final methods = [
      _PaymentMethodOption(
        method: OrderPaymentMethod.cash,
        icon: TablerIcons.cash,
        label: l.orderPaymentMethodCash,
      ),
      _PaymentMethodOption(
        method: OrderPaymentMethod.bankTransfer,
        icon: TablerIcons.building_bank,
        label: l.orderPaymentMethodBankTransfer,
      ),
      _PaymentMethodOption(
        method: OrderPaymentMethod.card,
        icon: TablerIcons.credit_card,
        label: l.orderPaymentMethodCard,
      ),
      _PaymentMethodOption(
        method: OrderPaymentMethod.other,
        icon: TablerIcons.dots,
        label: l.orderPaymentMethodOther,
      ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l.orderPaymentSheetMethod,
          style: TextStyle(
            color: c.textMuted,
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: methods.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            mainAxisExtent: 78,
          ),
          itemBuilder: (context, index) {
            final option = methods[index];
            return _PaymentMethodTile(
              option: option,
              selected: option.method == value,
              onTap: () => onChanged(option.method),
            );
          },
        ),
      ],
    );
  }
}

class _PaymentMethodOption {
  const _PaymentMethodOption({
    required this.method,
    required this.icon,
    required this.label,
  });

  final OrderPaymentMethod method;
  final IconData icon;
  final String label;
}

class _PaymentMethodTile extends StatelessWidget {
  const _PaymentMethodTile({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final _PaymentMethodOption option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Material(
      color: selected ? c.accent100 : c.surfaceElev,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: selected ? c.accent600 : c.borderSoft,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: selected ? c.accent600 : c.pageBg,
                  borderRadius: BorderRadius.circular(13),
                ),
                alignment: Alignment.center,
                child: Icon(
                  option.icon,
                  size: 21,
                  color: selected ? Colors.white : c.textMuted,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  option.label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: selected ? c.accent700 : c.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    height: 1.15,
                  ),
                ),
              ),
              if (selected)
                Icon(TablerIcons.check, color: c.accent700, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}

class _CashQuickPick extends StatelessWidget {
  const _CashQuickPick({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Material(
      color: selected ? c.accent600 : c.surfaceElev,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: selected ? c.accent600 : c.borderSoft),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : c.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
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
  const _ReferenceBox({
    required this.reference,
    required this.qr,
    required this.loading,
    required this.error,
    required this.amount,
    required this.format,
    required this.onRetry,
  });

  final String reference;
  final PosPaymentQr? qr;
  final bool loading;
  final String? error;
  final double amount;
  final String Function(double amount) format;
  final VoidCallback onRetry;

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (loading)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 28),
              child: Column(
                children: [
                  CircularProgressIndicator(color: c.accent600),
                  const SizedBox(height: 12),
                  Text(
                    'Đang tạo VietQR...',
                    style: TextStyle(
                      color: c.textMuted,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            )
          else if (qr != null && qr!.qrUrl.isNotEmpty)
            Column(
              children: [
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: ColoredBox(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Image.network(
                          qr!.qrUrl,
                          key: const ValueKey('pos-vietqr-image'),
                          width: 240,
                          height: 240,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => SizedBox(
                            width: 240,
                            height: 240,
                            child: Icon(
                              TablerIcons.qrcode,
                              color: c.textMuted,
                              size: 52,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                _QrInfoRow(label: 'Ngân hàng', value: qr!.bankCode),
                _QrInfoRow(label: 'Số tài khoản', value: qr!.accountNumber),
                _QrInfoRow(label: 'Chủ tài khoản', value: qr!.accountName),
                _QrInfoRow(label: 'Nội dung', value: qr!.memo),
                _QrInfoRow(label: l.posTotal, value: format(amount)),
              ],
            )
          else
            Row(
              children: [
                Icon(TablerIcons.qrcode, color: c.accent600),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    error ?? 'Không tạo được VietQR.',
                    style: TextStyle(
                      color: error == null ? c.textMuted : c.danger,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                TextButton(onPressed: onRetry, child: const Text('Thử lại')),
              ],
            ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(TablerIcons.receipt, color: c.accent600, size: 20),
              const SizedBox(width: 10),
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
        ],
      ),
    );
  }
}

class _QrInfoRow extends StatelessWidget {
  const _QrInfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 104,
            child: Text(
              label,
              style: TextStyle(
                color: c.textMuted,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: c.textPrimary,
                fontSize: 12,
                fontWeight: FontWeight.w900,
              ),
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

enum _DisplayPresenceStatus { checking, online, offline, inUse, none }

PosDisplayTerminal? _terminalById(
  List<PosDisplayTerminal> terminals,
  String id,
) {
  for (final terminal in terminals) {
    if (terminal.id == id) return terminal;
  }
  return null;
}

PosPairedDisplay? _displayById(List<PosPairedDisplay> displays, String id) {
  for (final display in displays) {
    if (display.id == id) return display;
  }
  return null;
}

PosPairedDisplay? _displayForTerminal(
  List<PosPairedDisplay> displays,
  String terminalId,
) {
  for (final display in displays) {
    if (display.terminalId == terminalId && display.isPaired) return display;
  }
  return null;
}

_DisplayPresenceStatus _displayStatus(PosPairedDisplay? display) {
  if (display == null) return _DisplayPresenceStatus.none;
  return display.isOnline
      ? _DisplayPresenceStatus.online
      : _DisplayPresenceStatus.offline;
}

String _formatPairCode(String code) {
  final trimmed = code.trim();
  if (trimmed.length <= 3) return trimmed;
  return '${trimmed.substring(0, 3)} ${trimmed.substring(3)}';
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

ProductWarehouseOption? _effectiveBranch(
  List<ProductWarehouseOption>? branches,
  String? selectedId,
) {
  if (branches == null || branches.isEmpty) return null;
  for (final branch in branches) {
    if (branch.warehouseId == selectedId) return branch;
  }
  return branches.first;
}

String? _effectiveBranchId(
  List<ProductWarehouseOption>? branches,
  String? selectedId,
) {
  return _effectiveBranch(branches, selectedId)?.warehouseId;
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
