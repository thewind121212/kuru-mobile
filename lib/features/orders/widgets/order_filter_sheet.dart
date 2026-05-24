import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/design/core/modal/k_modal_sheet.dart';
import 'package:kuru_mobile/features/orders/models/order_payment_status.dart';
import 'package:kuru_mobile/features/orders/models/order_sale_channel.dart';
import 'package:kuru_mobile/features/orders/providers/order_providers.dart';

Future<void> showOrderFilterSheet(BuildContext context) {
  return showKModalSheet<void>(
    context: context,
    title: AppLocalizations.of(context).orderListFilterTitle,
    builder: (ctx) => const _FilterSheetBody(),
  );
}

class _FilterSheetBody extends ConsumerStatefulWidget {
  const _FilterSheetBody();

  @override
  ConsumerState<_FilterSheetBody> createState() => _FilterSheetBodyState();
}

class _FilterSheetBodyState extends ConsumerState<_FilterSheetBody> {
  OrderPaymentStatus? _ps;
  OrderSaleChannel? _ch;
  DateTimeRange? _range;

  @override
  void initState() {
    super.initState();
    final current = ref.read(orderFiltersProvider);
    _ps = current.paymentStatus;
    _ch = current.saleChannel;
    if (current.fromDate != null && current.toDate != null) {
      _range = DateTimeRange(start: current.fromDate!, end: current.toDate!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DropdownButtonFormField<OrderPaymentStatus?>(
          initialValue: _ps,
          decoration: InputDecoration(
            labelText: l.orderListFilterPaymentStatus,
          ),
          items: [
            DropdownMenuItem(child: Text(l.orderStatusAll)),
            DropdownMenuItem(
              value: OrderPaymentStatus.unpaid,
              child: Text(l.orderPaymentStatusUnpaid),
            ),
            DropdownMenuItem(
              value: OrderPaymentStatus.partial,
              child: Text(l.orderPaymentStatusPartial),
            ),
            DropdownMenuItem(
              value: OrderPaymentStatus.paid,
              child: Text(l.orderPaymentStatusPaid),
            ),
          ],
          onChanged: (v) => setState(() => _ps = v),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<OrderSaleChannel?>(
          initialValue: _ch,
          decoration: InputDecoration(labelText: l.orderListFilterSaleChannel),
          items: [
            DropdownMenuItem(child: Text(l.orderStatusAll)),
            DropdownMenuItem(
              value: OrderSaleChannel.shop,
              child: Text(l.orderSaleChannelShop),
            ),
            DropdownMenuItem(
              value: OrderSaleChannel.ecommerce,
              child: Text(l.orderSaleChannelEcommerce),
            ),
          ],
          onChanged: (v) => setState(() => _ch = v),
        ),
        const SizedBox(height: 12),
        ListTile(
          title: Text(
            '${l.orderListFilterFromDate} → ${l.orderListFilterToDate}',
          ),
          subtitle: Text(
            _range == null
                ? '—'
                : '${_range!.start.toLocal()} → ${_range!.end.toLocal()}',
          ),
          trailing: const Icon(Icons.calendar_today),
          onTap: () async {
            final r = await showDateRangePicker(
              context: context,
              firstDate: DateTime(2020),
              lastDate: DateTime.now().add(const Duration(days: 1)),
              initialDateRange: _range,
            );
            if (r != null) setState(() => _range = r);
          },
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  ref.read(orderFiltersProvider.notifier).reset();
                  Navigator.of(context).pop();
                },
                child: Text(l.orderListFilterReset),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton(
                onPressed: () {
                  ref.read(orderFiltersProvider.notifier)
                    ..setPaymentStatus(_ps)
                    ..setSaleChannel(_ch)
                    ..setDateRange(_range?.start, _range?.end);
                  Navigator.of(context).pop();
                },
                child: Text(l.orderListFilterApply),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
