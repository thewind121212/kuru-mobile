// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'Simplestore';

  @override
  String get splashTagline => 'Đang kết nối...';

  @override
  String get loginTitle => 'Chào mừng trở lại';

  @override
  String get loginSubtitle =>
      'Đăng nhập Simplestore để tiếp tục quản lý cửa hàng.';

  @override
  String get fieldEmail => 'Email';

  @override
  String get fieldPassword => 'Mật khẩu';

  @override
  String get fieldPasswordShow => 'Hiện mật khẩu';

  @override
  String get fieldPasswordHide => 'Ẩn mật khẩu';

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
  String get validationInvalidEmail => 'Email không hợp lệ.';

  @override
  String get validationEmailRequired => 'Vui lòng nhập email.';

  @override
  String get validationPasswordRequired => 'Vui lòng nhập mật khẩu.';

  @override
  String get validationNameRequired => 'Vui lòng nhập họ tên.';

  @override
  String get totpTitle => 'Xác thực hai yếu tố';

  @override
  String get totpRecoveryTitle => 'Dùng mã khôi phục';

  @override
  String get totpDescription => 'Nhập mã 6 chữ số từ ứng dụng xác thực.';

  @override
  String get totpRecoveryDescription =>
      'Nhập một trong các mã khôi phục đã lưu.';

  @override
  String get totpVerifyButton => 'Xác minh';

  @override
  String get totpUseRecoveryButton => 'Dùng mã khôi phục';

  @override
  String get totpLostDevice => 'Mất thiết bị?';

  @override
  String get totpBackToAuthenticator => 'Quay lại mã xác thực';

  @override
  String get totpSignOut => 'Đăng xuất & đổi tài khoản';

  @override
  String get totpSignOutConfirm =>
      'Đăng xuất khỏi phiên xác thực này? Bạn sẽ cần đăng nhập lại từ đầu.';

  @override
  String get commonCancel => 'Hủy';

  @override
  String get commonSignOut => 'Đăng xuất';

  @override
  String get totpWrongCode => 'Sai mã xác thực, vui lòng thử lại.';

  @override
  String get totpRecoveryFailed => 'Mã khôi phục không hợp lệ.';

  @override
  String get totpRateLimited => 'Quá nhiều lần thử. Vui lòng đợi vài phút.';

  @override
  String get totpRecoveryPlaceholder => 'XXXX-XXXX';

  @override
  String get totpSessionExpired =>
      'Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.';

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
  String get onboardingStep4Title => 'Mọi cách thanh toán.';

  @override
  String get onboardingStep4Body =>
      'Tiền mặt, chuyển khoản, hay quét QR — bạn nhận, Simplestore ghi nhận tức thì.';

  @override
  String get onboardingStep5Title => 'Một tài khoản, nhiều cửa hàng.';

  @override
  String get onboardingStep5Body =>
      'Quản lý nhiều chi nhánh và đội ngũ trong cùng một nơi. Mỗi cửa hàng vẫn riêng tư.';

  @override
  String get onboardingStep6Title => 'Thấu hiểu từng khách hàng.';

  @override
  String get onboardingStep6Body =>
      'Lịch sử mua hàng và ưu đãi cá nhân hoá — khách hàng quay lại nhiều hơn.';

  @override
  String get registerTitle => 'Tạo tài khoản';

  @override
  String get registerSubtitle => 'Bắt đầu với Simplestore chỉ trong 30 giây.';

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
  String get registerErrorTermsRequired =>
      'Vui lòng đồng ý với điều khoản để tiếp tục.';

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

  @override
  String get navHome => 'Trang chủ';

  @override
  String get navCatalog => 'Danh mục';

  @override
  String get navSettings => 'Cài đặt';

  @override
  String get posOpenTooltip => 'Mở thu ngân';

  @override
  String get posComingSoon => 'Thu ngân sắp ra mắt';

  @override
  String get settingsPlaceholder => 'Cài đặt sắp ra mắt';

  @override
  String get categoryTitle => 'Danh mục';

  @override
  String get categorySubtitle => 'Quản lý phân loại sản phẩm';

  @override
  String get categorySearchHint => 'Tìm danh mục...';

  @override
  String get categoryEmptyTitle => 'Chưa có danh mục';

  @override
  String get categoryEmptyBody => 'Tạo danh mục đầu tiên để sắp xếp sản phẩm.';

  @override
  String get categoryEmptyAction => 'Tạo danh mục đầu tiên';

  @override
  String get categoryTabMain => 'Chính';

  @override
  String get categoryTabSub => 'Phụ';

  @override
  String categorySubCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count danh mục con',
    );
    return '$_temp0';
  }

  @override
  String categoryItemCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sản phẩm',
    );
    return '$_temp0';
  }

  @override
  String get categoryLoadError => 'Không tải được danh mục';

  @override
  String get categoryLoadRetry => 'Thử lại';

  @override
  String get categoryDetailPlaceholder => 'Chi tiết sắp ra mắt';

  @override
  String get categoryStatSubCategories => 'Phụ';

  @override
  String get categoryStatItems => 'Sản phẩm';

  @override
  String get categoryStatValue => 'Giá trị';

  @override
  String categoryLowStockBadge(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sắp hết',
    );
    return '$_temp0';
  }

  @override
  String categoryTotalCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count danh mục',
    );
    return '$_temp0';
  }

  @override
  String get categoryCreateTitle => 'Danh mục mới';

  @override
  String get categoryCreateSubcategoryTitle => 'Danh mục con mới';

  @override
  String get categoryEditTitle => 'Sửa danh mục';

  @override
  String get categoryFieldName => 'Tên';

  @override
  String get categoryFieldNameHint => 'VD: Điện tử';

  @override
  String get categoryFieldDescription => 'Mô tả';

  @override
  String get categoryFieldDescriptionHint => 'Ghi chú ngắn (tuỳ chọn)';

  @override
  String get categoryFieldStatus => 'Trạng thái';

  @override
  String get categoryFieldIcon => 'Biểu tượng';

  @override
  String get categoryFieldColor => 'Màu';

  @override
  String get categoryFieldParent => 'Danh mục cha';

  @override
  String get categoryStatusActive => 'Đang hoạt động';

  @override
  String get categoryStatusInactive => 'Ngừng';

  @override
  String get categoryStatusArchived => 'Lưu trữ';

  @override
  String get categorySaveCta => 'Lưu';

  @override
  String get categorySavingCta => 'Đang lưu…';

  @override
  String get categoryActionEdit => 'Sửa';

  @override
  String get categoryActionDelete => 'Xoá';

  @override
  String get categoryActionAddSubcategory => 'Thêm danh mục con';

  @override
  String get categoryDeleteConfirmTitle => 'Xoá danh mục?';

  @override
  String categoryDeleteConfirmBody(Object name) {
    return '$name sẽ bị xoá. Không thể hoàn tác.';
  }

  @override
  String get categoryDeleteConfirmCta => 'Xoá';

  @override
  String get categoryNotifySaved => 'Đã lưu danh mục';

  @override
  String get categoryNotifyDeleted => 'Đã xoá danh mục';

  @override
  String get categoryNotifyNetwork => 'Không kết nối được máy chủ. Thử lại.';

  @override
  String get categoryNotifyServer => 'Đã có lỗi xảy ra. Thử lại sau.';

  @override
  String get categoryNotifyForbidden =>
      'Bạn không có quyền thực hiện thao tác này.';

  @override
  String get categoryNotifyRateLimited =>
      'Chậm lại nhé — thử lại sau giây lát.';

  @override
  String get categoryMaxLayerReached => 'Đã đạt độ sâu tối đa';

  @override
  String categoryDetailSubcategoriesHeader(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Danh mục con ($count)',
    );
    return '$_temp0';
  }

  @override
  String get categoryDetailNoSubcategories => 'Chưa có danh mục con';

  @override
  String get catalogHubTitle => 'Danh mục sản phẩm';

  @override
  String get catalogHubCategoriesTitle => 'Danh mục';

  @override
  String get catalogHubCategoriesSub => 'Tổ chức sản phẩm theo nhóm';

  @override
  String get catalogHubBrandsTitle => 'Thương hiệu';

  @override
  String get catalogHubBrandsSub => 'Quản lý các nhà sản xuất';

  @override
  String get catalogHubDistributorsTitle => 'Nhà phân phối';

  @override
  String get catalogHubTaxTitle => 'Thuế';

  @override
  String get catalogHubComingSoon => 'Sắp có';

  @override
  String get brandTitle => 'Thương hiệu';

  @override
  String brandTotalCount(num count) {
    return '$count thương hiệu';
  }

  @override
  String get brandSearchHint => 'Tìm thương hiệu...';

  @override
  String brandStatProducts(num count) {
    return '$count sản phẩm';
  }

  @override
  String get brandEmptyTitle => 'Chưa có thương hiệu';

  @override
  String get brandEmptyBody =>
      'Tạo thương hiệu đầu tiên để gom sản phẩm theo nhà sản xuất.';

  @override
  String get brandEmptyAction => 'Tạo thương hiệu đầu tiên';

  @override
  String get brandLoadError => 'Không tải được danh sách thương hiệu';

  @override
  String get brandLoadRetry => 'Thử lại';

  @override
  String get brandCreateTitle => 'Tạo thương hiệu';

  @override
  String get brandEditTitle => 'Chỉnh sửa thương hiệu';

  @override
  String get brandFieldNameLabel => 'Tên thương hiệu *';

  @override
  String get brandFieldNameHint => 'VD: Bosch, Makita, Stanley';

  @override
  String get brandFieldNameRequired => 'Tên thương hiệu là bắt buộc';

  @override
  String get brandCreateCta => 'Tạo';

  @override
  String get brandEditCta => 'Cập nhật';

  @override
  String get brandDeleteConfirmTitle => 'Xóa thương hiệu?';

  @override
  String brandDeleteConfirmBody(String name) {
    return 'Hành động không thể hoàn tác. $name sẽ bị xóa.';
  }

  @override
  String get brandDeleteConfirmCta => 'Xóa';

  @override
  String get brandNotifySaved => 'Đã lưu thương hiệu';

  @override
  String get brandNotifyDeleted => 'Đã xóa thương hiệu';

  @override
  String get brandNotifyServer => 'Đã có lỗi xảy ra. Thử lại sau.';

  @override
  String get brandNotifyNetwork => 'Không kết nối được máy chủ. Thử lại.';

  @override
  String get brandActionEdit => 'Chỉnh sửa';

  @override
  String get brandActionDelete => 'Xóa';

  @override
  String get navOrders => 'Đơn hàng';

  @override
  String get orderListTitle => 'Đơn hàng';

  @override
  String get orderListSearchHint => 'Tìm theo mã đơn hoặc khách';

  @override
  String get orderListEmptyAll => 'Chưa có đơn hàng nào';

  @override
  String get orderListEmptyFiltered => 'Không có đơn phù hợp bộ lọc';

  @override
  String get orderListEmptyCta => 'Tạo đơn đầu tiên';

  @override
  String get orderListNewOrder => 'Đơn mới';

  @override
  String get orderListFilterTitle => 'Bộ lọc';

  @override
  String get orderListFilterApply => 'Áp dụng';

  @override
  String get orderListFilterReset => 'Đặt lại';

  @override
  String get orderListFilterPaymentStatus => 'Trạng thái thanh toán';

  @override
  String get orderListFilterSaleChannel => 'Kênh bán';

  @override
  String get orderListFilterFromDate => 'Từ ngày';

  @override
  String get orderListFilterToDate => 'Đến ngày';

  @override
  String get orderStatusDraft => 'Nháp';

  @override
  String get orderStatusPending => 'Chờ xử lý';

  @override
  String get orderStatusCompleted => 'Hoàn tất';

  @override
  String get orderStatusCancelled => 'Đã hủy';

  @override
  String get orderStatusAll => 'Tất cả';

  @override
  String get orderPaymentStatusUnpaid => 'Chưa thanh toán';

  @override
  String get orderPaymentStatusPartial => 'Thanh toán một phần';

  @override
  String get orderPaymentStatusPaid => 'Đã thanh toán';

  @override
  String get orderPaymentMethodCash => 'Tiền mặt';

  @override
  String get orderPaymentMethodBankTransfer => 'Chuyển khoản';

  @override
  String get orderPaymentMethodCard => 'Thẻ';

  @override
  String get orderPaymentMethodOther => 'Khác';

  @override
  String get orderSaleChannelShop => 'Cửa hàng';

  @override
  String get orderSaleChannelEcommerce => 'Thương mại điện tử';

  @override
  String get orderWalkIn => 'Khách lẻ';

  @override
  String get orderNoCustomer => 'Không có khách hàng';

  @override
  String orderItemsCount(int count) {
    return '$count món';
  }

  @override
  String get orderDetailTitle => 'Chi tiết đơn';

  @override
  String get orderDetailNotFound => 'Không tìm thấy đơn hàng';

  @override
  String get orderDetailSubtotal => 'Tạm tính';

  @override
  String get orderDetailDiscount => 'Giảm giá';

  @override
  String get orderDetailTax => 'Thuế';

  @override
  String get orderDetailTotal => 'Tổng cộng';

  @override
  String get orderDetailPaid => 'Đã trả';

  @override
  String get orderDetailChange => 'Tiền thừa';

  @override
  String get orderDetailCustomer => 'Khách hàng';

  @override
  String get orderDetailNote => 'Ghi chú';

  @override
  String get orderDetailItems => 'Sản phẩm';

  @override
  String get orderDetailPayments => 'Thanh toán';

  @override
  String get orderDetailAddPayment => 'Thêm thanh toán';

  @override
  String get orderDetailMarkCompleted => 'Đánh dấu hoàn tất';

  @override
  String get orderDetailCancel => 'Hủy đơn';

  @override
  String get orderDetailVoid => 'Hủy bỏ (Void)';

  @override
  String get orderDetailCancelDialogTitle => 'Hủy đơn hàng?';

  @override
  String get orderDetailCancelReasonHint => 'Lý do hủy';

  @override
  String get orderDetailVoidDialogTitle => 'Hủy bỏ đơn hàng?';

  @override
  String get orderDetailVoidDialogBody =>
      'Đơn đã hoàn tất sẽ được đánh dấu hủy bỏ. Không thể hoàn tác.';

  @override
  String get orderDetailMarkCompletedDialogTitle => 'Đánh dấu hoàn tất?';

  @override
  String get orderDetailUpdated => 'Đã cập nhật đơn hàng';

  @override
  String get orderCreateTitle => 'Đơn mới';

  @override
  String get orderCreateEmptyCta => 'Thêm sản phẩm';

  @override
  String get orderCreateAddMore => 'Thêm sản phẩm khác';

  @override
  String get orderCreateClearCart => 'Xóa giỏ hàng';

  @override
  String get orderCreateDiscardDialogTitle => 'Bỏ giỏ hàng?';

  @override
  String get orderCreateDiscardDialogBody =>
      'Bạn sẽ mất các sản phẩm đang chọn.';

  @override
  String get orderCreateDiscardConfirm => 'Bỏ';

  @override
  String get orderCreateKeepEditing => 'Tiếp tục';

  @override
  String get orderCreateCustomerName => 'Tên khách hàng';

  @override
  String get orderCreateCustomerPhone => 'Số điện thoại';

  @override
  String get orderCreateNote => 'Ghi chú';

  @override
  String get orderCreateOrderDiscount => 'Giảm giá đơn';

  @override
  String get orderCreateManualTax => 'Thuế (%)';

  @override
  String get orderCreateDiscountTypeNone => 'Không';

  @override
  String get orderCreateDiscountTypePercentage => 'Phần trăm';

  @override
  String get orderCreateDiscountTypeFixed => 'Cố định';

  @override
  String get orderCreateSaveDraft => 'Lưu nháp';

  @override
  String get orderCreatePay => 'Thanh toán';

  @override
  String get orderCreateSavedDraft => 'Đã lưu đơn nháp';

  @override
  String get orderCreatePaid => 'Đã thanh toán';

  @override
  String get addLineSheetTitle => 'Thêm sản phẩm';

  @override
  String get addLineSheetEditTitle => 'Sửa sản phẩm';

  @override
  String get addLineSheetSearchHint => 'Tìm sản phẩm';

  @override
  String get addLineSheetEmpty => 'Nhập tên để tìm sản phẩm';

  @override
  String get addLineSheetVariantPick => 'Chọn phân loại';

  @override
  String get addLineSheetQty => 'Số lượng';

  @override
  String get addLineSheetUnitPrice => 'Đơn giá';

  @override
  String get addLineSheetLineDiscount => 'Giảm giá dòng';

  @override
  String get addLineSheetAdd => 'Thêm vào đơn';

  @override
  String get addLineSheetUpdate => 'Cập nhật';

  @override
  String get orderPaymentSheetTitle => 'Thanh toán';

  @override
  String get orderPaymentSheetMethod => 'Hình thức';

  @override
  String get orderPaymentSheetAmount => 'Số tiền';

  @override
  String get orderPaymentSheetReference => 'Mã tham chiếu';

  @override
  String get orderPaymentSheetNote => 'Ghi chú';

  @override
  String get orderPaymentSheetConfirm => 'Xác nhận';
}
