// flutter_tabler_icons uses snake_case symbols.
// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
import 'package:kuru_mobile/design/core/feedback/k_badge.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_warehouse_option.dart';
import 'package:kuru_mobile/features/catalog/products/providers/product_providers.dart';
import 'package:kuru_mobile/features/expenses/models/expense_entry.dart';
import 'package:kuru_mobile/features/expenses/providers/expense_providers.dart';

final _money = NumberFormat.currency(
  locale: 'vi_VN',
  symbol: 'đ',
  decimalDigits: 0,
);
final _date = DateFormat('dd/MM/yyyy');
final _dateTime = DateFormat('dd/MM/yyyy HH:mm');

class ExpenseDetailScreen extends ConsumerWidget {
  const ExpenseDetailScreen({required this.entryId, super.key, this.initial});

  final String entryId;
  final ExpenseEntry? initial;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = kuruColors(context);
    final async = ref.watch(expenseEntryDetailProvider(entryId));
    final branches = ref.watch(productWarehouseOptionsProvider);
    final entry = async.valueOrNull ?? initial;
    return Scaffold(
      backgroundColor: c.pageBg,
      appBar: AppBar(
        backgroundColor: c.pageBg,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(
          entry?.title ?? 'Chi tiết chi phí',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: c.textPrimary,
            fontSize: 17,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: entry == null
          ? async.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => _ExpenseDetailError(
                message: '$error',
                onRetry: () =>
                    ref.invalidate(expenseEntryDetailProvider(entryId)),
              ),
              data: (entry) => _ExpenseDetailBody(
                entry: entry,
                branches: branches,
                onRefresh: () => _refresh(ref),
              ),
            )
          : _ExpenseDetailBody(
              entry: entry,
              branches: branches,
              onRefresh: () => _refresh(ref),
            ),
    );
  }

  Future<void> _refresh(WidgetRef ref) async {
    ref.invalidate(expenseEntryDetailProvider(entryId));
    await ref.read(expenseEntryDetailProvider(entryId).future);
  }
}

class _ExpenseDetailBody extends StatelessWidget {
  const _ExpenseDetailBody({
    required this.entry,
    required this.branches,
    required this.onRefresh,
  });

  final ExpenseEntry entry;
  final AsyncValue<List<ProductWarehouseOption>> branches;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
        children: [
          _ExpenseDetailHero(entry: entry),
          const SizedBox(height: 14),
          _ExpenseInfoCard(entry: entry, branches: branches),
          if (entry.hasImportRef) ...[
            const SizedBox(height: 14),
            _ImportReferenceCard(entry: entry),
          ],
          if (_notBlank(entry.note)) ...[
            const SizedBox(height: 14),
            _NoteCard(note: entry.note!.trim()),
          ],
        ],
      ),
    );
  }
}

class _ExpenseDetailHero extends StatelessWidget {
  const _ExpenseDetailHero({required this.entry});

  final ExpenseEntry entry;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final isVoided = entry.isVoided;
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
                  color: isVoided ? c.dangerSoft : c.primarySoft,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  isVoided ? TablerIcons.ban : TablerIcons.receipt_2,
                  color: isVoided ? c.danger : c.primary,
                ),
              ),
              const Spacer(),
              KBadge(
                label: isVoided ? 'Đã hủy' : 'Đang tính',
                tone: isVoided ? KBadgeTone.danger : KBadgeTone.success,
                size: KBadgeSize.md,
                leadingIcon: isVoided ? TablerIcons.ban : TablerIcons.check,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '-${_money.format(entry.amount)}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: isVoided ? c.textMuted : c.textPrimary,
              fontSize: 30,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.4,
              decoration: isVoided ? TextDecoration.lineThrough : null,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            entry.categoryName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: c.textMuted, fontSize: 13),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _HeroStat(
                icon: TablerIcons.calendar,
                label: _date.format(entry.paidAt.toLocal()),
              ),
              const SizedBox(width: 12),
              _HeroStat(
                icon: TablerIcons.link,
                label: _sourceLabel(context, entry.source),
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

class _ExpenseInfoCard extends StatelessWidget {
  const _ExpenseInfoCard({required this.entry, required this.branches});

  final ExpenseEntry entry;
  final AsyncValue<List<ProductWarehouseOption>> branches;

  @override
  Widget build(BuildContext context) {
    final scope = _scopePresentation(context, entry, branches.valueOrNull);
    return _FlatCard(
      children: [
        _InfoRow(
          icon: TablerIcons.category,
          label: 'Loại chi phí',
          value: entry.categoryName,
        ),
        _InfoRow(
          icon: TablerIcons.calendar,
          label: 'Ngày chi',
          value: _date.format(entry.paidAt.toLocal()),
        ),
        _InfoRow(
          icon: TablerIcons.link,
          label: 'Nguồn',
          value: _sourceLabel(context, entry.source),
        ),
        if (_notBlank(entry.receiptKey))
          _InfoRow(
            icon: TablerIcons.paperclip,
            label: 'Chứng từ',
            value: entry.receiptKey!.trim(),
          ),
        _InfoRow(
          icon: TablerIcons.building_store,
          label: scope.label,
          value: scope.value,
        ),
        _InfoRow(
          icon: TablerIcons.clock,
          label: 'Tạo lúc',
          value: _dateTime.format(entry.createdAt.toLocal()),
        ),
        _InfoRow(
          icon: TablerIcons.refresh,
          label: 'Cập nhật',
          value: _dateTime.format(entry.updatedAt.toLocal()),
        ),
        if (entry.voidedAt != null)
          _InfoRow(
            icon: TablerIcons.ban,
            label: 'Hủy lúc',
            value: _dateTime.format(entry.voidedAt!.toLocal()),
          ),
        if (_notBlank(entry.voidReason))
          _InfoRow(
            icon: TablerIcons.message_circle,
            label: 'Lý do hủy',
            value: entry.voidReason!.trim(),
          ),
      ],
    );
  }
}

class _ImportReferenceCard extends StatelessWidget {
  const _ImportReferenceCard({required this.entry});

  final ExpenseEntry entry;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final importId = entry.resolvedImportEntryId?.trim();
    final canOpen = importId != null && importId.isNotEmpty;
    return Material(
      color: c.surfaceElev,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: canOpen ? () => context.push('/import/$importId') : null,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: c.accent100,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  TablerIcons.package_import,
                  color: c.accent700,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Phiếu nhập liên quan',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: c.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      entry.importRefLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: c.textMuted, fontSize: 12),
                    ),
                  ],
                ),
              ),
              if (canOpen) ...[
                const SizedBox(width: 10),
                Icon(TablerIcons.chevron_right, color: c.textMuted, size: 18),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _NoteCard extends StatelessWidget {
  const _NoteCard({required this.note});

  final String note;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: c.surfaceElev,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(TablerIcons.note, size: 18, color: c.textMuted),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              note,
              style: TextStyle(
                color: c.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                height: 1.35,
              ),
            ),
          ),
        ],
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

class _ExpenseDetailError extends StatelessWidget {
  const _ExpenseDetailError({required this.message, required this.onRetry});

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

String _sourceLabel(BuildContext context, String source) {
  final vi = _isVietnamese(context);
  final normalized = source.toUpperCase();
  if (normalized.contains('IMPORT') || normalized.contains('PURCHASE')) {
    return vi ? 'Phiếu nhập' : 'Import';
  }
  if (normalized.contains('SUBSCRIPTION')) return vi ? 'Định kỳ' : 'Recurring';
  if (normalized.contains('PUSH') || normalized.contains('AUTO')) {
    return vi ? 'Tự động' : 'Auto';
  }
  if (normalized.contains('MANUAL')) return vi ? 'Thủ công' : 'Manual';
  return source;
}

({String label, String value}) _scopePresentation(
  BuildContext context,
  ExpenseEntry entry,
  List<ProductWarehouseOption>? branches,
) {
  final vi = _isVietnamese(context);
  final linkedWarehouses = entry.linkedImportWarehousesDeduped;
  if (linkedWarehouses.isNotEmpty) {
    return (
      label: vi ? 'Phạm vi' : 'Scope',
      value: _linkedWarehouseScopeValue(linkedWarehouses),
    );
  }
  if (entry.isOrgWide) {
    return (
      label: vi ? 'Phạm vi' : 'Scope',
      value: vi ? 'Toàn tổ chức' : 'Org-wide',
    );
  }
  final branchName =
      entry.branchDisplayName ?? _branchNameFromStoreId(entry, branches);
  return (
    label: vi ? 'Phạm vi' : 'Scope',
    value: branchName ?? (vi ? 'Chưa có tên' : 'Name missing'),
  );
}

String? _branchNameFromStoreId(
  ExpenseEntry entry,
  List<ProductWarehouseOption>? branches,
) {
  final storeId = entry.storeId?.trim();
  if (storeId == null || storeId.isEmpty || branches == null) return null;
  for (final branch in branches) {
    if (branch.warehouseId == storeId && branch.name.trim().isNotEmpty) {
      return branch.name.trim();
    }
  }
  return null;
}

String _linkedWarehouseScopeValue(List<ExpenseLinkedWarehouse> warehouses) {
  final firstName = warehouses.first.name.trim();
  final overflowCount = warehouses.length - 1;
  if (overflowCount <= 0) return firstName;
  return '$firstName +$overflowCount';
}

bool _isVietnamese(BuildContext context) =>
    Localizations.localeOf(context).languageCode == 'vi';

bool _notBlank(String? value) => value != null && value.trim().isNotEmpty;
