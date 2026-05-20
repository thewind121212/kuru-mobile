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
import 'package:kuru_mobile/core/feedback/k_notify.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/core/network/api_exception.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
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
import 'package:kuru_mobile/design/core/modal/k_confirm_dialog.dart';
import 'package:kuru_mobile/features/catalog/categories/providers/category_providers.dart';
import 'package:kuru_mobile/features/catalog/categories/widgets/category_action_menu.dart';
import 'package:kuru_mobile/features/catalog/categories/widgets/create_edit_category_sheet.dart';

class CategoriesListScreen extends ConsumerStatefulWidget {
  const CategoriesListScreen({super.key});

  @override
  ConsumerState<CategoriesListScreen> createState() =>
      _CategoriesListScreenState();
}

class _CategoriesListScreenState extends ConsumerState<CategoriesListScreen> {
  String _searchQuery = '';
  _CategoryTab _activeTab = _CategoryTab.main;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final overview = ref.watch(categoryOverviewProvider);
    final totalCount = overview.maybeWhen(
      data: (cats) => cats.length,
      orElse: () => null,
    );
    return Scaffold(
      // Tap outside the search bar dismisses the keyboard. Inner buttons,
      // cards, and the search field itself keep their own gestures.
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        behavior: HitTestBehavior.opaque,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _CategoriesHeader(
                title: l.categoryTitle,
                totalCount: totalCount,
                onCreate: () async {
                  final saved = await showCreateEditCategorySheet(
                    context: context,
                    mode: const CreateRoot(),
                  );
                  if (!context.mounted) return;
                  if (saved ?? false) {
                    KNotify.success(context, l.categoryNotifySaved);
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                child: KSearchBar(
                  hint: l.categorySearchHint,
                  onChanged: (q) => setState(() => _searchQuery = q),
                ),
              ),
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
                            onCreate: () async {
                              final saved = await showCreateEditCategorySheet(
                                context: context,
                                mode: const CreateRoot(),
                              );
                              if (!context.mounted) return;
                              if (saved ?? false) {
                                KNotify.success(context, l.categoryNotifySaved);
                              }
                            },
                          );
                        }
                        final mainCats = categories
                            .where((c) => (c.layer ?? '1') == '1')
                            .toList();
                        final subCats = categories
                            .where((c) => (c.layer ?? '1') != '1')
                            .toList();
                        return Column(
                          children: [
                            _CategoryTabBar(
                              active: _activeTab,
                              mainCount: mainCats.length,
                              subCount: subCats.length,
                              onChange: (t) => setState(() => _activeTab = t),
                            ),
                            const SizedBox(height: 12),
                            Expanded(
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 220),
                                switchInCurve: Curves.easeOutCubic,
                                switchOutCurve: Curves.easeInCubic,
                                transitionBuilder: (child, anim) {
                                  // Slide direction depends on which tab we
                                  // are entering — Main slides in from the
                                  // LEFT (its position in the bar), Sub from
                                  // the RIGHT. Fade lays on top of slide.
                                  final goingToMain =
                                      child.key == const ValueKey('main');
                                  final offset = Tween<Offset>(
                                    begin: Offset(
                                      goingToMain ? -0.08 : 0.08,
                                      0,
                                    ),
                                    end: Offset.zero,
                                  ).animate(anim);
                                  return ClipRect(
                                    child: FadeTransition(
                                      opacity: anim,
                                      child: SlideTransition(
                                        position: offset,
                                        child: child,
                                      ),
                                    ),
                                  );
                                },
                                child: _activeTab == _CategoryTab.main
                                    ? _MainTabList(
                                        key: const ValueKey('main'),
                                        categories: mainCats,
                                        searchQuery: _searchQuery,
                                      )
                                    : _SubTabGroupedList(
                                        key: const ValueKey('sub'),
                                        allCategories: categories,
                                        subCategories: subCats,
                                        searchQuery: _searchQuery,
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
      ),
    );
  }
}

/// Centered header for the Catalog tab — title + optional total-count line
/// + a trailing "+" [KIconBtn] that opens the Create Root category sheet.
///
/// iOS-style large header per
/// `docs/superpowers/specs/2026-05-20-ui-style-guide.md` §3.1. Left-aligned
/// 32sp/800w title with the total count as a muted subtitle, plus a
/// trailing `+` icon button.
class _CategoriesHeader extends StatelessWidget {
  const _CategoriesHeader({
    required this.title,
    required this.onCreate,
    this.totalCount,
  });

  final String title;
  final int? totalCount;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final l = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 16, 18),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.8,
                  ),
                ),
                if (totalCount != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    l.categoryTotalCount(totalCount!),
                    style: TextStyle(fontSize: 13, color: c.textMuted),
                  ),
                ],
              ],
            ),
          ),
          KIconBtn(
            icon: const Icon(TablerIcons.plus),
            tooltip: l.categoryCreateTitle,
            onPressed: onCreate,
          ),
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
///
/// Converted to [ConsumerWidget] so it can read providers for the kebab /
/// long-press action flows (edit, add-subcategory, delete).
class _CategoryCardItem extends ConsumerWidget {
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

  Future<void> _onMenu(BuildContext context, WidgetRef ref) async {
    final canAdd = (int.tryParse(category.layer ?? '1') ?? 1) < 5;
    final action = await showCategoryActionMenu(
      context: context,
      category: category,
      canAddSubcategory: canAdd,
    );
    if (action == null || !context.mounted) return;
    final l = AppLocalizations.of(context);
    switch (action) {
      case CategoryAction.edit:
        final saved = await showCreateEditCategorySheet(
          context: context,
          mode: EditCategory(category: category),
        );
        if ((saved ?? false) && context.mounted) {
          KNotify.success(context, l.categoryNotifySaved);
        }
      case CategoryAction.addSubcategory:
        final saved = await showCreateEditCategorySheet(
          context: context,
          mode: CreateNested(
            parentId: category.categoryId!,
            parentName: category.name ?? '',
            parentLayer: category.layer ?? '1',
          ),
        );
        if ((saved ?? false) && context.mounted) {
          KNotify.success(context, l.categoryNotifySaved);
        }
      case CategoryAction.delete:
        await _confirmAndDelete(context, ref);
    }
  }

  Future<void> _confirmAndDelete(BuildContext context, WidgetRef ref) async {
    final l = AppLocalizations.of(context);
    ApiException? failure;
    final confirmed = await showKConfirmDialog(
      context: context,
      title: l.categoryDeleteConfirmTitle,
      subtitle: l.categoryDeleteConfirmBody(category.name ?? ''),
      confirmLabel: l.categoryDeleteConfirmCta,
      onConfirm: () async {
        final result = await ref.read(categoryRepositoryProvider).remove([
          category.categoryId!,
        ]);
        if (result is ApiFailure<void>) {
          failure = result.err;
          throw result.err; // closes the dialog with null
        }
      },
    );
    if (!context.mounted) return;
    if (confirmed ?? false) {
      ref
        ..invalidate(categoryOverviewProvider)
        ..invalidate(categoryByIdProvider(category.categoryId!));
      const nilUuid = '00000000-0000-0000-0000-000000000000';
      final parentId = category.parentId;
      if (parentId != null && parentId != nilUuid) {
        ref.invalidate(categoryByIdProvider(parentId));
      }
      KNotify.success(context, l.categoryNotifyDeleted);
    } else if (failure != null) {
      // Surface the BE-rejected reason verbatim (e.g. "category has children").
      final msg = failure is BadRequestException
          ? (failure! as BadRequestException).message
          : l.categoryNotifyServer;
      KNotify.warning(context, msg);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onLongPress: () => _onMenu(context, ref),
      child: KCategoryCard(
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
          onPressed: () => _onMenu(context, ref),
        ),
        onTap: onTap,
      ),
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

/// Catalog tab modes: Main = layer-1 roots, Sub = everything below.
///
/// Replaces the legacy 6-tab "All / Cấp 1..5" layer filter with a binary
/// segmented control. Sub tab groups children by their direct parent to
/// preserve hierarchy context (per UX redesign).
enum _CategoryTab { main, sub }

/// Two-tab segmented control (Chính / Con). Active tab has a solid
/// accent pill background + white label + opaque count chip; inactive
/// has muted text and subtle count. Fits in fixed width — no horizontal
/// scrolling, unlike the old layer filter row.
class _CategoryTabBar extends StatelessWidget {
  const _CategoryTabBar({
    required this.active,
    required this.mainCount,
    required this.subCount,
    required this.onChange,
  });

  final _CategoryTab active;
  final int mainCount;
  final int subCount;
  final ValueChanged<_CategoryTab> onChange;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final l = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: c.surfaceElev,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          children: [
            Expanded(
              child: _CategoryTabChip(
                label: l.categoryTabMain,
                count: mainCount,
                isActive: active == _CategoryTab.main,
                onTap: () => onChange(_CategoryTab.main),
              ),
            ),
            Expanded(
              child: _CategoryTabChip(
                label: l.categoryTabSub,
                count: subCount,
                isActive: active == _CategoryTab.sub,
                onTap: () => onChange(_CategoryTab.sub),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryTabChip extends StatelessWidget {
  const _CategoryTabChip({
    required this.label,
    required this.count,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final int count;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    const dur = Duration(milliseconds: 220);
    const curve = Curves.easeOutCubic;
    return AnimatedContainer(
      duration: dur,
      curve: curve,
      decoration: BoxDecoration(
        color: isActive ? c.accent600 : Colors.transparent,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(999),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(999),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedDefaultTextStyle(
                  duration: dur,
                  curve: curve,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isActive ? Colors.white : c.textMuted,
                  ),
                  child: Text(label),
                ),
                const SizedBox(width: 6),
                AnimatedContainer(
                  duration: dur,
                  curve: curve,
                  decoration: BoxDecoration(
                    color: isActive
                        ? Colors.white.withValues(alpha: 0.18)
                        : c.surfaceHover,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 1,
                  ),
                  child: AnimatedDefaultTextStyle(
                    duration: dur,
                    curve: curve,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isActive ? Colors.white : c.textMuted,
                    ),
                    child: Text('$count'),
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

/// Main-tab list: flat layer-1 roots only. Filtered by search.
class _MainTabList extends StatelessWidget {
  const _MainTabList({
    required this.categories,
    required this.searchQuery,
    super.key,
  });

  final List<gen.CategoryResponse> categories;
  final String searchQuery;

  @override
  Widget build(BuildContext context) {
    final q = normalizeForSearch(searchQuery);
    final filtered = q.isEmpty
        ? categories
        : categories
              .where((c) => normalizeForSearch(c.name ?? '').contains(q))
              .toList();
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: filtered.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (ctx, i) => _CategoryCardItem(
        category: filtered[i],
        onTap: () =>
            context.go('/catalog/categories/${filtered[i].categoryId}'),
      ),
    );
  }
}

/// Sub-tab list: every non-root category grouped under its direct parent.
///
/// Each group has a header (color dot + parent name) followed by the
/// direct children as standard category cards. Preserves hierarchy
/// context that a flat sub-list would destroy ("Polo Nữ" sitting next
/// to "Jeans Nam" with no parent in sight).
class _SubTabGroupedList extends StatelessWidget {
  const _SubTabGroupedList({
    required this.allCategories,
    required this.subCategories,
    required this.searchQuery,
    super.key,
  });

  final List<gen.CategoryResponse> allCategories;
  final List<gen.CategoryResponse> subCategories;
  final String searchQuery;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final q = normalizeForSearch(searchQuery);
    final visible = q.isEmpty
        ? subCategories
        : subCategories
              .where((c) => normalizeForSearch(c.name ?? '').contains(q))
              .toList();
    if (visible.isEmpty) {
      return KEmptyState(
        icon: TablerIcons.search,
        title: l.categoryEmptyTitle,
        subtitle: l.categoryEmptyBody,
      );
    }

    final byId = <String, gen.CategoryResponse>{
      for (final c in allCategories)
        if (c.categoryId != null) c.categoryId!: c,
    };

    final byParent = <String, List<gen.CategoryResponse>>{};
    for (final child in visible) {
      final pid = child.parentId;
      if (pid == null) continue;
      byParent.putIfAbsent(pid, () => []).add(child);
    }
    final groups =
        byParent.entries
            .map(
              (e) => _SubGroup(
                parent: byId[e.key],
                parentId: e.key,
                children: e.value,
              ),
            )
            .where((g) => g.parent != null)
            .toList()
          ..sort(
            (a, b) => (a.parent!.name ?? '').compareTo(b.parent!.name ?? ''),
          );

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: groups.length,
      itemBuilder: (ctx, i) {
        final g = groups[i];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _SubGroupHeader(parent: g.parent!),
              const SizedBox(height: 8),
              for (var j = 0; j < g.children.length; j++) ...[
                _CategoryCardItem(
                  category: g.children[j],
                  onTap: () => context.go(
                    '/catalog/categories/${g.children[j].categoryId}',
                  ),
                ),
                if (j < g.children.length - 1) const SizedBox(height: 12),
              ],
            ],
          ),
        );
      },
    );
  }
}

@immutable
class _SubGroup {
  const _SubGroup({
    required this.parent,
    required this.parentId,
    required this.children,
  });

  final gen.CategoryResponse? parent;
  final String parentId;
  final List<gen.CategoryResponse> children;
}

/// Parent group header — small colored dot + parent name. Sits above its
/// child cards in [_SubTabGroupedList]. Uses the parent's `colorSettings`
/// for the dot (falls back to slate-400) so users can spot a group at a
/// glance.
class _SubGroupHeader extends StatelessWidget {
  const _SubGroupHeader({required this.parent});

  final gen.CategoryResponse parent;

  Color _dotColor() {
    final id = parent.colorSettings;
    if (id == null || id.isEmpty) return kAllColors.first.swatch;
    return kAllColors
        .firstWhere((co) => co.id == id, orElse: () => kAllColors.first)
        .swatch;
  }

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: _dotColor(),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            parent.name ?? '',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: c.textMuted,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
