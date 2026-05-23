// (flutter_tabler_icons uses snake_case symbols)
// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:intl/intl.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/features/orders/models/order_payment_status.dart';
import 'package:kuru_mobile/features/orders/models/order_status.dart';
import 'package:kuru_mobile/features/orders/models/order_summary.dart';

/// One order entry inside the grouped list surface.
///
/// Layout: status-tinted receipt icon · order number + meta · total + payment
/// status badge. Designed to be stacked inside a single rounded container with
/// hairline dividers between rows (see OrderListScreen). Not a standalone
/// card — does NOT draw its own border / shadow.
class OrderListRow extends StatelessWidget {
  const OrderListRow({required this.summary, required this.onTap, super.key});

  final OrderSummary summary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final c = kuruColors(context);
    final money = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: 'đ',
      decimalDigits: 0,
    );
    final dt = DateFormat('dd/MM HH:mm').format(summary.createdAt.toLocal());
    final (iconBg, iconFg) = _statusTint(summary.status);
    final trimmedCustomer = summary.customerName?.trim() ?? '';
    final customer = trimmedCustomer.isNotEmpty
        ? trimmedCustomer
        : l.orderWalkIn;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Icon(TablerIcons.receipt_2, size: 20, color: iconFg),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '#${summary.orderNumber}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: c.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      customer,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: c.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${l.orderItemsCount(summary.itemCount)} · $dt',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: c.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    money.format(summary.totalAmount),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: c.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  _PaymentChip(status: summary.paymentStatus),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Pastel pair per order status (matches detail screen tints).
  (Color, Color) _statusTint(OrderStatus status) => switch (status) {
    OrderStatus.draft => (
      const Color(0xFFEFF1F4),
      const Color(0xFF64748B),
    ), // slate
    OrderStatus.pending => (
      const Color(0xFFFEF6E5),
      const Color(0xFFD97706),
    ), // amber
    OrderStatus.completed => (
      const Color(0xFFE6F7F0),
      const Color(0xFF10B981),
    ), // green
    OrderStatus.cancelled => (
      const Color(0xFFFCE7E7),
      const Color(0xFFDC2626),
    ), // red
  };
}

class _PaymentChip extends StatelessWidget {
  const _PaymentChip({required this.status});
  final OrderPaymentStatus status;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final (bg, fg, label) = switch (status) {
      OrderPaymentStatus.unpaid => (
        const Color(0xFFFCE7E7),
        const Color(0xFFDC2626),
        l.orderPaymentStatusUnpaid,
      ),
      OrderPaymentStatus.partial => (
        const Color(0xFFFEF6E5),
        const Color(0xFFD97706),
        l.orderPaymentStatusPartial,
      ),
      OrderPaymentStatus.paid => (
        const Color(0xFFE6F7F0),
        const Color(0xFF10B981),
        l.orderPaymentStatusPaid,
      ),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: fg),
      ),
    );
  }
}
