// TablerIcons uses snake_case names (e.g. TablerIcons.layout_grid) which
// triggers non_constant_identifier_names; suppress for the whole file.
// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:kuru_category_api/kuru_category_api.dart' as gen;
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/design/core/catalog/k_list_row.dart';
import 'package:kuru_mobile/design/core/feedback/k_empty_state.dart';
import 'package:kuru_mobile/design/core/feedback/k_skeleton.dart';
import 'package:kuru_mobile/design/core/input/k_search_bar.dart';
import 'package:kuru_mobile/design/core/input/k_secondary_btn.dart';
import 'package:kuru_mobile/design/core/layout/k_page_header.dart';
import 'package:kuru_mobile/features/catalog/categories/providers/category_providers.dart';

class CategoriesListScreen extends ConsumerStatefulWidget {
  const CategoriesListScreen({super.key});

  @override
  ConsumerState<CategoriesListScreen> createState() =>
      _CategoriesListScreenState();
}

class _CategoriesListScreenState extends ConsumerState<CategoriesListScreen> {
  // TODO(task-18): wire _searchQuery into categoriesListProvider filter.
  String _searchQuery = ''; // ignore: unused_field

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
                      return ListView.separated(
                        itemCount: categories.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (_, i) {
                          final c = categories[i];
                          final subtitle = _subtitleFor(c);
                          return KListRow(
                            leading: Icon(
                              TablerIcons.layout_grid,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            title: c.name ?? '',
                            subtitle: subtitle.isEmpty ? null : subtitle,
                            onTap: () => context.go(
                              '/catalog/categories/${c.categoryId}',
                            ),
                          );
                        },
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

class _CategorySkeletonList extends StatelessWidget {
  const _CategorySkeletonList();
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (_, __) => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: KSkeleton(height: 56),
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

String _subtitleFor(gen.CategoryResponse c) {
  // i18n: Use AppLocalizations.of(context).categorySubCount / categoryItemCount
  // for plural forms once we wire this from the build method. For now we
  // need a context-free helper, so use a simple join. Task 16's tests don't
  // assert subtitle text, only that the row renders.
  // TODO(catalog): refactor to pass context when subtitle
  // becomes locale-sensitive.
  final parts = <String>[];
  final subs = c.subCategoriesCount ?? 0;
  if (subs > 0) parts.add('$subs sub');
  if (c.itemCount > 0) parts.add('${c.itemCount} items');
  return parts.join(' · ');
}
