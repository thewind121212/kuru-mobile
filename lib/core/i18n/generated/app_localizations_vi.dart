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

  @override
  String get onboardingSkip => 'Bỏ qua';

  @override
  String get onboardingNext => 'Tiếp theo';

  @override
  String get onboardingStart => 'Bắt đầu';

  @override
  String get onboardingStep1Title =>
      'Bán hàng nhanh hơn, chỉ với một lần quét.';

  @override
  String get onboardingStep1Body =>
      'Quét mã vạch để thêm sản phẩm vào giỏ, tính tiền và in hóa đơn — chỉ trong vài giây.';

  @override
  String get onboardingStep2Title => 'Quản lý tồn kho theo thời gian thực.';

  @override
  String get onboardingStep2Body =>
      'Mỗi giao dịch cập nhật tồn kho tức thì. Cảnh báo khi sắp hết hàng.';

  @override
  String get onboardingStep3Title => 'Hiểu cửa hàng của bạn qua từng con số.';

  @override
  String get onboardingStep3Body =>
      'Báo cáo doanh thu, đơn hàng, khách hàng tự động hoá.';

  @override
  String get registerTitle => 'Tạo tài khoản';

  @override
  String get registerSubtitle => 'Bắt đầu với kuru chỉ trong 30 giây.';

  @override
  String get fieldFullName => 'Họ và tên';

  @override
  String get registerStrengthLabel => 'Độ mạnh';

  @override
  String get registerStrengthWeak => 'Yếu';

  @override
  String get registerStrengthFair => 'Khá';

  @override
  String get registerStrengthGood => 'Tốt';

  @override
  String get registerStrengthStrong => 'Mạnh';

  @override
  String registerStrengthCharsCount(int current, int min) {
    return '$current/$min ký tự';
  }

  @override
  String registerTerms(String tos, String privacy) {
    return 'Tôi đồng ý với $tos và $privacy.';
  }

  @override
  String get registerTermsTos => 'Điều khoản dịch vụ';

  @override
  String get registerTermsPrivacy => 'Chính sách bảo mật';

  @override
  String get registerCta => 'Tạo tài khoản';

  @override
  String get registerFooterHasAccount => 'Đã có tài khoản?';

  @override
  String get registerFooterLogin => 'Đăng nhập';

  @override
  String get registerErrorEmailExists => 'Email đã được sử dụng.';

  @override
  String get registerErrorWeakPassword => 'Mật khẩu chưa đủ mạnh.';

  @override
  String get createOrgTitle => 'Tạo cửa hàng của bạn';

  @override
  String get createOrgSubtitle =>
      'Tạo tổ chức và chi nhánh đầu tiên. Bạn có thể thêm chi nhánh khác sau.';

  @override
  String get createOrgBusinessName => 'Tên doanh nghiệp';

  @override
  String get createOrgBranchName => 'Tên chi nhánh đầu tiên';

  @override
  String get createOrgBranchPlaceholder => 'Mặc định: cùng tên doanh nghiệp';

  @override
  String get createOrgCta => 'Tạo cửa hàng';

  @override
  String get createOrgErrorNameRequired => 'Vui lòng nhập tên doanh nghiệp.';

  @override
  String get createOrgErrorServer => 'Không tạo được cửa hàng. Thử lại sau.';

  @override
  String get orgPickerTitle => 'Chọn tổ chức';

  @override
  String orgPickerSubtitle(int count) {
    return 'Bạn là thành viên của $count tổ chức';
  }

  @override
  String get orgPickerCreateNew => 'Tạo tổ chức mới';

  @override
  String get orgPickerNote =>
      'Mỗi tổ chức là một không gian dữ liệu riêng biệt. Bạn có thể chuyển đổi bất kỳ lúc nào trong Cài đặt.';
}
