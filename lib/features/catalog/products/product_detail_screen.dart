import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
import 'package:kuru_mobile/core/env/env.dart';
import 'package:kuru_mobile/core/feedback/k_notify.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/design/core/catalog/k_settings_row.dart';
import 'package:kuru_mobile/design/core/layout/k_settings_section.dart';
import 'package:kuru_mobile/design/core/modal/k_action_sheet.dart';
import 'package:kuru_mobile/features/catalog/categories/providers/category_providers.dart';
import 'package:kuru_mobile/features/catalog/products/data/uoms.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_detail.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_status.dart';
import 'package:kuru_mobile/features/catalog/products/models/update_product_info_body.dart';
import 'package:kuru_mobile/features/catalog/products/providers/product_providers.dart';
import 'package:kuru_mobile/features/catalog/products/widgets/product_archive_dialog.dart';
import 'package:kuru_mobile/features/catalog/products/widgets/product_status_badge.dart';

final _vnd = NumberFormat.currency(
  locale: 'vi_VN',
  symbol: 'đ',
  decimalDigits: 0,
);

/// Pushed detail screen for a single product — hero image + 5 grouped
/// info sections (Phân loại / Giá / Tồn kho / Thống kê / Mô tả).
///
/// Action menu (edit / archive) is gated by `canWriteProductsProvider`.
class ProductDetailScreen extends ConsumerWidget {
  const ProductDetailScreen({required this.productId, super.key});

  final String productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = kuruColors(context);
    final async = ref.watch(productByIdProvider(productId));
    final canWrite = ref.watch(canWriteProductsProvider);

    return Scaffold(
      backgroundColor: c.pageBg,
      appBar: AppBar(
        backgroundColor: c.pageBg,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(
          async.maybeWhen(data: (p) => p.name, orElse: () => 'Sản phẩm'),
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: c.textPrimary,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          if (canWrite)
            IconButton(
              tooltip: 'Tác vụ',
              icon: const Icon(TablerIcons.dots_vertical),
              // Only enabled once the detail has loaded — the action sheet
              // needs a resolved [ProductDetail] to hand to the edit sheet.
              onPressed: async.maybeWhen(
                data: (p) =>
                    () => _openActionMenu(context, ref, p),
                orElse: () => null,
              ),
            ),
        ],
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Không tải được: $e')),
        data: (p) => _Body(detail: p),
      ),
    );
  }

  Future<void> _openActionMenu(
    BuildContext context,
    WidgetRef ref,
    ProductDetail detail,
  ) async {
    final picked = await showKActionSheet<String>(
      context: context,
      title: 'Tác vụ',
      actions: [
        const KActionItem(
          id: 'edit',
          label: 'Sửa thông tin',
          icon: TablerIcons.pencil,
        ),
        if (detail.status == ProductStatus.archived)
          const KActionItem(
            id: 'reactivate',
            label: 'Buôn bán lại',
            icon: TablerIcons.refresh,
          ),
        const KActionItem(
          id: 'archive',
          label: 'Ngừng kinh doanh',
          icon: TablerIcons.archive,
          danger: true,
        ),
      ],
    );
    if (picked == null || !context.mounted) return;
    switch (picked) {
      case 'edit':
        await context.push(
          '/catalog/products/${detail.id}/edit',
          extra: detail,
        );
      case 'reactivate':
        final repo = ref.read(productRepositoryProvider);
        final result = await repo.updateInfo(
          UpdateProductInfoBody(productId: detail.id, status: 'ACTIVE'),
        );
        if (!context.mounted) return;
        switch (result) {
          case ApiSuccess():
            KNotify.success(context, 'Đã mở bán lại');
            ref.invalidate(productByIdProvider(detail.id));
            ref.invalidate(productListProvider);
          case ApiFailure(:final err):
            KNotify.warning(context, err.message);
        }
      case 'archive':
        final ok = await showProductArchiveDialog(
          context,
          productId: productId,
        );
        if ((ok ?? false) && context.mounted) context.pop();
    }
  }
}

class _Body extends ConsumerWidget {
  const _Body({required this.detail});

  final ProductDetail detail;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = kuruColors(context);
    final unitLabel =
        detail.baseUnitLabel ?? resolveUomLabel(detail.baseUnitCode);
    // Only read categoryOverviewProvider when we actually have a category
    // to resolve — keeps the screen testable without overriding the category
    // provider when a product has no categoryId.
    String? catName;
    if (detail.categoryId != null) {
      final cats = ref.watch(categoryOverviewProvider).valueOrNull ?? const [];
      for (final cat in cats) {
        if (cat.categoryId == detail.categoryId) {
          catName = cat.name;
          break;
        }
      }
    }

    String fmtPrice(num? v) => v == null ? '—' : _vnd.format(v);
    String fmtQty(num v) => '${v.toInt()} $unitLabel';

    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 12, bottom: 96),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _Hero(detail: detail),
          ),
          const SizedBox(height: 20),
          KSettingsSection(
            header: 'Phân loại',
            children: [
              KSettingsRow(
                leadingIcon: TablerIcons.folder,
                iconBackground: const Color(0xFFF1ECFB),
                iconColor: const Color(0xFF8B5CF6),
                label: 'Danh mục',
                trailingText: catName ?? '—',
                showChevron: false,
              ),
              KSettingsRow(
                leadingIcon: TablerIcons.tag,
                iconBackground: const Color(0xFFE7F1FB),
                iconColor: const Color(0xFF3B82F6),
                label: 'Thương hiệu',
                trailingText: detail.brandName ?? '—',
                showChevron: false,
              ),
              KSettingsRow(
                leadingIcon: TablerIcons.scale,
                iconBackground: const Color(0xFFEFF1F4),
                iconColor: const Color(0xFF64748B),
                label: 'Đơn vị',
                trailingText: unitLabel,
                showChevron: false,
              ),
            ],
          ),
          const SizedBox(height: 20),
          KSettingsSection(
            header: 'Giá',
            children: [
              KSettingsRow(
                leadingIcon: TablerIcons.coin,
                iconBackground: const Color(0xFFE6F7F0),
                iconColor: const Color(0xFF10B981),
                label: 'Giá bán',
                trailingText: _vnd.format(detail.sellPrice),
                showChevron: false,
              ),
              KSettingsRow(
                leadingIcon: TablerIcons.arrow_down_circle,
                iconBackground: const Color(0xFFE7F1FB),
                iconColor: const Color(0xFF3B82F6),
                label: 'Giá nhập',
                trailingText: fmtPrice(detail.importPrice),
                showChevron: false,
              ),
              KSettingsRow(
                leadingIcon: TablerIcons.arrow_up_circle,
                iconBackground: const Color(0xFFFEF6E5),
                iconColor: const Color(0xFFD97706),
                label: 'Giá xuất',
                trailingText: fmtPrice(detail.exportPrice),
                showChevron: false,
              ),
            ],
          ),
          const SizedBox(height: 20),
          KSettingsSection(
            header: 'Tồn kho',
            children: [
              KSettingsRow(
                leadingIcon: TablerIcons.alert_triangle,
                iconBackground: const Color(0xFFFEF6E5),
                iconColor: const Color(0xFFD97706),
                label: 'Tồn tối thiểu',
                trailingText: detail.demandStock > 0
                    ? fmtQty(detail.demandStock)
                    : '—',
                showChevron: false,
              ),
            ],
          ),
          const SizedBox(height: 20),
          KSettingsSection(
            header: 'Thống kê',
            children: [
              KSettingsRow(
                leadingIcon: TablerIcons.chart_bar,
                iconBackground: const Color(0xFFF1ECFB),
                iconColor: const Color(0xFF8B5CF6),
                label: 'Giá vốn trung bình',
                trailingText: _vnd.format(detail.avgCost),
                showChevron: false,
              ),
              KSettingsRow(
                leadingIcon: TablerIcons.package,
                iconBackground: const Color(0xFFE7F1FB),
                iconColor: const Color(0xFF3B82F6),
                label: 'Đã nhập tổng',
                trailingText: fmtQty(detail.totalQtyImported),
                showChevron: false,
              ),
              KSettingsRow(
                leadingIcon: TablerIcons.cash,
                iconBackground: const Color(0xFFE6F7F0),
                iconColor: const Color(0xFF10B981),
                label: 'Giá trị tồn kho',
                trailingText: _vnd.format(detail.totalCostValue),
                showChevron: false,
              ),
            ],
          ),
          if (detail.description != null && detail.description!.isNotEmpty) ...[
            const SizedBox(height: 20),
            KSettingsSection(
              header: 'Mô tả',
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                  child: Text(
                    detail.description!,
                    style: TextStyle(fontSize: 14, color: c.textPrimary),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({required this.detail});

  final ProductDetail detail;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final imageUrl = detail.hasImage
        ? '${Env.imageBaseUrl}/product-avatar/${detail.imageUrl}'
        : null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          button: imageUrl != null,
          label: imageUrl == null ? null : 'Xem ảnh sản phẩm',
          child: GestureDetector(
            key: const ValueKey('product-detail-image'),
            onTap: imageUrl == null
                ? null
                : () => _showProductImageViewer(context, detail.name, imageUrl),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: SizedBox(
                height: 220,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (imageUrl == null)
                      _placeholder()
                    else
                      Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _placeholder(),
                      ),
                    if (imageUrl != null)
                      Positioned(
                        right: 10,
                        bottom: 10,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.54),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(8),
                            child: Icon(
                              TablerIcons.arrows_maximize,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          detail.name,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: c.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        ProductStatusBadge(status: detail.status),
      ],
    );
  }

  Widget _placeholder() => const ColoredBox(
    color: Color(0xFFEFF1F4),
    child: Center(
      child: Icon(TablerIcons.package, size: 64, color: Color(0xFF94A3B8)),
    ),
  );

  Future<void> _showProductImageViewer(
    BuildContext context,
    String title,
    String imageUrl,
  ) {
    return showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.92),
      builder: (context) => Dialog.fullscreen(
        key: const ValueKey('product-image-viewer'),
        backgroundColor: Colors.black,
        child: SafeArea(
          child: Stack(
            children: [
              Center(
                child: InteractiveViewer(
                  minScale: 1,
                  maxScale: 4,
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Icon(
                      TablerIcons.photo_off,
                      color: Colors.white54,
                      size: 56,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 10,
                left: 16,
                right: 64,
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Positioned(
                top: 4,
                right: 8,
                child: IconButton.filled(
                  tooltip: 'Đóng ảnh',
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(TablerIcons.x),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white.withValues(alpha: 0.14),
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
