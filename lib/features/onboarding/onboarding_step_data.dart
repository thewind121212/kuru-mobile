import 'package:flutter/material.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/features/onboarding/illustrations/chart_illustration.dart';
import 'package:kuru_mobile/features/onboarding/illustrations/customer_illustration.dart';
import 'package:kuru_mobile/features/onboarding/illustrations/inventory_illustration.dart';
import 'package:kuru_mobile/features/onboarding/illustrations/multi_store_illustration.dart';
import 'package:kuru_mobile/features/onboarding/illustrations/payment_illustration.dart';
import 'package:kuru_mobile/features/onboarding/illustrations/scan_illustration.dart';

class OnboardingStep {
  const OnboardingStep({
    required this.title,
    required this.body,
    required this.illustration,
  });

  final String title;
  final String body;
  final Widget illustration;
}

List<OnboardingStep> buildOnboardingSteps(AppLocalizations l) => [
      OnboardingStep(
        title: l.onboardingStep1Title,
        body: l.onboardingStep1Body,
        illustration: const ScanIllustration(),
      ),
      OnboardingStep(
        title: l.onboardingStep2Title,
        body: l.onboardingStep2Body,
        illustration: const InventoryIllustration(),
      ),
      OnboardingStep(
        title: l.onboardingStep3Title,
        body: l.onboardingStep3Body,
        illustration: const ChartIllustration(),
      ),
      OnboardingStep(
        title: l.onboardingStep4Title,
        body: l.onboardingStep4Body,
        illustration: const PaymentIllustration(),
      ),
      OnboardingStep(
        title: l.onboardingStep5Title,
        body: l.onboardingStep5Body,
        illustration: const MultiStoreIllustration(),
      ),
      OnboardingStep(
        title: l.onboardingStep6Title,
        body: l.onboardingStep6Body,
        illustration: const CustomerIllustration(),
      ),
    ];
