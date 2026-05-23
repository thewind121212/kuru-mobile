import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/core/auth/auth_providers.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/features/orders/models/order_cart_draft.dart';
import 'package:kuru_mobile/features/orders/order_create_screen.dart';
import 'package:kuru_mobile/features/orders/providers/order_providers.dart';

void main() {
  testWidgets('empty cart shows Thêm sản phẩm CTA', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          currentOrgIdProvider.overrideWithValue('org_test'),
          orderCartProvider.overrideWith(_EmptyCartNotifier.new),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: Locale('vi'),
          home: OrderCreateScreen(),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('Thêm sản phẩm'), findsOneWidget);
  });
}

class _EmptyCartNotifier extends OrderCartNotifier {
  @override
  OrderCartDraft build() => const OrderCartDraft();
}
