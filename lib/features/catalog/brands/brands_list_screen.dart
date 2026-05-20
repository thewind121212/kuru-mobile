import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:kuru_brand_api/kuru_brand_api.dart' as gen;
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/core/network/api_exception.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/core/text/search_normalize.dart';
import 'package:kuru_mobile/design/core/feedback/k_empty_state.dart';
import 'package:kuru_mobile/design/core/feedback/k_skeleton.dart';
import 'package:kuru_mobile/design/core/input/k_icon_btn.dart';
import 'package:kuru_mobile/design/core/input/k_search_bar.dart';
import 'package:kuru_mobile/design/core/input/k_secondary_btn.dart';
import 'package:kuru_mobile/design/core/modal/color_options.dart';
import 'package:kuru_mobile/design/core/modal/k_confirm_dialog.dart';
import 'package:kuru_mobile/features/catalog/brands/providers/brand_providers.dart';
import 'package:kuru_mobile/features/catalog/brands/widgets/brand_action_menu.dart';
import 'package:kuru_mobile/features/catalog/brands/widgets/create_edit_brand_sheet.dart';

class BrandsListScreen extends ConsumerStatefulWidget {
  const BrandsListScreen({super.key});

  @override
  ConsumerState<BrandsListScreen> createState() => _BrandsListScreenState();
}

class _BrandsListScreenState extends ConsumerState<BrandsListScreen> {
  String _query = '';

  Future<void> _openCreate() async {
    final l = AppLocalizations.of(context);
    final saved = await showCreateEditBrandSheet(
      context: context,
      mode: const CreateBrand(),
    );
    if (!mounted) return;
    if (saved ?? false) {
      ref.invalidate(brandOverviewProvider);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l.brandNotifySaved)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final overview = ref.watch(brandOverviewProvider);
    final total = overview.maybeWhen(data: (b) => b.length, orElse: () => null);

    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        behavior: HitTestBehavior.opaque,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _BrandsHeader(
                title: l.brandTitle,
                totalCount: total,
                onCreate: _openCreate,
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: KSearchBar(
                  hint: l.brandSearchHint,
                  onChanged: (q) => setState(() => _query = q),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: overview.when(
                  loading: () => const _SkeletonList(),
                  error: (e, _) => _ErrorState(
                    onRetry: () => ref.invalidate(brandOverviewProvider),
                  ),
                  data: (brands) => brands.isEmpty
                      ? _Empty(onCreate: _openCreate)
                      : _List(brands: brands, query: _query),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BrandsHeader extends StatelessWidget {
  const _BrandsHeader({
    required this.title,
    required this.onCreate,
    this.totalCount,
  });
  final String title;
  final int? totalCount;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final l = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: t.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              if (totalCount != null) ...[
                const SizedBox(height: 2),
                Text(
                  l.brandTotalCount(totalCount!),
                  textAlign: TextAlign.center,
                  style: t.bodySmall?.copyWith(
                    color: t.bodySmall?.color?.withValues(alpha: 0.65),
                  ),
                ),
              ],
            ],
          ),
          Positioned(
            right: 0,
            child: KIconBtn(
              icon: const Icon(TablerIcons.plus),
              tooltip: l.brandCreateTitle,
              onPressed: onCreate,
            ),
          ),
        ],
      ),
    );
  }
}

class _List extends ConsumerWidget {
  const _List({required this.brands, required this.query});
  final List<gen.BrandOverviewItem> brands;
  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final q = normalizeForSearch(query);
    final visible = q.isEmpty
        ? brands
        : brands.where((b) => normalizeForSearch(b.name).contains(q)).toList();
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: visible.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) => _BrandCardItem(brand: visible[i]),
    );
  }
}

class _BrandCardItem extends ConsumerWidget {
  const _BrandCardItem({required this.brand});
  final gen.BrandOverviewItem brand;

  Future<void> _onMenu(BuildContext context, WidgetRef ref) async {
    final action = await showBrandActionMenu(
      context: context,
      brandName: brand.name,
    );
    if (action == null || !context.mounted) return;
    final l = AppLocalizations.of(context);
    switch (action) {
      case BrandAction.edit:
        final saved = await showCreateEditBrandSheet(
          context: context,
          mode: EditBrand(brand: brand),
        );
        if ((saved ?? false) && context.mounted) {
          ref.invalidate(brandOverviewProvider);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l.brandNotifySaved)));
        }
      case BrandAction.delete:
        await _confirmAndDelete(context, ref);
    }
  }

  Future<void> _confirmAndDelete(BuildContext context, WidgetRef ref) async {
    final l = AppLocalizations.of(context);
    ApiException? failure;
    final confirmed = await showKConfirmDialog(
      context: context,
      title: l.brandDeleteConfirmTitle,
      subtitle: l.brandDeleteConfirmBody(brand.name),
      confirmLabel: l.brandDeleteConfirmCta,
      onConfirm: () async {
        final result = await ref.read(brandRepositoryProvider).remove(brand.id);
        if (result is ApiFailure<void>) {
          failure = result.err;
          throw result.err; // closes the dialog with null
        }
      },
    );
    if (!context.mounted) return;
    if (confirmed ?? false) {
      ref.invalidate(brandOverviewProvider);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l.brandNotifyDeleted)));
    } else if (failure != null) {
      final msg = failure is BadRequestException
          ? (failure! as BadRequestException).message
          : l.brandNotifyServer;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  Future<void> _onTap(BuildContext context, WidgetRef ref) async {
    final l = AppLocalizations.of(context);
    final saved = await showCreateEditBrandSheet(
      context: context,
      mode: EditBrand(brand: brand),
    );
    if ((saved ?? false) && context.mounted) {
      ref.invalidate(brandOverviewProvider);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l.brandNotifySaved)));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = kuruColors(context);
    final l = AppLocalizations.of(context);
    final name = brand.name;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onLongPress: () => _onMenu(context, ref),
      onTap: () => _onTap(context, ref),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: c.surfaceElev,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: c.border),
        ),
        child: Row(
          children: [
            _InitialChip(name: name),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l.brandStatProducts(brand.productCount),
                    style: TextStyle(fontSize: 12, color: c.textMuted),
                  ),
                ],
              ),
            ),
            KIconBtn(
              icon: const Icon(TablerIcons.dots_vertical),
              size: 32,
              onPressed: () => _onMenu(context, ref),
            ),
          ],
        ),
      ),
    );
  }
}

class _InitialChip extends StatelessWidget {
  const _InitialChip({required this.name});
  final String name;

  Color _bg() {
    if (name.isEmpty) return kAllColors.first.swatch;
    final idx = name.hashCode.abs() % kAllColors.length;
    return kAllColors[idx].swatch;
  }

  String _letter() => name.isEmpty ? '?' : name.characters.first.toUpperCase();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: _bg(),
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      child: Text(
        _letter(),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: 16,
        ),
      ),
    );
  }
}

class _SkeletonList extends StatelessWidget {
  const _SkeletonList();
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      itemCount: 4,
      itemBuilder: (_, __) => const Padding(
        padding: EdgeInsets.symmetric(vertical: 6),
        child: KSkeleton(height: 80),
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty({required this.onCreate});
  final VoidCallback onCreate;
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return KEmptyState(
      icon: TablerIcons.shopping_bag,
      title: l.brandEmptyTitle,
      subtitle: l.brandEmptyBody,
      action: KSecondaryBtn(
        onPressed: onCreate,
        label: l.brandEmptyAction,
        fullWidth: false,
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.onRetry});
  final VoidCallback onRetry;
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return KEmptyState(
      icon: TablerIcons.alert_triangle,
      title: l.brandLoadError,
      action: KSecondaryBtn(
        onPressed: onRetry,
        label: l.brandLoadRetry,
        fullWidth: false,
      ),
    );
  }
}
