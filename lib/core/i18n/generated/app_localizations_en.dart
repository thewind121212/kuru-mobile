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
  String get totpSignOutConfirm =>
      'Sign out of this verification session? You\'ll need to log in again from the start.';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonSignOut => 'Sign out';

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
  String get navCatalog => 'Catalogue';

  @override
  String get navLedger => 'Cashflow';

  @override
  String get navExpenses => 'Expenses';

  @override
  String get navImport => 'Imports';

  @override
  String get navProducts => 'Products';

  @override
  String get navSettings => 'Settings';

  @override
  String get ledgerOrdersSub => 'Track sales orders and payments';

  @override
  String get ledgerExpensesSub => 'Record purchasing and operating costs';

  @override
  String get ledgerImportSub => 'Receive stock and record purchase cost';

  @override
  String get ledgerHubSubtitle =>
      'Track money in, money out, and purchase costs.';

  @override
  String get posOpenTooltip => 'Open POS';

  @override
  String get posComingSoon => 'POS coming soon';

  @override
  String get posTitle => 'POS';

  @override
  String get posSubtitle => 'Start a sale from your phone.';

  @override
  String get posHeroMetric => 'Quick selling';

  @override
  String get posHeroMeta =>
      'Create orders, receive payment, and record inventory from one flow.';

  @override
  String get posPrimaryAction => 'Create sale';

  @override
  String get posSectionStart => 'Start';

  @override
  String get posQuickOrder => 'Quick sale';

  @override
  String get posQuickOrderMeta => 'Create a new order from a cart';

  @override
  String get posScanBarcode => 'Scan barcode';

  @override
  String get posScanBarcodeMeta => 'Product scanning will connect to POS next';

  @override
  String get posScanComingSoon =>
      'POS barcode scanning will be connected in the next step';

  @override
  String get posSectionManage => 'Manage';

  @override
  String get posViewOrders => 'View orders';

  @override
  String get posViewOrdersMeta => 'Open the orders you have created';

  @override
  String get posPayment => 'Payment';

  @override
  String get posSuccess => 'Done';

  @override
  String get posSearchLabel => 'Search by name';

  @override
  String get posSearchHint => 'Enter product name';

  @override
  String get posScanPrimary => 'Scan product';

  @override
  String get posBranchLabel => 'Branch';

  @override
  String get posBranchLoading => 'Loading branch';

  @override
  String get posBranchMissing => 'No selling branch found';

  @override
  String get posBranchRequired => 'Select a branch before charging';

  @override
  String get posBranchPickerTitle => 'Select selling branch';

  @override
  String get posDisplayLabel => 'Display';

  @override
  String get posDisplayLoading => 'Loading display';

  @override
  String get posDisplayMissing => 'No customer display found';

  @override
  String get posDisplaySelect => 'Select display';

  @override
  String get posDisplaySelectRequired =>
      'Select a counter or No display before charging';

  @override
  String get posDisplayNone => 'No display';

  @override
  String get posDisplayNoneDesc =>
      'Do not sync this cart to a customer display';

  @override
  String get posDisplayDefault => 'Default';

  @override
  String get posDisplayPickerTitle => 'Select customer display';

  @override
  String get posDisplayPickerSubtitle =>
      'The cart will sync to this counter\'s customer display.';

  @override
  String get posDisplayOnline => 'Online';

  @override
  String get posDisplayOffline => 'Offline';

  @override
  String get posDisplayNoScreen => 'No screen paired';

  @override
  String get posDisplayPair => 'Pair';

  @override
  String get posDisplayRepair => 'Re-pair';

  @override
  String get posDisplayPairHint =>
      'Open the customer display, enter the pair code, then keep it on the sale display page.';

  @override
  String get posDisplayInUseShort => 'In use by another POS';

  @override
  String get posDisplayInUse =>
      'This display is being used by another POS session.';

  @override
  String get posDisplayTakeOver => 'Take over';

  @override
  String get posPairTitle => 'Pair customer display';

  @override
  String get posPairRepairTitle => 'Re-pair customer display';

  @override
  String get posPairInstructions =>
      'Generate a pair code, then enter it on the customer display.';

  @override
  String get posPairRepairInstructions =>
      'Generate a new pair code, then enter it on the existing customer display.';

  @override
  String get posPairGenerate => 'Generate pair code';

  @override
  String get posPairCodeCopy => 'Copy pair code';

  @override
  String get posPairCopied => 'Code copied';

  @override
  String get posPairCopyFailed => 'Could not copy code';

  @override
  String get posPairConnected => 'Display connected';

  @override
  String get posPairDone => 'Done';

  @override
  String posPairExpiresIn(String time) {
    return 'Code expires in $time';
  }

  @override
  String get posPairExpired => 'Code expired';

  @override
  String get posPairCancel => 'Cancel code';

  @override
  String get posPairCancelled => 'Pair code cancelled';

  @override
  String get posPairError => 'Could not generate pair code';

  @override
  String get posScanHint => 'Point the camera at the product barcode';

  @override
  String get posBarcodeAdded => 'Product added from barcode';

  @override
  String get posEmptySearch => 'Tap Scan product below';

  @override
  String get posEmptySearchMeta =>
      'Or enter a product name when scanning is not available.';

  @override
  String get posNoProducts => 'No matching products found';

  @override
  String get posCart => 'Cart';

  @override
  String get posCartHint => 'Add at least one product to take payment.';

  @override
  String get posEmptyCart => 'Cart is empty';

  @override
  String get posClearCart => 'Clear cart';

  @override
  String get posRemoveLine => 'Remove line';

  @override
  String get posAdjustLineTitle => 'Adjust line';

  @override
  String get posAdjustQty => 'Quantity';

  @override
  String get posAdjustUnitPrice => 'Sell price';

  @override
  String get posBaseUnitPrice => 'Original price';

  @override
  String get posUnitReduction => 'Reduction';

  @override
  String get posReductionAmount => 'Reduction amount';

  @override
  String get posNoReduction => 'No reduction';

  @override
  String get posReductionPrompt => 'Tap to reduce';

  @override
  String get posResetReduction => 'Reset';

  @override
  String get posLineTotal => 'Line total';

  @override
  String get posSaveLine => 'Update';

  @override
  String get posViewProductDetail => 'View product detail';

  @override
  String get posTotal => 'Total';

  @override
  String get posCharge => 'Charge';

  @override
  String get posAmountReceived => 'Amount received';

  @override
  String get posChange => 'Change';

  @override
  String get posRemaining => 'Remaining';

  @override
  String get posConfirmPayment => 'Confirm payment';

  @override
  String get posPaymentNote =>
      'The order will be created and paid immediately.';

  @override
  String get posCreateBankTransferOrder => 'Create order and show QR';

  @override
  String get posBankTransferManualConfirm => 'I have received the transfer';

  @override
  String get posBankTransferCreateNote =>
      'The order will be created first, then the QR will wait for bank confirmation.';

  @override
  String get posBankTransferPendingNote =>
      'Webhook can mark this order paid automatically. Use manual confirm only after checking the bank app.';

  @override
  String get posBankTransferWaiting => 'Waiting for bank confirmation';

  @override
  String get posBankTransferAutoConfirm =>
      'The app checks the order status while this QR is open.';

  @override
  String get posBankTransferManualHint =>
      'Manual confirmation records the bank-transfer payment immediately.';

  @override
  String get posPaymentReference => 'Transfer reference';

  @override
  String get posPaymentFailed => 'Could not create paid order';

  @override
  String get posSuccessTitle => 'Payment complete';

  @override
  String get posSuccessBody =>
      'The sale order was created and the cart has been reset.';

  @override
  String get posNewSale => 'New sale';

  @override
  String get posViewOrder => 'View created order';

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
  String get categoryTabMain => 'Main';

  @override
  String get categoryTabSub => 'Sub';

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

  @override
  String categoryTotalCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count categories',
      one: '$count category',
    );
    return '$_temp0';
  }

  @override
  String get categoryCreateTitle => 'New category';

  @override
  String get categoryCreateSubcategoryTitle => 'New subcategory';

  @override
  String get categoryEditTitle => 'Edit category';

  @override
  String get categoryFieldName => 'Name';

  @override
  String get categoryFieldNameHint => 'e.g. Electronics';

  @override
  String get categoryFieldDescription => 'Description';

  @override
  String get categoryFieldDescriptionHint => 'Short notes (optional)';

  @override
  String get categoryFieldStatus => 'Status';

  @override
  String get categoryFieldIcon => 'Icon';

  @override
  String get categoryFieldColor => 'Color';

  @override
  String get categoryFieldParent => 'Parent';

  @override
  String get categoryStatusActive => 'Active';

  @override
  String get categoryStatusInactive => 'Inactive';

  @override
  String get categoryStatusArchived => 'Archived';

  @override
  String get categorySaveCta => 'Save';

  @override
  String get categorySavingCta => 'Saving…';

  @override
  String get categoryActionEdit => 'Edit';

  @override
  String get categoryActionDelete => 'Delete';

  @override
  String get categoryActionAddSubcategory => 'Add subcategory';

  @override
  String get categoryDeleteConfirmTitle => 'Delete category?';

  @override
  String categoryDeleteConfirmBody(Object name) {
    return '$name will be removed. This cannot be undone.';
  }

  @override
  String get categoryDeleteConfirmCta => 'Delete';

  @override
  String get categoryNotifySaved => 'Category saved';

  @override
  String get categoryNotifyDeleted => 'Category deleted';

  @override
  String get categoryNotifyNetwork => 'Couldn\'t reach the server. Try again.';

  @override
  String get categoryNotifyServer => 'Something went wrong. Try again later.';

  @override
  String get categoryNotifyForbidden =>
      'You don\'t have permission to do that.';

  @override
  String get categoryNotifyRateLimited => 'Slow down — try again in a moment.';

  @override
  String get categoryMaxLayerReached => 'Max nesting depth reached';

  @override
  String categoryDetailSubcategoriesHeader(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Subcategories ($count)',
      one: 'Subcategory ($count)',
    );
    return '$_temp0';
  }

  @override
  String get categoryDetailNoSubcategories => 'No subcategories yet';

  @override
  String get catalogHubTitle => 'Catalogue';

  @override
  String get catalogHubSubtitle =>
      'Manage products, categories, and brands in one place.';

  @override
  String get catalogHubProductsTitle => 'Products';

  @override
  String get catalogHubProductsSub => 'Manage stock items and sale details';

  @override
  String get catalogHubCategoriesTitle => 'Categories';

  @override
  String get catalogHubCategoriesSub => 'Organize products by category';

  @override
  String get catalogHubBrandsTitle => 'Brands';

  @override
  String get catalogHubBrandsSub => 'Manage manufacturers';

  @override
  String get catalogHubDistributorsTitle => 'Distributors';

  @override
  String get catalogHubTaxTitle => 'Tax';

  @override
  String get catalogHubComingSoon => 'Coming soon';

  @override
  String get brandTitle => 'Brands';

  @override
  String brandTotalCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '# brands',
      one: '# brand',
    );
    return '$_temp0';
  }

  @override
  String get brandSearchHint => 'Search brands...';

  @override
  String brandStatProducts(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '# products',
      one: '# product',
    );
    return '$_temp0';
  }

  @override
  String get brandEmptyTitle => 'No brands yet';

  @override
  String get brandEmptyBody =>
      'Create your first brand to group products by manufacturer.';

  @override
  String get brandEmptyAction => 'Create first brand';

  @override
  String get brandLoadError => 'Could not load brands';

  @override
  String get brandLoadRetry => 'Retry';

  @override
  String get brandCreateTitle => 'Create brand';

  @override
  String get brandEditTitle => 'Edit brand';

  @override
  String get brandFieldNameLabel => 'Name *';

  @override
  String get brandFieldNameHint => 'e.g. Bosch, Makita, Stanley';

  @override
  String get brandFieldNameRequired => 'Name is required';

  @override
  String get brandCreateCta => 'Create';

  @override
  String get brandEditCta => 'Update';

  @override
  String get brandDeleteConfirmTitle => 'Delete brand?';

  @override
  String brandDeleteConfirmBody(String name) {
    return 'Cannot be undone. $name will be deleted.';
  }

  @override
  String get brandDeleteConfirmCta => 'Delete';

  @override
  String get brandNotifySaved => 'Brand saved';

  @override
  String get brandNotifyDeleted => 'Brand deleted';

  @override
  String get brandNotifyServer => 'Something went wrong. Try again later.';

  @override
  String get brandNotifyNetwork => 'Couldn\'t reach the server. Try again.';

  @override
  String get brandActionEdit => 'Edit';

  @override
  String get brandActionDelete => 'Delete';

  @override
  String get navOrders => 'Orders';

  @override
  String get orderListTitle => 'Orders';

  @override
  String get orderListSearchHint => 'Search by order # or customer';

  @override
  String get orderListEmptyAll => 'No orders yet';

  @override
  String get orderListEmptyFiltered => 'No orders match your filters';

  @override
  String get orderListEmptyCta => 'Create first order';

  @override
  String get orderListEmptyBody => 'Create your first order to get started.';

  @override
  String get orderListNewOrder => 'New order';

  @override
  String get orderListLoading => 'Loading…';

  @override
  String orderListLoadError(String error) {
    return 'Could not load orders: $error';
  }

  @override
  String get orderListOrderUnit => 'orders';

  @override
  String orderListPaymentFilterChip(String status) {
    return 'Payment: $status';
  }

  @override
  String orderListChannelFilterChip(String channel) {
    return 'Channel: $channel';
  }

  @override
  String orderListFromDateChip(String date) {
    return 'From $date';
  }

  @override
  String orderListToDateChip(String date) {
    return 'To $date';
  }

  @override
  String get orderListClearFilters => 'Clear filters';

  @override
  String get orderListFilterTitle => 'Filters';

  @override
  String get orderListFilterApply => 'Apply';

  @override
  String get orderListFilterReset => 'Reset';

  @override
  String get orderListFilterPaymentStatus => 'Payment status';

  @override
  String get orderListFilterSaleChannel => 'Sales channel';

  @override
  String get orderListFilterFromDate => 'From';

  @override
  String get orderListFilterToDate => 'To';

  @override
  String get orderStatusDraft => 'Draft';

  @override
  String get orderStatusPending => 'Pending';

  @override
  String get orderStatusCompleted => 'Completed';

  @override
  String get orderStatusCancelled => 'Cancelled';

  @override
  String get orderStatusAll => 'All';

  @override
  String get orderPaymentStatusUnpaid => 'Unpaid';

  @override
  String get orderPaymentStatusPartial => 'Partial';

  @override
  String get orderPaymentStatusPaid => 'Paid';

  @override
  String get orderPaymentMethodCash => 'Cash';

  @override
  String get orderPaymentMethodBankTransfer => 'Bank transfer';

  @override
  String get orderPaymentMethodCard => 'Card';

  @override
  String get orderPaymentMethodOther => 'Other';

  @override
  String get orderSaleChannelShop => 'Shop';

  @override
  String get orderSaleChannelEcommerce => 'E-commerce';

  @override
  String get orderWalkIn => 'Walk-in';

  @override
  String get orderNoCustomer => 'No customer';

  @override
  String orderItemsCount(int count) {
    return '$count items';
  }

  @override
  String get orderDetailTitle => 'Order details';

  @override
  String get orderDetailNotFound => 'Order not found';

  @override
  String get orderDetailSubtotal => 'Subtotal';

  @override
  String get orderDetailDiscount => 'Discount';

  @override
  String get orderDetailTax => 'Tax';

  @override
  String get orderDetailTotal => 'Total';

  @override
  String get orderDetailPaid => 'Paid';

  @override
  String get orderDetailChange => 'Change';

  @override
  String get orderDetailCustomer => 'Customer';

  @override
  String get orderDetailNote => 'Note';

  @override
  String get orderDetailItems => 'Items';

  @override
  String get orderDetailPayments => 'Payments';

  @override
  String get orderDetailAddPayment => 'Add payment';

  @override
  String get orderDetailMarkCompleted => 'Mark completed';

  @override
  String get orderDetailCancel => 'Cancel order';

  @override
  String get orderDetailVoid => 'Void';

  @override
  String get orderDetailCancelDialogTitle => 'Cancel order?';

  @override
  String get orderDetailCancelReasonHint => 'Reason';

  @override
  String get orderDetailVoidDialogTitle => 'Void this order?';

  @override
  String get orderDetailVoidDialogBody =>
      'A completed order will be marked as voided. This cannot be undone.';

  @override
  String get orderDetailMarkCompletedDialogTitle => 'Mark as completed?';

  @override
  String get orderDetailUpdated => 'Order updated';

  @override
  String get orderCreateTitle => 'New order';

  @override
  String get orderCreateEmptyCta => 'Add product';

  @override
  String get orderCreateAddMore => 'Add another product';

  @override
  String get orderCreateClearCart => 'Clear cart';

  @override
  String get orderCreateDiscardDialogTitle => 'Discard cart?';

  @override
  String get orderCreateDiscardDialogBody =>
      'You\'ll lose the items you\'ve added.';

  @override
  String get orderCreateDiscardConfirm => 'Discard';

  @override
  String get orderCreateKeepEditing => 'Keep editing';

  @override
  String get orderCreateCustomerName => 'Customer name';

  @override
  String get orderCreateCustomerPhone => 'Phone';

  @override
  String get orderCreateNote => 'Note';

  @override
  String get orderCreateOrderDiscount => 'Order discount';

  @override
  String get orderCreateManualTax => 'Tax (%)';

  @override
  String get orderCreateDiscountTypeNone => 'None';

  @override
  String get orderCreateDiscountTypePercentage => 'Percent';

  @override
  String get orderCreateDiscountTypeFixed => 'Fixed';

  @override
  String get orderCreateSaveDraft => 'Save as draft';

  @override
  String get orderCreatePay => 'Pay';

  @override
  String get orderCreateSavedDraft => 'Draft saved';

  @override
  String get orderCreatePaid => 'Payment received';

  @override
  String get addLineSheetTitle => 'Add product';

  @override
  String get addLineSheetEditTitle => 'Edit product';

  @override
  String get addLineSheetSearchHint => 'Search products';

  @override
  String get addLineSheetEmpty => 'Type to search products';

  @override
  String get addLineSheetVariantPick => 'Choose variant';

  @override
  String get addLineSheetQty => 'Quantity';

  @override
  String get addLineSheetUnitPrice => 'Unit price';

  @override
  String get addLineSheetLineDiscount => 'Line discount';

  @override
  String get addLineSheetAdd => 'Add to order';

  @override
  String get addLineSheetUpdate => 'Update';

  @override
  String get orderPaymentSheetTitle => 'Payment';

  @override
  String get orderPaymentSheetMethod => 'Method';

  @override
  String get orderPaymentSheetAmount => 'Amount';

  @override
  String get orderPaymentSheetReference => 'Reference';

  @override
  String get orderPaymentSheetNote => 'Note';

  @override
  String get orderPaymentSheetConfirm => 'Confirm';

  @override
  String get commonRequiredBadge => 'Required';

  @override
  String get commonActions => 'Actions';

  @override
  String get commonName => 'Name';

  @override
  String get commonPhone => 'Phone';

  @override
  String get commonStore => 'Store';

  @override
  String get orderDetailSectionInfo => 'Order info';

  @override
  String get orderDetailFieldCreatedAt => 'Created at';

  @override
  String get orderDetailFieldChannel => 'Sale channel';

  @override
  String get orderDetailSectionSummary => 'Summary';

  @override
  String get orderDetailPaymentsEmpty => 'No payments yet';

  @override
  String get orderCreateCartEmptyTitle => 'Cart is empty';

  @override
  String get orderCreateCustomerNameHint => 'e.g. Mr. Nam';

  @override
  String get orderCreatePhoneHint => '0xxxxxxxxx';

  @override
  String get orderCreateNoteHint => 'Add notes for this order';

  @override
  String get orderCreateManualTaxHint => 'e.g. 8';

  @override
  String get orderCreatePercentHint => '0–100';

  @override
  String get detailQuantityByStore => 'Stock by store';

  @override
  String get detailQuantityByStoreSubtitle =>
      'Remaining quantity at each store';
}
