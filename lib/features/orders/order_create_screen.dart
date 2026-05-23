import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:kuru_mobile/core/auth/auth_providers.dart';
import 'package:kuru_mobile/core/feedback/k_notify.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/design/core/modal/k_confirm_dialog.dart';
import 'package:kuru_mobile/features/orders/data/order_repository.dart';
import 'package:kuru_mobile/features/orders/models/discount_type.dart';
import 'package:kuru_mobile/features/orders/providers/order_providers.dart';
import 'package:kuru_mobile/features/orders/widgets/add_line_sheet.dart';
import 'package:kuru_mobile/features/orders/widgets/cart_line_row.dart';
import 'package:kuru_mobile/features/orders/widgets/order_payment_sheet.dart';
import 'package:uuid/uuid.dart';

class OrderCreateScreen extends ConsumerStatefulWidget {
  const OrderCreateScreen({super.key});

  @override
  ConsumerState<OrderCreateScreen> createState() => _OrderCreateScreenState();
}

class _OrderCreateScreenState extends ConsumerState<OrderCreateScreen> {
  final TextEditingController _customerName = TextEditingController();
  final TextEditingController _customerPhone = TextEditingController();
  final TextEditingController _note = TextEditingController();
  final TextEditingController _orderDiscountValue = TextEditingController();
  final TextEditingController _manualTax = TextEditingController();

  DiscountType? _discountType;

  @override
  void dispose() {
    _customerName.dispose();
    _customerPhone.dispose();
    _note.dispose();
    _orderDiscountValue.dispose();
    _manualTax.dispose();
    super.dispose();
  }

  Future<void> _onSubmit({required bool payment}) async {
    final l = AppLocalizations.of(context);
    final cart = ref.read(orderCartProvider);
    final totals = ref.read(orderCartTotalsProvider);
    final orgId = ref.read(currentOrgIdProvider);
    if (orgId == null) return;

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
    final result = await ref
        .read(orderRepositoryProvider)
        .createOrder(
          orgId: orgId,
          idempotencyKey: key,
          draft: cart,
          payment: paymentInput,
        );

    if (!mounted) return;
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

  Widget _kv(String label, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: bold ? const TextStyle(fontWeight: FontWeight.bold) : null,
          ),
          Text(
            value,
            style: bold ? const TextStyle(fontWeight: FontWeight.bold) : null,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cart = ref.watch(orderCartProvider);
    final notifier = ref.read(orderCartProvider.notifier);
    final isEmpty = cart.items.isEmpty;

    final body = SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Cart list or empty CTA ──────────────────────────────────────
          if (isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
              child: Center(
                child: FilledButton.icon(
                  onPressed: () async {
                    final line = await showAddLineSheet(context);
                    if (line != null) notifier.addLine(line);
                  },
                  icon: const Icon(Icons.add),
                  label: Text(l.orderCreateEmptyCta),
                ),
              ),
            )
          else ...[
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: cart.items.length,
              itemBuilder: (_, i) {
                final item = cart.items[i];
                return CartLineRow(
                  item: item,
                  onTap: () async {
                    final updated = await showAddLineSheet(context, edit: item);
                    if (updated != null) notifier.updateLineAt(i, updated);
                  },
                  onQtyChanged: (q) =>
                      notifier.updateLineAt(i, item.copyWith(qty: q)),
                  onRemove: () => notifier.removeLineAt(i),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: OutlinedButton.icon(
                onPressed: () async {
                  final line = await showAddLineSheet(context);
                  if (line != null) notifier.addLine(line);
                },
                icon: const Icon(Icons.add),
                label: Text(l.orderCreateAddMore),
              ),
            ),
          ],

          const Divider(height: 24),

          // ── Customer fields ─────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _customerName,
                  decoration: InputDecoration(
                    labelText: l.orderCreateCustomerName,
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (v) =>
                      notifier.setCustomer(name: v, phone: _customerPhone.text),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _customerPhone,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: l.orderCreateCustomerPhone,
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (v) =>
                      notifier.setCustomer(name: _customerName.text, phone: v),
                ),
                const SizedBox(height: 12),

                // ── Note ──────────────────────────────────────────────────
                TextField(
                  controller: _note,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: l.orderCreateNote,
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: notifier.setNote,
                ),
                const SizedBox(height: 12),

                // ── Discount type ─────────────────────────────────────────
                DropdownButtonFormField<DiscountType?>(
                  initialValue: _discountType,
                  decoration: InputDecoration(
                    labelText: l.orderCreateOrderDiscount,
                    border: const OutlineInputBorder(),
                  ),
                  items: [
                    DropdownMenuItem(
                      child: Text(l.orderCreateDiscountTypeNone),
                    ),
                    DropdownMenuItem(
                      value: DiscountType.percentage,
                      child: Text(l.orderCreateDiscountTypePercentage),
                    ),
                    DropdownMenuItem(
                      value: DiscountType.fixed,
                      child: Text(l.orderCreateDiscountTypeFixed),
                    ),
                  ],
                  onChanged: (t) {
                    setState(() => _discountType = t);
                    notifier.setOrderDiscount(
                      t,
                      double.tryParse(_orderDiscountValue.text),
                    );
                  },
                ),
                if (_discountType != null) ...[
                  const SizedBox(height: 12),
                  TextField(
                    controller: _orderDiscountValue,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: _discountType == DiscountType.percentage
                          ? l.orderCreateDiscountTypePercentage
                          : l.orderCreateDiscountTypeFixed,
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (v) => notifier.setOrderDiscount(
                      _discountType,
                      double.tryParse(v),
                    ),
                  ),
                ],
                const SizedBox(height: 12),

                // ── Manual tax ────────────────────────────────────────────
                TextField(
                  controller: _manualTax,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: l.orderCreateManualTax,
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (v) =>
                      notifier.setManualTaxPercent(double.tryParse(v)),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),

          // ── Totals card ─────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Consumer(
              builder: (_, ref, __) {
                final t = ref.watch(orderCartTotalsProvider);
                final money = NumberFormat.currency(
                  locale: 'vi_VN',
                  symbol: '₫',
                  decimalDigits: 0,
                );
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _kv(l.orderDetailSubtotal, money.format(t.subtotal)),
                        if (t.orderDiscountAmount > 0)
                          _kv(
                            l.orderDetailDiscount,
                            '- ${money.format(t.orderDiscountAmount)}',
                          ),
                        if (t.taxAmount > 0)
                          _kv(l.orderDetailTax, money.format(t.taxAmount)),
                        const Divider(),
                        _kv(
                          l.orderDetailTotal,
                          money.format(t.total),
                          bold: true,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );

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
        appBar: AppBar(title: Text(l.orderCreateTitle)),
        body: body,
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: isEmpty ? null : () => _onSubmit(payment: false),
                    child: Text(l.orderCreateSaveDraft),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: isEmpty ? null : () => _onSubmit(payment: true),
                    child: Text(l.orderCreatePay),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
