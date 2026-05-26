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

  /// No description provided for @totpSignOutConfirm.
  ///
  /// In vi, this message translates to:
  /// **'Đăng xuất khỏi phiên xác thực này? Bạn sẽ cần đăng nhập lại từ đầu.'**
  String get totpSignOutConfirm;

  /// No description provided for @commonCancel.
  ///
  /// In vi, this message translates to:
  /// **'Hủy'**
  String get commonCancel;

  /// No description provided for @commonSignOut.
  ///
  /// In vi, this message translates to:
  /// **'Đăng xuất'**
  String get commonSignOut;

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

  /// No description provided for @navLedger.
  ///
  /// In vi, this message translates to:
  /// **'Thu chi'**
  String get navLedger;

  /// No description provided for @navExpenses.
  ///
  /// In vi, this message translates to:
  /// **'Chi phí'**
  String get navExpenses;

  /// No description provided for @navImport.
  ///
  /// In vi, this message translates to:
  /// **'Nhập hàng'**
  String get navImport;

  /// No description provided for @navProducts.
  ///
  /// In vi, this message translates to:
  /// **'Sản phẩm'**
  String get navProducts;

  /// No description provided for @navSettings.
  ///
  /// In vi, this message translates to:
  /// **'Cài đặt'**
  String get navSettings;

  /// No description provided for @ledgerOrdersSub.
  ///
  /// In vi, this message translates to:
  /// **'Theo dõi đơn bán và thanh toán'**
  String get ledgerOrdersSub;

  /// No description provided for @ledgerExpensesSub.
  ///
  /// In vi, this message translates to:
  /// **'Ghi lại tiền nhập hàng và vận hành'**
  String get ledgerExpensesSub;

  /// No description provided for @ledgerImportSub.
  ///
  /// In vi, this message translates to:
  /// **'Nhập kho và ghi giá vốn mua hàng'**
  String get ledgerImportSub;

  /// No description provided for @ledgerHubSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Theo dõi tiền thu, tiền chi và chi phí nhập hàng.'**
  String get ledgerHubSubtitle;

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

  /// No description provided for @posTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thu ngân'**
  String get posTitle;

  /// No description provided for @posSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Bắt đầu bán nhanh từ điện thoại.'**
  String get posSubtitle;

  /// No description provided for @posHeroMetric.
  ///
  /// In vi, this message translates to:
  /// **'Bán hàng nhanh'**
  String get posHeroMetric;

  /// No description provided for @posHeroMeta.
  ///
  /// In vi, this message translates to:
  /// **'Tạo đơn, nhận thanh toán và ghi nhận tồn kho từ cùng một luồng.'**
  String get posHeroMeta;

  /// No description provided for @posPrimaryAction.
  ///
  /// In vi, this message translates to:
  /// **'Tạo đơn bán'**
  String get posPrimaryAction;

  /// No description provided for @posSectionStart.
  ///
  /// In vi, this message translates to:
  /// **'Bắt đầu'**
  String get posSectionStart;

  /// No description provided for @posQuickOrder.
  ///
  /// In vi, this message translates to:
  /// **'Đơn bán nhanh'**
  String get posQuickOrder;

  /// No description provided for @posQuickOrderMeta.
  ///
  /// In vi, this message translates to:
  /// **'Tạo đơn mới từ giỏ hàng'**
  String get posQuickOrderMeta;

  /// No description provided for @posScanBarcode.
  ///
  /// In vi, this message translates to:
  /// **'Quét mã vạch'**
  String get posScanBarcode;

  /// No description provided for @posScanBarcodeMeta.
  ///
  /// In vi, this message translates to:
  /// **'Luồng quét sản phẩm sẽ nối vào POS sau'**
  String get posScanBarcodeMeta;

  /// No description provided for @posScanComingSoon.
  ///
  /// In vi, this message translates to:
  /// **'Quét mã vạch trong POS sẽ được nối ở bước tiếp theo'**
  String get posScanComingSoon;

  /// No description provided for @posSectionManage.
  ///
  /// In vi, this message translates to:
  /// **'Quản lý'**
  String get posSectionManage;

  /// No description provided for @posViewOrders.
  ///
  /// In vi, this message translates to:
  /// **'Xem đơn hàng'**
  String get posViewOrders;

  /// No description provided for @posViewOrdersMeta.
  ///
  /// In vi, this message translates to:
  /// **'Mở danh sách đơn đã tạo'**
  String get posViewOrdersMeta;

  /// No description provided for @posPayment.
  ///
  /// In vi, this message translates to:
  /// **'Thanh toán'**
  String get posPayment;

  /// No description provided for @posSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Hoàn tất'**
  String get posSuccess;

  /// No description provided for @posSearchLabel.
  ///
  /// In vi, this message translates to:
  /// **'Tìm bằng tên'**
  String get posSearchLabel;

  /// No description provided for @posSearchHint.
  ///
  /// In vi, this message translates to:
  /// **'Nhập tên sản phẩm'**
  String get posSearchHint;

  /// No description provided for @posScanPrimary.
  ///
  /// In vi, this message translates to:
  /// **'Quét sản phẩm'**
  String get posScanPrimary;

  /// No description provided for @posBranchLabel.
  ///
  /// In vi, this message translates to:
  /// **'Chi nhánh'**
  String get posBranchLabel;

  /// No description provided for @posBranchLoading.
  ///
  /// In vi, this message translates to:
  /// **'Đang tải chi nhánh'**
  String get posBranchLoading;

  /// No description provided for @posBranchMissing.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có chi nhánh bán hàng'**
  String get posBranchMissing;

  /// No description provided for @posBranchRequired.
  ///
  /// In vi, this message translates to:
  /// **'Chọn chi nhánh trước khi thu tiền'**
  String get posBranchRequired;

  /// No description provided for @posBranchPickerTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chọn chi nhánh bán hàng'**
  String get posBranchPickerTitle;

  /// No description provided for @posScanHint.
  ///
  /// In vi, this message translates to:
  /// **'Hướng camera vào mã vạch sản phẩm'**
  String get posScanHint;

  /// No description provided for @posBarcodeAdded.
  ///
  /// In vi, this message translates to:
  /// **'Đã thêm sản phẩm từ mã vạch'**
  String get posBarcodeAdded;

  /// No description provided for @posEmptySearch.
  ///
  /// In vi, this message translates to:
  /// **'Bấm nút Quét sản phẩm bên dưới'**
  String get posEmptySearch;

  /// No description provided for @posEmptySearchMeta.
  ///
  /// In vi, this message translates to:
  /// **'Hoặc nhập tên sản phẩm nếu không quét được mã.'**
  String get posEmptySearchMeta;

  /// No description provided for @posNoProducts.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy sản phẩm phù hợp'**
  String get posNoProducts;

  /// No description provided for @posCart.
  ///
  /// In vi, this message translates to:
  /// **'Giỏ hàng'**
  String get posCart;

  /// No description provided for @posCartHint.
  ///
  /// In vi, this message translates to:
  /// **'Thêm ít nhất một sản phẩm để thanh toán.'**
  String get posCartHint;

  /// No description provided for @posEmptyCart.
  ///
  /// In vi, this message translates to:
  /// **'Giỏ hàng đang trống'**
  String get posEmptyCart;

  /// No description provided for @posClearCart.
  ///
  /// In vi, this message translates to:
  /// **'Xóa giỏ'**
  String get posClearCart;

  /// No description provided for @posRemoveLine.
  ///
  /// In vi, this message translates to:
  /// **'Xóa dòng hàng'**
  String get posRemoveLine;

  /// No description provided for @posAdjustLineTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chỉnh dòng hàng'**
  String get posAdjustLineTitle;

  /// No description provided for @posAdjustQty.
  ///
  /// In vi, this message translates to:
  /// **'Số lượng'**
  String get posAdjustQty;

  /// No description provided for @posAdjustUnitPrice.
  ///
  /// In vi, this message translates to:
  /// **'Giá bán'**
  String get posAdjustUnitPrice;

  /// No description provided for @posBaseUnitPrice.
  ///
  /// In vi, this message translates to:
  /// **'Giá gốc'**
  String get posBaseUnitPrice;

  /// No description provided for @posUnitReduction.
  ///
  /// In vi, this message translates to:
  /// **'Giảm giá'**
  String get posUnitReduction;

  /// No description provided for @posReductionAmount.
  ///
  /// In vi, this message translates to:
  /// **'Số tiền giảm'**
  String get posReductionAmount;

  /// No description provided for @posNoReduction.
  ///
  /// In vi, this message translates to:
  /// **'Không giảm'**
  String get posNoReduction;

  /// No description provided for @posReductionPrompt.
  ///
  /// In vi, this message translates to:
  /// **'Bấm để giảm'**
  String get posReductionPrompt;

  /// No description provided for @posResetReduction.
  ///
  /// In vi, this message translates to:
  /// **'Đặt lại'**
  String get posResetReduction;

  /// No description provided for @posLineTotal.
  ///
  /// In vi, this message translates to:
  /// **'Thành tiền'**
  String get posLineTotal;

  /// No description provided for @posSaveLine.
  ///
  /// In vi, this message translates to:
  /// **'Cập nhật'**
  String get posSaveLine;

  /// No description provided for @posViewProductDetail.
  ///
  /// In vi, this message translates to:
  /// **'Xem chi tiết sản phẩm'**
  String get posViewProductDetail;

  /// No description provided for @posTotal.
  ///
  /// In vi, this message translates to:
  /// **'Tổng tiền'**
  String get posTotal;

  /// No description provided for @posCharge.
  ///
  /// In vi, this message translates to:
  /// **'Thu tiền'**
  String get posCharge;

  /// No description provided for @posAmountReceived.
  ///
  /// In vi, this message translates to:
  /// **'Tiền khách đưa'**
  String get posAmountReceived;

  /// No description provided for @posChange.
  ///
  /// In vi, this message translates to:
  /// **'Tiền thối'**
  String get posChange;

  /// No description provided for @posRemaining.
  ///
  /// In vi, this message translates to:
  /// **'Còn thiếu'**
  String get posRemaining;

  /// No description provided for @posConfirmPayment.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận thanh toán'**
  String get posConfirmPayment;

  /// No description provided for @posPaymentNote.
  ///
  /// In vi, this message translates to:
  /// **'Đơn sẽ được tạo và ghi nhận thanh toán ngay.'**
  String get posPaymentNote;

  /// No description provided for @posPaymentReference.
  ///
  /// In vi, this message translates to:
  /// **'Nội dung chuyển khoản'**
  String get posPaymentReference;

  /// No description provided for @posPaymentFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không thể tạo đơn thanh toán'**
  String get posPaymentFailed;

  /// No description provided for @posSuccessTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thanh toán thành công'**
  String get posSuccessTitle;

  /// No description provided for @posSuccessBody.
  ///
  /// In vi, this message translates to:
  /// **'Đơn bán đã được tạo và giỏ hàng đã được làm mới.'**
  String get posSuccessBody;

  /// No description provided for @posNewSale.
  ///
  /// In vi, this message translates to:
  /// **'Đơn mới'**
  String get posNewSale;

  /// No description provided for @posViewOrder.
  ///
  /// In vi, this message translates to:
  /// **'Xem đơn vừa tạo'**
  String get posViewOrder;

  /// No description provided for @settingsPlaceholder.
  ///
  /// In vi, this message translates to:
  /// **'Cài đặt sắp ra mắt'**
  String get settingsPlaceholder;

  /// No description provided for @categoryTitle.
  ///
  /// In vi, this message translates to:
  /// **'Nhóm sản phẩm'**
  String get categoryTitle;

  /// No description provided for @categorySubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Quản lý nhóm sản phẩm'**
  String get categorySubtitle;

  /// No description provided for @categorySearchHint.
  ///
  /// In vi, this message translates to:
  /// **'Tìm nhóm sản phẩm...'**
  String get categorySearchHint;

  /// No description provided for @categoryEmptyTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có nhóm sản phẩm'**
  String get categoryEmptyTitle;

  /// No description provided for @categoryEmptyBody.
  ///
  /// In vi, this message translates to:
  /// **'Tạo nhóm sản phẩm đầu tiên để sắp xếp sản phẩm.'**
  String get categoryEmptyBody;

  /// No description provided for @categoryEmptyAction.
  ///
  /// In vi, this message translates to:
  /// **'Tạo nhóm sản phẩm đầu tiên'**
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
  /// **'{count, plural, other{{count} nhóm con}}'**
  String categorySubCount(num count);

  /// No description provided for @categoryItemCount.
  ///
  /// In vi, this message translates to:
  /// **'{count, plural, other{{count} sản phẩm}}'**
  String categoryItemCount(num count);

  /// No description provided for @categoryLoadError.
  ///
  /// In vi, this message translates to:
  /// **'Không tải được nhóm sản phẩm'**
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
  /// **'{count, plural, other{{count} nhóm sản phẩm}}'**
  String categoryTotalCount(num count);

  /// No description provided for @categoryCreateTitle.
  ///
  /// In vi, this message translates to:
  /// **'Nhóm sản phẩm mới'**
  String get categoryCreateTitle;

  /// No description provided for @categoryCreateSubcategoryTitle.
  ///
  /// In vi, this message translates to:
  /// **'Nhóm sản phẩm con mới'**
  String get categoryCreateSubcategoryTitle;

  /// No description provided for @categoryEditTitle.
  ///
  /// In vi, this message translates to:
  /// **'Sửa nhóm sản phẩm'**
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
  /// **'Nhóm cha'**
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
  /// **'Thêm nhóm con'**
  String get categoryActionAddSubcategory;

  /// No description provided for @categoryDeleteConfirmTitle.
  ///
  /// In vi, this message translates to:
  /// **'Xoá nhóm sản phẩm?'**
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
  /// **'Đã lưu nhóm sản phẩm'**
  String get categoryNotifySaved;

  /// No description provided for @categoryNotifyDeleted.
  ///
  /// In vi, this message translates to:
  /// **'Đã xoá nhóm sản phẩm'**
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
  /// **'{count, plural, other{Nhóm con ({count})}}'**
  String categoryDetailSubcategoriesHeader(num count);

  /// No description provided for @categoryDetailNoSubcategories.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có nhóm con'**
  String get categoryDetailNoSubcategories;

  /// No description provided for @catalogHubTitle.
  ///
  /// In vi, this message translates to:
  /// **'Danh mục'**
  String get catalogHubTitle;

  /// No description provided for @catalogHubSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Quản lý sản phẩm, nhóm sản phẩm và thương hiệu trong một chỗ.'**
  String get catalogHubSubtitle;

  /// No description provided for @catalogHubProductsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Sản phẩm'**
  String get catalogHubProductsTitle;

  /// No description provided for @catalogHubProductsSub.
  ///
  /// In vi, this message translates to:
  /// **'Quản lý hàng hóa và thông tin bán'**
  String get catalogHubProductsSub;

  /// No description provided for @catalogHubCategoriesTitle.
  ///
  /// In vi, this message translates to:
  /// **'Nhóm sản phẩm'**
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
  String brandTotalCount(num count);

  /// No description provided for @brandSearchHint.
  ///
  /// In vi, this message translates to:
  /// **'Tìm thương hiệu...'**
  String get brandSearchHint;

  /// No description provided for @brandStatProducts.
  ///
  /// In vi, this message translates to:
  /// **'{count} sản phẩm'**
  String brandStatProducts(num count);

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
  /// **'Đã có lỗi xảy ra. Thử lại sau.'**
  String get brandNotifyServer;

  /// No description provided for @brandNotifyNetwork.
  ///
  /// In vi, this message translates to:
  /// **'Không kết nối được máy chủ. Thử lại.'**
  String get brandNotifyNetwork;

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

  /// No description provided for @navOrders.
  ///
  /// In vi, this message translates to:
  /// **'Đơn hàng'**
  String get navOrders;

  /// No description provided for @orderListTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đơn hàng'**
  String get orderListTitle;

  /// No description provided for @orderListSearchHint.
  ///
  /// In vi, this message translates to:
  /// **'Tìm theo mã đơn hoặc khách'**
  String get orderListSearchHint;

  /// No description provided for @orderListEmptyAll.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có đơn hàng nào'**
  String get orderListEmptyAll;

  /// No description provided for @orderListEmptyFiltered.
  ///
  /// In vi, this message translates to:
  /// **'Không có đơn phù hợp bộ lọc'**
  String get orderListEmptyFiltered;

  /// No description provided for @orderListEmptyCta.
  ///
  /// In vi, this message translates to:
  /// **'Tạo đơn đầu tiên'**
  String get orderListEmptyCta;

  /// No description provided for @orderListEmptyBody.
  ///
  /// In vi, this message translates to:
  /// **'Tạo đơn đầu tiên để bắt đầu.'**
  String get orderListEmptyBody;

  /// No description provided for @orderListNewOrder.
  ///
  /// In vi, this message translates to:
  /// **'Đơn mới'**
  String get orderListNewOrder;

  /// No description provided for @orderListLoading.
  ///
  /// In vi, this message translates to:
  /// **'Đang tải…'**
  String get orderListLoading;

  /// No description provided for @orderListLoadError.
  ///
  /// In vi, this message translates to:
  /// **'Không tải được đơn: {error}'**
  String orderListLoadError(String error);

  /// No description provided for @orderListOrderUnit.
  ///
  /// In vi, this message translates to:
  /// **'đơn hàng'**
  String get orderListOrderUnit;

  /// No description provided for @orderListPaymentFilterChip.
  ///
  /// In vi, this message translates to:
  /// **'TT: {status}'**
  String orderListPaymentFilterChip(String status);

  /// No description provided for @orderListChannelFilterChip.
  ///
  /// In vi, this message translates to:
  /// **'Kênh: {channel}'**
  String orderListChannelFilterChip(String channel);

  /// No description provided for @orderListFromDateChip.
  ///
  /// In vi, this message translates to:
  /// **'Từ {date}'**
  String orderListFromDateChip(String date);

  /// No description provided for @orderListToDateChip.
  ///
  /// In vi, this message translates to:
  /// **'Đến {date}'**
  String orderListToDateChip(String date);

  /// No description provided for @orderListClearFilters.
  ///
  /// In vi, this message translates to:
  /// **'Xóa lọc'**
  String get orderListClearFilters;

  /// No description provided for @orderListFilterTitle.
  ///
  /// In vi, this message translates to:
  /// **'Bộ lọc'**
  String get orderListFilterTitle;

  /// No description provided for @orderListFilterApply.
  ///
  /// In vi, this message translates to:
  /// **'Áp dụng'**
  String get orderListFilterApply;

  /// No description provided for @orderListFilterReset.
  ///
  /// In vi, this message translates to:
  /// **'Đặt lại'**
  String get orderListFilterReset;

  /// No description provided for @orderListFilterPaymentStatus.
  ///
  /// In vi, this message translates to:
  /// **'Trạng thái thanh toán'**
  String get orderListFilterPaymentStatus;

  /// No description provided for @orderListFilterSaleChannel.
  ///
  /// In vi, this message translates to:
  /// **'Kênh bán'**
  String get orderListFilterSaleChannel;

  /// No description provided for @orderListFilterFromDate.
  ///
  /// In vi, this message translates to:
  /// **'Từ ngày'**
  String get orderListFilterFromDate;

  /// No description provided for @orderListFilterToDate.
  ///
  /// In vi, this message translates to:
  /// **'Đến ngày'**
  String get orderListFilterToDate;

  /// No description provided for @orderStatusDraft.
  ///
  /// In vi, this message translates to:
  /// **'Nháp'**
  String get orderStatusDraft;

  /// No description provided for @orderStatusPending.
  ///
  /// In vi, this message translates to:
  /// **'Chờ xử lý'**
  String get orderStatusPending;

  /// No description provided for @orderStatusCompleted.
  ///
  /// In vi, this message translates to:
  /// **'Hoàn tất'**
  String get orderStatusCompleted;

  /// No description provided for @orderStatusCancelled.
  ///
  /// In vi, this message translates to:
  /// **'Đã hủy'**
  String get orderStatusCancelled;

  /// No description provided for @orderStatusAll.
  ///
  /// In vi, this message translates to:
  /// **'Tất cả'**
  String get orderStatusAll;

  /// No description provided for @orderPaymentStatusUnpaid.
  ///
  /// In vi, this message translates to:
  /// **'Chưa thanh toán'**
  String get orderPaymentStatusUnpaid;

  /// No description provided for @orderPaymentStatusPartial.
  ///
  /// In vi, this message translates to:
  /// **'Thanh toán một phần'**
  String get orderPaymentStatusPartial;

  /// No description provided for @orderPaymentStatusPaid.
  ///
  /// In vi, this message translates to:
  /// **'Đã thanh toán'**
  String get orderPaymentStatusPaid;

  /// No description provided for @orderPaymentMethodCash.
  ///
  /// In vi, this message translates to:
  /// **'Tiền mặt'**
  String get orderPaymentMethodCash;

  /// No description provided for @orderPaymentMethodBankTransfer.
  ///
  /// In vi, this message translates to:
  /// **'Chuyển khoản'**
  String get orderPaymentMethodBankTransfer;

  /// No description provided for @orderPaymentMethodCard.
  ///
  /// In vi, this message translates to:
  /// **'Thẻ'**
  String get orderPaymentMethodCard;

  /// No description provided for @orderPaymentMethodOther.
  ///
  /// In vi, this message translates to:
  /// **'Khác'**
  String get orderPaymentMethodOther;

  /// No description provided for @orderSaleChannelShop.
  ///
  /// In vi, this message translates to:
  /// **'Cửa hàng'**
  String get orderSaleChannelShop;

  /// No description provided for @orderSaleChannelEcommerce.
  ///
  /// In vi, this message translates to:
  /// **'Thương mại điện tử'**
  String get orderSaleChannelEcommerce;

  /// No description provided for @orderWalkIn.
  ///
  /// In vi, this message translates to:
  /// **'Khách lẻ'**
  String get orderWalkIn;

  /// No description provided for @orderNoCustomer.
  ///
  /// In vi, this message translates to:
  /// **'Không có khách hàng'**
  String get orderNoCustomer;

  /// No description provided for @orderItemsCount.
  ///
  /// In vi, this message translates to:
  /// **'{count} món'**
  String orderItemsCount(int count);

  /// No description provided for @orderDetailTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chi tiết đơn'**
  String get orderDetailTitle;

  /// No description provided for @orderDetailNotFound.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy đơn hàng'**
  String get orderDetailNotFound;

  /// No description provided for @orderDetailSubtotal.
  ///
  /// In vi, this message translates to:
  /// **'Tạm tính'**
  String get orderDetailSubtotal;

  /// No description provided for @orderDetailDiscount.
  ///
  /// In vi, this message translates to:
  /// **'Giảm giá'**
  String get orderDetailDiscount;

  /// No description provided for @orderDetailTax.
  ///
  /// In vi, this message translates to:
  /// **'Thuế'**
  String get orderDetailTax;

  /// No description provided for @orderDetailTotal.
  ///
  /// In vi, this message translates to:
  /// **'Tổng cộng'**
  String get orderDetailTotal;

  /// No description provided for @orderDetailPaid.
  ///
  /// In vi, this message translates to:
  /// **'Đã trả'**
  String get orderDetailPaid;

  /// No description provided for @orderDetailChange.
  ///
  /// In vi, this message translates to:
  /// **'Tiền thừa'**
  String get orderDetailChange;

  /// No description provided for @orderDetailCustomer.
  ///
  /// In vi, this message translates to:
  /// **'Khách hàng'**
  String get orderDetailCustomer;

  /// No description provided for @orderDetailNote.
  ///
  /// In vi, this message translates to:
  /// **'Ghi chú'**
  String get orderDetailNote;

  /// No description provided for @orderDetailItems.
  ///
  /// In vi, this message translates to:
  /// **'Sản phẩm'**
  String get orderDetailItems;

  /// No description provided for @orderDetailPayments.
  ///
  /// In vi, this message translates to:
  /// **'Thanh toán'**
  String get orderDetailPayments;

  /// No description provided for @orderDetailAddPayment.
  ///
  /// In vi, this message translates to:
  /// **'Thêm thanh toán'**
  String get orderDetailAddPayment;

  /// No description provided for @orderDetailMarkCompleted.
  ///
  /// In vi, this message translates to:
  /// **'Đánh dấu hoàn tất'**
  String get orderDetailMarkCompleted;

  /// No description provided for @orderDetailCancel.
  ///
  /// In vi, this message translates to:
  /// **'Hủy đơn'**
  String get orderDetailCancel;

  /// No description provided for @orderDetailVoid.
  ///
  /// In vi, this message translates to:
  /// **'Hủy bỏ (Void)'**
  String get orderDetailVoid;

  /// No description provided for @orderDetailCancelDialogTitle.
  ///
  /// In vi, this message translates to:
  /// **'Hủy đơn hàng?'**
  String get orderDetailCancelDialogTitle;

  /// No description provided for @orderDetailCancelReasonHint.
  ///
  /// In vi, this message translates to:
  /// **'Lý do hủy'**
  String get orderDetailCancelReasonHint;

  /// No description provided for @orderDetailVoidDialogTitle.
  ///
  /// In vi, this message translates to:
  /// **'Hủy bỏ đơn hàng?'**
  String get orderDetailVoidDialogTitle;

  /// No description provided for @orderDetailVoidDialogBody.
  ///
  /// In vi, this message translates to:
  /// **'Đơn đã hoàn tất sẽ được đánh dấu hủy bỏ. Không thể hoàn tác.'**
  String get orderDetailVoidDialogBody;

  /// No description provided for @orderDetailMarkCompletedDialogTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đánh dấu hoàn tất?'**
  String get orderDetailMarkCompletedDialogTitle;

  /// No description provided for @orderDetailUpdated.
  ///
  /// In vi, this message translates to:
  /// **'Đã cập nhật đơn hàng'**
  String get orderDetailUpdated;

  /// No description provided for @orderCreateTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đơn mới'**
  String get orderCreateTitle;

  /// No description provided for @orderCreateEmptyCta.
  ///
  /// In vi, this message translates to:
  /// **'Thêm sản phẩm'**
  String get orderCreateEmptyCta;

  /// No description provided for @orderCreateAddMore.
  ///
  /// In vi, this message translates to:
  /// **'Thêm sản phẩm khác'**
  String get orderCreateAddMore;

  /// No description provided for @orderCreateClearCart.
  ///
  /// In vi, this message translates to:
  /// **'Xóa giỏ hàng'**
  String get orderCreateClearCart;

  /// No description provided for @orderCreateDiscardDialogTitle.
  ///
  /// In vi, this message translates to:
  /// **'Bỏ giỏ hàng?'**
  String get orderCreateDiscardDialogTitle;

  /// No description provided for @orderCreateDiscardDialogBody.
  ///
  /// In vi, this message translates to:
  /// **'Bạn sẽ mất các sản phẩm đang chọn.'**
  String get orderCreateDiscardDialogBody;

  /// No description provided for @orderCreateDiscardConfirm.
  ///
  /// In vi, this message translates to:
  /// **'Bỏ'**
  String get orderCreateDiscardConfirm;

  /// No description provided for @orderCreateKeepEditing.
  ///
  /// In vi, this message translates to:
  /// **'Tiếp tục'**
  String get orderCreateKeepEditing;

  /// No description provided for @orderCreateCustomerName.
  ///
  /// In vi, this message translates to:
  /// **'Tên khách hàng'**
  String get orderCreateCustomerName;

  /// No description provided for @orderCreateCustomerPhone.
  ///
  /// In vi, this message translates to:
  /// **'Số điện thoại'**
  String get orderCreateCustomerPhone;

  /// No description provided for @orderCreateNote.
  ///
  /// In vi, this message translates to:
  /// **'Ghi chú'**
  String get orderCreateNote;

  /// No description provided for @orderCreateOrderDiscount.
  ///
  /// In vi, this message translates to:
  /// **'Giảm giá đơn'**
  String get orderCreateOrderDiscount;

  /// No description provided for @orderCreateManualTax.
  ///
  /// In vi, this message translates to:
  /// **'Thuế (%)'**
  String get orderCreateManualTax;

  /// No description provided for @orderCreateDiscountTypeNone.
  ///
  /// In vi, this message translates to:
  /// **'Không'**
  String get orderCreateDiscountTypeNone;

  /// No description provided for @orderCreateDiscountTypePercentage.
  ///
  /// In vi, this message translates to:
  /// **'Phần trăm'**
  String get orderCreateDiscountTypePercentage;

  /// No description provided for @orderCreateDiscountTypeFixed.
  ///
  /// In vi, this message translates to:
  /// **'Cố định'**
  String get orderCreateDiscountTypeFixed;

  /// No description provided for @orderCreateSaveDraft.
  ///
  /// In vi, this message translates to:
  /// **'Lưu nháp'**
  String get orderCreateSaveDraft;

  /// No description provided for @orderCreatePay.
  ///
  /// In vi, this message translates to:
  /// **'Thanh toán'**
  String get orderCreatePay;

  /// No description provided for @orderCreateSavedDraft.
  ///
  /// In vi, this message translates to:
  /// **'Đã lưu đơn nháp'**
  String get orderCreateSavedDraft;

  /// No description provided for @orderCreatePaid.
  ///
  /// In vi, this message translates to:
  /// **'Đã thanh toán'**
  String get orderCreatePaid;

  /// No description provided for @addLineSheetTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thêm sản phẩm'**
  String get addLineSheetTitle;

  /// No description provided for @addLineSheetEditTitle.
  ///
  /// In vi, this message translates to:
  /// **'Sửa sản phẩm'**
  String get addLineSheetEditTitle;

  /// No description provided for @addLineSheetSearchHint.
  ///
  /// In vi, this message translates to:
  /// **'Tìm sản phẩm'**
  String get addLineSheetSearchHint;

  /// No description provided for @addLineSheetEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Nhập tên để tìm sản phẩm'**
  String get addLineSheetEmpty;

  /// No description provided for @addLineSheetVariantPick.
  ///
  /// In vi, this message translates to:
  /// **'Chọn phân loại'**
  String get addLineSheetVariantPick;

  /// No description provided for @addLineSheetQty.
  ///
  /// In vi, this message translates to:
  /// **'Số lượng'**
  String get addLineSheetQty;

  /// No description provided for @addLineSheetUnitPrice.
  ///
  /// In vi, this message translates to:
  /// **'Đơn giá'**
  String get addLineSheetUnitPrice;

  /// No description provided for @addLineSheetLineDiscount.
  ///
  /// In vi, this message translates to:
  /// **'Giảm giá dòng'**
  String get addLineSheetLineDiscount;

  /// No description provided for @addLineSheetAdd.
  ///
  /// In vi, this message translates to:
  /// **'Thêm vào đơn'**
  String get addLineSheetAdd;

  /// No description provided for @addLineSheetUpdate.
  ///
  /// In vi, this message translates to:
  /// **'Cập nhật'**
  String get addLineSheetUpdate;

  /// No description provided for @orderPaymentSheetTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thanh toán'**
  String get orderPaymentSheetTitle;

  /// No description provided for @orderPaymentSheetMethod.
  ///
  /// In vi, this message translates to:
  /// **'Hình thức'**
  String get orderPaymentSheetMethod;

  /// No description provided for @orderPaymentSheetAmount.
  ///
  /// In vi, this message translates to:
  /// **'Số tiền'**
  String get orderPaymentSheetAmount;

  /// No description provided for @orderPaymentSheetReference.
  ///
  /// In vi, this message translates to:
  /// **'Mã tham chiếu'**
  String get orderPaymentSheetReference;

  /// No description provided for @orderPaymentSheetNote.
  ///
  /// In vi, this message translates to:
  /// **'Ghi chú'**
  String get orderPaymentSheetNote;

  /// No description provided for @orderPaymentSheetConfirm.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận'**
  String get orderPaymentSheetConfirm;

  /// No description provided for @commonRequiredBadge.
  ///
  /// In vi, this message translates to:
  /// **'Bắt buộc'**
  String get commonRequiredBadge;

  /// No description provided for @commonActions.
  ///
  /// In vi, this message translates to:
  /// **'Tác vụ'**
  String get commonActions;

  /// No description provided for @commonName.
  ///
  /// In vi, this message translates to:
  /// **'Tên'**
  String get commonName;

  /// No description provided for @commonPhone.
  ///
  /// In vi, this message translates to:
  /// **'SĐT'**
  String get commonPhone;

  /// No description provided for @commonStore.
  ///
  /// In vi, this message translates to:
  /// **'Cửa hàng'**
  String get commonStore;

  /// No description provided for @orderDetailSectionInfo.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin đơn'**
  String get orderDetailSectionInfo;

  /// No description provided for @orderDetailFieldCreatedAt.
  ///
  /// In vi, this message translates to:
  /// **'Tạo lúc'**
  String get orderDetailFieldCreatedAt;

  /// No description provided for @orderDetailFieldChannel.
  ///
  /// In vi, this message translates to:
  /// **'Kênh bán'**
  String get orderDetailFieldChannel;

  /// No description provided for @orderDetailSectionSummary.
  ///
  /// In vi, this message translates to:
  /// **'Tổng kết'**
  String get orderDetailSectionSummary;

  /// No description provided for @orderDetailPaymentsEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có thanh toán'**
  String get orderDetailPaymentsEmpty;

  /// No description provided for @orderCreateCartEmptyTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có sản phẩm trong giỏ'**
  String get orderCreateCartEmptyTitle;

  /// No description provided for @orderCreateCustomerNameHint.
  ///
  /// In vi, this message translates to:
  /// **'VD: Anh Nam'**
  String get orderCreateCustomerNameHint;

  /// No description provided for @orderCreatePhoneHint.
  ///
  /// In vi, this message translates to:
  /// **'0xxxxxxxxx'**
  String get orderCreatePhoneHint;

  /// No description provided for @orderCreateNoteHint.
  ///
  /// In vi, this message translates to:
  /// **'Ghi chú thêm cho đơn hàng'**
  String get orderCreateNoteHint;

  /// No description provided for @orderCreateManualTaxHint.
  ///
  /// In vi, this message translates to:
  /// **'VD: 8'**
  String get orderCreateManualTaxHint;

  /// No description provided for @orderCreatePercentHint.
  ///
  /// In vi, this message translates to:
  /// **'0–100'**
  String get orderCreatePercentHint;
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
