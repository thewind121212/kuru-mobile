// TablerIcons uses snake_case names.
// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:kuru_category_api/kuru_category_api.dart' as gen;
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/design/core/feedback/k_empty_state.dart';
import 'package:kuru_mobile/design/core/feedback/k_skeleton.dart';
import 'package:kuru_mobile/design/core/input/k_secondary_btn.dart';
import 'package:kuru_mobile/features/catalog/categories/providers/category_providers.dart';
import 'package:kuru_mobile/features/catalog/categories/widgets/category_tree.dart';

const _nilUuid = '00000000-0000-0000-0000-000000000000';

/// Walks up the parent chain from [fromId] to the top-most ancestor.
///
/// Mirrors kuru-web's `selectedRootCategoryId` derivation in
/// `NestedCategoriesView`: the detail screen always renders the subtree
/// starting from the focused category's root, with the focused row
/// auto-expanded via [CategoryTree]'s ancestor-path logic.
String _topAncestorId(List<gen.CategoryResponse> all, String fromId) {
  final byId = <String, gen.CategoryResponse>{
    for (final c in all)
      if (c.categoryId != null) c.categoryId!: c,
  };
  var cur = fromId;
  while (true) {
    final parent = byId[cur]?.parentId;
    if (parent == null || parent == _nilUuid || !byId.containsKey(parent)) {
      return cur;
    }
    cur = parent;
  }
}

/// Per-category detail screen.
///
/// Renders the full category tree (every root + descendants) with the
/// tapped category highlighted via [CategoryTree.focusedId]. The
/// ancestor path is auto-expanded so the focused row is visible without
/// scrolling. Edit / Add subcategory / Delete are reachable via the
/// focused row's kebab menu — same affordance every other tree node
/// has, no duplicate header card.
class CategoryDetailScreen extends ConsumerWidget {
  const CategoryDetailScreen({required this.categoryId, super.key});
  final String categoryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final overview = ref.watch(categoryOverviewProvider);
    // Resolve the focused category's name (if loaded) for the AppBar title.
    final focused = overview.value
        ?.where((c) => c.categoryId == categoryId)
        .firstOrNull;
    return Scaffold(
      appBar: AppBar(title: Text(focused?.name ?? '')),
      body: overview.when(
        loading: () => const _DetailSkeleton(),
        error: (_, __) => KEmptyState(
          icon: TablerIcons.alert_triangle,
          title: l.categoryLoadError,
          action: KSecondaryBtn(
            onPressed: () => ref.invalidate(categoryOverviewProvider),
            label: l.categoryLoadRetry,
            fullWidth: false,
          ),
        ),
        data: (allCategories) {
          final rootId = _topAncestorId(allCategories, categoryId);
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              CategoryTree(
                allCategories: allCategories,
                rootId: rootId,
                focusedId: categoryId,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _DetailSkeleton extends StatelessWidget {
  const _DetailSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          KSkeleton(height: 48),
          SizedBox(height: 6),
          KSkeleton(height: 48),
          SizedBox(height: 6),
          KSkeleton(height: 48),
          SizedBox(height: 6),
          KSkeleton(height: 48),
        ],
      ),
    );
  }
}

extension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
