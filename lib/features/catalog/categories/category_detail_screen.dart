// TablerIcons uses snake_case names.
// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:kuru_category_api/kuru_category_api.dart' as gen;
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/design/core/catalog/k_list_row.dart';
import 'package:kuru_mobile/design/core/feedback/k_empty_state.dart';
import 'package:kuru_mobile/design/core/feedback/k_skeleton.dart';
import 'package:kuru_mobile/design/core/input/k_secondary_btn.dart';
import 'package:kuru_mobile/design/core/modal/color_options.dart';
import 'package:kuru_mobile/design/core/modal/icon_mapping.dart';
import 'package:kuru_mobile/features/catalog/categories/providers/category_providers.dart';
import 'package:kuru_mobile/features/catalog/categories/widgets/create_edit_category_sheet.dart';

class CategoryDetailScreen extends ConsumerWidget {
  const CategoryDetailScreen({required this.categoryId, super.key});
  final String categoryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final root = ref.watch(categoryByIdProvider(categoryId));
    final overview = ref.watch(categoryOverviewProvider);
    return Scaffold(
      appBar: AppBar(),
      body: root.when(
        loading: () => const _DetailSkeleton(),
        error: (_, __) => KEmptyState(
          icon: TablerIcons.alert_triangle,
          title: l.categoryLoadError,
          action: KSecondaryBtn(
            onPressed: () => ref.invalidate(categoryByIdProvider(categoryId)),
            label: l.categoryLoadRetry,
            fullWidth: false,
          ),
        ),
        data: (cat) =>
            _DetailBody(root: cat, allCategories: overview.value ?? const []),
      ),
    );
  }
}

class _DetailBody extends ConsumerWidget {
  const _DetailBody({required this.root, required this.allCategories});

  final gen.CategoryResponse root;
  final List<gen.CategoryResponse> allCategories;

  Color _bg() {
    for (final co in kAllColors) {
      if (co.id == root.colorSettings) return co.swatch;
    }
    return kAllColors.first.swatch;
  }

  IconData _icon() {
    final n = root.icon;
    if (n == null || n.isEmpty) return TablerIcons.layout_grid;
    return resolveIconName(n) ?? TablerIcons.layout_grid;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = kuruColors(context);
    final l = AppLocalizations.of(context);
    final children = allCategories
        .where((cat) => cat.parentId == root.categoryId)
        .toList();
    final canAdd = (int.tryParse(root.layer ?? '1') ?? 1) < 5;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Header card.
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: c.surfaceElev,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: c.border),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(color: _bg(), shape: BoxShape.circle),
                child: Icon(_icon(), color: Colors.white, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      root.name ?? '',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: c.textPrimary,
                      ),
                    ),
                    if ((root.description ?? '').isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          root.description!,
                          style: TextStyle(
                            fontSize: 13,
                            color: c.textSecondary,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: KSecondaryBtn(
                onPressed: () async {
                  await showCreateEditCategorySheet(
                    context: context,
                    mode: EditCategory(category: root),
                  );
                },
                label: l.categoryActionEdit,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: KSecondaryBtn(
                onPressed: canAdd
                    ? () async {
                        await showCreateEditCategorySheet(
                          context: context,
                          mode: CreateNested(
                            parentId: root.categoryId!,
                            parentName: root.name ?? '',
                            parentLayer: root.layer ?? '1',
                          ),
                        );
                      }
                    : null,
                label: l.categoryActionAddSubcategory,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          children.isEmpty
              ? l.categoryDetailNoSubcategories
              : l.categoryDetailSubcategoriesHeader(children.length),
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: c.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        for (final child in children) ...[
          KListRow(
            leading: const Icon(TablerIcons.layout_grid),
            title: child.name ?? '',
            trailing: const Icon(TablerIcons.chevron_right),
            onTap: () => context.go('/catalog/categories/${child.categoryId}'),
          ),
          const SizedBox(height: 8),
        ],
      ],
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
          KSkeleton(height: 80),
          SizedBox(height: 12),
          KSkeleton(height: 44),
          SizedBox(height: 20),
          KSkeleton(height: 48),
          SizedBox(height: 8),
          KSkeleton(height: 48),
        ],
      ),
    );
  }
}
