import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:kuru_category_api/kuru_category_api.dart' as gen;
import 'package:kuru_mobile/app/router.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/core/auth/auth_providers.dart';
import 'package:kuru_mobile/core/auth/biometric_providers.dart';
import 'package:kuru_mobile/core/auth/onboarding_seen_provider.dart';
import 'package:kuru_mobile/core/auth/org_info.dart';
import 'package:kuru_mobile/core/auth/user_info.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/core/permissions/permissions_providers.dart';
import 'package:kuru_mobile/core/permissions/resolved_permissions.dart';
import 'package:kuru_mobile/features/catalog/brands/providers/brand_providers.dart';
import 'package:kuru_mobile/features/catalog/categories/providers/category_providers.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_list_filter.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_list_page.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_warehouse_option.dart';
import 'package:kuru_mobile/features/catalog/products/providers/product_providers.dart';
import 'package:kuru_mobile/features/expenses/models/expense_category.dart';
import 'package:kuru_mobile/features/expenses/models/expense_entry.dart';
import 'package:kuru_mobile/features/expenses/models/expense_summary.dart';
import 'package:kuru_mobile/features/expenses/providers/expense_providers.dart';
import 'package:kuru_mobile/features/home/home_stub_screen.dart';
import 'package:kuru_mobile/features/orders/models/order_overview_page.dart';
import 'package:kuru_mobile/features/orders/providers/order_providers.dart';
import 'package:kuru_mobile/features/splash/splash_screen.dart';
import 'package:kuru_mobile/main.dart' show sharedPrefsProvider;
import 'package:shared_preferences/shared_preferences.dart';

/// Minimal notifier that always says "onboarding seen" — no SharedPrefs needed.
class _SeenNotifier extends OnboardingSeenController {
  @override
  bool build() => true;
}

class _EmptyOrderListNotifier extends OrderListNotifier {
  @override
  Future<OrderOverviewPage> build() async {
    return const OrderOverviewPage(orders: [], total: 0, page: 1, limit: 20);
  }
}

class _EmptyProductListNotifier extends ProductListNotifier {
  @override
  Future<ProductListPage> build(ProductListFilter arg) async {
    return const ProductListPage(
      items: [],
      page: 1,
      limit: 50,
      totalProducts: 0,
    );
  }
}

void main() {
  testWidgets('grouped tabs mount screens and preserve stacks', (tester) async {
    const fakeUser = UserInfo(
      email: 'test@x.com',
      orgInfos: <OrgInfo>[
        OrgInfo(id: 'org-x', name: 'Test Org', role: 'Chủ sở hữu'),
      ],
    );

    SharedPreferences.setMockInitialValues(<String, Object>{});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPrefsProvider.overrideWithValue(prefs),
          // Override both bootstrap providers so no real network calls are
          // made. splashGateProvider drives the router redirect;
          // appBootstrapProvider drives the HomeStubScreen body.
          appBootstrapProvider.overrideWith(
            (_) async => const BootstrapAuthed(fakeUser),
          ),
          splashGateProvider.overrideWith(
            (ref) async => const BootstrapAuthed(fakeUser),
          ),
          // Pin org-id so router sees an active org and doesn't redirect to
          // /org-picker.
          currentOrgIdProvider.overrideWithValue('org-x'),
          // Onboarding already seen — no SharedPrefs needed.
          onboardingSeenProvider.overrideWith(_SeenNotifier.new),
          // Provide an empty category list — this test doesn't tap rows.
          categoryOverviewProvider.overrideWith(
            (ref) async => <gen.CategoryResponse>[],
          ),
          brandOverviewProvider.overrideWith((ref) async => const []),
          variantAttributeOverviewProvider.overrideWith(
            (ref) async => const [],
          ),
          productListProvider.overrideWith(_EmptyProductListNotifier.new),
          productWarehouseOptionsProvider.overrideWith(
            (ref) async => const <ProductWarehouseOption>[],
          ),
          orderListProvider.overrideWith(_EmptyOrderListNotifier.new),
          homeLedgerProvider.overrideWith(
            (ref) async => const HomeLedgerSnapshot(
              orders: [],
              totalOrders: 0,
              salesTotal: 0,
              collected: 0,
              receivable: 0,
              expenses: 0,
              expenseCount: 0,
            ),
          ),
          expenseCategoriesProvider.overrideWith(
            (ref) async => const <ExpenseCategory>[],
          ),
          expenseEntriesProvider.overrideWith(
            (ref) async => const <ExpenseEntry>[],
          ),
          expenseSummaryProvider.overrideWith(
            (ref) async => ExpenseSummary.empty(),
          ),
          myPermissionsProvider.overrideWith(
            (ref) async => const ResolvedPermissions(orgRole: OrgRole.staff),
          ),
          biometricEnabledProvider.overrideWith((ref) async => false),
          biometricAvailableProvider.overrideWith((ref) async => false),
        ],
        child: Consumer(
          builder: (ctx, ref, _) {
            final router = ref.watch(routerProvider);
            return MaterialApp.router(
              routerConfig: router,
              theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
              locale: const Locale('en'),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
            );
          },
        ),
      ),
    );

    // Advance through splash → bootstrap → /home (default tab).
    // Pump chain: pumpWidget schedules first frame → pump() lets the
    // FutureProvider microtask run → pump(50ms) lets Riverpod notify →
    // pump(50ms) lets GoRouter fire its redirect → pump(50ms) renders /home.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    await tester.pump(const Duration(milliseconds: 50));
    await tester.pump(const Duration(milliseconds: 50));
    await tester.pump(const Duration(milliseconds: 50));

    // Default tab is Home; the bottom nav still exposes the grouped
    // Cashflow tab.
    expect(find.byIcon(TablerIcons.report_money), findsOneWidget);

    // Tap Catalogue tab (index 1).
    await tester.tap(find.text('Catalogue'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    // Catalogue tab lands on CatalogLauncherScreen. Drill into Categories.
    await tester.tap(find.text('Categories'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    // CategoriesListScreen KPageHeader renders the categoryTitle heading.
    expect(find.text('Categories'), findsWidgets);

    // Tap Cashflow tab, then drill into Expenses from the launcher.
    await tester.tap(find.byIcon(TablerIcons.report_money));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.text('Cashflow'), findsWidgets);
    await tester.tap(find.text('Expenses').last);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.text('Tổng chi trong tháng này'), findsOneWidget);

    // Tap Settings tab. Settings is reached from the bottom nav now.
    await tester.tap(find.text('Settings'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.text('Cài đặt'), findsOneWidget);

    // Tap Catalogue tab again — per-branch stack is preserved, so we land
    // back on CategoriesListScreen (not the launcher).
    await tester.tap(find.text('Catalogue'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.text('Categories'), findsWidgets);
  });

  testWidgets('POS can return to Orders shell branch without page-key clash', (
    tester,
  ) async {
    const fakeUser = UserInfo(
      email: 'test@x.com',
      orgInfos: <OrgInfo>[
        OrgInfo(id: 'org-x', name: 'Test Org', role: 'Chủ sở hữu'),
      ],
    );
    late GoRouter router;

    SharedPreferences.setMockInitialValues(<String, Object>{});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPrefsProvider.overrideWithValue(prefs),
          productWarehouseOptionsProvider.overrideWith(
            (ref) async => const <ProductWarehouseOption>[],
          ),
          appBootstrapProvider.overrideWith(
            (_) async => const BootstrapAuthed(fakeUser),
          ),
          splashGateProvider.overrideWith(
            (ref) async => const BootstrapAuthed(fakeUser),
          ),
          currentOrgIdProvider.overrideWithValue('org-x'),
          onboardingSeenProvider.overrideWith(_SeenNotifier.new),
          categoryOverviewProvider.overrideWith(
            (ref) async => <gen.CategoryResponse>[],
          ),
          orderListProvider.overrideWith(_EmptyOrderListNotifier.new),
          homeLedgerProvider.overrideWith(
            (ref) async => const HomeLedgerSnapshot(
              orders: [],
              totalOrders: 0,
              salesTotal: 0,
              collected: 0,
              receivable: 0,
              expenses: 0,
              expenseCount: 0,
            ),
          ),
          expenseCategoriesProvider.overrideWith(
            (ref) async => const <ExpenseCategory>[],
          ),
          expenseEntriesProvider.overrideWith(
            (ref) async => const <ExpenseEntry>[],
          ),
          expenseSummaryProvider.overrideWith(
            (ref) async => ExpenseSummary.empty(),
          ),
          myPermissionsProvider.overrideWith(
            (ref) async => const ResolvedPermissions(orgRole: OrgRole.staff),
          ),
          biometricEnabledProvider.overrideWith((ref) async => false),
          biometricAvailableProvider.overrideWith((ref) async => false),
        ],
        child: Consumer(
          builder: (ctx, ref, _) {
            router = ref.watch(routerProvider);
            return MaterialApp.router(
              routerConfig: router,
              theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
              locale: const Locale('en'),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
            );
          },
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    await tester.pump(const Duration(milliseconds: 50));
    await tester.pump(const Duration(milliseconds: 50));
    await tester.pump(const Duration(milliseconds: 50));

    await tester.tap(find.byTooltip('Open POS'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.text('POS'), findsOneWidget);

    router.go('/orders');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    await tester.pump(const Duration(milliseconds: 50));
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('Orders'), findsWidgets);
    expect(find.text('POS'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Cashflow launcher opens grouped money screens', (tester) async {
    const fakeUser = UserInfo(
      email: 'test@x.com',
      orgInfos: <OrgInfo>[
        OrgInfo(id: 'org-x', name: 'Test Org', role: 'Chủ sở hữu'),
      ],
    );

    SharedPreferences.setMockInitialValues(<String, Object>{});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPrefsProvider.overrideWithValue(prefs),
          appBootstrapProvider.overrideWith(
            (_) async => const BootstrapAuthed(fakeUser),
          ),
          splashGateProvider.overrideWith(
            (ref) async => const BootstrapAuthed(fakeUser),
          ),
          currentOrgIdProvider.overrideWithValue('org-x'),
          onboardingSeenProvider.overrideWith(_SeenNotifier.new),
          orderListProvider.overrideWith(_EmptyOrderListNotifier.new),
          homeLedgerProvider.overrideWith(
            (ref) async => const HomeLedgerSnapshot(
              orders: [],
              totalOrders: 0,
              salesTotal: 0,
              collected: 0,
              receivable: 0,
              expenses: 0,
              expenseCount: 0,
            ),
          ),
          expenseCategoriesProvider.overrideWith(
            (ref) async => const <ExpenseCategory>[],
          ),
          expenseEntriesProvider.overrideWith(
            (ref) async => const <ExpenseEntry>[],
          ),
          expenseSummaryProvider.overrideWith(
            (ref) async => ExpenseSummary.empty(),
          ),
          myPermissionsProvider.overrideWith(
            (ref) async => const ResolvedPermissions(orgRole: OrgRole.staff),
          ),
          biometricEnabledProvider.overrideWith((ref) async => false),
          biometricAvailableProvider.overrideWith((ref) async => false),
        ],
        child: Consumer(
          builder: (ctx, ref, _) {
            final router = ref.watch(routerProvider);
            return MaterialApp.router(
              routerConfig: router,
              theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
              locale: const Locale('en'),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
            );
          },
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    await tester.pump(const Duration(milliseconds: 50));
    await tester.pump(const Duration(milliseconds: 50));
    await tester.pump(const Duration(milliseconds: 50));

    await tester.tap(find.byIcon(TablerIcons.report_money));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.text('Orders'), findsWidgets);
    expect(find.text('Expenses'), findsOneWidget);
    expect(find.text('Imports'), findsOneWidget);

    await tester.tap(find.text('Orders').first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.text('Orders'), findsWidgets);

    await tester.tap(find.byIcon(TablerIcons.report_money));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    await tester.tap(find.text('Expenses').last);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.text('Tổng chi trong tháng này'), findsOneWidget);
  });
}
