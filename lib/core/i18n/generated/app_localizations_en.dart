// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Simplestore';

  @override
  String get splashTagline => 'Connecting...';

  @override
  String get loginTitle => 'Welcome back';

  @override
  String get loginSubtitle =>
      'Log in to Simplestore to keep managing your store.';

  @override
  String get fieldEmail => 'Email';

  @override
  String get fieldPassword => 'Password';

  @override
  String get fieldPasswordShow => 'Show password';

  @override
  String get fieldPasswordHide => 'Hide password';

  @override
  String get loginRemember => 'Remember me';

  @override
  String get loginCta => 'Log in';

  @override
  String get loginFooterNoAccount => 'No account yet?';

  @override
  String get loginFooterRegister => 'Sign up';

  @override
  String get loginErrorBadCredentials =>
      'Email password combination is incorrect.';

  @override
  String get validationInvalidEmail => 'That doesn\'t look like a valid email.';

  @override
  String get validationEmailRequired => 'Please enter your email.';

  @override
  String get validationPasswordRequired => 'Please enter your password.';

  @override
  String get validationNameRequired => 'Please enter your full name.';

  @override
  String get totpTitle => 'Two-factor verification';

  @override
  String get totpRecoveryTitle => 'Use recovery code';

  @override
  String get totpDescription =>
      'Enter the 6-digit code from your authenticator app.';

  @override
  String get totpRecoveryDescription =>
      'Enter one of your saved recovery codes.';

  @override
  String get totpVerifyButton => 'Verify';

  @override
  String get totpUseRecoveryButton => 'Use recovery code';

  @override
  String get totpLostDevice => 'Lost your device?';

  @override
  String get totpBackToAuthenticator => 'Back to authenticator code';

  @override
  String get totpSignOut => 'Sign out & switch account';

  @override
  String get totpWrongCode => 'Wrong code, please try again.';

  @override
  String get totpRecoveryFailed => 'Invalid recovery code.';

  @override
  String get totpRateLimited =>
      'Too many attempts. Try again in a few minutes.';

  @override
  String get totpRecoveryPlaceholder => 'XXXX-XXXX';

  @override
  String get totpSessionExpired =>
      'Your session expired. Please sign in again.';

  @override
  String get loginErrorNetwork => 'No internet connection. Try again.';

  @override
  String get loginErrorGeneric => 'Oops! Something went wrong.';

  @override
  String get homeStubTitle => 'You\'re logged in';

  @override
  String homeStubBody(String email, String orgName) {
    return 'Hi $email, you\'re working in $orgName.';
  }

  @override
  String get homeStubLogout => 'Log out';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingStart => 'Get started';

  @override
  String get onboardingStep1Title => 'Sell faster — one scan at a time.';

  @override
  String get onboardingStep1Body =>
      'Scan a barcode to add a product, cash out, and print a receipt — in seconds.';

  @override
  String get onboardingStep2Title => 'Inventory updates in real time.';

  @override
  String get onboardingStep2Body =>
      'Every sale moves stock instantly. We warn you when items are running low.';

  @override
  String get onboardingStep3Title =>
      'Understand your store through its numbers.';

  @override
  String get onboardingStep3Body =>
      'Revenue, orders, and customer trends — automated reports, better decisions.';

  @override
  String get onboardingStep4Title => 'Every way to pay.';

  @override
  String get onboardingStep4Body =>
      'Cash, bank transfer, or QR — you accept, Simplestore records every method instantly.';

  @override
  String get onboardingStep5Title => 'One account, many stores.';

  @override
  String get onboardingStep5Body =>
      'Manage multiple branches and teams from one place. Each store stays isolated.';

  @override
  String get onboardingStep6Title => 'Understand every customer.';

  @override
  String get onboardingStep6Body =>
      'Purchase history and personalized offers — keep them coming back.';

  @override
  String get registerTitle => 'Create an account';

  @override
  String get registerSubtitle => 'Start with Simplestore in 30 seconds.';

  @override
  String get fieldFullName => 'Full name';

  @override
  String get registerStrengthLabel => 'Strength';

  @override
  String get registerStrengthWeak => 'Weak';

  @override
  String get registerStrengthFair => 'Fair';

  @override
  String get registerStrengthGood => 'Good';

  @override
  String get registerStrengthStrong => 'Strong';

  @override
  String registerStrengthCharsCount(int current, int min) {
    return '$current/$min chars';
  }

  @override
  String registerTerms(String tos, String privacy) {
    return 'I agree to the $tos and $privacy.';
  }

  @override
  String get registerTermsTos => 'Terms of Service';

  @override
  String get registerTermsPrivacy => 'Privacy Policy';

  @override
  String get registerCta => 'Create account';

  @override
  String get registerFooterHasAccount => 'Already have an account?';

  @override
  String get registerFooterLogin => 'Log in';

  @override
  String get registerErrorEmailExists => 'That email is already in use.';

  @override
  String get registerErrorWeakPassword => 'Password isn\'t strong enough.';

  @override
  String get registerErrorTermsRequired =>
      'Please accept the terms to continue.';

  @override
  String get createOrgTitle => 'Create your store';

  @override
  String get createOrgSubtitle =>
      'Set up your organization and first branch. You can add more branches later.';

  @override
  String get createOrgBusinessName => 'Business name';

  @override
  String get createOrgBranchName => 'First branch name';

  @override
  String get createOrgBranchPlaceholder => 'Default: same as business name';

  @override
  String get createOrgCta => 'Create store';

  @override
  String get createOrgErrorNameRequired => 'Please enter a business name.';

  @override
  String get createOrgErrorServer =>
      'Couldn\'t create the store. Try again later.';

  @override
  String get orgPickerTitle => 'Choose an organization';

  @override
  String orgPickerSubtitle(int count) {
    return 'You belong to $count organizations';
  }

  @override
  String get orgPickerCreateNew => 'Create new organization';

  @override
  String get orgPickerNote =>
      'Each organization is an isolated data space. You can switch any time from Settings.';

  @override
  String get navHome => 'Home';

  @override
  String get navCatalog => 'Catalog';

  @override
  String get navSettings => 'Settings';

  @override
  String get settingsPlaceholder => 'Settings coming soon';

  @override
  String get categoryTitle => 'Categories';

  @override
  String get categorySubtitle => 'Manage product classifications';

  @override
  String get categorySearchHint => 'Search categories...';

  @override
  String get categoryEmptyTitle => 'No categories yet';

  @override
  String get categoryEmptyBody =>
      'Create your first category to organize products.';

  @override
  String get categoryEmptyAction => 'Create first category';

  @override
  String get categoryLayerAll => 'All';

  @override
  String get categoryLayerMain => 'Main';

  @override
  String get categoryLayerSub => 'Sub';

  @override
  String get categoryLayerSubSub => 'Sub Sub';

  @override
  String get categoryLayerPrefix => 'Layer';

  @override
  String categorySubCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count subcategories',
      one: '$count subcategory',
    );
    return '$_temp0';
  }

  @override
  String categoryItemCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '$count item',
    );
    return '$_temp0';
  }

  @override
  String get categoryLoadError => 'Couldn\'t load categories';

  @override
  String get categoryLoadRetry => 'Retry';

  @override
  String get categoryDetailPlaceholder => 'Detail view coming soon';

  @override
  String get categoryStatSubCategories => 'Sub';

  @override
  String get categoryStatItems => 'Items';

  @override
  String get categoryStatValue => 'Value';

  @override
  String categoryLowStockBadge(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count low stock',
      one: '$count low stock',
    );
    return '$_temp0';
  }
}
