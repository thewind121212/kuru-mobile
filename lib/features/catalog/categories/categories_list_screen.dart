// TablerIcons uses snake_case names (e.g. TablerIcons.layout_grid) which
// triggers non_constant_identifier_names; suppress for the whole file.
// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:kuru_category_api/kuru_category_api.dart' as gen;
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/core/text/search_normalize.dart';
import 'package:kuru_mobile/design/core/catalog/k_category_card.dart';
import 'package:kuru_mobile/design/core/feedback/k_badge.dart';
import 'package:kuru_mobile/design/core/feedback/k_empty_state.dart';
import 'package:kuru_mobile/design/core/feedback/k_skeleton.dart';
import 'package:kuru_mobile/design/core/input/k_icon_btn.dart';
import 'package:kuru_mobile/design/core/input/k_search_bar.dart';
import 'package:kuru_mobile/design/core/input/k_secondary_btn.dart';
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

  /// Uniform "Cấp N" / "Layer N" label across all 5 layers — drops the
  /// awkward "Cấp chính / phụ / phụ phụ" variants per design feedback.
  String _layerLabel(BuildContext context, String layer) {
    return '${AppLocalizations.of(context).categoryLayerPrefix} $layer';
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final overview = ref.watch(categoryOverviewProvider);
    final totalCount = overview.maybeWhen(
      data: (cats) => cats.length,
      orElse: () => null,
    );
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _CategoriesHeader(title: l.categoryTitle, totalCount: totalCount),
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
                      final filters = <_LayerFilter>[
                        _LayerFilter(
                          id: 'all',
                          label: l.categoryLayerAll,
                          count: categories.length,
                        ),
                        for (final layer in layers)
                          _LayerFilter(
                            id: layer,
                            label: _layerLabel(context, layer),
                            count: categories
                                .where((c) => (c.layer ?? '1') == layer)
                                .length,
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
                          _LayerFilterRow(
                            filters: filters,
                            active: _activeLayer,
                            onChange: (id) => setState(() => _activeLayer = id),
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

/// Centered header for the Catalog tab — title + optional total-count line.
///
/// Deliberately does NOT use `KPageHeader` because Categories wants a
/// transparent, centred treatment with no description and the total count
/// surfaced under the title (kuru-web parity).
class _CategoriesHeader extends StatelessWidget {
  const _CategoriesHeader({required this.title, this.totalCount});

  final String title;
  final int? totalCount;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).textTheme;
    final l = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: c.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          if (totalCount != null) ...[
            const SizedBox(height: 2),
            Text(
              l.categoryTotalCount(totalCount!),
              textAlign: TextAlign.center,
              style: c.bodySmall?.copyWith(
                color: Theme.of(
                  context,
                ).textTheme.bodySmall?.color?.withValues(alpha: 0.65),
              ),
            ),
          ],
        ],
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

/// One option on the [`_LayerFilterRow`] — the filter id, its label, and
/// the count of categories that match (rendered as a subtle inline number).
@immutable
class _LayerFilter {
  const _LayerFilter({
    required this.id,
    required this.label,
    required this.count,
  });

  final String id;
  final String label;
  final int count;
}

/// Horizontally scrollable minimalist filter row for the layer tabs.
///
/// Active filter: solid accent-tinted pill with bold accent text + a
/// rounded count chip on the right. Inactive filters: plain text + a
/// subtle muted count badge — no surrounding pill, so the row reads as
/// "one selected option among options" rather than a heavy segmented
/// control. Tap any filter to switch.
class _LayerFilterRow extends StatelessWidget {
  const _LayerFilterRow({
    required this.filters,
    required this.active,
    required this.onChange,
  });

  final List<_LayerFilter> filters;
  final String active;
  final ValueChanged<String> onChange;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (ctx, i) {
          final f = filters[i];
          return _LayerFilterChip(
            filter: f,
            isActive: f.id == active,
            onTap: () => onChange(f.id),
          );
        },
      ),
    );
  }
}

class _LayerFilterChip extends StatelessWidget {
  const _LayerFilterChip({
    required this.filter,
    required this.isActive,
    required this.onTap,
  });

  final _LayerFilter filter;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final fg = isActive ? c.accent600 : c.textMuted;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: isActive ? c.accent600.withValues(alpha: 0.10) : null,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(999),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(999),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  filter.label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                    color: fg,
                  ),
                ),
                const SizedBox(width: 6),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: isActive
                        ? c.accent600.withValues(alpha: 0.18)
                        : c.surfaceHover,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 1,
                    ),
                    child: Text(
                      '${filter.count}',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: fg,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
