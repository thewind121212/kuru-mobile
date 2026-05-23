import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/design/core/catalog/k_list_row.dart';
import 'package:kuru_mobile/features/orders/models/order_sale_channel.dart';
import 'package:kuru_mobile/features/orders/models/order_summary.dart';
import 'package:kuru_mobile/features/orders/widgets/order_payment_status_badge.dart';
import 'package:kuru_mobile/features/orders/widgets/order_status_badge.dart';

class OrderListRow extends StatelessWidget {
  const OrderListRow({required this.summary, required this.onTap, super.key});
  final OrderSummary summary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final money = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫',
      decimalDigits: 0,
    );
    final dt = DateFormat('dd/MM HH:mm').format(summary.createdAt.toLocal());
    return KListRow(
      leading: Icon(
        summary.saleChannel == OrderSaleChannel.ecommerce
            ? Icons.shopping_bag_outlined
            : Icons.storefront_outlined,
      ),
      title: '#${summary.orderNumber}',
      subtitle:
          '${summary.customerName ?? l.orderWalkIn} • '
          '${l.orderItemsCount(summary.itemCount)} • $dt',
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            money.format(summary.totalAmount),
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              OrderStatusBadge(status: summary.status),
              const SizedBox(width: 4),
              OrderPaymentStatusBadge(status: summary.paymentStatus),
            ],
          ),
        ],
      ),
      onTap: onTap,
    );
  }
}
