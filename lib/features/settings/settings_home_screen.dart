import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
import 'package:kuru_mobile/core/auth/auth_providers.dart';
import 'package:kuru_mobile/core/auth/auth_repository.dart';
import 'package:kuru_mobile/core/auth/biometric_providers.dart';
import 'package:kuru_mobile/core/permissions/permissions_providers.dart';
import 'package:kuru_mobile/design/core/catalog/k_settings_row.dart';
import 'package:kuru_mobile/design/core/layout/k_settings_hero.dart';
import 'package:kuru_mobile/design/core/layout/k_settings_section.dart';

class SettingsHomeScreen extends ConsumerWidget {
  const SettingsHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = kuruColors(context);
    final bootstrap = ref.watch(appBootstrapProvider);
    final perms = ref.watch(myPermissionsProvider);
    final bioEnabled = ref.watch(biometricEnabledProvider);

    final user = bootstrap.maybeWhen(
      data: (b) => b is BootstrapAuthed ? b.user : null,
      orElse: () => null,
    );
    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final org = user.orgInfos.isNotEmpty ? user.orgInfos.first : null;
    final orgChip = org == null ? '' : '${org.name} · ${_roleLabel(org.role)}';

    final isOwner = perms.maybeWhen(
      data: (p) => p.isOwner,
      orElse: () => false,
    );

    return Scaffold(
      backgroundColor: c.pageBg,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 32),
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(24, 12, 24, 18),
              child: Text(
                'Cài đặt',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.8,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: KSettingsHero(
                name: user.name ?? '',
                email: user.email ?? '',
                orgChip: orgChip,
                avatarStyle: user.avatarStyle,
                avatarSeed: user.avatarSeed,
                avatarUrl: user.avatarUrl,
                onTap: () => context.push('/settings/profile'),
              ),
            ),
            KSettingsSection(
              header: 'Bảo mật',
              children: [
                KSettingsRow(
                  leadingIcon: Icons.key_outlined,
                  iconBackground: const Color(0xFFEEF0FF),
                  iconColor: const Color(0xFF6366F1),
                  label: 'Đổi mật khẩu',
                  onTap: () => context.push('/settings/security'),
                ),
                KSettingsRow(
                  leadingIcon: Icons.shield_outlined,
                  iconBackground: const Color(0xFFFEF6E5),
                  iconColor: const Color(0xFFD97706),
                  label: 'Xác thực 2 lớp',
                  trailingText: user.totpEnabled ? 'Bật' : 'Tắt',
                  onTap: () => context.push('/settings/security'),
                ),
                KSettingsRow(
                  leadingIcon: Icons.fingerprint,
                  iconBackground: const Color(0xFFE6F7F0),
                  iconColor: const Color(0xFF10B981),
                  label: 'FaceID / Vân tay',
                  trailingText: bioEnabled.maybeWhen(
                    data: (v) => v ? 'Bật' : 'Tắt',
                    orElse: () => 'Tắt',
                  ),
                  onTap: () => context.push('/settings/security'),
                ),
              ],
            ),
            if (isOwner)
              KSettingsSection(
                header: 'Cửa hàng',
                children: [
                  KSettingsRow(
                    leadingIcon: Icons.public,
                    iconBackground: const Color(0xFFF1ECFB),
                    iconColor: const Color(0xFF8B5CF6),
                    label: 'Múi giờ',
                    onTap: () => context.push('/settings/store'),
                  ),
                ],
              ),
            KSettingsSection(
              header: 'Giao diện',
              children: [
                KSettingsRow(
                  leadingIcon: Icons.palette_outlined,
                  iconBackground: const Color(0xFFE6F4F5),
                  iconColor: const Color(0xFF14B8A6),
                  label: 'Màu chủ đề',
                  onTap: () => context.push('/settings/appearance'),
                ),
                KSettingsRow(
                  leadingIcon: Icons.language,
                  iconBackground: const Color(0xFFE7F1FB),
                  iconColor: const Color(0xFF3B82F6),
                  label: 'Ngôn ngữ',
                  onTap: () => context.push('/settings/appearance'),
                ),
              ],
            ),
            KSettingsSection(
              header: '',
              children: [
                KSettingsRow(
                  leadingIcon: Icons.logout,
                  iconBackground: const Color(0xFFFBE9EC),
                  iconColor: const Color(0xFFE11D48),
                  label: 'Đăng xuất',
                  labelColor: const Color(0xFFDC2626),
                  showChevron: false,
                  onTap: () async {
                    final repo = ref.read(authRepositoryProvider);
                    await repo.signOut();
                    ref.read(currentOrgIdProvider.notifier).clear();
                    ref.invalidate(appBootstrapProvider);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _roleLabel(String wireRole) {
    switch (wireRole) {
      case 'OWNER':
        return 'Chủ shop';
      case 'MANAGER':
        return 'Quản lý';
      case 'STAFF':
        return 'Nhân viên';
      default:
        return wireRole;
    }
  }
}
