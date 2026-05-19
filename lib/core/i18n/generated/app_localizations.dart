import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In vi, this message translates to:
  /// **'Simplestore'**
  String get appTitle;

  /// No description provided for @splashTagline.
  ///
  /// In vi, this message translates to:
  /// **'Đang kết nối...'**
  String get splashTagline;

  /// No description provided for @loginTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chào mừng trở lại'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập Simplestore để tiếp tục quản lý cửa hàng.'**
  String get loginSubtitle;

  /// No description provided for @fieldEmail.
  ///
  /// In vi, this message translates to:
  /// **'Email'**
  String get fieldEmail;

  /// No description provided for @fieldPassword.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu'**
  String get fieldPassword;

  /// No description provided for @fieldPasswordShow.
  ///
  /// In vi, this message translates to:
  /// **'Hiện mật khẩu'**
  String get fieldPasswordShow;

  /// No description provided for @fieldPasswordHide.
  ///
  /// In vi, this message translates to:
  /// **'Ẩn mật khẩu'**
  String get fieldPasswordHide;

  /// No description provided for @loginRemember.
  ///
  /// In vi, this message translates to:
  /// **'Ghi nhớ đăng nhập'**
  String get loginRemember;

  /// No description provided for @loginCta.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập'**
  String get loginCta;

  /// No description provided for @loginFooterNoAccount.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có tài khoản?'**
  String get loginFooterNoAccount;

  /// No description provided for @loginFooterRegister.
  ///
  /// In vi, this message translates to:
  /// **'Đăng ký'**
  String get loginFooterRegister;

  /// No description provided for @loginErrorBadCredentials.
  ///
  /// In vi, this message translates to:
  /// **'Email hoặc mật khẩu không chính xác.'**
  String get loginErrorBadCredentials;

  /// No description provided for @validationInvalidEmail.
  ///
  /// In vi, this message translates to:
  /// **'Email không hợp lệ.'**
  String get validationInvalidEmail;

  /// No description provided for @validationEmailRequired.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập email.'**
  String get validationEmailRequired;

  /// No description provided for @validationPasswordRequired.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập mật khẩu.'**
  String get validationPasswordRequired;

  /// No description provided for @validationNameRequired.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập họ tên.'**
  String get validationNameRequired;

  /// No description provided for @totpTitle.
  ///
  /// In vi, this message translates to:
  /// **'Xác thực hai yếu tố'**
  String get totpTitle;

  /// No description provided for @totpRecoveryTitle.
  ///
  /// In vi, this message translates to:
  /// **'Dùng mã khôi phục'**
  String get totpRecoveryTitle;

  /// No description provided for @totpDescription.
  ///
  /// In vi, this message translates to:
  /// **'Nhập mã 6 chữ số từ ứng dụng xác thực.'**
  String get totpDescription;

  /// No description provided for @totpRecoveryDescription.
  ///
  /// In vi, this message translates to:
  /// **'Nhập một trong các mã khôi phục đã lưu.'**
  String get totpRecoveryDescription;

  /// No description provided for @totpVerifyButton.
  ///
  /// In vi, this message translates to:
  /// **'Xác minh'**
  String get totpVerifyButton;

  /// No description provided for @totpUseRecoveryButton.
  ///
  /// In vi, this message translates to:
  /// **'Dùng mã khôi phục'**
  String get totpUseRecoveryButton;

  /// No description provided for @totpLostDevice.
  ///
  /// In vi, this message translates to:
  /// **'Mất thiết bị?'**
  String get totpLostDevice;

  /// No description provided for @totpBackToAuthenticator.
  ///
  /// In vi, this message translates to:
  /// **'Quay lại mã xác thực'**
  String get totpBackToAuthenticator;

  /// No description provided for @totpSignOut.
  ///
  /// In vi, this message translates to:
  /// **'Đăng xuất & đổi tài khoản'**
  String get totpSignOut;

  /// No description provided for @totpWrongCode.
  ///
  /// In vi, this message translates to:
  /// **'Sai mã xác thực, vui lòng thử lại.'**
  String get totpWrongCode;

  /// No description provided for @totpRecoveryFailed.
  ///
  /// In vi, this message translates to:
  /// **'Mã khôi phục không hợp lệ.'**
  String get totpRecoveryFailed;

  /// No description provided for @totpRateLimited.
  ///
  /// In vi, this message translates to:
  /// **'Quá nhiều lần thử. Vui lòng đợi vài phút.'**
  String get totpRateLimited;

  /// No description provided for @totpRecoveryPlaceholder.
  ///
  /// In vi, this message translates to:
  /// **'XXXX-XXXX'**
  String get totpRecoveryPlaceholder;

  /// No description provided for @totpSessionExpired.
  ///
  /// In vi, this message translates to:
  /// **'Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.'**
  String get totpSessionExpired;

  /// No description provided for @loginErrorNetwork.
  ///
  /// In vi, this message translates to:
  /// **'Không có kết nối mạng. Thử lại.'**
  String get loginErrorNetwork;

  /// No description provided for @loginErrorGeneric.
  ///
  /// In vi, this message translates to:
  /// **'Đã có lỗi xảy ra. Thử lại sau.'**
  String get loginErrorGeneric;

  /// No description provided for @homeStubTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đã đăng nhập'**
  String get homeStubTitle;

  /// No description provided for @homeStubBody.
  ///
  /// In vi, this message translates to:
  /// **'Chào {email}, bạn đang ở cửa hàng {orgName}.'**
  String homeStubBody(String email, String orgName);

  /// No description provided for @homeStubLogout.
  ///
  /// In vi, this message translates to:
  /// **'Đăng xuất'**
  String get homeStubLogout;

  /// No description provided for @onboardingSkip.
  ///
  /// In vi, this message translates to:
  /// **'Bỏ qua'**
  String get onboardingSkip;

  /// No description provided for @onboardingNext.
  ///
  /// In vi, this message translates to:
  /// **'Tiếp theo'**
  String get onboardingNext;

  /// No description provided for @onboardingStart.
  ///
  /// In vi, this message translates to:
  /// **'Bắt đầu'**
  String get onboardingStart;

  /// No description provided for @onboardingStep1Title.
  ///
  /// In vi, this message translates to:
  /// **'Bán hàng nhanh hơn, chỉ với một lần quét.'**
  String get onboardingStep1Title;

  /// No description provided for @onboardingStep1Body.
  ///
  /// In vi, this message translates to:
  /// **'Quét mã vạch để thêm sản phẩm vào giỏ, tính tiền và in hóa đơn — chỉ trong vài giây.'**
  String get onboardingStep1Body;

  /// No description provided for @onboardingStep2Title.
  ///
  /// In vi, this message translates to:
  /// **'Quản lý tồn kho theo thời gian thực.'**
  String get onboardingStep2Title;

  /// No description provided for @onboardingStep2Body.
  ///
  /// In vi, this message translates to:
  /// **'Mỗi giao dịch cập nhật tồn kho tức thì. Cảnh báo khi sắp hết hàng.'**
  String get onboardingStep2Body;

  /// No description provided for @onboardingStep3Title.
  ///
  /// In vi, this message translates to:
  /// **'Hiểu cửa hàng của bạn qua từng con số.'**
  String get onboardingStep3Title;

  /// No description provided for @onboardingStep3Body.
  ///
  /// In vi, this message translates to:
  /// **'Báo cáo doanh thu, đơn hàng, khách hàng tự động hoá.'**
  String get onboardingStep3Body;

  /// No description provided for @onboardingStep4Title.
  ///
  /// In vi, this message translates to:
  /// **'Mọi cách thanh toán.'**
  String get onboardingStep4Title;

  /// No description provided for @onboardingStep4Body.
  ///
  /// In vi, this message translates to:
  /// **'Tiền mặt, chuyển khoản, hay quét QR — bạn nhận, Simplestore ghi nhận tức thì.'**
  String get onboardingStep4Body;

  /// No description provided for @onboardingStep5Title.
  ///
  /// In vi, this message translates to:
  /// **'Một tài khoản, nhiều cửa hàng.'**
  String get onboardingStep5Title;

  /// No description provided for @onboardingStep5Body.
  ///
  /// In vi, this message translates to:
  /// **'Quản lý nhiều chi nhánh và đội ngũ trong cùng một nơi. Mỗi cửa hàng vẫn riêng tư.'**
  String get onboardingStep5Body;

  /// No description provided for @onboardingStep6Title.
  ///
  /// In vi, this message translates to:
  /// **'Thấu hiểu từng khách hàng.'**
  String get onboardingStep6Title;

  /// No description provided for @onboardingStep6Body.
  ///
  /// In vi, this message translates to:
  /// **'Lịch sử mua hàng và ưu đãi cá nhân hoá — khách hàng quay lại nhiều hơn.'**
  String get onboardingStep6Body;

  /// No description provided for @registerTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tạo tài khoản'**
  String get registerTitle;

  /// No description provided for @registerSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Bắt đầu với Simplestore chỉ trong 30 giây.'**
  String get registerSubtitle;

  /// No description provided for @fieldFullName.
  ///
  /// In vi, this message translates to:
  /// **'Họ và tên'**
  String get fieldFullName;

  /// No description provided for @registerStrengthLabel.
  ///
  /// In vi, this message translates to:
  /// **'Độ mạnh'**
  String get registerStrengthLabel;

  /// No description provided for @registerStrengthWeak.
  ///
  /// In vi, this message translates to:
  /// **'Yếu'**
  String get registerStrengthWeak;

  /// No description provided for @registerStrengthFair.
  ///
  /// In vi, this message translates to:
  /// **'Khá'**
  String get registerStrengthFair;

  /// No description provided for @registerStrengthGood.
  ///
  /// In vi, this message translates to:
  /// **'Tốt'**
  String get registerStrengthGood;

  /// No description provided for @registerStrengthStrong.
  ///
  /// In vi, this message translates to:
  /// **'Mạnh'**
  String get registerStrengthStrong;

  /// No description provided for @registerStrengthCharsCount.
  ///
  /// In vi, this message translates to:
  /// **'{current}/{min} ký tự'**
  String registerStrengthCharsCount(int current, int min);

  /// No description provided for @registerTerms.
  ///
  /// In vi, this message translates to:
  /// **'Tôi đồng ý với {tos} và {privacy}.'**
  String registerTerms(String tos, String privacy);

  /// No description provided for @registerTermsTos.
  ///
  /// In vi, this message translates to:
  /// **'Điều khoản dịch vụ'**
  String get registerTermsTos;

  /// No description provided for @registerTermsPrivacy.
  ///
  /// In vi, this message translates to:
  /// **'Chính sách bảo mật'**
  String get registerTermsPrivacy;

  /// No description provided for @registerCta.
  ///
  /// In vi, this message translates to:
  /// **'Tạo tài khoản'**
  String get registerCta;

  /// No description provided for @registerFooterHasAccount.
  ///
  /// In vi, this message translates to:
  /// **'Đã có tài khoản?'**
  String get registerFooterHasAccount;

  /// No description provided for @registerFooterLogin.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập'**
  String get registerFooterLogin;

  /// No description provided for @registerErrorEmailExists.
  ///
  /// In vi, this message translates to:
  /// **'Email đã được sử dụng.'**
  String get registerErrorEmailExists;

  /// No description provided for @registerErrorWeakPassword.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu chưa đủ mạnh.'**
  String get registerErrorWeakPassword;

  /// No description provided for @registerErrorTermsRequired.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng đồng ý với điều khoản để tiếp tục.'**
  String get registerErrorTermsRequired;

  /// No description provided for @createOrgTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tạo cửa hàng của bạn'**
  String get createOrgTitle;

  /// No description provided for @createOrgSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Tạo tổ chức và chi nhánh đầu tiên. Bạn có thể thêm chi nhánh khác sau.'**
  String get createOrgSubtitle;

  /// No description provided for @createOrgBusinessName.
  ///
  /// In vi, this message translates to:
  /// **'Tên doanh nghiệp'**
  String get createOrgBusinessName;

  /// No description provided for @createOrgBranchName.
  ///
  /// In vi, this message translates to:
  /// **'Tên chi nhánh đầu tiên'**
  String get createOrgBranchName;

  /// No description provided for @createOrgBranchPlaceholder.
  ///
  /// In vi, this message translates to:
  /// **'Mặc định: cùng tên doanh nghiệp'**
  String get createOrgBranchPlaceholder;

  /// No description provided for @createOrgCta.
  ///
  /// In vi, this message translates to:
  /// **'Tạo cửa hàng'**
  String get createOrgCta;

  /// No description provided for @createOrgErrorNameRequired.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập tên doanh nghiệp.'**
  String get createOrgErrorNameRequired;

  /// No description provided for @createOrgErrorServer.
  ///
  /// In vi, this message translates to:
  /// **'Không tạo được cửa hàng. Thử lại sau.'**
  String get createOrgErrorServer;

  /// No description provided for @orgPickerTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chọn tổ chức'**
  String get orgPickerTitle;

  /// No description provided for @orgPickerSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Bạn là thành viên của {count} tổ chức'**
  String orgPickerSubtitle(int count);

  /// No description provided for @orgPickerCreateNew.
  ///
  /// In vi, this message translates to:
  /// **'Tạo tổ chức mới'**
  String get orgPickerCreateNew;

  /// No description provided for @orgPickerNote.
  ///
  /// In vi, this message translates to:
  /// **'Mỗi tổ chức là một không gian dữ liệu riêng biệt. Bạn có thể chuyển đổi bất kỳ lúc nào trong Cài đặt.'**
  String get orgPickerNote;

  /// No description provided for @navHome.
  ///
  /// In vi, this message translates to:
  /// **'Trang chủ'**
  String get navHome;

  /// No description provided for @navCatalog.
  ///
  /// In vi, this message translates to:
  /// **'Danh mục'**
  String get navCatalog;

  /// No description provided for @navSettings.
  ///
  /// In vi, this message translates to:
  /// **'Cài đặt'**
  String get navSettings;

  /// No description provided for @posOpenTooltip.
  ///
  /// In vi, this message translates to:
  /// **'Mở thu ngân'**
  String get posOpenTooltip;

  /// No description provided for @posComingSoon.
  ///
  /// In vi, this message translates to:
  /// **'Thu ngân sắp ra mắt'**
  String get posComingSoon;

  /// No description provided for @settingsPlaceholder.
  ///
  /// In vi, this message translates to:
  /// **'Cài đặt sắp ra mắt'**
  String get settingsPlaceholder;

  /// No description provided for @categoryTitle.
  ///
  /// In vi, this message translates to:
  /// **'Danh mục'**
  String get categoryTitle;

  /// No description provided for @categorySubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Quản lý phân loại sản phẩm'**
  String get categorySubtitle;

  /// No description provided for @categorySearchHint.
  ///
  /// In vi, this message translates to:
  /// **'Tìm danh mục...'**
  String get categorySearchHint;

  /// No description provided for @categoryEmptyTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có danh mục'**
  String get categoryEmptyTitle;

  /// No description provided for @categoryEmptyBody.
  ///
  /// In vi, this message translates to:
  /// **'Tạo danh mục đầu tiên để sắp xếp sản phẩm.'**
  String get categoryEmptyBody;

  /// No description provided for @categoryEmptyAction.
  ///
  /// In vi, this message translates to:
  /// **'Tạo danh mục đầu tiên'**
  String get categoryEmptyAction;

  /// No description provided for @categoryTabMain.
  ///
  /// In vi, this message translates to:
  /// **'Chính'**
  String get categoryTabMain;

  /// No description provided for @categoryTabSub.
  ///
  /// In vi, this message translates to:
  /// **'Phụ'**
  String get categoryTabSub;

  /// No description provided for @categorySubCount.
  ///
  /// In vi, this message translates to:
  /// **'{count, plural, other{{count} danh mục con}}'**
  String categorySubCount(num count);

  /// No description provided for @categoryItemCount.
  ///
  /// In vi, this message translates to:
  /// **'{count, plural, other{{count} sản phẩm}}'**
  String categoryItemCount(num count);

  /// No description provided for @categoryLoadError.
  ///
  /// In vi, this message translates to:
  /// **'Không tải được danh mục'**
  String get categoryLoadError;

  /// No description provided for @categoryLoadRetry.
  ///
  /// In vi, this message translates to:
  /// **'Thử lại'**
  String get categoryLoadRetry;

  /// No description provided for @categoryDetailPlaceholder.
  ///
  /// In vi, this message translates to:
  /// **'Chi tiết sắp ra mắt'**
  String get categoryDetailPlaceholder;

  /// No description provided for @categoryStatSubCategories.
  ///
  /// In vi, this message translates to:
  /// **'Phụ'**
  String get categoryStatSubCategories;

  /// No description provided for @categoryStatItems.
  ///
  /// In vi, this message translates to:
  /// **'Sản phẩm'**
  String get categoryStatItems;

  /// No description provided for @categoryStatValue.
  ///
  /// In vi, this message translates to:
  /// **'Giá trị'**
  String get categoryStatValue;

  /// No description provided for @categoryLowStockBadge.
  ///
  /// In vi, this message translates to:
  /// **'{count, plural, other{{count} sắp hết}}'**
  String categoryLowStockBadge(num count);

  /// No description provided for @categoryTotalCount.
  ///
  /// In vi, this message translates to:
  /// **'{count, plural, other{{count} danh mục}}'**
  String categoryTotalCount(num count);

  /// No description provided for @categoryCreateTitle.
  ///
  /// In vi, this message translates to:
  /// **'Danh mục mới'**
  String get categoryCreateTitle;

  /// No description provided for @categoryCreateSubcategoryTitle.
  ///
  /// In vi, this message translates to:
  /// **'Danh mục con mới'**
  String get categoryCreateSubcategoryTitle;

  /// No description provided for @categoryEditTitle.
  ///
  /// In vi, this message translates to:
  /// **'Sửa danh mục'**
  String get categoryEditTitle;

  /// No description provided for @categoryFieldName.
  ///
  /// In vi, this message translates to:
  /// **'Tên'**
  String get categoryFieldName;

  /// No description provided for @categoryFieldNameHint.
  ///
  /// In vi, this message translates to:
  /// **'VD: Điện tử'**
  String get categoryFieldNameHint;

  /// No description provided for @categoryFieldDescription.
  ///
  /// In vi, this message translates to:
  /// **'Mô tả'**
  String get categoryFieldDescription;

  /// No description provided for @categoryFieldDescriptionHint.
  ///
  /// In vi, this message translates to:
  /// **'Ghi chú ngắn (tuỳ chọn)'**
  String get categoryFieldDescriptionHint;

  /// No description provided for @categoryFieldStatus.
  ///
  /// In vi, this message translates to:
  /// **'Trạng thái'**
  String get categoryFieldStatus;

  /// No description provided for @categoryFieldIcon.
  ///
  /// In vi, this message translates to:
  /// **'Biểu tượng'**
  String get categoryFieldIcon;

  /// No description provided for @categoryFieldColor.
  ///
  /// In vi, this message translates to:
  /// **'Màu'**
  String get categoryFieldColor;

  /// No description provided for @categoryFieldParent.
  ///
  /// In vi, this message translates to:
  /// **'Danh mục cha'**
  String get categoryFieldParent;

  /// No description provided for @categoryStatusActive.
  ///
  /// In vi, this message translates to:
  /// **'Đang hoạt động'**
  String get categoryStatusActive;

  /// No description provided for @categoryStatusInactive.
  ///
  /// In vi, this message translates to:
  /// **'Ngừng'**
  String get categoryStatusInactive;

  /// No description provided for @categoryStatusArchived.
  ///
  /// In vi, this message translates to:
  /// **'Lưu trữ'**
  String get categoryStatusArchived;

  /// No description provided for @categorySaveCta.
  ///
  /// In vi, this message translates to:
  /// **'Lưu'**
  String get categorySaveCta;

  /// No description provided for @categorySavingCta.
  ///
  /// In vi, this message translates to:
  /// **'Đang lưu…'**
  String get categorySavingCta;

  /// No description provided for @categoryActionEdit.
  ///
  /// In vi, this message translates to:
  /// **'Sửa'**
  String get categoryActionEdit;

  /// No description provided for @categoryActionDelete.
  ///
  /// In vi, this message translates to:
  /// **'Xoá'**
  String get categoryActionDelete;

  /// No description provided for @categoryActionAddSubcategory.
  ///
  /// In vi, this message translates to:
  /// **'Thêm danh mục con'**
  String get categoryActionAddSubcategory;

  /// No description provided for @categoryDeleteConfirmTitle.
  ///
  /// In vi, this message translates to:
  /// **'Xoá danh mục?'**
  String get categoryDeleteConfirmTitle;

  /// No description provided for @categoryDeleteConfirmBody.
  ///
  /// In vi, this message translates to:
  /// **'{name} sẽ bị xoá. Không thể hoàn tác.'**
  String categoryDeleteConfirmBody(Object name);

  /// No description provided for @categoryDeleteConfirmCta.
  ///
  /// In vi, this message translates to:
  /// **'Xoá'**
  String get categoryDeleteConfirmCta;

  /// No description provided for @categoryNotifySaved.
  ///
  /// In vi, this message translates to:
  /// **'Đã lưu danh mục'**
  String get categoryNotifySaved;

  /// No description provided for @categoryNotifyDeleted.
  ///
  /// In vi, this message translates to:
  /// **'Đã xoá danh mục'**
  String get categoryNotifyDeleted;

  /// No description provided for @categoryNotifyNetwork.
  ///
  /// In vi, this message translates to:
  /// **'Không kết nối được máy chủ. Thử lại.'**
  String get categoryNotifyNetwork;

  /// No description provided for @categoryNotifyServer.
  ///
  /// In vi, this message translates to:
  /// **'Đã có lỗi xảy ra. Thử lại sau.'**
  String get categoryNotifyServer;

  /// No description provided for @categoryNotifyForbidden.
  ///
  /// In vi, this message translates to:
  /// **'Bạn không có quyền thực hiện thao tác này.'**
  String get categoryNotifyForbidden;

  /// No description provided for @categoryNotifyRateLimited.
  ///
  /// In vi, this message translates to:
  /// **'Chậm lại nhé — thử lại sau giây lát.'**
  String get categoryNotifyRateLimited;

  /// No description provided for @categoryMaxLayerReached.
  ///
  /// In vi, this message translates to:
  /// **'Đã đạt độ sâu tối đa'**
  String get categoryMaxLayerReached;

  /// No description provided for @categoryDetailSubcategoriesHeader.
  ///
  /// In vi, this message translates to:
  /// **'{count, plural, other{Danh mục con ({count})}}'**
  String categoryDetailSubcategoriesHeader(num count);

  /// No description provided for @categoryDetailNoSubcategories.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có danh mục con'**
  String get categoryDetailNoSubcategories;

  /// No description provided for @catalogHubTitle.
  ///
  /// In vi, this message translates to:
  /// **'Danh mục sản phẩm'**
  String get catalogHubTitle;

  /// No description provided for @catalogHubCategoriesTitle.
  ///
  /// In vi, this message translates to:
  /// **'Danh mục'**
  String get catalogHubCategoriesTitle;

  /// No description provided for @catalogHubCategoriesSub.
  ///
  /// In vi, this message translates to:
  /// **'Tổ chức sản phẩm theo nhóm'**
  String get catalogHubCategoriesSub;

  /// No description provided for @catalogHubBrandsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thương hiệu'**
  String get catalogHubBrandsTitle;

  /// No description provided for @catalogHubBrandsSub.
  ///
  /// In vi, this message translates to:
  /// **'Quản lý các nhà sản xuất'**
  String get catalogHubBrandsSub;

  /// No description provided for @catalogHubDistributorsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Nhà phân phối'**
  String get catalogHubDistributorsTitle;

  /// No description provided for @catalogHubTaxTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thuế'**
  String get catalogHubTaxTitle;

  /// No description provided for @catalogHubComingSoon.
  ///
  /// In vi, this message translates to:
  /// **'Sắp có'**
  String get catalogHubComingSoon;

  /// No description provided for @brandTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thương hiệu'**
  String get brandTitle;

  /// No description provided for @brandTotalCount.
  ///
  /// In vi, this message translates to:
  /// **'{count} thương hiệu'**
  String brandTotalCount(int count);

  /// No description provided for @brandSearchHint.
  ///
  /// In vi, this message translates to:
  /// **'Tìm thương hiệu...'**
  String get brandSearchHint;

  /// No description provided for @brandStatProducts.
  ///
  /// In vi, this message translates to:
  /// **'{count} sản phẩm'**
  String brandStatProducts(int count);

  /// No description provided for @brandEmptyTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có thương hiệu'**
  String get brandEmptyTitle;

  /// No description provided for @brandEmptyBody.
  ///
  /// In vi, this message translates to:
  /// **'Tạo thương hiệu đầu tiên để gom sản phẩm theo nhà sản xuất.'**
  String get brandEmptyBody;

  /// No description provided for @brandEmptyAction.
  ///
  /// In vi, this message translates to:
  /// **'Tạo thương hiệu đầu tiên'**
  String get brandEmptyAction;

  /// No description provided for @brandLoadError.
  ///
  /// In vi, this message translates to:
  /// **'Không tải được danh sách thương hiệu'**
  String get brandLoadError;

  /// No description provided for @brandLoadRetry.
  ///
  /// In vi, this message translates to:
  /// **'Thử lại'**
  String get brandLoadRetry;

  /// No description provided for @brandCreateTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tạo thương hiệu'**
  String get brandCreateTitle;

  /// No description provided for @brandEditTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chỉnh sửa thương hiệu'**
  String get brandEditTitle;

  /// No description provided for @brandFieldNameLabel.
  ///
  /// In vi, this message translates to:
  /// **'Tên thương hiệu *'**
  String get brandFieldNameLabel;

  /// No description provided for @brandFieldNameHint.
  ///
  /// In vi, this message translates to:
  /// **'VD: Bosch, Makita, Stanley'**
  String get brandFieldNameHint;

  /// No description provided for @brandFieldNameRequired.
  ///
  /// In vi, this message translates to:
  /// **'Tên thương hiệu là bắt buộc'**
  String get brandFieldNameRequired;

  /// No description provided for @brandCreateCta.
  ///
  /// In vi, this message translates to:
  /// **'Tạo'**
  String get brandCreateCta;

  /// No description provided for @brandEditCta.
  ///
  /// In vi, this message translates to:
  /// **'Cập nhật'**
  String get brandEditCta;

  /// No description provided for @brandDeleteConfirmTitle.
  ///
  /// In vi, this message translates to:
  /// **'Xóa thương hiệu?'**
  String get brandDeleteConfirmTitle;

  /// No description provided for @brandDeleteConfirmBody.
  ///
  /// In vi, this message translates to:
  /// **'Hành động không thể hoàn tác. {name} sẽ bị xóa.'**
  String brandDeleteConfirmBody(String name);

  /// No description provided for @brandDeleteConfirmCta.
  ///
  /// In vi, this message translates to:
  /// **'Xóa'**
  String get brandDeleteConfirmCta;

  /// No description provided for @brandNotifySaved.
  ///
  /// In vi, this message translates to:
  /// **'Đã lưu thương hiệu'**
  String get brandNotifySaved;

  /// No description provided for @brandNotifyDeleted.
  ///
  /// In vi, this message translates to:
  /// **'Đã xóa thương hiệu'**
  String get brandNotifyDeleted;

  /// No description provided for @brandNotifyServer.
  ///
  /// In vi, this message translates to:
  /// **'Đã có lỗi xảy ra'**
  String get brandNotifyServer;

  /// No description provided for @brandActionEdit.
  ///
  /// In vi, this message translates to:
  /// **'Chỉnh sửa'**
  String get brandActionEdit;

  /// No description provided for @brandActionDelete.
  ///
  /// In vi, this message translates to:
  /// **'Xóa'**
  String get brandActionDelete;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
