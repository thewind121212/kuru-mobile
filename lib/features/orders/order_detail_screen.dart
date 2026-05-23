import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:intl/intl.dart';
import 'package:kuru_mobile/core/feedback/k_notify.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/design/core/feedback/k_empty_state.dart';
import 'package:kuru_mobile/design/core/feedback/k_spinner.dart';
import 'package:kuru_mobile/design/core/input/k_text_field.dart';
import 'package:kuru_mobile/design/core/modal/k_confirm_dialog.dart';
import 'package:kuru_mobile/design/core/modal/k_modal_sheet.dart';
import 'package:kuru_mobile/features/orders/models/order_detail.dart';
import 'package:kuru_mobile/features/orders/models/order_line_item.dart';
import 'package:kuru_mobile/features/orders/models/order_payment.dart';
import 'package:kuru_mobile/features/orders/models/order_payment_method.dart';
import 'package:kuru_mobile/features/orders/models/order_payment_status.dart';
import 'package:kuru_mobile/features/orders/models/order_status.dart';
import 'package:kuru_mobile/features/orders/providers/order_providers.dart';
import 'package:kuru_mobile/features/orders/widgets/order_payment_sheet.dart';
import 'package:kuru_mobile/features/orders/widgets/order_payment_status_badge.dart';
import 'package:kuru_mobile/features/orders/widgets/order_status_badge.dart';
import 'package:uuid/uuid.dart';

class OrderDetailScreen extends ConsumerWidget {
  const OrderDetailScreen({required this.orderId, super.key});

  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final async = ref.watch(orderDetailProvider(orderId));
    final money = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫',
      decimalDigits: 0,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(l.orderDetailTitle),
        actions: async.valueOrNull == null
            ? null
            : [
                PopupMenuButton<_StatusAction>(
                  onSelected: (action) {
                    final d = async.value!;
                    switch (action) {
                      case _StatusAction.cancel:
                        _onCancel(context, ref, d);
                      case _StatusAction.void_:
                        _onVoid(context, ref, d);
                    }
                  },
                  itemBuilder: (ctx) {
                    final d = async.value!;
                    return [
                      if (d.status == OrderStatus.draft ||
                          d.status == OrderStatus.pending)
                        PopupMenuItem(
                          value: _StatusAction.cancel,
                          child: Text(l.orderDetailCancel),
                        ),
                      if (d.status == OrderStatus.completed)
                        PopupMenuItem(
                          value: _StatusAction.void_,
                          child: Text(l.orderDetailVoid),
                        ),
                    ];
                  },
                ),
              ],
      ),
      bottomNavigationBar:
          async.valueOrNull != null &&
              async.value!.status == OrderStatus.pending &&
              async.value!.paymentStatus == OrderPaymentStatus.paid
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: FilledButton(
                  onPressed: () => _onMarkCompleted(context, ref, async.value!),
                  child: Text(l.orderDetailMarkCompleted),
                ),
              ),
            )
          : null,
      body: async.when(
        loading: () => const Center(child: KSpinner()),
        error: (_, __) => Center(
          child: KEmptyState(
            icon: Icons.search_off,
            title: l.orderDetailNotFound,
          ),
        ),
        data: (d) => _DetailBody(detail: d, money: money),
      ),
    );
  }
}

// ─── Status actions ──────────────────────────────────────────────────────────

enum _StatusAction { cancel, void_ }

Future<void> _onMarkCompleted(
  BuildContext context,
  WidgetRef ref,
  OrderDetail d,
) async {
  final l = AppLocalizations.of(context);
  final confirmed = await showKConfirmDialog(
    context: context,
    title: l.orderDetailMarkCompletedDialogTitle,
    tone: KConfirmDialogTone.info,
  );
  if (confirmed != true || !context.mounted) return;
  final res = await ref
      .read(orderRepositoryProvider)
      .updateOrderStatus(orderId: d.id, status: OrderStatus.completed);
  if (!context.mounted) return;
  switch (res) {
    case ApiSuccess<void>():
      ref.invalidate(orderDetailProvider(d.id));
      ref.invalidate(orderListProvider);
      KNotify.success(context, AppLocalizations.of(context).orderDetailUpdated);
    case ApiFailure<void>(:final err):
      KNotify.warning(context, err.message);
  }
}

Future<void> _onCancel(
  BuildContext context,
  WidgetRef ref,
  OrderDetail d,
) async {
  final l = AppLocalizations.of(context);
  final reasonCtrl = TextEditingController();
  final reason = await showKModalSheet<String>(
    context: context,
    title: l.orderDetailCancelDialogTitle,
    builder: (ctx) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          KTextField(
            controller: reasonCtrl,
            label: l.orderDetailCancelReasonHint,
            maxLength: 500,
          ),
          const SizedBox(height: 12),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: reasonCtrl,
            builder: (_, v, __) => FilledButton(
              onPressed: v.text.trim().isEmpty
                  ? null
                  : () => Navigator.of(ctx).pop(reasonCtrl.text.trim()),
              child: Text(l.orderDetailCancel),
            ),
          ),
        ],
      ),
    ),
  );
  reasonCtrl.dispose();
  if (reason == null || !context.mounted) return;
  final res = await ref
      .read(orderRepositoryProvider)
      .updateOrderStatus(
        orderId: d.id,
        status: OrderStatus.cancelled,
        cancelledReason: reason,
      );
  if (!context.mounted) return;
  switch (res) {
    case ApiSuccess<void>():
      ref.invalidate(orderDetailProvider(d.id));
      ref.invalidate(orderListProvider);
      KNotify.success(context, AppLocalizations.of(context).orderDetailUpdated);
    case ApiFailure<void>(:final err):
      KNotify.warning(context, err.message);
  }
}

Future<void> _onVoid(BuildContext context, WidgetRef ref, OrderDetail d) async {
  final l = AppLocalizations.of(context);
  final confirmed = await showKConfirmDialog(
    context: context,
    title: l.orderDetailVoidDialogTitle,
    subtitle: l.orderDetailVoidDialogBody,
  );
  if (confirmed != true || !context.mounted) return;
  final res = await ref.read(orderRepositoryProvider).voidOrder(orderId: d.id);
  if (!context.mounted) return;
  switch (res) {
    case ApiSuccess<void>():
      ref.invalidate(orderDetailProvider(d.id));
      ref.invalidate(orderListProvider);
      KNotify.success(context, AppLocalizations.of(context).orderDetailUpdated);
    case ApiFailure<void>(:final err):
      KNotify.warning(context, err.message);
  }
}

Future<void> _onAddPayment(
  BuildContext context,
  WidgetRef ref,
  OrderDetail d,
  NumberFormat money,
) async {
  final outstanding = d.totalAmount - d.paidAmount;
  final input = await showOrderPaymentSheet(
    context,
    defaultAmount: outstanding,
  );
  if (input == null) return;
  final idempotencyKey = const Uuid().v4();
  final result = await ref
      .read(orderRepositoryProvider)
      .addOrderPayment(
        orderId: d.id,
        idempotencyKey: idempotencyKey,
        method: input.method,
        amount: input.amount,
        reference: input.reference,
        note: input.note,
      );
  if (!context.mounted) return;
  switch (result) {
    case ApiSuccess<String>():
      ref.invalidate(orderDetailProvider(d.id));
      ref.invalidate(orderListProvider);
      KNotify.success(context, AppLocalizations.of(context).orderDetailUpdated);
    case ApiFailure<String>(:final err):
      KNotify.warning(context, err.message);
  }
}

// ─── Detail body ─────────────────────────────────────────────────────────────

class _DetailBody extends StatelessWidget {
  const _DetailBody({required this.detail, required this.money});

  final OrderDetail detail;
  final NumberFormat money;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final d = detail;
    final dateFmt = DateFormat('dd/MM/yyyy HH:mm');
    final hasCustomer = d.customerName != null || d.customerPhone != null;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        // ── Header card ──
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '#${d.orderNumber}',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    OrderStatusBadge(status: d.status),
                    const SizedBox(width: 8),
                    OrderPaymentStatusBadge(status: d.paymentStatus),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  money.format(d.totalAmount),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (d.paidAmount > 0)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      '${l.orderDetailPaid}: ${money.format(d.paidAmount)}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                const SizedBox(height: 8),
                Text(
                  dateFmt.format(d.createdAt.toLocal()),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),

        // ── Customer section ──
        if (hasCustomer) ...[
          _SectionHeader(label: l.orderDetailCustomer),
          Card(
            child: ListTile(
              leading: const Icon(Icons.person_outline),
              title: d.customerName != null ? Text(d.customerName!) : null,
              subtitle: d.customerPhone != null ? Text(d.customerPhone!) : null,
            ),
          ),
        ],

        // ── Items section ──
        _SectionHeader(label: l.orderDetailItems),
        Card(
          child: Column(
            children: [
              for (final item in d.items)
                ListTile(
                  leading: item.imageUrl != null
                      ? Image.network(
                          item.imageUrl!,
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              const Icon(TablerIcons.package),
                        )
                      : const Icon(TablerIcons.package),
                  title: Text(item.productName),
                  subtitle: item.variantName != null
                      ? Text(item.variantName!)
                      : null,
                  trailing: _ItemTrailing(item: item, money: money),
                ),
            ],
          ),
        ),

        // ── Summary card ──
        const SizedBox(height: 4),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _kv(l.orderDetailSubtotal, money.format(d.subtotal)),
                if (d.discountAmount > 0)
                  _kv(
                    l.orderDetailDiscount,
                    '−${money.format(d.discountAmount)}',
                  ),
                if (d.taxAmount > 0)
                  _kv(l.orderDetailTax, money.format(d.taxAmount)),
                const Divider(height: 16),
                _kv(
                  l.orderDetailTotal,
                  money.format(d.totalAmount),
                  bold: true,
                ),
              ],
            ),
          ),
        ),

        // ── Note section ──
        if (d.note != null && d.note!.isNotEmpty) ...[
          _SectionHeader(label: l.orderDetailNote),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                d.note!,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
              ),
            ),
          ),
        ],

        // ── Payments section ──
        _SectionHeader(label: l.orderDetailPayments),
        Card(
          child: Column(
            children: [
              for (final p in d.payments)
                _PaymentTile(payment: p, money: money),
              if (d.paymentStatus != OrderPaymentStatus.paid &&
                  d.status != OrderStatus.cancelled)
                _AddPaymentTile(
                  detail: d,
                  money: money,
                  label: l.orderDetailAddPayment,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ItemTrailing extends StatelessWidget {
  const _ItemTrailing({required this.item, required this.money});
  final OrderLineItem item;
  final NumberFormat money;

  @override
  Widget build(BuildContext context) {
    final qty = item.qty == item.qty.truncate()
        ? item.qty.toStringAsFixed(0)
        : item.qty.toStringAsFixed(2);
    return Text(
      '$qty × ${money.format(item.unitPrice)}'
      ' = ${money.format(item.totalAmount)}',
      style: Theme.of(context).textTheme.bodySmall,
      textAlign: TextAlign.end,
    );
  }
}

class _PaymentTile extends StatelessWidget {
  const _PaymentTile({required this.payment, required this.money});
  final OrderPayment payment;
  final NumberFormat money;

  @override
  Widget build(BuildContext context) {
    final dateFmt = DateFormat('dd/MM/yyyy HH:mm');
    final icon = switch (payment.method) {
      OrderPaymentMethod.cash => TablerIcons.cash,
      OrderPaymentMethod.bankTransfer => TablerIcons.building_bank,
      OrderPaymentMethod.card => TablerIcons.credit_card,
      OrderPaymentMethod.other => TablerIcons.receipt,
    };
    return ListTile(
      leading: Icon(icon),
      title: Text(money.format(payment.amount)),
      subtitle: payment.reference != null ? Text(payment.reference!) : null,
      trailing: Text(
        dateFmt.format(payment.paidAt.toLocal()),
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }
}

class _AddPaymentTile extends ConsumerWidget {
  const _AddPaymentTile({
    required this.detail,
    required this.money,
    required this.label,
  });
  final OrderDetail detail;
  final NumberFormat money;
  final String label;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: const Icon(TablerIcons.plus),
      title: Text(label),
      onTap: () => _onAddPayment(context, ref, detail, money),
    );
  }
}

// ─── Helpers ─────────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(4, 16, 4, 8),
    child: Text(label, style: Theme.of(context).textTheme.titleMedium),
  );
}

Widget _kv(String k, String v, {bool bold = false}) => Padding(
  padding: const EdgeInsets.symmetric(vertical: 4),
  child: Row(
    children: [
      Expanded(child: Text(k)),
      Text(
        v,
        style: bold ? const TextStyle(fontWeight: FontWeight.w700) : null,
      ),
    ],
  ),
);
