// TablerIcons uses snake_case names.
// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:kuru_category_api/kuru_category_api.dart' as gen;
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
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

class CategoryDetailScreen extends ConsumerWidget {
  const CategoryDetailScreen({required this.categoryId, super.key});
  final String categoryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = kuruColors(context);
    final l = AppLocalizations.of(context);
    final overview = ref.watch(categoryOverviewProvider);
    final focused = overview.value
        ?.where((c) => c.categoryId == categoryId)
        .firstOrNull;
    return Scaffold(
      backgroundColor: c.pageBg,
      appBar: AppBar(
        backgroundColor: c.pageBg,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: const BackButton(),
      ),
      body: SafeArea(
        top: false,
        child: overview.when(
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
              padding: const EdgeInsets.only(bottom: 32),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 4, 24, 18),
                  child: Text(
                    focused?.name ?? '',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.8,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: CategoryTree(
                    allCategories: allCategories,
                    rootId: rootId,
                    focusedId: categoryId,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _DetailSkeleton extends StatelessWidget {
  const _DetailSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 32),
      children: const [
        Padding(
          padding: EdgeInsets.fromLTRB(24, 4, 24, 18),
          child: SizedBox(height: 40, child: KSkeleton(height: 40)),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              KSkeleton(height: 56),
              SizedBox(height: 8),
              KSkeleton(height: 56),
              SizedBox(height: 8),
              KSkeleton(height: 56),
              SizedBox(height: 8),
              KSkeleton(height: 56),
            ],
          ),
        ),
      ],
    );
  }
}

extension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
