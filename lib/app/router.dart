import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kuru_mobile/core/auth/auth_providers.dart';
import 'package:kuru_mobile/core/auth/onboarding_seen_provider.dart';
import 'package:kuru_mobile/features/catalog/brands/brands_list_screen.dart';
import 'package:kuru_mobile/features/catalog/catalog_launcher_screen.dart';
import 'package:kuru_mobile/features/catalog/categories/categories_list_screen.dart';
import 'package:kuru_mobile/features/catalog/categories/category_detail_screen.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_detail.dart';
import 'package:kuru_mobile/features/catalog/products/product_detail_screen.dart';
import 'package:kuru_mobile/features/catalog/products/product_form_screen.dart';
import 'package:kuru_mobile/features/catalog/products/products_list_screen.dart';
import 'package:kuru_mobile/features/create_org/create_org_screen.dart';
import 'package:kuru_mobile/features/home/home_stub_screen.dart';
import 'package:kuru_mobile/features/login/login_screen.dart';
import 'package:kuru_mobile/features/main_shell/main_shell.dart';
import 'package:kuru_mobile/features/onboarding/onboarding_screen.dart';
import 'package:kuru_mobile/features/org_picker/org_picker_screen.dart';
import 'package:kuru_mobile/features/register/register_screen.dart';
import 'package:kuru_mobile/features/settings/appearance_screen.dart';
import 'package:kuru_mobile/features/settings/profile_screen.dart';
import 'package:kuru_mobile/features/settings/security_screen.dart';
import 'package:kuru_mobile/features/settings/settings_home_screen.dart';
import 'package:kuru_mobile/features/settings/store_screen.dart';
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

      // Prefer the LAST resolved value over the transient AsyncLoading we
      // re-enter every time someone invalidates `appBootstrapProvider`
      // (sign-in, sign-out, org switch, TOTP verify, …). Without this,
      // every invalidate bounces the user through `/splash`, which feels
      // like the splash is re-rendering on every fetch. Initial cold
      // start has no previous value → falls through to the splash branch
      // exactly once, which is what we want.
      final settled = boot.valueOrNull;
      if (settled != null) {
        return _routeForBootstrap(
          settled,
          loc,
          seenOnboarding,
          ref.read(currentOrgIdProvider),
        );
      }

      return boot.when(
        loading: () => loc == '/splash' ? null : '/splash',
        error: (_, __) => loc == '/login' ? null : '/login',
        data: (result) => _routeForBootstrap(
          result,
          loc,
          seenOnboarding,
          ref.read(currentOrgIdProvider),
        ),
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
                builder: (_, __) => const CatalogLauncherScreen(),
                routes: [
                  GoRoute(
                    path: 'categories',
                    builder: (_, __) => const CategoriesListScreen(),
                    routes: [
                      GoRoute(
                        path: ':id',
                        builder: (_, state) => CategoryDetailScreen(
                          categoryId: state.pathParameters['id'] ?? '',
                        ),
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'brands',
                    builder: (_, __) => const BrandsListScreen(),
                  ),
                  GoRoute(
                    path: 'products',
                    builder: (_, __) => const ProductsListScreen(),
                    routes: [
                      GoRoute(
                        path: 'create',
                        builder: (_, __) => const ProductFormScreen(),
                      ),
                      GoRoute(
                        path: ':id',
                        builder: (_, state) => ProductDetailScreen(
                          productId: state.pathParameters['id']!,
                        ),
                      ),
                      GoRoute(
                        path: ':id/edit',
                        builder: (_, state) => ProductFormScreen(
                          initial: state.extra as ProductDetail?,
                        ),
                      ),
                    ],
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
                builder: (_, __) => const SettingsHomeScreen(),
                routes: [
                  GoRoute(
                    path: 'profile',
                    builder: (_, __) => const ProfileScreen(),
                  ),
                  GoRoute(
                    path: 'security',
                    builder: (_, __) => const SecurityScreen(),
                  ),
                  GoRoute(
                    path: 'store',
                    builder: (_, __) => const StoreScreen(),
                  ),
                  GoRoute(
                    path: 'appearance',
                    builder: (_, __) => const AppearanceScreen(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
});

/// Pure router-table function: where should an authenticated/unauthenticated
/// user end up given the resolved [BootstrapResult]? Returns null to keep
/// the user on [loc], or a target path to redirect to.
String? _routeForBootstrap(
  BootstrapResult result,
  String loc,
  bool seenOnboarding,
  String? currentOrgId,
) {
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
  if (user.orgInfos.length > 1 && currentOrgId == null) {
    return loc == '/org-picker' ? null : '/org-picker';
  }
  // Authed shell branches — bottom-nav routes (and their sub-paths) are
  // all valid destinations. Without this safelist, a deep link / push
  // notification / restored URL hitting /catalog or /settings would
  // bounce back to /home.
  const authedShellPrefixes = ['/home', '/catalog', '/settings'];
  final isAuthedShellRoute = authedShellPrefixes.any(loc.startsWith);
  return isAuthedShellRoute ? null : '/home';
}

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
