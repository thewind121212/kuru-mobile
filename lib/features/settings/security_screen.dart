import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
import 'package:kuru_mobile/core/auth/auth_providers.dart';
import 'package:kuru_mobile/core/auth/biometric_providers.dart';
import 'package:kuru_mobile/core/feedback/k_notify.dart';
import 'package:kuru_mobile/design/core/catalog/k_settings_row.dart';
import 'package:kuru_mobile/design/core/input/k_switch_row.dart';
import 'package:kuru_mobile/design/core/layout/k_settings_section.dart';
import 'package:kuru_mobile/features/settings/sheets/change_password_sheet.dart';
import 'package:kuru_mobile/features/settings/sheets/enable_biometric_sheet.dart';

class SecurityScreen extends ConsumerWidget {
  const SecurityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = kuruColors(context);
    final bioEnabled = ref.watch(biometricEnabledProvider);
    final bioAvailable = ref.watch(biometricAvailableProvider);
    final bootstrap = ref.watch(appBootstrapProvider);

    final user = bootstrap.maybeWhen(
      data: (b) => b is BootstrapAuthed ? b.user : null,
      orElse: () => null,
    );
    final bioOn = bioEnabled.maybeWhen(data: (v) => v, orElse: () => false);

    return Scaffold(
      backgroundColor: c.pageBg,
      appBar: AppBar(
        backgroundColor: c.pageBg,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: const BackButton(),
        title: Text(
          'Bảo mật',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: c.textPrimary,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 12),
          children: [
            KSettingsSection(
              header: 'Tài khoản',
              children: [
                KSettingsRow(
                  leadingIcon: Icons.key_outlined,
                  iconBackground: const Color(0xFFEEF0FF),
                  iconColor: const Color(0xFF6366F1),
                  label: 'Đổi mật khẩu',
                  onTap: () => showChangePasswordSheet(context),
                ),
                KSettingsRow(
                  leadingIcon: Icons.shield_outlined,
                  iconBackground: const Color(0xFFFEF6E5),
                  iconColor: const Color(0xFFD97706),
                  label: 'Xác thực 2 lớp',
                  trailingText: (user?.totpEnabled ?? false) ? 'Bật' : 'Tắt',
                  onTap: () =>
                      KNotify.info(context, 'Tính năng đang phát triển'),
                ),
                KSwitchRow(
                  leadingIcon: Icons.fingerprint,
                  iconBackground: const Color(0xFFE6F7F0),
                  iconColor: const Color(0xFF10B981),
                  label: 'FaceID / Vân tay',
                  subtitle: bioOn
                      ? 'Đã bật'
                      : 'Đăng nhập nhanh không cần mật khẩu',
                  value: bioOn,
                  onChanged: (target) async {
                    final available = bioAvailable.maybeWhen(
                      data: (v) => v,
                      orElse: () => false,
                    );
                    if (!available) {
                      KNotify.warning(
                        context,
                        'Thiết bị chưa cài FaceID hoặc vân tay',
                      );
                      return;
                    }
                    if (target) {
                      final ok = await showEnableBiometricSheet(context);
                      if (ok) ref.invalidate(biometricEnabledProvider);
                    } else {
                      await ref.read(biometricRepositoryProvider).disable();
                      ref.invalidate(biometricEnabledProvider);
                      if (!context.mounted) return;
                      KNotify.success(context, 'Đã tắt FaceID');
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
