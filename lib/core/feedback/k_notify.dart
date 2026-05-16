import 'package:flutter/material.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
import 'package:toastification/toastification.dart';

/// Unified feedback API. Picks the right pattern per category:
///
/// - `success` / `info` / `warning` → top-right toast (toastification),
///   auto-dismisses after a few seconds. Multiple toasts stack.
/// - `networkError` → bottom SnackBar with a "Thử lại" / "Retry" action.
///
/// Inline banners (rendered directly inside form bodies) are still the
/// right pattern for field-level errors like "wrong password" — call sites
/// should keep their existing `_errorMessage` state for those.
class KNotify {
  KNotify._();

  static void success(BuildContext context, String message) {
    _toast(
      context,
      message,
      ToastificationType.success,
    );
  }

  static void info(BuildContext context, String message) {
    _toast(
      context,
      message,
      ToastificationType.info,
    );
  }

  static void warning(BuildContext context, String message) {
    _toast(
      context,
      message,
      ToastificationType.warning,
    );
  }

  /// Transient operational error (network down, server 5xx, request cancelled).
  /// Always include a retry action if the operation is retriable.
  static void networkError(
    BuildContext context,
    String message, {
    required VoidCallback onRetry,
    String retryLabel = 'Thử lại',
  }) {
    final c = kuruColors(context);
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: c.textPrimary,
          duration: const Duration(seconds: 8),
          action: SnackBarAction(
            label: retryLabel,
            textColor: c.accent400,
            onPressed: onRetry,
          ),
        ),
      );
  }

  static void _toast(
    BuildContext context,
    String message,
    ToastificationType type,
  ) {
    final c = kuruColors(context);
    toastification.show(
      context: context,
      type: type,
      style: ToastificationStyle.flatColored,
      title: Text(message),
      alignment: Alignment.topRight,
      autoCloseDuration: const Duration(seconds: 4),
      borderRadius: BorderRadius.circular(12),
      dragToClose: true,
      primaryColor: switch (type) {
        ToastificationType.success => c.success,
        ToastificationType.warning => c.warning,
        ToastificationType.error => c.danger,
        ToastificationType.info => c.primary,
        _ => c.primary,
      },
      showProgressBar: false,
      pauseOnHover: true,
    );
  }
}
