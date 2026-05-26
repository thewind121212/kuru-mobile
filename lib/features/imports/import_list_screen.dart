// flutter_tabler_icons uses snake_case symbols.
// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
import 'package:kuru_mobile/features/imports/models/purchase_entry.dart';
import 'package:kuru_mobile/features/imports/models/purchase_entry_status.dart';
import 'package:kuru_mobile/features/imports/models/purchase_summary.dart';
import 'package:kuru_mobile/features/imports/providers/purchase_providers.dart';

class ImportListScreen extends ConsumerWidget {
  const ImportListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = kuruColors(context);
    final pageAsync = ref.watch(purchaseEntriesProvider);
    final summaryAsync = ref.watch(purchasePostedSummaryProvider);
    final page = pageAsync.valueOrNull;
    final summary = summaryAsync.valueOrNull ?? PurchaseSummary.empty();
    final money = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: 'đ',
      decimalDigits: 0,
    );

    return Scaffold(
      backgroundColor: c.pageBg,
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: () async {
            ref
              ..invalidate(purchaseEntriesProvider)
              ..invalidate(purchasePostedSummaryProvider);
            await ref.read(purchaseEntriesProvider.future);
          },
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 112),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 2, 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Nhập hàng',
                        style: TextStyle(
                          color: c.textPrimary,
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.8,
                        ),
                      ),
                    ),
                    FilledButton.icon(
                      onPressed: () => context.push('/import/create'),
                      icon: const Icon(TablerIcons.plus),
                      label: const Text('Tạo phiếu'),
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(0, 38),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ],
                ),
              ),
              _ImportHero(
                totalCost: money.format(summary.totalCost),
                totalQty: NumberFormat.decimalPattern(
                  'vi_VN',
                ).format(summary.totalQty),
                count: summary.entryCount,
              ),
              const SizedBox(height: 14),
              _SectionTitle(
                title: 'Phiếu nhập gần đây',
                subtitle: '${page?.total ?? 0} phiếu',
              ),
              const SizedBox(height: 10),
              if (pageAsync.isLoading && !pageAsync.hasValue)
                const Padding(
                  padding: EdgeInsets.all(48),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (pageAsync.hasError)
                _LoadError(
                  message: '${pageAsync.error}',
                  onRetry: () => ref.invalidate(purchaseEntriesProvider),
                )
              else if ((page?.entries ?? const []).isEmpty)
                _ImportEmpty(onCreate: () => context.push('/import/create'))
              else
                ...(page?.entries ?? const <PurchaseEntryOverview>[]).map(
                  (entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _ImportRow(
                      entry: entry,
                      money: money,
                      onTap: () => context.push('/import/${entry.id}'),
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

class _ImportHero extends StatelessWidget {
  const _ImportHero({
    required this.totalCost,
    required this.totalQty,
    required this.count,
  });

  final String totalCost;
  final String totalQty;
  final int count;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: c.surfaceElev,
        borderRadius: BorderRadius.circular(22),
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
                  color: const Color(0xFFFFECEB),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  TablerIcons.package_import,
                  color: Color(0xFFDC2626),
                ),
              ),
              const Spacer(),
              Text(
                '$count phiếu đã nhập',
                style: TextStyle(
                  color: c.textMuted,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            totalCost,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: c.textPrimary,
              fontSize: 32,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Giá vốn hàng nhập đã ghi',
            style: TextStyle(color: c.textMuted, fontSize: 13),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Icon(TablerIcons.box, size: 18, color: c.textMuted),
              const SizedBox(width: 8),
              Text(
                '$totalQty sản phẩm',
                style: TextStyle(
                  color: c.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.subtitle});

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

class _ImportRow extends StatelessWidget {
  const _ImportRow({
    required this.entry,
    required this.money,
    required this.onTap,
  });

  final PurchaseEntryOverview entry;
  final NumberFormat money;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final statusColor = switch (entry.status) {
      PurchaseEntryStatus.posted => c.success,
      PurchaseEntryStatus.cancelled => c.textMuted,
      PurchaseEntryStatus.draft => c.warning,
    };
    final statusLabel = switch (entry.status) {
      PurchaseEntryStatus.posted => 'Đã nhập',
      PurchaseEntryStatus.cancelled => 'Đã hủy',
      PurchaseEntryStatus.draft => 'Nháp',
    };
    return Material(
      color: c.surfaceElev,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: c.accent100,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(TablerIcons.package_import, color: c.accent600),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.entryNumber,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: c.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${entry.itemCount} dòng · '
                      '${DateFormat('dd/MM/yyyy').format(entry.createdAt)}',
                      style: TextStyle(color: c.textMuted, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    money.format(entry.totalCost),
                    style: TextStyle(
                      color: c.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    statusLabel,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 6),
              Icon(TablerIcons.chevron_right, size: 18, color: c.textMuted),
            ],
          ),
        ),
      ),
    );
  }
}

class _ImportEmpty extends StatelessWidget {
  const _ImportEmpty({required this.onCreate});

  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: c.surfaceElev,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Icon(TablerIcons.package_off, size: 44, color: c.textMuted),
          const SizedBox(height: 10),
          Text(
            'Chưa có phiếu nhập',
            style: TextStyle(
              color: c.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Tạo phiếu nhập để tăng tồn kho và ghi giá vốn mua hàng.',
            textAlign: TextAlign.center,
            style: TextStyle(color: c.textMuted, fontSize: 13),
          ),
          const SizedBox(height: 14),
          FilledButton.icon(
            onPressed: onCreate,
            icon: const Icon(TablerIcons.plus),
            label: const Text('Tạo phiếu nhập'),
          ),
        ],
      ),
    );
  }
}

class _LoadError extends StatelessWidget {
  const _LoadError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: c.surfaceElev,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Icon(TablerIcons.alert_circle, size: 42, color: c.danger),
          const SizedBox(height: 10),
          Text(
            'Không tải được phiếu nhập',
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
    );
  }
}
