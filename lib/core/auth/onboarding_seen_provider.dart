import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuru_mobile/main.dart' show sharedPrefsProvider;

const _kHasSeenOnboardingKey = 'kuru.has_seen_onboarding.v1';

/// Persisted "user has finished/skipped onboarding once" flag.
/// Read by router redirect; set to true when the user taps "Bắt đầu" on
/// the last onboarding step or "Bỏ qua" at any step.
class OnboardingSeenController extends Notifier<bool> {
  @override
  bool build() {
    final prefs = ref.read(sharedPrefsProvider);
    return prefs.getBool(_kHasSeenOnboardingKey) ?? false;
  }

  Future<void> markSeen() async {
    final prefs = ref.read(sharedPrefsProvider);
    await prefs.setBool(_kHasSeenOnboardingKey, true);
    state = true;
  }

  /// Test-only — clears persisted flag.
  Future<void> reset() async {
    final prefs = ref.read(sharedPrefsProvider);
    await prefs.remove(_kHasSeenOnboardingKey);
    state = false;
  }
}

final onboardingSeenProvider = NotifierProvider<OnboardingSeenController, bool>(
  OnboardingSeenController.new,
);
