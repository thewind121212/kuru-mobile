import 'package:flutter/material.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/features/orders/models/order_status.dart';

class OrderStatusBadge extends StatelessWidget {
  const OrderStatusBadge({required this.status, super.key});
  final OrderStatus status;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final (label, bg, fg) = switch (status) {
      OrderStatus.draft => (
        l.orderStatusDraft,
        scheme.surfaceContainerHighest,
        scheme.onSurfaceVariant,
      ),
      OrderStatus.pending => (
        l.orderStatusPending,
        scheme.tertiaryContainer,
        scheme.onTertiaryContainer,
      ),
      OrderStatus.completed => (
        l.orderStatusCompleted,
        scheme.primaryContainer,
        scheme.onPrimaryContainer,
      ),
      OrderStatus.cancelled => (
        l.orderStatusCancelled,
        scheme.errorContainer,
        scheme.onErrorContainer,
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
