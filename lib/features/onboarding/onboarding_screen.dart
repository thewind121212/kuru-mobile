import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
import 'package:kuru_mobile/core/auth/onboarding_seen_provider.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/design/widgets/k_primary_btn.dart';
import 'package:kuru_mobile/design/widgets/k_step_dots.dart';
import 'package:kuru_mobile/features/onboarding/onboarding_step_data.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pageCtl = PageController();
  int _index = 0;

  @override
  void dispose() {
    _pageCtl.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    await ref.read(onboardingSeenProvider.notifier).markSeen();
    if (!mounted) return;
    context.go('/login');
  }

  void _next(int total) {
    if (_index >= total - 1) {
      _finish();
    } else {
      _pageCtl.nextPage(
        duration: const Duration(milliseconds: 240),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final l = AppLocalizations.of(context);
    final steps = buildOnboardingSteps(l);
    final isLast = _index == steps.length - 1;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top row: step count + Skip
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${_index + 1} ',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: c.textPrimary,
                    ),
                  ).asRichWithFaded(steps.length, c.textMuted),
                  TextButton(
                    onPressed: _finish,
                    style: TextButton.styleFrom(
                      foregroundColor: c.textMuted,
                      textStyle: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    child: Text(l.onboardingSkip),
                  ),
                ],
              ),
            ),

            // PageView (illustration + title + body)
            Expanded(
              child: PageView.builder(
                controller: _pageCtl,
                itemCount: steps.length,
                onPageChanged: (i) => setState(() => _index = i),
                itemBuilder: (context, i) {
                  final step = steps[i];
                  return Column(
                    children: [
                      const SizedBox(height: 8),
                      step.illustration,
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              step.title,
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.6,
                                color: c.textPrimary,
                                height: 1.1,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              step.body,
                              style: TextStyle(
                                fontSize: 14,
                                color: c.textSecondary,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            // Bottom: dots + CTA
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 36),
              child: Column(
                children: [
                  KStepDots(count: steps.length, current: _index),
                  const SizedBox(height: 18),
                  KPrimaryBtn(
                    fullWidth: true,
                    icon: Icon(
                      isLast ? Icons.arrow_forward : Icons.chevron_right,
                    ),
                    onPressed: () => _next(steps.length),
                    child: Text(isLast ? l.onboardingStart : l.onboardingNext),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension on Text {
  /// Tiny helper to render the "N / total" indicator with the total grayed out.
  Widget asRichWithFaded(int total, Color faded) {
    return Builder(
      builder: (context) {
        final base = (style ?? const TextStyle()).copyWith(
          color: style?.color ?? Colors.black,
        );
        return RichText(
          text: TextSpan(
            style: base,
            children: [
              TextSpan(text: data ?? ''),
              TextSpan(
                text: '/ $total',
                style: base.copyWith(color: faded.withValues(alpha: 0.6)),
              ),
            ],
          ),
        );
      },
    );
  }
}
