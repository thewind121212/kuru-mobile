import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
import 'package:kuru_mobile/core/auth/auth_providers.dart';
import 'package:kuru_mobile/core/env/package_info_provider.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/design/auth/auth_backdrop.dart';
import 'package:kuru_mobile/design/auth/auth_logo.dart';

/// Records the moment the splash route was first observed. Used by
/// [splashGateProvider] to enforce a minimum on-screen duration.
final _splashStartProvider = Provider<DateTime>((ref) => DateTime.now());

/// Wraps [appBootstrapProvider] with an 800ms minimum-display floor so the
/// splash route is never rendered for less than a perceivable moment. The
/// router redirect reads THIS provider (not bootstrap directly) so the floor
/// is honored before any route transition.
///
/// If bootstrap takes longer than 800ms, no artificial delay is added.
/// Errors are propagated after the floor has elapsed.
final splashGateProvider = FutureProvider<BootstrapResult>((ref) async {
  final start = ref.read(_splashStartProvider);
  const minSplash = Duration(milliseconds: 800);

  Object? error;
  StackTrace? stack;
  BootstrapResult? value;
  try {
    value = await ref.watch(appBootstrapProvider.future);
  } on Object catch (e, s) {
    error = e;
    stack = s;
  }

  final elapsed = DateTime.now().difference(start);
  if (elapsed < minSplash) {
    await Future<void>.delayed(minSplash - elapsed);
  }

  if (error != null) {
    Error.throwWithStackTrace(error, stack!);
  }
  return value!;
});

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  bool _faded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _faded = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Eagerly trigger the gate; the router redirect reads its state.
    ref.watch(splashGateProvider);
    final pkg = ref.watch(packageInfoProvider);
    final c = kuruColors(context);
    final l = AppLocalizations.of(context);

    return Scaffold(
      body: Stack(
        children: [
          const AuthBackdrop(),
          Center(
            child: AnimatedOpacity(
              opacity: _faded ? 1 : 0,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeIn,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const AuthLogo(simple: true),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.4,
                      color: c.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l.splashTagline,
                    style: TextStyle(fontSize: 13, color: c.textMuted),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 24,
            child: Center(
              child: pkg.maybeWhen(
                data: (info) => Text(
                  'TuiBuonBan · v${info.version}',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.4,
                    color: c.textMuted.withValues(alpha: 0.7),
                  ),
                ),
                orElse: () => const SizedBox.shrink(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
