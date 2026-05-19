import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_category_api/kuru_category_api.dart' as gen;
import 'package:kuru_mobile/app/router.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/core/auth/auth_providers.dart';
import 'package:kuru_mobile/core/auth/onboarding_seen_provider.dart';
import 'package:kuru_mobile/core/auth/org_info.dart';
import 'package:kuru_mobile/core/auth/user_info.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/features/catalog/categories/category_detail_screen.dart';
import 'package:kuru_mobile/features/catalog/categories/providers/category_providers.dart';
import 'package:kuru_mobile/features/splash/splash_screen.dart';

gen.CategoryResponse _cat({
  required String id,
  required String name,
  String layer = '1',
  String? parentId,
}) => gen.CategoryResponse(
  (b) => b
    ..categoryId = id
    ..name = name
    ..layer = layer
    ..parentId = parentId
    ..orgId = 'org'
    ..itemCount = 0
    ..totalValue = 0
    ..lowStockCount = 0
    ..subCategoriesCount = 0,
);

/// Minimal notifier that always says "onboarding seen" — no SharedPrefs needed.
class _SeenNotifier extends OnboardingSeenController {
  @override
  bool build() => true;
}

/// Returns a fixed org-id from build() without mutating state, preventing the
/// LateInitializationError that occurs when the setter fires notifyListeners()
/// before the GoRouter element is fully mounted.
class _FixedOrgController extends CurrentOrgIdController {
  _FixedOrgController(this._orgId);
  final String _orgId;

  @override
  String? build() => _orgId;
}

void main() {
  testWidgets('renders header (name) + child rows when overview has them', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          categoryByIdProvider(
            'root',
          ).overrideWith((ref) async => _cat(id: 'root', name: 'Electronics')),
          categoryOverviewProvider.overrideWith(
            (ref) async => [
              _cat(id: 'root', name: 'Electronics'),
              _cat(id: 'c1', name: 'Audio', layer: '2', parentId: 'root'),
              _cat(id: 'c2', name: 'Mobile', layer: '2', parentId: 'root'),
            ],
          ),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: CategoryDetailScreen(categoryId: 'root'),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('Electronics'), findsWidgets);
    expect(find.text('Audio'), findsOneWidget);
    expect(find.text('Mobile'), findsOneWidget);
  });

  testWidgets('tapping a child row pushes its detail screen', (tester) async {
    const fakeUser = UserInfo(
      email: 't@x.com',
      orgInfos: <OrgInfo>[OrgInfo(id: 'org-x', name: 'Test', role: 'Owner')],
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          splashGateProvider.overrideWith(
            (ref) async => const BootstrapAuthed(fakeUser),
          ),
          // Uses a subclass that returns the value from build() to avoid a
          // LateInitializationError when the setter fires notifyListeners()
          // before the GoRouter element is fully mounted.
          currentOrgIdProvider.overrideWith(() => _FixedOrgController('org-x')),
          onboardingSeenProvider.overrideWith(_SeenNotifier.new),
          categoryByIdProvider(
            'root',
          ).overrideWith((ref) async => _cat(id: 'root', name: 'Electronics')),
          categoryByIdProvider('c1').overrideWith(
            (ref) async =>
                _cat(id: 'c1', name: 'Audio', layer: '2', parentId: 'root'),
          ),
          categoryOverviewProvider.overrideWith(
            (ref) async => [
              _cat(id: 'root', name: 'Electronics'),
              _cat(id: 'c1', name: 'Audio', layer: '2', parentId: 'root'),
            ],
          ),
        ],
        child: Consumer(
          builder: (ctx, ref, _) {
            final router = ref.watch(routerProvider);
            return MaterialApp.router(
              routerConfig: router,
              theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              locale: const Locale('en'),
            );
          },
        ),
      ),
    );
    // Splash → home.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    await tester.pump(const Duration(milliseconds: 50));
    await tester.pump(const Duration(milliseconds: 50));
    await tester.pump(const Duration(milliseconds: 50));
    // Switch to Catalog tab.
    await tester.tap(find.text('Catalog'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    // Catalog tab now lands on CatalogLauncherScreen. Drill into Categories.
    await tester.tap(find.text('Categories'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    // Tap root category row to open its detail screen.
    await tester.tap(find.text('Electronics'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Detail of root visible — tap the 'Audio' child row to drill in.
    expect(find.text('Audio'), findsOneWidget);
    await tester.tap(find.text('Audio'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Audio's detail screen now shows.
    expect(find.text('Audio'), findsWidgets);
  });
}
