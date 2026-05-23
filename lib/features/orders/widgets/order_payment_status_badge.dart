import 'package:flutter/material.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/features/orders/models/order_payment_status.dart';

class OrderPaymentStatusBadge extends StatelessWidget {
  const OrderPaymentStatusBadge({required this.status, super.key});
  final OrderPaymentStatus status;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final (label, bg, fg) = switch (status) {
      OrderPaymentStatus.unpaid => (
        l.orderPaymentStatusUnpaid,
        scheme.errorContainer,
        scheme.onErrorContainer,
      ),
      OrderPaymentStatus.partial => (
        l.orderPaymentStatusPartial,
        scheme.tertiaryContainer,
        scheme.onTertiaryContainer,
      ),
      OrderPaymentStatus.paid => (
        l.orderPaymentStatusPaid,
        scheme.primaryContainer,
        scheme.onPrimaryContainer,
      ),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(color: fg),
      ),
    );
  }
}
