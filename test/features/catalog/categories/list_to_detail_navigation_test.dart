import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_category_api/kuru_category_api.dart' as gen;
import 'package:kuru_mobile/app/router.dart';
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

void main() {
  testWidgets('tapping a row pushes the placeholder detail screen', (
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
          // Override the splash gate so bootstrap resolves immediately to authed.
          splashGateProvider.overrideWith(
            (ref) async => const BootstrapAuthed(fakeUser),
          ),
          // Override currentOrgIdProvider so router sees a selected org and
          // doesn't redirect to /org-picker.
          currentOrgIdProvider.overrideWith(() {
            final n = CurrentOrgIdController();
            return n..orgId = 'org-x';
          }),
          // Onboarding already seen — no SharedPrefs needed.
          onboardingSeenProvider.overrideWith(_SeenNotifier.new),
          // Provide test category data directly, bypassing the real HTTP client.
          categoryOverviewProvider.overrideWith(
            (ref) async => [
              gen.CategoryResponse(
                (b) => b
                  ..categoryId = 'cat-1'
                  ..name = 'Electronics'
                  ..layer = '1'
                  ..orgId = 'org-x'
                  ..itemCount = 0
                  ..totalValue = 0
                  ..lowStockCount = 0,
              ),
            ],
          ),
        ],
        child: Consumer(
          builder: (ctx, ref, _) {
            final router = ref.watch(routerProvider);
            return MaterialApp.router(
              routerConfig: router,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
            );
          },
        ),
      ),
    );

    // Advance through splash → redirect → /home.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    await tester.pump(const Duration(milliseconds: 50));

    // Switch to the Catalog tab (index 1 in the bottom nav).
    await tester.tap(find.text('Catalog'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // The category row should now be visible.
    expect(find.text('Electronics'), findsOneWidget);

    // Tap the row — should push /catalog/categories/cat-1.
    await tester.tap(find.text('Electronics'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // The placeholder detail body should be rendered.
    expect(find.text('Detail view coming soon'), findsOneWidget);
  });
}
