import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kuru_mobile/core/auth/auth_providers.dart';
import 'package:kuru_mobile/core/auth/onboarding_seen_provider.dart';
import 'package:kuru_mobile/features/catalog/categories/categories_list_screen.dart';
import 'package:kuru_mobile/features/catalog/categories/category_detail_screen.dart';
import 'package:kuru_mobile/features/create_org/create_org_screen.dart';
import 'package:kuru_mobile/features/home/home_stub_screen.dart';
import 'package:kuru_mobile/features/login/login_screen.dart';
import 'package:kuru_mobile/features/main_shell/main_shell.dart';
import 'package:kuru_mobile/features/onboarding/onboarding_screen.dart';
import 'package:kuru_mobile/features/org_picker/org_picker_screen.dart';
import 'package:kuru_mobile/features/register/register_screen.dart';
import 'package:kuru_mobile/features/settings/settings_stub_screen.dart';
import 'package:kuru_mobile/features/splash/splash_screen.dart'
    show SplashScreen, splashGateProvider;
import 'package:kuru_mobile/features/totp/recovery_code_screen.dart';
import 'package:kuru_mobile/features/totp/totp_verification_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      final boot = ref.read(splashGateProvider);
      final seenOnboarding = ref.read(onboardingSeenProvider);
      final loc = state.matchedLocation;
      return boot.when(
        loading: () => loc == '/splash' ? null : '/splash',
        error: (_, __) => loc == '/login' ? null : '/login',
        data: (result) {
          if (result is BootstrapUnauthed) {
            if (!seenOnboarding) {
              return loc == '/onboarding' ? null : '/onboarding';
            }
            const publicRoutes = {'/login', '/register'};
            return publicRoutes.contains(loc) ? null : '/login';
          }
          if (result is BootstrapMfaPending) {
            // Lock the user to /totp and /totp/recovery until verification.
            const mfaRoutes = {'/totp', '/totp/recovery'};
            return mfaRoutes.contains(loc) ? null : '/totp';
          }
          // BootstrapAuthed
          final user = (result as BootstrapAuthed).user;
          if (user.orgInfos.isEmpty) {
            return loc == '/create-org' ? null : '/create-org';
          }
          if (user.orgInfos.length > 1 &&
              ref.read(currentOrgIdProvider) == null) {
            return loc == '/org-picker' ? null : '/org-picker';
          }
          return loc == '/home' ? null : '/home';
        },
      );
    },
    // Re-evaluate redirect whenever bootstrap state changes.
    refreshListenable: _BootstrapNotifier(ref),
    routes: [
      // Unauthenticated routes — unchanged.
      GoRoute(path: '/splash', builder: (_, __) => const SplashScreen()),
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/register', builder: (_, __) => const RegisterScreen()),
      GoRoute(
        path: '/onboarding',
        builder: (_, __) => const OnboardingScreen(),
      ),
      GoRoute(path: '/create-org', builder: (_, __) => const CreateOrgScreen()),
      GoRoute(path: '/org-picker', builder: (_, __) => const OrgPickerScreen()),
      GoRoute(
        path: '/totp',
        builder: (_, __) => const TotpVerificationScreen(),
      ),
      GoRoute(
        path: '/totp/recovery',
        builder: (_, __) => const RecoveryCodeScreen(),
      ),

      // Authenticated shell — bottom-nav with three branches.
      StatefulShellRoute.indexedStack(
        builder: (context, state, navShell) => MainShell(
          currentIndex: navShell.currentIndex,
          onTabChanged: (i) =>
              navShell.goBranch(i, initialLocation: i == navShell.currentIndex),
          body: navShell,
        ),
        branches: [
          // Branch 0: Home
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (_, __) => const HomeStubScreen(),
              ),
            ],
          ),
          // Branch 1: Catalog
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/catalog',
                builder: (_, __) => const CategoriesListScreen(),
                routes: [
                  GoRoute(
                    path: 'categories/:id',
                    builder: (_, state) => CategoryDetailScreen(
                      categoryId: state.pathParameters['id'] ?? '',
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Branch 2: Settings
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                builder: (_, __) => const SettingsStubScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});

class _BootstrapNotifier extends ChangeNotifier {
  _BootstrapNotifier(this._ref) {
    _sub = _ref.listen(splashGateProvider, (_, __) => notifyListeners());
    _onboardingSub = _ref.listen(
      onboardingSeenProvider,
      (_, __) => notifyListeners(),
    );
    _orgIdSub = _ref.listen(currentOrgIdProvider, (_, __) => notifyListeners());
  }
  final Ref _ref;
  late final ProviderSubscription<AsyncValue<BootstrapResult>> _sub;
  late final ProviderSubscription<bool> _onboardingSub;
  late final ProviderSubscription<String?> _orgIdSub;

  @override
  void dispose() {
    _sub.close();
    _onboardingSub.close();
    _orgIdSub.close();
    super.dispose();
  }
}
