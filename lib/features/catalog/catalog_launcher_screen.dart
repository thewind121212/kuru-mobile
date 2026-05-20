// TablerIcons uses snake_case symbols.
// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/design/core/layout/k_page_header.dart';

/// Landing screen for the Catalog bottom-nav branch.
///
/// Renders a vertical list of "what do you want to manage?" cards: live
/// Categories + Brands, plus disabled "Sắp có" placeholders for Distributor
/// and Tax. Tapping a live card pushes to the dedicated list screen.
class CatalogLauncherScreen extends StatelessWidget {
  const CatalogLauncherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
          children: [
            KPageHeader(title: l.catalogHubTitle),
            const SizedBox(height: 16),
            _LauncherCard(
              icon: TablerIcons.layout_grid,
              title: l.catalogHubCategoriesTitle,
              subtitle: l.catalogHubCategoriesSub,
              onTap: () => context.go('/catalog/categories'),
            ),
            const SizedBox(height: 12),
            _LauncherCard(
              icon: TablerIcons.shopping_bag,
              title: l.catalogHubBrandsTitle,
              subtitle: l.catalogHubBrandsSub,
              onTap: () => context.go('/catalog/brands'),
            ),
            const SizedBox(height: 12),
            _LauncherCard(
              icon: TablerIcons.truck,
              title: l.catalogHubDistributorsTitle,
              subtitle: l.catalogHubComingSoon,
              disabled: true,
            ),
            const SizedBox(height: 12),
            _LauncherCard(
              icon: TablerIcons.receipt_tax,
              title: l.catalogHubTaxTitle,
              subtitle: l.catalogHubComingSoon,
              disabled: true,
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
    required this.title,
    required this.subtitle,
    this.onTap,
    this.disabled = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Opacity(
      opacity: disabled ? 0.55 : 1.0,
      child: Material(
        color: c.surfaceElev,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: disabled ? null : onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border.all(color: c.border),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: c.accent100,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, size: 30, color: c.accent300),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
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
