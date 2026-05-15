// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Kuru';

  @override
  String get splashTagline => 'Connecting...';

  @override
  String get loginTitle => 'Welcome back';

  @override
  String get loginSubtitle => 'Log in to kuru to keep managing your store.';

  @override
  String get fieldEmail => 'Email';

  @override
  String get fieldPassword => 'Password';

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
}
