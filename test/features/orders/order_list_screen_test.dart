import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/core/auth/auth_providers.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/features/orders/models/order_overview_page.dart';
import 'package:kuru_mobile/features/orders/order_list_screen.dart';
import 'package:kuru_mobile/features/orders/providers/order_providers.dart';

class _FakeOrderListNotifier extends OrderListNotifier {
  _FakeOrderListNotifier(this._page);
  final OrderOverviewPage _page;
  @override
  Future<OrderOverviewPage> build() async => _page;
}

void main() {
  testWidgets('shows title and empty-state when no orders', (tester) async {
    const emptyPage = OrderOverviewPage(
      orders: [],
      total: 0,
      page: 1,
      limit: 20,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          currentOrgIdProvider.overrideWithValue('org_test'),
          orderListProvider.overrideWith(
            () => _FakeOrderListNotifier(emptyPage),
          ),
        ],
        child: MaterialApp(
          theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('vi'),
          home: const OrderListScreen(),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    // Title
    expect(find.text('Đơn hàng'), findsWidgets);
    // Empty state
    expect(find.text('Chưa có đơn hàng nào'), findsOneWidget);
  });
}
