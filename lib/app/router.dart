import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kuru_mobile/core/auth/auth_providers.dart';
import 'package:kuru_mobile/core/auth/onboarding_seen_provider.dart';
import 'package:kuru_mobile/features/home/home_stub_screen.dart';
import 'package:kuru_mobile/features/login/login_screen.dart';
import 'package:kuru_mobile/features/onboarding/onboarding_screen.dart';
import 'package:kuru_mobile/features/splash/splash_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      final boot = ref.read(appBootstrapProvider);
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
            return loc == '/login' ? null : '/login';
          }
          // BootstrapAuthed
          return loc == '/home' ? null : '/home';
        },
      );
    },
    // Re-evaluate redirect whenever bootstrap state changes.
    refreshListenable: _BootstrapNotifier(ref),
    routes: [
      GoRoute(path: '/splash', builder: (_, __) => const SplashScreen()),
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/onboarding', builder: (_, __) => const OnboardingScreen()),
      GoRoute(path: '/home', builder: (_, __) => const HomeStubScreen()),
    ],
  );
});

class _BootstrapNotifier extends ChangeNotifier {
  _BootstrapNotifier(this._ref) {
    _sub = _ref.listen(appBootstrapProvider, (_, __) => notifyListeners());
    _onboardingSub =
        _ref.listen(onboardingSeenProvider, (_, __) => notifyListeners());
  }
  final Ref _ref;
  late final ProviderSubscription<AsyncValue<BootstrapResult>> _sub;
  late final ProviderSubscription<bool> _onboardingSub;

  @override
  void dispose() {
    _sub.close();
    _onboardingSub.close();
    super.dispose();
  }
}
