// (flutter_tabler_icons uses snake_case symbols)
// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
import 'package:kuru_mobile/core/auth/auth_providers.dart';
import 'package:kuru_mobile/core/feedback/k_notify.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/design/core/input/k_currency_field.dart';
import 'package:kuru_mobile/design/core/input/k_text_field.dart';
import 'package:kuru_mobile/design/core/input/k_textarea.dart';
import 'package:kuru_mobile/design/core/modal/k_confirm_dialog.dart';
import 'package:kuru_mobile/features/orders/data/order_repository.dart';
import 'package:kuru_mobile/features/orders/models/discount_type.dart';
import 'package:kuru_mobile/features/orders/models/order_cart_totals.dart';
import 'package:kuru_mobile/features/orders/models/order_line_item.dart';
import 'package:kuru_mobile/features/orders/providers/order_providers.dart';
import 'package:kuru_mobile/features/orders/widgets/add_line_sheet.dart';
import 'package:kuru_mobile/features/orders/widgets/order_payment_sheet.dart';
import 'package:uuid/uuid.dart';

class OrderCreateScreen extends ConsumerStatefulWidget {
  const OrderCreateScreen({super.key});

  @override
  ConsumerState<OrderCreateScreen> createState() => _OrderCreateScreenState();
}

class _OrderCreateScreenState extends ConsumerState<OrderCreateScreen> {
  final _customerName = TextEditingController();
  final _customerPhone = TextEditingController();
  final _note = TextEditingController();
  final _manualTax = TextEditingController();

  DiscountType? _discountType;
  int? _discountValue;
  bool _submitting = false;
  bool _submitPayment = false;

  @override
  void initState() {
    super.initState();
    _customerName.addListener(_pushCustomer);
    _customerPhone.addListener(_pushCustomer);
    _note.addListener(_pushNote);
    _manualTax.addListener(_pushManualTax);
  }

  @override
  void dispose() {
    _customerName.dispose();
    _customerPhone.dispose();
    _note.dispose();
    _manualTax.dispose();
    super.dispose();
  }

  void _pushCustomer() {
    ref
        .read(orderCartProvider.notifier)
        .setCustomer(name: _customerName.text, phone: _customerPhone.text);
  }

  void _pushNote() {
    ref.read(orderCartProvider.notifier).setNote(_note.text);
  }

  void _pushManualTax() {
    ref
        .read(orderCartProvider.notifier)
        .setManualTaxPercent(double.tryParse(_manualTax.text));
  }

  void _pushDiscount() {
    ref
        .read(orderCartProvider.notifier)
        .setOrderDiscount(_discountType, _discountValue?.toDouble());
  }

  Future<void> _addLine() async {
    final line = await showAddLineSheet(context);
    if (line != null) {
      ref.read(orderCartProvider.notifier).addLine(line);
    }
  }

  Future<void> _editLine(int index, OrderLineItem item) async {
    final updated = await showAddLineSheet(context, edit: item);
    if (updated != null) {
      ref.read(orderCartProvider.notifier).updateLineAt(index, updated);
    }
  }

  Future<void> _submit({required bool payment}) async {
    final l = AppLocalizations.of(context);
    final cart = ref.read(orderCartProvider);
    final totals = ref.read(orderCartTotalsProvider);
    final orgId = ref.read(currentOrgIdProvider);
    if (orgId == null || cart.items.isEmpty) return;

    ref
        .read(orderCartProvider.notifier)
        .ensureIdempotencyKey(() => const Uuid().v4());
    final key = ref.read(orderCartProvider).idempotencyKey!;

    OrderPaymentInput? paymentInput;
    if (payment) {
      paymentInput = await showOrderPaymentSheet(
        context,
        defaultAmount: totals.total,
      );
      if (paymentInput == null) return;
    }

    if (!mounted) return;
    setState(() {
      _submitting = true;
      _submitPayment = payment;
    });

    final result = await ref
        .read(orderRepositoryProvider)
        .createOrder(
          orgId: orgId,
          idempotencyKey: key,
          draft: cart,
          payment: paymentInput,
        );

    if (!mounted) return;
    setState(() => _submitting = false);

    switch (result) {
      case ApiSuccess<String>(:final data):
        ref.invalidate(orderListProvider);
        ref.read(orderCartProvider.notifier).clear();
        KNotify.success(
          context,
          payment ? l.orderCreatePaid : l.orderCreateSavedDraft,
        );
        context.go('/orders/$data');
      case ApiFailure<String>(:final err):
        KNotify.warning(context, err.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final c = kuruColors(context);
    final cart = ref.watch(orderCartProvider);
    final totals = ref.watch(orderCartTotalsProvider);
    final isEmpty = cart.items.isEmpty;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return PopScope(
      canPop: isEmpty,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final confirmed = await showKConfirmDialog(
          context: context,
          title: l.orderCreateDiscardDialogTitle,
          subtitle: l.orderCreateDiscardDialogBody,
          confirmLabel: l.orderCreateDiscardConfirm,
          cancelLabel: l.orderCreateKeepEditing,
        );
        if ((confirmed ?? false) && context.mounted) {
          ref.read(orderCartProvider.notifier).clear();
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        backgroundColor: c.pageBg,
        appBar: AppBar(
          backgroundColor: c.pageBg,
          elevation: 0,
          scrolledUnderElevation: 0,
          title: Text(
            l.orderCreateTitle,
            style: TextStyle(
              color: c.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: EdgeInsets.fromLTRB(16, 8, 16, 24 + bottomInset),
                  children: [
                    _CreateSection(
                      title: '${l.orderDetailItems} (${cart.items.length})',
                      icon: TablerIcons.shopping_cart,
                      required: true,
                      children: [
                        if (isEmpty)
                          _EmptyCartTile(
                            onAdd: _addLine,
                            label: l.orderCreateEmptyCta,
                          )
                        else ...[
                          for (var i = 0; i < cart.items.length; i++) ...[
                            _CartItemTile(
                              item: cart.items[i],
                              onTap: () => _editLine(i, cart.items[i]),
                              onRemove: () => ref
                                  .read(orderCartProvider.notifier)
                                  .removeLineAt(i),
                            ),
                            if (i < cart.items.length - 1)
                              Divider(
                                height: 1,
                                thickness: 0.5,
                                color: c.borderSoft,
                              ),
                          ],
                          const SizedBox(height: 10),
                          OutlinedButton.icon(
                            onPressed: _addLine,
                            icon: const Icon(TablerIcons.plus, size: 18),
                            label: Text(l.orderCreateAddMore),
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size.fromHeight(44),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              side: BorderSide(color: c.borderSoft),
                              foregroundColor: c.textPrimary,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 18),
                    _CreateSection(
                      title: l.orderDetailCustomer,
                      icon: TablerIcons.user,
                      children: [
                        KTextField(
                          label: l.orderCreateCustomerName,
                          controller: _customerName,
                          placeholder: 'VD: Anh Nam',
                          maxLength: 120,
                        ),
                        const SizedBox(height: 12),
                        KTextField(
                          label: l.orderCreateCustomerPhone,
                          controller: _customerPhone,
                          keyboardType: TextInputType.phone,
                          placeholder: '0xxxxxxxxx',
                          maxLength: 30,
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    _CreateSection(
                      title: l.orderCreateNote,
                      icon: TablerIcons.notes,
                      children: [
                        KTextarea(
                          label: l.orderCreateNote,
                          controller: _note,
                          placeholder: 'Ghi chú thêm cho đơn hàng',
                          maxLines: 4,
                          maxLength: 500,
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    _CreateSection(
                      title: l.orderCreateOrderDiscount,
                      icon: TablerIcons.discount,
                      children: [
                        _DiscountTypeChips(
                          value: _discountType,
                          onChanged: (t) {
                            setState(() {
                              _discountType = t;
                              if (t == null) _discountValue = null;
                            });
                            _pushDiscount();
                          },
                        ),
                        if (_discountType == DiscountType.fixed) ...[
                          const SizedBox(height: 12),
                          KCurrencyField(
                            label: l.orderCreateDiscountTypeFixed,
                            value: _discountValue,
                            onChanged: (v) {
                              setState(() => _discountValue = v);
                              _pushDiscount();
                            },
                          ),
                        ] else if (_discountType ==
                            DiscountType.percentage) ...[
                          const SizedBox(height: 12),
                          _PercentField(
                            label: '${l.orderCreateDiscountTypePercentage} (%)',
                            initialValue: _discountValue,
                            onChanged: (v) {
                              _discountValue = v;
                              _pushDiscount();
                            },
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 18),
                    _CreateSection(
                      title: l.orderCreateManualTax,
                      icon: TablerIcons.receipt_tax,
                      children: [
                        KTextField(
                          label: l.orderCreateManualTax,
                          controller: _manualTax,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          placeholder: 'VD: 8',
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    _SummaryPanel(totals: totals),
                  ],
                ),
              ),
              _CreateFooter(
                isEmpty: isEmpty,
                submitting: _submitting,
                submittingPayment: _submitPayment,
                saveDraftLabel: l.orderCreateSaveDraft,
                payLabel: l.orderCreatePay,
                onSaveDraft: () => _submit(payment: false),
                onPay: () => _submit(payment: true),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Section wrapper (mirrors product_form_screen._CreateSection) ────────────

class _CreateSection extends StatelessWidget {
  const _CreateSection({
    required this.title,
    required this.icon,
    required this.children,
    this.required = false,
  });

  final String title;
  final IconData icon;
  final List<Widget> children;
  final bool required;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: c.surfaceElev,
        border: Border.all(color: c.borderSoft),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: c.accent600),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: c.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                if (required)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: c.dangerSoft,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      'Bắt buộc',
                      style: TextStyle(
                        color: c.danger,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 14),
            ...children,
          ],
        ),
      ),
    );
  }
}

// ─── Cart rows ────────────────────────────────────────────────────────────

class _EmptyCartTile extends StatelessWidget {
  const _EmptyCartTile({required this.onAdd, required this.label});

  final VoidCallback onAdd;
  final String label;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 14),
      decoration: BoxDecoration(
        color: c.pageBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: c.borderSoft),
      ),
      child: Column(
        children: [
          Icon(TablerIcons.shopping_cart, size: 36, color: c.textMuted),
          const SizedBox(height: 10),
          Text(
            'Chưa có sản phẩm trong giỏ',
            style: TextStyle(
              color: c.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: onAdd,
            icon: const Icon(TablerIcons.plus, size: 18),
            label: Text(label),
            style: FilledButton.styleFrom(
              backgroundColor: c.accent600,
              foregroundColor: Colors.white,
              minimumSize: const Size(0, 42),
              padding: const EdgeInsets.symmetric(horizontal: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CartItemTile extends StatelessWidget {
  const _CartItemTile({
    required this.item,
    required this.onTap,
    required this.onRemove,
  });

  final OrderLineItem item;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final money = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: 'đ',
      decimalDigits: 0,
    );
    final qty = item.qty == item.qty.truncate()
        ? item.qty.toStringAsFixed(0)
        : item.qty.toStringAsFixed(2);
    return Dismissible(
      key: ValueKey('cart-${item.productId}-${item.variantId ?? '_'}'),
      direction: DismissDirection.endToStart,
      background: Container(
        color: c.dangerSoft,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Icon(TablerIcons.trash, color: c.danger),
      ),
      onDismissed: (_) => onRemove(),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: 44,
                  height: 44,
                  color: const Color(0xFFEFF1F4),
                  alignment: Alignment.center,
                  child: item.imageUrl != null && item.imageUrl!.isNotEmpty
                      ? Image.network(
                          item.imageUrl!,
                          fit: BoxFit.cover,
                          width: 44,
                          height: 44,
                          errorBuilder: (_, __, ___) => const Icon(
                            TablerIcons.package,
                            size: 22,
                            color: Color(0xFF94A3B8),
                          ),
                        )
                      : const Icon(
                          TablerIcons.package,
                          size: 22,
                          color: Color(0xFF94A3B8),
                        ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.productName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: c.textPrimary,
                      ),
                    ),
                    if (item.variantName?.isNotEmpty ?? false) ...[
                      const SizedBox(height: 2),
                      Text(
                        item.variantName!,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: c.textMuted,
                        ),
                      ),
                    ],
                    const SizedBox(height: 2),
                    Text(
                      '$qty × ${money.format(item.unitPrice)}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: c.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                money.format(item.qty * item.unitPrice),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: c.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Discount type chips (segmented row, no Material dropdown noise) ─────────

class _DiscountTypeChips extends StatelessWidget {
  const _DiscountTypeChips({required this.value, required this.onChanged});

  final DiscountType? value;
  final ValueChanged<DiscountType?> onChanged;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Row(
      children: [
        _Chip(
          label: l.orderCreateDiscountTypeNone,
          selected: value == null,
          onTap: () => onChanged(null),
        ),
        const SizedBox(width: 8),
        _Chip(
          label: l.orderCreateDiscountTypePercentage,
          selected: value == DiscountType.percentage,
          onTap: () => onChanged(DiscountType.percentage),
        ),
        const SizedBox(width: 8),
        _Chip(
          label: l.orderCreateDiscountTypeFixed,
          selected: value == DiscountType.fixed,
          onTap: () => onChanged(DiscountType.fixed),
        ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
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
    return Expanded(
      child: Material(
        color: selected ? c.accent600 : c.pageBg,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: selected ? c.accent600 : c.borderSoft),
            ),
            alignment: Alignment.center,
            child: Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : c.textPrimary,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Percent field (decimal % entry) ─────────────────────────────────────────

class _PercentField extends StatefulWidget {
  const _PercentField({
    required this.label,
    required this.initialValue,
    required this.onChanged,
  });

  final String label;
  final int? initialValue;
  final ValueChanged<int?> onChanged;

  @override
  State<_PercentField> createState() => _PercentFieldState();
}

class _PercentFieldState extends State<_PercentField> {
  late final TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.initialValue?.toString() ?? '');
    _ctrl.addListener(_emit);
  }

  void _emit() {
    widget.onChanged(int.tryParse(_ctrl.text));
  }

  @override
  void dispose() {
    _ctrl
      ..removeListener(_emit)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KTextField(
      label: widget.label,
      controller: _ctrl,
      keyboardType: TextInputType.number,
      placeholder: '0–100',
    );
  }
}

// ─── Summary panel ───────────────────────────────────────────────────────────

class _SummaryPanel extends StatelessWidget {
  const _SummaryPanel({required this.totals});

  final OrderCartTotals totals;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final c = kuruColors(context);
    final money = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: 'đ',
      decimalDigits: 0,
    );
    return Container(
      decoration: BoxDecoration(
        color: c.surfaceElev,
        border: Border.all(color: c.borderSoft),
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      child: Column(
        children: [
          _SumRow(
            label: l.orderDetailSubtotal,
            value: money.format(totals.subtotal),
          ),
          if (totals.orderDiscountAmount > 0)
            _SumRow(
              label: l.orderDetailDiscount,
              value: '−${money.format(totals.orderDiscountAmount)}',
              tone: c.danger,
            ),
          if (totals.taxAmount > 0)
            _SumRow(
              label: l.orderDetailTax,
              value: money.format(totals.taxAmount),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Divider(height: 1, color: c.borderSoft),
          ),
          _SumRow(
            label: l.orderDetailTotal,
            value: money.format(totals.total),
            emphasize: true,
          ),
        ],
      ),
    );
  }
}

class _SumRow extends StatelessWidget {
  const _SumRow({
    required this.label,
    required this.value,
    this.tone,
    this.emphasize = false,
  });

  final String label;
  final String value;
  final Color? tone;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: emphasize ? c.textPrimary : c.textMuted,
                fontSize: emphasize ? 15 : 13,
                fontWeight: emphasize ? FontWeight.w700 : FontWeight.w600,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: tone ?? (emphasize ? c.textPrimary : c.textPrimary),
              fontSize: emphasize ? 18 : 13,
              fontWeight: emphasize ? FontWeight.w800 : FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Footer (mirrors product_form_screen._CreateFooter, 2-button variant) ────

class _CreateFooter extends StatelessWidget {
  const _CreateFooter({
    required this.isEmpty,
    required this.submitting,
    required this.submittingPayment,
    required this.saveDraftLabel,
    required this.payLabel,
    required this.onSaveDraft,
    required this.onPay,
  });

  final bool isEmpty;
  final bool submitting;
  final bool submittingPayment;
  final String saveDraftLabel;
  final String payLabel;
  final VoidCallback onSaveDraft;
  final VoidCallback onPay;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final canSubmit = !isEmpty && !submitting;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: c.surfaceElev,
        border: Border(top: BorderSide(color: c.borderSoft)),
      ),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 50,
              child: OutlinedButton.icon(
                onPressed: canSubmit ? onSaveDraft : null,
                icon: submitting && !submittingPayment
                    ? SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: c.accent600,
                        ),
                      )
                    : const Icon(TablerIcons.bookmark, size: 18),
                label: Text(saveDraftLabel),
                style: OutlinedButton.styleFrom(
                  foregroundColor: c.textPrimary,
                  side: BorderSide(color: c.borderSoft),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SizedBox(
              height: 50,
              child: FilledButton.icon(
                onPressed: canSubmit ? onPay : null,
                icon: submitting && submittingPayment
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                      )
                    : const Icon(TablerIcons.cash, size: 18),
                label: Text(payLabel),
                style: FilledButton.styleFrom(
                  backgroundColor: c.accent600,
                  disabledBackgroundColor: c.accent600.withValues(alpha: 0.38),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
