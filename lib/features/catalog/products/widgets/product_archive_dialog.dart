import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuru_mobile/core/feedback/k_notify.dart';
import 'package:kuru_mobile/core/network/api_exception.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/design/core/modal/k_confirm_dialog.dart';
import 'package:kuru_mobile/features/catalog/products/models/update_product_info_body.dart';
import 'package:kuru_mobile/features/catalog/products/providers/product_providers.dart';

/// Confirm dialog for the "Ngừng kinh doanh" (status=ARCHIVED) product flow.
///
/// Returns:
/// - `true`  → archive succeeded (productById + productList invalidated,
///             success toast shown)
/// - `false` → archive failed (warning toast surfaces `err.message`)
/// - `null`  → user cancelled / dismissed the dialog
Future<bool?> showProductArchiveDialog(
  BuildContext context, {
  required String productId,
}) async {
  final container = ProviderScope.containerOf(context);
  // Captures the outcome of the awaited mutation so we can translate
  // showKConfirmDialog's `true | null` into `true | false | null`.
  bool? outcome;
  ApiException? capturedErr;

  final confirmed = await showKConfirmDialog(
    context: context,
    title: 'Ngừng kinh doanh sản phẩm?',
    subtitle:
        'Sản phẩm sẽ bị ẩn khỏi bán hàng và nhóm sản phẩm. '
        'Lịch sử nhập xuất kho và mua hàng được giữ nguyên.',
    confirmLabel: 'Ngừng kinh doanh',
    onConfirm: () async {
      final repo = container.read(productRepositoryProvider);
      final result = await repo.updateInfo(
        UpdateProductInfoBody(productId: productId, status: 'ARCHIVED'),
      );
      switch (result) {
        case ApiSuccess<void>():
          outcome = true;
          container.invalidate(productByIdProvider(productId));
          container.invalidate(productListProvider);
          return;
        case ApiFailure<void>(:final err):
          outcome = false;
          capturedErr = err;
          // Throwing closes the dialog with `null` from showKConfirmDialog;
          // the caller-facing return value is normalised below.
          throw err;
      }
    },
  );

  if (context.mounted) {
    if ((confirmed ?? false) && (outcome ?? false)) {
      KNotify.success(context, 'Đã ngừng kinh doanh sản phẩm');
    } else if (outcome == false && capturedErr != null) {
      KNotify.warning(context, capturedErr!.message);
    }
  }

  if (outcome == false) return false;
  return confirmed;
}
