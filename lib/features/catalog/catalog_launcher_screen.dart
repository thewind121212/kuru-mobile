// TablerIcons uses snake_case symbols.
// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';

/// Landing screen for the Catalog bottom-nav branch.
///
/// Renders a vertical list of "what do you want to manage?" cards: live
/// Categories + Brands, plus disabled "Sắp có" placeholders for Distributor
/// and Tax. Tapping a live card pushes to the dedicated list screen.
class CatalogLauncherScreen extends StatelessWidget {
  const CatalogLauncherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final l = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: c.pageBg,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 96),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 18),
              child: Text(
                l.catalogHubTitle,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.8,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _LauncherCard(
                    icon: TablerIcons.layout_grid,
                    iconBg: const Color(0xFFEEF0FF),
                    iconFg: const Color(0xFF6366F1),
                    title: l.catalogHubCategoriesTitle,
                    subtitle: l.catalogHubCategoriesSub,
                    onTap: () => context.go('/catalog/categories'),
                  ),
                  const SizedBox(height: 12),
                  _LauncherCard(
                    icon: TablerIcons.shopping_bag,
                    iconBg: const Color(0xFFFEF6E5),
                    iconFg: const Color(0xFFD97706),
                    title: l.catalogHubBrandsTitle,
                    subtitle: l.catalogHubBrandsSub,
                    onTap: () => context.go('/catalog/brands'),
                  ),
                  const SizedBox(height: 12),
                  _LauncherCard(
                    icon: TablerIcons.package,
                    iconBg: const Color(0xFFEEF0FF),
                    iconFg: const Color(0xFF6366F1),
                    title: 'Sản phẩm',
                    subtitle: 'Quản lý kho hàng',
                    onTap: () => context.go('/catalog/products'),
                  ),
                  const SizedBox(height: 12),
                  _LauncherCard(
                    icon: TablerIcons.receipt_tax,
                    iconBg: const Color(0xFFF1ECFB),
                    iconFg: const Color(0xFF8B5CF6),
                    title: l.catalogHubTaxTitle,
                    subtitle: l.catalogHubComingSoon,
                    disabled: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LauncherCard extends StatelessWidget {
  const _LauncherCard({
    required this.icon,
    required this.iconBg,
    required this.iconFg,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.disabled = false,
  });

  final IconData icon;
  final Color iconBg;
  final Color iconFg;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Opacity(
      opacity: disabled ? 0.55 : 1,
      child: Material(
        color: c.surfaceElev,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: disabled ? null : onTap,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  alignment: Alignment.center,
                  child: Icon(icon, size: 26, color: iconFg),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: c.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(fontSize: 13, color: c.textMuted),
                      ),
                    ],
                  ),
                ),
                Icon(TablerIcons.chevron_right, color: c.textMuted),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
