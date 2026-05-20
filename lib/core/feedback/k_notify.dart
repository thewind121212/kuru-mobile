import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
import 'package:toastification/toastification.dart';

// TablerIcons uses snake_case names which triggers the analyzer lint;
// the convention is fixed by the icon library, not us.
// ignore_for_file: non_constant_identifier_names

/// Unified feedback API. Style matches `docs/superpowers/specs/2026-05-20-ui-style-guide.md`:
/// minimal-style toast with the bible's soft pastel backgrounds, 14-radius,
/// a tinted leading icon, and a strong matching foreground. Always
/// rendered top-right, auto-dismiss after 4s.
///
/// - `success` / `info` / `warning` / `danger` → toastification toast
/// - `networkError` → bottom SnackBar with a "Thử lại" / "Retry" action
///
/// Field-level errors (wrong password, invalid email, taken name) belong
/// in `KFormField.errorText`, NOT a toast.
class KNotify {
  KNotify._();

  static void success(BuildContext context, String message) {
    _toast(
      context,
      message,
      icon: TablerIcons.circle_check,
      background: const Color(0xFFE6F7F0),
      foreground: const Color(0xFF047857),
    );
  }

  static void info(BuildContext context, String message) {
    _toast(
      context,
      message,
      icon: TablerIcons.info_circle,
      background: const Color(0xFFE7F1FB),
      foreground: const Color(0xFF1D4ED8),
    );
  }

  static void warning(BuildContext context, String message) {
    _toast(
      context,
      message,
      icon: TablerIcons.alert_triangle,
      background: const Color(0xFFFEF6E5),
      foreground: const Color(0xFFB45309),
    );
  }

  static void danger(BuildContext context, String message) {
    _toast(
      context,
      message,
      icon: TablerIcons.alert_circle,
      background: const Color(0xFFFBE9EC),
      foreground: const Color(0xFFBE123C),
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
            borderRadius: BorderRadius.circular(14),
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
    String message, {
    required IconData icon,
    required Color background,
    required Color foreground,
  }) {
    toastification.show(
      context: context,
      style: ToastificationStyle.minimal,
      alignment: Alignment.topRight,
      autoCloseDuration: const Duration(seconds: 4),
      dragToClose: true,
      showProgressBar: false,
      pauseOnHover: true,
      backgroundColor: background,
      foregroundColor: foreground,
      icon: Icon(icon, color: foreground, size: 20),
      borderRadius: BorderRadius.circular(14),
      title: Text(
        message,
        style: TextStyle(
          color: foreground,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
