import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kuru_mobile/features/orders/models/order_cart_totals.dart';
import 'package:kuru_mobile/features/orders/models/order_line_item.dart';

class CartLineRow extends StatelessWidget {
  const CartLineRow({
    required this.item,
    required this.onTap,
    required this.onQtyChanged,
    required this.onRemove,
    super.key,
  });

  final OrderLineItem item;
  final VoidCallback onTap;
  final ValueChanged<double> onQtyChanged;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final money = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫',
      decimalDigits: 0,
    );
    final lineTotal = computeLineTotal(item);
    final saleUnitPrice = computeLineSaleUnitPrice(item);
    final hasDiscount = computeLineDiscountAmount(item) > 0;
    final qtyStr = item.qty.toStringAsFixed(
      item.qty.truncateToDouble() == item.qty ? 0 : 2,
    );
    final unitFmt = money.format(hasDiscount ? saleUnitPrice : item.unitPrice);
    final totalFmt = money.format(lineTotal);
    final lineSummary = '$qtyStr × $unitFmt = $totalFmt';
    return Dismissible(
      key: ValueKey('cart-line-${item.productId}-${item.variantId ?? '_'}'),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Theme.of(context).colorScheme.errorContainer,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: const Icon(Icons.delete_outline),
      ),
      onDismissed: (_) => onRemove(),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              if (item.imageUrl != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    item.imageUrl!,
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                  ),
                )
              else
                const SizedBox(width: 48, height: 48),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.productName,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    if (item.variantName != null)
                      Text(
                        item.variantName!,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    Text(
                      lineSummary,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: item.qty > 1
                    ? () => onQtyChanged(item.qty - 1)
                    : null,
              ),
              Text(item.qty.toStringAsFixed(0)),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => onQtyChanged(item.qty + 1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
