// (flutter_tabler_icons uses snake_case symbols)
// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
import 'package:kuru_mobile/core/env/env.dart';
import 'package:kuru_mobile/core/feedback/k_notify.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/design/core/catalog/k_settings_row.dart';
import 'package:kuru_mobile/design/core/feedback/k_spinner.dart';
import 'package:kuru_mobile/design/core/input/k_text_field.dart';
import 'package:kuru_mobile/design/core/layout/k_settings_section.dart';
import 'package:kuru_mobile/design/core/modal/k_action_sheet.dart';
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

// Pastel icon-tint pairs matching product_detail_screen.dart.
const _tintPurpleBg = Color(0xFFF1ECFB);
const _tintPurpleFg = Color(0xFF8B5CF6);
const _tintBlueBg = Color(0xFFE7F1FB);
const _tintBlueFg = Color(0xFF3B82F6);
const _tintGreenBg = Color(0xFFE6F7F0);
const _tintGreenFg = Color(0xFF10B981);
const _tintSlateBg = Color(0xFFEFF1F4);
const _tintSlateFg = Color(0xFF64748B);
const _tintAmberBg = Color(0xFFFEF6E5);
const _tintAmberFg = Color(0xFFD97706);

final _vnd = NumberFormat.currency(
  locale: 'vi_VN',
  symbol: 'đ',
  decimalDigits: 0,
);
final _dateLong = DateFormat('dd/MM/yyyy HH:mm');

class OrderDetailScreen extends ConsumerWidget {
  const OrderDetailScreen({required this.orderId, super.key});

  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = kuruColors(context);
    final l = AppLocalizations.of(context);
    final async = ref.watch(orderDetailProvider(orderId));

    return Scaffold(
      backgroundColor: c.pageBg,
      appBar: AppBar(
        backgroundColor: c.pageBg,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          icon: const Icon(TablerIcons.arrow_left),
          onPressed: () => _goBack(context),
        ),
        title: Text(
          async.maybeWhen(
            data: (d) => '#${d.orderNumber}',
            orElse: () => l.orderDetailTitle,
          ),
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: c.textPrimary,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            tooltip: l.commonActions,
            icon: const Icon(TablerIcons.dots_vertical),
            onPressed: async.maybeWhen(
              data: (d) =>
                  () => _openActionMenu(context, ref, d),
              orElse: () => null,
            ),
          ),
        ],
      ),
      bottomNavigationBar: async.maybeWhen(
        data: (d) => _maybeCompleteFooter(context, ref, d, l),
        orElse: () => null,
      ),
      body: async.when(
        loading: () => const Center(child: KSpinner()),
        error: (_, __) => _NotFound(message: l.orderDetailNotFound),
        data: (d) => _Body(detail: d),
      ),
    );
  }

  Widget? _maybeCompleteFooter(
    BuildContext context,
    WidgetRef ref,
    OrderDetail d,
    AppLocalizations l,
  ) {
    final canComplete =
        d.status == OrderStatus.pending &&
        d.paymentStatus == OrderPaymentStatus.paid;
    if (!canComplete) return null;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: FilledButton(
          onPressed: () => _onMarkCompleted(context, ref, d),
          style: FilledButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
          ),
          child: Text(l.orderDetailMarkCompleted),
        ),
      ),
    );
  }

  Future<void> _openActionMenu(
    BuildContext context,
    WidgetRef ref,
    OrderDetail d,
  ) async {
    final l = AppLocalizations.of(context);
    final actions = <KActionItem<String>>[
      if (d.paymentStatus != OrderPaymentStatus.paid &&
          d.status != OrderStatus.cancelled)
        KActionItem(
          id: 'addPayment',
          label: l.orderDetailAddPayment,
          icon: TablerIcons.cash,
        ),
      if (d.status == OrderStatus.draft || d.status == OrderStatus.pending)
        KActionItem(
          id: 'cancel',
          label: l.orderDetailCancel,
          icon: TablerIcons.x,
          danger: true,
        ),
      if (d.status == OrderStatus.completed)
        KActionItem(
          id: 'void',
          label: l.orderDetailVoid,
          icon: TablerIcons.ban,
          danger: true,
        ),
    ];
    if (actions.isEmpty) return;

    final picked = await showKActionSheet<String>(
      context: context,
      title: l.commonActions,
      actions: actions,
    );
    if (picked == null || !context.mounted) return;
    switch (picked) {
      case 'addPayment':
        await _onAddPayment(context, ref, d);
      case 'cancel':
        await _onCancel(context, ref, d);
      case 'void':
        await _onVoid(context, ref, d);
    }
  }
}

void _goBack(BuildContext context) {
  final nav = Navigator.of(context);
  if (nav.canPop()) {
    nav.maybePop();
    return;
  }
  final router = GoRouter.maybeOf(context);
  if (router != null) {
    router.go('/orders');
  }
}

// ─── Status actions ──────────────────────────────────────────────────────────

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

// ─── Body ────────────────────────────────────────────────────────────────────

class _Body extends StatelessWidget {
  const _Body({required this.detail});

  final OrderDetail detail;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final d = detail;
    final hasCustomer =
        (d.customerName != null && d.customerName!.isNotEmpty) ||
        (d.customerPhone != null && d.customerPhone!.isNotEmpty);

    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 12, bottom: 96),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _Hero(detail: d),
          ),
          const SizedBox(height: 20),
          KSettingsSection(
            header: l.orderDetailSectionInfo,
            children: [
              KSettingsRow(
                leadingIcon: TablerIcons.calendar_event,
                iconBackground: _tintBlueBg,
                iconColor: _tintBlueFg,
                label: l.orderDetailFieldCreatedAt,
                trailingText: _dateLong.format(d.createdAt.toLocal()),
                showChevron: false,
              ),
              KSettingsRow(
                leadingIcon: _channelIcon(d.saleChannel.name),
                iconBackground: _tintPurpleBg,
                iconColor: _tintPurpleFg,
                label: l.orderDetailFieldChannel,
                trailingText: _channelLabel(d.saleChannel.name, l),
                showChevron: false,
              ),
              if (d.storeName case final storeName? when storeName.isNotEmpty)
                KSettingsRow(
                  leadingIcon: TablerIcons.building_store,
                  iconBackground: _tintSlateBg,
                  iconColor: _tintSlateFg,
                  label: l.commonStore,
                  trailingText: storeName,
                  showChevron: false,
                ),
            ],
          ),
          if (hasCustomer) ...[
            KSettingsSection(
              header: l.orderDetailCustomer,
              children: [
                if (d.customerName case final name? when name.isNotEmpty)
                  KSettingsRow(
                    leadingIcon: TablerIcons.user,
                    iconBackground: _tintBlueBg,
                    iconColor: _tintBlueFg,
                    label: l.commonName,
                    trailingText: name,
                    showChevron: false,
                  ),
                if (d.customerPhone case final phone? when phone.isNotEmpty)
                  KSettingsRow(
                    leadingIcon: TablerIcons.phone,
                    iconBackground: _tintGreenBg,
                    iconColor: _tintGreenFg,
                    label: l.commonPhone,
                    trailingText: phone,
                    showChevron: false,
                  ),
              ],
            ),
          ],
          KSettingsSection(
            header: '${l.orderDetailItems} (${d.items.length})',
            children: [
              for (var i = 0; i < d.items.length; i++)
                _ItemRow(item: d.items[i]),
            ],
          ),
          KSettingsSection(
            header: l.orderDetailSectionSummary,
            children: [
              _SummaryRow(
                leadingIcon: TablerIcons.list_numbers,
                iconBg: _tintSlateBg,
                iconFg: _tintSlateFg,
                label: l.orderDetailSubtotal,
                value: _vnd.format(d.subtotal),
              ),
              if (d.discountAmount > 0)
                _SummaryRow(
                  leadingIcon: TablerIcons.discount,
                  iconBg: _tintAmberBg,
                  iconFg: _tintAmberFg,
                  label: l.orderDetailDiscount,
                  value: '−${_vnd.format(d.discountAmount)}',
                ),
              if (d.taxAmount > 0)
                _SummaryRow(
                  leadingIcon: TablerIcons.receipt_tax,
                  iconBg: _tintBlueBg,
                  iconFg: _tintBlueFg,
                  label: l.orderDetailTax,
                  value: _vnd.format(d.taxAmount),
                ),
              _SummaryRow(
                leadingIcon: TablerIcons.coin,
                iconBg: _tintGreenBg,
                iconFg: _tintGreenFg,
                label: l.orderDetailTotal,
                value: _vnd.format(d.totalAmount),
                emphasize: true,
              ),
              if (d.paidAmount > 0)
                _SummaryRow(
                  leadingIcon: TablerIcons.check,
                  iconBg: _tintGreenBg,
                  iconFg: _tintGreenFg,
                  label: l.orderDetailPaid,
                  value: _vnd.format(d.paidAmount),
                ),
              if (d.changeAmount > 0)
                _SummaryRow(
                  leadingIcon: TablerIcons.arrow_back_up,
                  iconBg: _tintSlateBg,
                  iconFg: _tintSlateFg,
                  label: l.orderDetailChange,
                  value: _vnd.format(d.changeAmount),
                ),
            ],
          ),
          KSettingsSection(
            header: '${l.orderDetailPayments} (${d.payments.length})',
            children: [
              if (d.payments.isEmpty)
                _EmptyTile(
                  icon: TablerIcons.cash,
                  text: l.orderDetailPaymentsEmpty,
                )
              else
                for (final p in d.payments) _PaymentRow(payment: p),
            ],
          ),
          if (d.note != null && d.note!.isNotEmpty)
            KSettingsSection(
              header: l.orderDetailNote,
              children: [_NoteTile(note: d.note!)],
            ),
        ],
      ),
    );
  }
}

// ─── Hero ────────────────────────────────────────────────────────────────────

class _Hero extends StatelessWidget {
  const _Hero({required this.detail});

  final OrderDetail detail;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      decoration: BoxDecoration(
        color: c.surfaceElev,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              OrderStatusBadge(status: detail.status),
              const SizedBox(width: 8),
              OrderPaymentStatusBadge(status: detail.paymentStatus),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            _vnd.format(detail.totalAmount),
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.6,
              color: c.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Builder(
            builder: (_) {
              final when = _dateLong.format(detail.createdAt.toLocal());
              return Text(
                '#${detail.orderNumber} · $when',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: c.textMuted,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ─── Items section row ───────────────────────────────────────────────────────

class _ItemRow extends StatelessWidget {
  const _ItemRow({required this.item});

  final OrderLineItem item;

  /// Order line items snapshot the image at sale time. BE can store either
  /// a full URL (`http…`) or just the avatar filename — resolve both.
  String? _resolveImageUrl() {
    final raw = item.imageUrl?.trim();
    if (raw == null || raw.isEmpty) return null;
    if (raw.startsWith('http://') || raw.startsWith('https://')) return raw;
    return '${Env.imageBaseUrl}/product-avatar/$raw';
  }

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final qty = item.qty == item.qty.truncate()
        ? item.qty.toStringAsFixed(0)
        : item.qty.toStringAsFixed(2);
    final imageUrl = _resolveImageUrl();
    return InkWell(
      onTap: () => context.push('/products/${item.productId}'),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
                child: imageUrl != null
                    ? Image.network(
                        imageUrl,
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
                  const SizedBox(height: 4),
                  Text(
                    '$qty × ${_vnd.format(item.unitPrice)}',
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _vnd.format(item.totalAmount),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: c.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Icon(TablerIcons.chevron_right, size: 16, color: c.textMuted),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Summary row (emphasize for totals) ──────────────────────────────────────

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.leadingIcon,
    required this.iconBg,
    required this.iconFg,
    required this.label,
    required this.value,
    this.emphasize = false,
  });

  final IconData leadingIcon;
  final Color iconBg;
  final Color iconFg;
  final String label;
  final String value;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Icon(leadingIcon, size: 19, color: iconFg),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: emphasize ? FontWeight.w700 : FontWeight.w500,
                color: c.textPrimary,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: emphasize ? 17 : 14,
              fontWeight: emphasize ? FontWeight.w800 : FontWeight.w600,
              color: emphasize ? c.textPrimary : c.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Payment row ─────────────────────────────────────────────────────────────

class _PaymentRow extends StatelessWidget {
  const _PaymentRow({required this.payment});

  final OrderPayment payment;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final (icon, bg, fg) = _methodVisual(payment.method);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Icon(icon, size: 19, color: fg),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _vnd.format(payment.amount),
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: c.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _dateLong.format(payment.paidAt.toLocal()),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: c.textMuted,
                  ),
                ),
                if (payment.reference != null &&
                    payment.reference!.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    payment.reference!,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: c.textMuted,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyTile extends StatelessWidget {
  const _EmptyTile({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 16, 14, 16),
      child: Row(
        children: [
          Icon(icon, size: 18, color: c.textMuted),
          const SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: c.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _NoteTile extends StatelessWidget {
  const _NoteTile({required this.note});

  final String note;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      child: Text(
        note,
        style: TextStyle(
          fontSize: 14,
          fontStyle: FontStyle.italic,
          color: c.textPrimary,
        ),
      ),
    );
  }
}

class _NotFound extends StatelessWidget {
  const _NotFound({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(TablerIcons.receipt_off, size: 56, color: c.textMuted),
          const SizedBox(height: 12),
          Text(
            message,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: c.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Helpers ─────────────────────────────────────────────────────────────────

(IconData, Color, Color) _methodVisual(OrderPaymentMethod m) => switch (m) {
  OrderPaymentMethod.cash => (TablerIcons.cash, _tintGreenBg, _tintGreenFg),
  OrderPaymentMethod.bankTransfer => (
    TablerIcons.building_bank,
    _tintBlueBg,
    _tintBlueFg,
  ),
  OrderPaymentMethod.card => (
    TablerIcons.credit_card,
    _tintPurpleBg,
    _tintPurpleFg,
  ),
  OrderPaymentMethod.other => (TablerIcons.receipt, _tintSlateBg, _tintSlateFg),
};

IconData _channelIcon(String name) => switch (name) {
  'ecommerce' => TablerIcons.shopping_bag,
  _ => TablerIcons.building_store,
};

String _channelLabel(String name, AppLocalizations l) => switch (name) {
  'ecommerce' => l.orderSaleChannelEcommerce,
  _ => l.orderSaleChannelShop,
};
