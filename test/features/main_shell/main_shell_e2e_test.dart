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
import 'package:kuru_mobile/features/catalog/categories/providers/category_providers.dart';
import 'package:kuru_mobile/features/splash/splash_screen.dart';

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
  testWidgets('three tabs mount correct screens; tap returns to mounted tab', (
    tester,
  ) async {
    const fakeUser = UserInfo(
      email: 'test@x.com',
      orgInfos: <OrgInfo>[
        OrgInfo(id: 'org-x', name: 'Test Org', role: 'Chủ sở hữu'),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          // Override both bootstrap providers so no real network calls are
          // made. splashGateProvider drives the router redirect;
          // appBootstrapProvider drives the HomeStubScreen body.
          appBootstrapProvider.overrideWith(
            (_) async => const BootstrapAuthed(fakeUser),
          ),
          splashGateProvider.overrideWith(
            (ref) async => const BootstrapAuthed(fakeUser),
          ),
          // Override currentOrgIdProvider so router sees a selected org and
          // doesn't redirect to /org-picker.
          currentOrgIdProvider.overrideWith(() => _FixedOrgController('org-x')),
          // Onboarding already seen — no SharedPrefs needed.
          onboardingSeenProvider.overrideWith(_SeenNotifier.new),
          // Provide an empty category list — this test doesn't tap rows.
          categoryOverviewProvider.overrideWith(
            (ref) async => <gen.CategoryResponse>[],
          ),
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

    // Default tab is Home — HomeStubScreen renders homeStubTitle.
    expect(find.text("You're logged in"), findsOneWidget);

    // Tap Catalog tab (index 1).
    await tester.tap(find.text('Catalog'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    // Catalog tab now lands on CatalogLauncherScreen. Drill into Categories.
    await tester.tap(find.text('Categories'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    // CategoriesListScreen KPageHeader renders the categoryTitle heading.
    expect(find.text('Categories'), findsWidgets);

    // Tap Settings tab (index 2).
    await tester.tap(find.text('Settings'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.text('Settings coming soon'), findsOneWidget);

    // Tap Catalog tab again — per-branch stack is preserved, so we land
    // back on CategoriesListScreen (not the launcher).
    await tester.tap(find.text('Catalog'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.text('Categories'), findsWidgets);
  });
}
