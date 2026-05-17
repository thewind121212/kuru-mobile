// TablerIcons uses snake_case names (e.g. TablerIcons.layout_grid) which
// triggers non_constant_identifier_names; suppress for the whole file.
// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:kuru_category_api/kuru_category_api.dart' as gen;
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/core/text/search_normalize.dart';
import 'package:kuru_mobile/design/core/catalog/k_category_card.dart';
import 'package:kuru_mobile/design/core/feedback/k_badge.dart';
import 'package:kuru_mobile/design/core/feedback/k_empty_state.dart';
import 'package:kuru_mobile/design/core/feedback/k_skeleton.dart';
import 'package:kuru_mobile/design/core/input/k_icon_btn.dart';
import 'package:kuru_mobile/design/core/input/k_search_bar.dart';
import 'package:kuru_mobile/design/core/input/k_secondary_btn.dart';
import 'package:kuru_mobile/design/core/input/k_tab_nav.dart';
import 'package:kuru_mobile/design/core/layout/k_page_header.dart';
import 'package:kuru_mobile/design/core/modal/color_options.dart';
import 'package:kuru_mobile/design/core/modal/icon_mapping.dart';
import 'package:kuru_mobile/features/catalog/categories/providers/category_providers.dart';

class CategoriesListScreen extends ConsumerStatefulWidget {
  const CategoriesListScreen({super.key});

  @override
  ConsumerState<CategoriesListScreen> createState() =>
      _CategoriesListScreenState();
}

class _CategoriesListScreenState extends ConsumerState<CategoriesListScreen> {
  String _searchQuery = '';
  String _activeLayer = 'all';

  String _layerLabel(BuildContext context, String layer) {
    final l = AppLocalizations.of(context);
    switch (layer) {
      case '1':
        return l.categoryLayerMain;
      case '2':
        return l.categoryLayerSub;
      case '3':
        return l.categoryLayerSubSub;
      default:
        return '${l.categoryLayerPrefix} $layer';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            KPageHeader(title: l.categoryTitle, subtitle: l.categorySubtitle),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: KSearchBar(
                hint: l.categorySearchHint,
                onChanged: (q) => setState(() => _searchQuery = q),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ref
                  .watch(categoryOverviewProvider)
                  .when(
                    loading: () => const _CategorySkeletonList(),
                    error: (e, _) => _CategoryErrorState(
                      onRetry: () => ref.invalidate(categoryOverviewProvider),
                    ),
                    data: (categories) {
                      if (categories.isEmpty) {
                        return _CategoryEmpty(
                          onCreate: () {
                            // Plan 2 wires the create modal here.
                          },
                        );
                      }
                      final layers =
                          categories.map((c) => c.layer ?? '1').toSet().toList()
                            ..sort(
                              (a, b) => (int.tryParse(a) ?? 0).compareTo(
                                int.tryParse(b) ?? 0,
                              ),
                            );
                      final tabs = <KTabItem<String>>[
                        KTabItem(id: 'all', label: l.categoryLayerAll),
                        for (final layer in layers)
                          KTabItem(
                            id: layer,
                            label: _layerLabel(context, layer),
                          ),
                      ];
                      final visible = _activeLayer == 'all'
                          ? categories
                          : categories
                                .where((c) => (c.layer ?? '1') == _activeLayer)
                                .toList();
                      final normalizedQuery = normalizeForSearch(_searchQuery);
                      final filtered = normalizedQuery.isEmpty
                          ? visible
                          : visible
                                .where(
                                  (c) => normalizeForSearch(
                                    c.name ?? '',
                                  ).contains(normalizedQuery),
                                )
                                .toList();
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: KTabNav<String>(
                              tabs: tabs,
                              active: _activeLayer,
                              onChange: (id) =>
                                  setState(() => _activeLayer = id),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Expanded(
                            child: ListView.separated(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              itemCount: filtered.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 12),
                              itemBuilder: (ctx, i) => _CategoryCardItem(
                                category: filtered[i],
                                onTap: () => context.go(
                                  '/catalog/categories/${filtered[i].categoryId}',
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                      );
                    },
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Wraps one [gen.CategoryResponse] into the design-system [KCategoryCard].
///
/// Maps BE persistence fields to design tokens:
/// - `icon` (kebab-case name)   → [resolveIconName] → [IconData], fallback
///   to [TablerIcons.layout_grid] when the BE stored an icon outside our
///   curated set (per spec §5.4 / showKIconPicker contract).
/// - `colorSettings` (tailwind id like `slate-400`) → [kAllColors] swatch,
///   fallback to slate-400 when the BE stored an unknown id.
/// - `subCategoriesCount` + `itemCount` → two [KCategoryCardStat] entries.
/// - `lowStockCount > 0` → danger [KBadge] in the footer.
class _CategoryCardItem extends StatelessWidget {
  const _CategoryCardItem({required this.category, required this.onTap});

  final gen.CategoryResponse category;
  final VoidCallback onTap;

  static final _vndCompact = NumberFormat.compactCurrency(
    locale: 'vi_VN',
    symbol: '₫',
    decimalDigits: 1,
  );

  IconData _resolveIcon() {
    final name = category.icon;
    if (name == null || name.isEmpty) return TablerIcons.layout_grid;
    return resolveIconName(name) ?? TablerIcons.layout_grid;
  }

  Color _resolveColor() {
    final id = category.colorSettings;
    if (id == null || id.isEmpty) return kAllColors.first.swatch;
    return kAllColors
        .firstWhere((co) => co.id == id, orElse: () => kAllColors.first)
        .swatch;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final stats = <KCategoryCardStat>[
      KCategoryCardStat(
        label: l.categoryStatSubCategories,
        value: '${category.subCategoriesCount ?? 0}',
      ),
      KCategoryCardStat(
        label: l.categoryStatItems,
        value: '${category.itemCount}',
      ),
      if (category.totalValue > 0)
        KCategoryCardStat(
          label: l.categoryStatValue,
          value: _vndCompact.format(category.totalValue),
        ),
    ];
    final lowStock = category.lowStockCount;
    return KCategoryCard(
      icon: _resolveIcon(),
      iconBg: _resolveColor(),
      name: category.name ?? '',
      stats: stats,
      lowStockBadge: lowStock > 0
          ? KBadge(
              label: l.categoryLowStockBadge(lowStock),
              tone: KBadgeTone.danger,
              leadingIcon: TablerIcons.alert_triangle,
            )
          : null,
      menu: KIconBtn(
        icon: const Icon(TablerIcons.dots_vertical),
        size: 32,
        onPressed: () {
          // Plan 2 wires the action menu (Edit / Delete / Add subcategory).
        },
      ),
      onTap: onTap,
    );
  }
}

class _CategorySkeletonList extends StatelessWidget {
  const _CategorySkeletonList();
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      itemCount: 4,
      itemBuilder: (_, __) => const Padding(
        padding: EdgeInsets.symmetric(vertical: 6),
        child: KSkeleton(height: 120),
      ),
    );
  }
}

class _CategoryEmpty extends StatelessWidget {
  const _CategoryEmpty({required this.onCreate});
  final VoidCallback onCreate;
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return KEmptyState(
      icon: TablerIcons.layout_grid,
      title: l.categoryEmptyTitle,
      subtitle: l.categoryEmptyBody,
      action: KSecondaryBtn(
        onPressed: onCreate,
        label: l.categoryEmptyAction,
        fullWidth: false,
      ),
    );
  }
}

class _CategoryErrorState extends StatelessWidget {
  const _CategoryErrorState({required this.onRetry});
  final VoidCallback onRetry;
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return KEmptyState(
      icon: TablerIcons.alert_triangle,
      title: l.categoryLoadError,
      action: KSecondaryBtn(
        onPressed: onRetry,
        label: l.categoryLoadRetry,
        fullWidth: false,
      ),
    );
  }
}
