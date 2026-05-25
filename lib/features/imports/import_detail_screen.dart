// flutter_tabler_icons uses snake_case symbols.
// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
import 'package:kuru_mobile/core/env/env.dart';
import 'package:kuru_mobile/features/catalog/products/providers/product_providers.dart';
import 'package:kuru_mobile/features/imports/models/purchase_entry.dart';
import 'package:kuru_mobile/features/imports/models/purchase_entry_status.dart';
import 'package:kuru_mobile/features/imports/providers/purchase_providers.dart';

final _money = NumberFormat.currency(
  locale: 'vi_VN',
  symbol: 'đ',
  decimalDigits: 0,
);
final _qty = NumberFormat.decimalPattern('vi_VN');
final _date = DateFormat('dd/MM/yyyy HH:mm');

class ImportDetailScreen extends ConsumerWidget {
  const ImportDetailScreen({required this.entryId, super.key});

  final String entryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = kuruColors(context);
    final async = ref.watch(purchaseEntryDetailProvider(entryId));
    return Scaffold(
      backgroundColor: c.pageBg,
      appBar: AppBar(
        backgroundColor: c.pageBg,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(
          async.maybeWhen(
            data: (entry) => entry.entryNumber,
            orElse: () => 'Chi tiết nhập hàng',
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: c.textPrimary,
            fontSize: 17,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _ImportDetailError(
          message: '$error',
          onRetry: () => ref.invalidate(purchaseEntryDetailProvider(entryId)),
        ),
        data: (entry) => RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(purchaseEntryDetailProvider(entryId));
            await ref.read(purchaseEntryDetailProvider(entryId).future);
          },
          child: Builder(
            builder: (context) {
              final storeGroups = _groupLinesByStore(entry.items);
              return ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
                children: [
                  _ImportDetailHero(entry: entry),
                  const SizedBox(height: 14),
                  _ImportInfoCard(entry: entry),
                  const SizedBox(height: 14),
                  _SectionHeader(
                    title: 'Sản phẩm nhập',
                    subtitle: '${entry.items.length} dòng',
                  ),
                  const SizedBox(height: 10),
                  if (entry.items.isEmpty)
                    _EmptyLines(expectedCount: entry.itemCount)
                  else
                    ...storeGroups.map(
                      (group) => Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: _ImportStoreSection(group: group),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ImportDetailHero extends StatelessWidget {
  const _ImportDetailHero({required this.entry});

  final PurchaseEntryDetail entry;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final status = _statusStyle(context, entry.status);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: c.surfaceElev,
        borderRadius: BorderRadius.circular(20),
        boxShadow: c.shadowSm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: c.accent100,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(TablerIcons.package_import, color: c.accent600),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: status.bg,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  status.label,
                  style: TextStyle(
                    color: status.fg,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            _money.format(entry.totalCost),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: c.textPrimary,
              fontSize: 30,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Tổng giá vốn phiếu nhập',
            style: TextStyle(color: c.textMuted, fontSize: 13),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _HeroStat(
                icon: TablerIcons.list_details,
                label: '${entry.itemCount} dòng',
              ),
              const SizedBox(width: 12),
              _HeroStat(
                icon: TablerIcons.box,
                label: '${_qty.format(entry.totalQty)} sản phẩm',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroStat extends StatelessWidget {
  const _HeroStat({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
        decoration: BoxDecoration(
          color: c.pageBg,
          borderRadius: BorderRadius.circular(13),
        ),
        child: Row(
          children: [
            Icon(icon, size: 17, color: c.textMuted),
            const SizedBox(width: 7),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: c.textPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ImportInfoCard extends StatelessWidget {
  const _ImportInfoCard({required this.entry});

  final PurchaseEntryDetail entry;

  @override
  Widget build(BuildContext context) {
    return _FlatCard(
      children: [
        _InfoRow(
          icon: TablerIcons.calendar,
          label: 'Ngày tạo',
          value: _date.format(entry.createdAt),
        ),
        if (entry.postedAt != null)
          _InfoRow(
            icon: TablerIcons.circle_check,
            label: 'Ngày nhập kho',
            value: _date.format(entry.postedAt!),
          ),
        if (_notBlank(entry.invoiceRef))
          _InfoRow(
            icon: TablerIcons.file_invoice,
            label: 'Mã hóa đơn',
            value: entry.invoiceRef!,
          ),
        if (entry.invoiceDate != null)
          _InfoRow(
            icon: TablerIcons.calendar_time,
            label: 'Ngày hóa đơn',
            value: DateFormat('dd/MM/yyyy').format(entry.invoiceDate!),
          ),
        if (_notBlank(entry.warehouseName))
          _InfoRow(
            icon: TablerIcons.building_warehouse,
            label: 'Kho nhập',
            value: entry.warehouseName!,
          ),
        if (_notBlank(entry.distributorName))
          _InfoRow(
            icon: TablerIcons.truck_delivery,
            label: 'Nhà cung cấp',
            value: entry.distributorName!,
          ),
        if (_notBlank(entry.note))
          _InfoRow(
            icon: TablerIcons.note,
            label: 'Ghi chú',
            value: entry.note!,
          ),
      ],
    );
  }
}

class _ImportStoreSection extends StatelessWidget {
  const _ImportStoreSection({required this.group});

  final _ImportStoreGroup group;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(2, 0, 2, 8),
          child: Row(
            children: [
              Icon(TablerIcons.building_store, size: 17, color: c.primary),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  group.storeName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: c.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Text(
                _money.format(group.total),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: c.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
        Material(
          color: c.surfaceElev,
          borderRadius: BorderRadius.circular(16),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              for (var i = 0; i < group.lines.length; i++) ...[
                _ImportLineRow(line: group.lines[i]),
                if (i != group.lines.length - 1)
                  Divider(height: 1, thickness: 1, color: c.borderSoft),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _ImportLineRow extends StatelessWidget {
  const _ImportLineRow({required this.line});

  final PurchaseEntryLine line;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return InkWell(
      onTap: line.productId.isEmpty
          ? null
          : () => context.push('/products/${line.productId}'),
      child: Padding(
        padding: const EdgeInsets.all(13),
        child: Row(
          children: [
            _ProductAvatar(line: line),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    line.productName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: c.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _lineSub(line),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: c.textMuted, fontSize: 12),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${_qty.format(line.qty)} × '
                    '${_money.format(line.unitCost)}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: c.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _money.format(line.total),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: c.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Icon(TablerIcons.chevron_right, size: 17, color: c.textMuted),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductAvatar extends ConsumerWidget {
  const _ProductAvatar({required this.line});

  final PurchaseEntryLine line;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = kuruColors(context);
    final imageUrl = _resolvedVariantImageUrl(ref, line);
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 42,
        height: 42,
        color: const Color(0xFFEFF1F4),
        alignment: Alignment.center,
        child: imageUrl == null
            ? const Icon(
                TablerIcons.package,
                color: Color(0xFF94A3B8),
                size: 22,
              )
            : Image.network(
                imageUrl,
                width: 42,
                height: 42,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) =>
                    Icon(TablerIcons.package, color: c.textMuted, size: 22),
              ),
      ),
    );
  }
}

class _FlatCard extends StatelessWidget {
  const _FlatCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Container(
      decoration: BoxDecoration(
        color: c.surfaceElev,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            children[i],
            if (i != children.length - 1)
              Divider(height: 1, thickness: 1, color: c.borderSoft),
          ],
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 18, color: c.textMuted),
          const SizedBox(width: 10),
          Text(label, style: TextStyle(color: c.textMuted, fontSize: 12)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: c.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: c.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        Text(subtitle, style: TextStyle(color: c.textMuted, fontSize: 12)),
      ],
    );
  }
}

class _EmptyLines extends StatelessWidget {
  const _EmptyLines({required this.expectedCount});

  final int expectedCount;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: c.surfaceElev,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        expectedCount > 0
            ? 'Backend chưa trả danh sách sản phẩm cho phiếu này.'
            : 'Phiếu nhập chưa có sản phẩm.',
        textAlign: TextAlign.center,
        style: TextStyle(color: c.textMuted, fontSize: 13),
      ),
    );
  }
}

class _ImportDetailError extends StatelessWidget {
  const _ImportDetailError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(TablerIcons.alert_circle, size: 42, color: c.danger),
            const SizedBox(height: 10),
            Text(
              'Không tải được chi tiết',
              style: TextStyle(
                color: c.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: c.textMuted, fontSize: 12),
            ),
            const SizedBox(height: 14),
            OutlinedButton(onPressed: onRetry, child: const Text('Tải lại')),
          ],
        ),
      ),
    );
  }
}

({Color bg, Color fg, String label}) _statusStyle(
  BuildContext context,
  PurchaseEntryStatus status,
) {
  final c = kuruColors(context);
  return switch (status) {
    PurchaseEntryStatus.posted => (
      bg: c.successSoft,
      fg: c.success,
      label: 'Đã nhập',
    ),
    PurchaseEntryStatus.cancelled => (
      bg: c.surfaceHover,
      fg: c.textMuted,
      label: 'Đã hủy',
    ),
    PurchaseEntryStatus.draft => (
      bg: c.warningSoft,
      fg: c.warning,
      label: 'Nháp',
    ),
  };
}

String _lineSub(PurchaseEntryLine line) {
  final parts = [
    if (_notBlank(line.variantName)) line.variantName!,
    if (_notBlank(line.sku)) 'SKU ${line.sku}',
  ];
  return parts.isEmpty ? 'Sản phẩm nhập' : parts.join(' · ');
}

class _ImportStoreGroup {
  const _ImportStoreGroup({required this.storeName, required this.lines});

  final String storeName;
  final List<PurchaseEntryLine> lines;

  int get total => lines.fold(0, (sum, line) => sum + line.total);
}

List<_ImportStoreGroup> _groupLinesByStore(List<PurchaseEntryLine> lines) {
  final buckets = <String, List<PurchaseEntryLine>>{};
  final labels = <String, String>{};
  for (final line in lines) {
    final key = _notBlank(line.warehouseId)
        ? line.warehouseId!
        : _storeLabel(line);
    buckets.putIfAbsent(key, () => <PurchaseEntryLine>[]).add(line);
    labels[key] = _storeLabel(line);
  }
  return [
    for (final entry in buckets.entries)
      _ImportStoreGroup(
        storeName: labels[entry.key] ?? 'Cửa hàng',
        lines: entry.value,
      ),
  ]..sort((a, b) => a.storeName.compareTo(b.storeName));
}

String _storeLabel(PurchaseEntryLine line) {
  final name = line.warehouseName?.trim();
  if (name != null && name.isNotEmpty) return name;
  return 'Cửa hàng';
}

String? _resolvedVariantImageUrl(WidgetRef ref, PurchaseEntryLine line) {
  final lineVariantImage = _imageUrl(line.variantImageUrl);
  if (lineVariantImage != null) return lineVariantImage;
  if (!_notBlank(line.productId)) return null;

  final product = ref.watch(productByIdProvider(line.productId)).valueOrNull;
  if (product == null) return null;

  if (_notBlank(line.variantId)) {
    for (final variant in product.variants) {
      if (variant.id == line.variantId) {
        final variantImage = _imageUrl(variant.imageUrl);
        if (variantImage != null) return variantImage;
        break;
      }
    }
  }

  for (final variant in product.variants) {
    if (variant.isDefault) {
      final defaultImage = _imageUrl(variant.imageUrl);
      if (defaultImage != null) return defaultImage;
      break;
    }
  }

  return null;
}

String? _imageUrl(String? raw) {
  if (!_notBlank(raw)) return null;
  return '${Env.imageBaseUrl}/product-avatar/$raw';
}

bool _notBlank(String? value) => value != null && value.trim().isNotEmpty;
