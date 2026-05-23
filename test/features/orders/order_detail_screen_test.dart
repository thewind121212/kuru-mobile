import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/features/orders/models/order_detail.dart';
import 'package:kuru_mobile/features/orders/models/order_payment_status.dart';
import 'package:kuru_mobile/features/orders/models/order_sale_channel.dart';
import 'package:kuru_mobile/features/orders/models/order_status.dart';
import 'package:kuru_mobile/features/orders/order_detail_screen.dart';
import 'package:kuru_mobile/features/orders/providers/order_providers.dart';

void main() {
  testWidgets('renders order number + status badges for paid pending order', (
    tester,
  ) async {
    final detail = OrderDetail(
      id: 'o_1',
      orgId: 'org',
      orderNumber: 'A-99',
      status: OrderStatus.pending,
      paymentStatus: OrderPaymentStatus.paid,
      subtotal: 100000,
      totalAmount: 100000,
      paidAmount: 100000,
      createdAt: DateTime(2026, 5, 23),
      updatedAt: DateTime(2026, 5, 23),
      createdBy: 'u',
      itemCount: 1,
      saleChannel: OrderSaleChannel.shop,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          orderDetailProvider('o_1').overrideWith((_) async => detail),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: Locale('vi'),
          home: OrderDetailScreen(orderId: 'o_1'),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('#A-99'), findsOneWidget);
    expect(find.text('Chờ xử lý'), findsOneWidget);
    expect(find.text('Đã thanh toán'), findsOneWidget);
  });
}
