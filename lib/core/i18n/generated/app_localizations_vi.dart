// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'Kuru';

  @override
  String get splashTagline => 'Đang kết nối...';

  @override
  String get loginTitle => 'Chào mừng trở lại';

  @override
  String get loginSubtitle => 'Đăng nhập kuru để tiếp tục quản lý cửa hàng.';

  @override
  String get fieldEmail => 'Email';

  @override
  String get fieldPassword => 'Mật khẩu';

  @override
  String get loginRemember => 'Ghi nhớ đăng nhập';

  @override
  String get loginCta => 'Đăng nhập';

  @override
  String get loginFooterNoAccount => 'Chưa có tài khoản?';

  @override
  String get loginFooterRegister => 'Đăng ký';

  @override
  String get loginErrorBadCredentials => 'Email hoặc mật khẩu không chính xác.';

  @override
  String get loginErrorNetwork => 'Không có kết nối mạng. Thử lại.';

  @override
  String get loginErrorGeneric => 'Đã có lỗi xảy ra. Thử lại sau.';

  @override
  String get homeStubTitle => 'Đã đăng nhập';

  @override
  String homeStubBody(String email, String orgName) {
    return 'Chào $email, bạn đang ở cửa hàng $orgName.';
  }

  @override
  String get homeStubLogout => 'Đăng xuất';
}
