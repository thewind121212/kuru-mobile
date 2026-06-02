// flutter_tabler_icons uses snake_case symbols.
// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/design/core/feedback/k_badge.dart';
import 'package:kuru_mobile/design/core/input/k_currency_field.dart';
import 'package:kuru_mobile/design/core/input/k_select.dart';
import 'package:kuru_mobile/design/core/input/k_text_field.dart';
import 'package:kuru_mobile/design/core/modal/k_modal_sheet.dart';
import 'package:kuru_mobile/features/expenses/models/expense_category.dart';
import 'package:kuru_mobile/features/expenses/models/expense_entry.dart';
import 'package:kuru_mobile/features/expenses/models/expense_summary.dart';
import 'package:kuru_mobile/features/expenses/providers/expense_providers.dart';

class ExpenseListScreen extends ConsumerStatefulWidget {
  const ExpenseListScreen({super.key});

  @override
  ConsumerState<ExpenseListScreen> createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends ConsumerState<ExpenseListScreen> {
  static const _expenseTicketWriteEnabled = bool.fromEnvironment(
    'ENABLE_EXPENSE_TICKETS',
  );

  final _searchCtrl = TextEditingController();
  String? _categoryId;
  DateTimeRange? _dateRange;

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _openCreateSheet() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _ExpenseCreateSheet(),
    );
  }

  Future<void> _openFilterSheet(List<ExpenseCategory> categories) async {
    final result = await showKModalSheet<_ExpenseFilterResult>(
      context: context,
      title: 'Bộ lọc chi phí',
      builder: (_) => _ExpenseFilterSheet(
        categories: categories,
        initialCategoryId: _categoryId,
        initialDateRange: _dateRange,
      ),
    );
    if (result == null || !mounted) return;
    setState(() {
      _categoryId = result.categoryId;
      _dateRange = result.dateRange;
    });
  }

  bool _matchesFilters(ExpenseEntry entry) {
    if (_categoryId != null && entry.categoryId != _categoryId) return false;
    final range = _dateRange;
    if (range == null) return true;
    final paidDate = _dateOnly(entry.paidAt);
    return !paidDate.isBefore(_dateOnly(range.start)) &&
        !paidDate.isAfter(_dateOnly(range.end));
  }

  void _clearFilters() {
    setState(() {
      _categoryId = null;
      _dateRange = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final entriesAsync = ref.watch(expenseEntriesProvider);
    final summaryAsync = ref.watch(expenseSummaryProvider);
    final categoriesAsync = ref.watch(expenseCategoriesProvider);
    final entries = entriesAsync.valueOrNull ?? const <ExpenseEntry>[];
    final categories = categoriesAsync.valueOrNull ?? const <ExpenseCategory>[];
    final summary = summaryAsync.valueOrNull ?? ExpenseSummary.empty();
    final query = _searchCtrl.text.trim();
    final searched = query.isEmpty
        ? entries
        : entries.where((e) => e.matches(query)).toList();
    final filtered = searched.where(_matchesFilters).toList();
    final groups = _groupEntriesByPaidDate(filtered);
    final activeFilterCount =
        (_categoryId == null ? 0 : 1) + (_dateRange == null ? 0 : 1);
    final categoryLabel = _selectedCategoryLabel(categories, _categoryId);
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
              ..invalidate(expenseEntriesProvider)
              ..invalidate(expenseSummaryProvider)
              ..invalidate(expenseCategoriesProvider);
            await ref.read(expenseEntriesProvider.future);
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
                        'Chi phí',
                        style: TextStyle(
                          color: c.danger,
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.8,
                        ),
                      ),
                    ),
                    FilledButton.icon(
                      onPressed: _expenseTicketWriteEnabled
                          ? _openCreateSheet
                          : null,
                      icon: const Icon(TablerIcons.plus),
                      label: const Text('Thêm'),
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(0, 38),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ],
                ),
              ),
              _ExpenseHero(
                monthTotal: money.format(summary.monthTotal),
                total: money.format(summary.total),
                count: summary.count,
              ),
              const SizedBox(height: 14),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchCtrl,
                      onSubmitted: (_) => setState(() {}),
                      style: TextStyle(
                        color: c.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Tìm chi phí...',
                        hintStyle: TextStyle(color: c.textMuted, fontSize: 14),
                        prefixIcon: const Icon(TablerIcons.search, size: 18),
                        filled: true,
                        fillColor: c.surfaceElev,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 13,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _ExpenseFilterIconButton(
                    activeCount: activeFilterCount,
                    onTap: () => _openFilterSheet(categories),
                  ),
                ],
              ),
              if (activeFilterCount > 0) ...[
                const SizedBox(height: 10),
                _ExpenseFilterBar(
                  categoryLabel: categoryLabel,
                  dateRangeLabel: _dateRange == null
                      ? null
                      : _formatDateRange(_dateRange!),
                  onClearCategory: () => setState(() => _categoryId = null),
                  onClearDate: () => setState(() => _dateRange = null),
                  onClearAll: _clearFilters,
                ),
                const SizedBox(height: 14),
              ] else
                const SizedBox(height: 14),
              if (entries.isNotEmpty) ...[
                _ExpenseTrendCard(groups: groups, money: money),
                const SizedBox(height: 14),
              ],
              _SectionTitle(
                title: query.isEmpty ? 'Giao dịch gần đây' : 'Kết quả tìm kiếm',
                subtitle: '${filtered.length} khoản chi',
              ),
              const SizedBox(height: 10),
              if (entriesAsync.isLoading && !entriesAsync.hasValue)
                const Padding(
                  padding: EdgeInsets.all(48),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (entriesAsync.hasError)
                _ExpenseLoadError(
                  message: '${entriesAsync.error}',
                  onRetry: () => ref.invalidate(expenseEntriesProvider),
                )
              else if (filtered.isEmpty)
                _ExpenseEmpty(
                  hasQuery: query.isNotEmpty,
                  onCreate: _expenseTicketWriteEnabled
                      ? _openCreateSheet
                      : null,
                )
              else
                ...groups.map(
                  (group) => Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: _ExpenseDateSection(group: group, money: money),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExpenseFilterIconButton extends StatelessWidget {
  const _ExpenseFilterIconButton({
    required this.activeCount,
    required this.onTap,
  });

  final int activeCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Material(
      color: c.surfaceElev,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(
              color: activeCount > 0 ? c.accent500 : c.borderSoft,
              width: activeCount > 0 ? 1.4 : 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                TablerIcons.adjustments_horizontal,
                color: c.textPrimary,
                size: 19,
              ),
              if (activeCount > 0) ...[
                const SizedBox(width: 7),
                Container(
                  constraints: const BoxConstraints(minWidth: 20),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: c.accent600,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '$activeCount',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ExpenseFilterBar extends StatelessWidget {
  const _ExpenseFilterBar({
    required this.categoryLabel,
    required this.dateRangeLabel,
    required this.onClearCategory,
    required this.onClearDate,
    required this.onClearAll,
  });

  final String? categoryLabel;
  final String? dateRangeLabel;
  final VoidCallback onClearCategory;
  final VoidCallback onClearDate;
  final VoidCallback onClearAll;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final chips = <Widget>[
      if (categoryLabel != null)
        _ExpenseFilterChip(label: categoryLabel!, onRemove: onClearCategory),
      if (dateRangeLabel != null)
        _ExpenseFilterChip(label: dateRangeLabel!, onRemove: onClearDate),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final chip in chips) ...[chip, const SizedBox(width: 7)],
          TextButton(
            onPressed: onClearAll,
            style: TextButton.styleFrom(
              foregroundColor: c.textMuted,
              minimumSize: const Size(0, 32),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text('Xóa lọc'),
          ),
        ],
      ),
    );
  }
}

class _ExpenseFilterChip extends StatelessWidget {
  const _ExpenseFilterChip({required this.label, required this.onRemove});

  final String label;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Container(
      height: 32,
      padding: const EdgeInsets.only(left: 10, right: 5),
      decoration: BoxDecoration(
        color: c.accent50,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: c.accent200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: c.accent700,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onRemove,
            child: Icon(TablerIcons.x, size: 15, color: c.accent700),
          ),
        ],
      ),
    );
  }
}

class _ExpenseTrendCard extends StatelessWidget {
  const _ExpenseTrendCard({required this.groups, required this.money});

  final List<_ExpenseDateGroup> groups;
  final NumberFormat money;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final bars = groups
        .where((group) => group.total > 0)
        .take(7)
        .toList()
        .reversed
        .toList();
    final total = groups.fold<int>(0, (sum, group) => sum + group.total);
    final maxTotal = bars.fold<int>(
      0,
      (max, group) => group.total > max ? group.total : max,
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c.surfaceElev,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: c.borderSoft),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: c.primarySoft,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(TablerIcons.chart_bar, color: c.primary, size: 19),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Biểu đồ chi theo ngày',
                      style: TextStyle(
                        color: c.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      bars.isEmpty ? 'Không có dữ liệu' : '7 ngày gần nhất',
                      style: TextStyle(color: c.textMuted, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Text(
                '-${money.format(total)}',
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
          const SizedBox(height: 14),
          if (bars.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 22),
              decoration: BoxDecoration(
                color: c.pageBg,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                'Chưa có khoản chi trong bộ lọc này',
                textAlign: TextAlign.center,
                style: TextStyle(color: c.textMuted, fontSize: 12),
              ),
            )
          else
            SizedBox(
              height: 116,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  for (final group in bars)
                    Expanded(
                      child: _ExpenseDayBar(
                        group: group,
                        maxTotal: maxTotal,
                        money: money,
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _ExpenseDayBar extends StatelessWidget {
  const _ExpenseDayBar({
    required this.group,
    required this.maxTotal,
    required this.money,
  });

  final _ExpenseDateGroup group;
  final int maxTotal;
  final NumberFormat money;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final ratio = maxTotal == 0 ? 0.0 : group.total / maxTotal;
    final height = 10 + (ratio * 62);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            _compactMoney(group.total),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: c.textMuted,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Tooltip(
            message:
                '${_formatExpenseDate(group.date)} · '
                '-${money.format(group.total)}',
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: double.infinity,
              height: height,
              decoration: BoxDecoration(
                color: c.primary,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            DateFormat('dd/MM').format(group.date),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: c.textMuted, fontSize: 10),
          ),
        ],
      ),
    );
  }
}

class _ExpenseDateSection extends StatelessWidget {
  const _ExpenseDateSection({required this.group, required this.money});

  final _ExpenseDateGroup group;
  final NumberFormat money;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final countLabel = group.hasVoided
        ? '${group.activeCount}/${group.entries.length} khoản đang tính'
        : '${group.entries.length} khoản chi';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(2, 0, 2, 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _formatExpenseDate(group.date),
                      style: TextStyle(
                        color: c.primary,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      countLabel,
                      style: TextStyle(color: c.textMuted, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Text(
                '-${money.format(group.total)}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: c.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        Material(
          color: c.surfaceElev,
          borderRadius: BorderRadius.circular(14),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              for (var i = 0; i < group.entries.length; i++) ...[
                _ExpenseRow(entry: group.entries[i], money: money),
                if (i != group.entries.length - 1)
                  Divider(height: 1, thickness: 1, color: c.borderSoft),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _ExpenseHero extends StatelessWidget {
  const _ExpenseHero({
    required this.monthTotal,
    required this.total,
    required this.count,
  });

  final String monthTotal;
  final String total;
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
                  color: c.dangerSoft,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(TablerIcons.cash_banknote_off, color: c.danger),
              ),
              const Spacer(),
              Text(
                '$count khoản',
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
            monthTotal,
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
            'Tổng chi trong tháng này',
            style: TextStyle(color: c.textMuted, fontSize: 13),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: c.pageBg,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Icon(TablerIcons.history, size: 18, color: c.textMuted),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Kỳ này',
                    style: TextStyle(color: c.textMuted, fontSize: 13),
                  ),
                ),
                Text(
                  total,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: c.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
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

class _ExpenseRow extends StatelessWidget {
  const _ExpenseRow({required this.entry, required this.money});

  final ExpenseEntry entry;
  final NumberFormat money;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final note = entry.note?.trim();
    final voidReason = entry.voidReason?.trim();
    final isVoided = entry.isVoided;
    final subtitle = note == null || note.isEmpty
        ? entry.categoryName
        : '${entry.categoryName} · $note';
    final secondaryText =
        isVoided && voidReason != null && voidReason.isNotEmpty
        ? 'Lý do hủy: $voidReason'
        : subtitle;
    return InkWell(
      onTap: entry.id.isEmpty
          ? null
          : () => context.push('/expenses/${entry.id}', extra: entry),
      onLongPress: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: isVoided ? c.dangerSoft : c.surfaceHover,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isVoided ? TablerIcons.ban : TablerIcons.receipt,
                color: isVoided ? c.danger : c.textSecondary,
                size: 20,
              ),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          entry.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: isVoided ? c.textMuted : c.textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            decoration: isVoided
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                      ),
                      if (isVoided) ...[
                        const SizedBox(width: 6),
                        const KBadge(
                          label: 'Đã hủy',
                          tone: KBadgeTone.danger,
                          leadingIcon: TablerIcons.ban,
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    secondaryText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
                  '-${money.format(entry.amount)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isVoided ? c.textMuted : c.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    decoration: isVoided ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(height: 7),
                Icon(TablerIcons.chevron_right, color: c.textMuted, size: 17),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ExpenseEmpty extends StatelessWidget {
  const _ExpenseEmpty({required this.hasQuery, required this.onCreate});

  final bool hasQuery;
  final VoidCallback? onCreate;

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
          Icon(TablerIcons.receipt_off, size: 44, color: c.textMuted),
          const SizedBox(height: 10),
          Text(
            hasQuery ? 'Không tìm thấy khoản chi' : 'Chưa có chi phí',
            style: TextStyle(
              color: c.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            hasQuery
                ? 'Thử từ khóa khác hoặc xóa bộ lọc.'
                : 'Tạo phiếu chi đang tạm tắt; các khoản đã ghi '
                      'vẫn hiển thị ở đây.',
            textAlign: TextAlign.center,
            style: TextStyle(color: c.textMuted, fontSize: 13),
          ),
          if (!hasQuery) ...[
            const SizedBox(height: 14),
            FilledButton.icon(
              onPressed: onCreate,
              icon: const Icon(TablerIcons.plus),
              label: const Text('Thêm chi phí'),
            ),
          ],
        ],
      ),
    );
  }
}

class _ExpenseLoadError extends StatelessWidget {
  const _ExpenseLoadError({required this.message, required this.onRetry});

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
            'Không tải được chi phí',
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

class _ExpenseFilterSheet extends StatefulWidget {
  const _ExpenseFilterSheet({
    required this.categories,
    required this.initialCategoryId,
    required this.initialDateRange,
  });

  final List<ExpenseCategory> categories;
  final String? initialCategoryId;
  final DateTimeRange? initialDateRange;

  @override
  State<_ExpenseFilterSheet> createState() => _ExpenseFilterSheetState();
}

class _ExpenseFilterSheetState extends State<_ExpenseFilterSheet> {
  String? _categoryId;
  DateTimeRange? _dateRange;

  @override
  void initState() {
    super.initState();
    _categoryId = widget.initialCategoryId;
    _dateRange = widget.initialDateRange;
  }

  void _setQuickRange(_ExpenseQuickRange range) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final picked = switch (range) {
      _ExpenseQuickRange.today => DateTimeRange(start: today, end: today),
      _ExpenseQuickRange.last7Days => DateTimeRange(
        start: today.subtract(const Duration(days: 6)),
        end: today,
      ),
      _ExpenseQuickRange.thisMonth => DateTimeRange(
        start: DateTime(today.year, today.month),
        end: today,
      ),
    };
    setState(() => _dateRange = picked);
  }

  Future<void> _pickCustomRange() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(now.year + 1),
      initialDateRange: _dateRange,
    );
    if (picked != null) {
      setState(() => _dateRange = picked);
    }
  }

  bool _isQuickRangeSelected(_ExpenseQuickRange range) {
    final current = _dateRange;
    if (current == null) return false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final expected = switch (range) {
      _ExpenseQuickRange.today => DateTimeRange(start: today, end: today),
      _ExpenseQuickRange.last7Days => DateTimeRange(
        start: today.subtract(const Duration(days: 6)),
        end: today,
      ),
      _ExpenseQuickRange.thisMonth => DateTimeRange(
        start: DateTime(today.year, today.month),
        end: today,
      ),
    };
    return _dateOnly(current.start) == expected.start &&
        _dateOnly(current.end) == expected.end;
  }

  void _reset() {
    Navigator.of(context).pop(const _ExpenseFilterResult());
  }

  void _apply() {
    Navigator.of(
      context,
    ).pop(_ExpenseFilterResult(categoryId: _categoryId, dateRange: _dateRange));
  }

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _ExpenseFilterSectionTitle(
          icon: TablerIcons.receipt,
          title: 'Loại chi phí',
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _ExpenseFilterPill(
              label: 'Tất cả',
              selected: _categoryId == null,
              onTap: () => setState(() => _categoryId = null),
            ),
            for (final category in widget.categories)
              _ExpenseFilterPill(
                label: category.name,
                selected: _categoryId == category.id,
                onTap: () => setState(() => _categoryId = category.id),
              ),
          ],
        ),
        const SizedBox(height: 20),
        const _ExpenseFilterSectionTitle(
          icon: TablerIcons.calendar_stats,
          title: 'Thời gian',
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _ExpenseFilterPill(
              label: 'Tất cả ngày',
              selected: _dateRange == null,
              onTap: () => setState(() => _dateRange = null),
            ),
            _ExpenseFilterPill(
              label: 'Hôm nay',
              selected: _isQuickRangeSelected(_ExpenseQuickRange.today),
              onTap: () => _setQuickRange(_ExpenseQuickRange.today),
            ),
            _ExpenseFilterPill(
              label: '7 ngày',
              selected: _isQuickRangeSelected(_ExpenseQuickRange.last7Days),
              onTap: () => _setQuickRange(_ExpenseQuickRange.last7Days),
            ),
            _ExpenseFilterPill(
              label: 'Tháng này',
              selected: _isQuickRangeSelected(_ExpenseQuickRange.thisMonth),
              onTap: () => _setQuickRange(_ExpenseQuickRange.thisMonth),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Material(
          color: c.pageBg,
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: _pickCustomRange,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                border: Border.all(color: c.borderSoft),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: c.surfaceElev,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      TablerIcons.calendar,
                      color: c.textSecondary,
                      size: 19,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Chọn khoảng ngày',
                          style: TextStyle(
                            color: c.textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _dateRange == null
                              ? 'Đang xem tất cả ngày'
                              : _formatDateRange(_dateRange!),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: c.textMuted, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Icon(TablerIcons.chevron_right, color: c.textMuted, size: 18),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _reset,
                child: const Text('Đặt lại'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton(
                onPressed: _apply,
                child: const Text('Áp dụng'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ExpenseFilterSectionTitle extends StatelessWidget {
  const _ExpenseFilterSectionTitle({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Row(
      children: [
        Icon(icon, size: 18, color: c.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            color: c.textPrimary,
            fontSize: 15,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _ExpenseFilterPill extends StatelessWidget {
  const _ExpenseFilterPill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Material(
      color: selected ? c.primary : c.pageBg,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: selected ? c.primary : c.borderSoft),
          ),
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: selected ? c.textInverse : c.textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}

enum _ExpenseQuickRange { today, last7Days, thisMonth }

class _ExpenseFilterResult {
  const _ExpenseFilterResult({this.categoryId, this.dateRange});

  final String? categoryId;
  final DateTimeRange? dateRange;
}

class _ExpenseCreateSheet extends ConsumerStatefulWidget {
  const _ExpenseCreateSheet();

  @override
  ConsumerState<_ExpenseCreateSheet> createState() =>
      _ExpenseCreateSheetState();
}

class _ExpenseCreateSheetState extends ConsumerState<_ExpenseCreateSheet> {
  final _categoryNameCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  String? _categoryId;
  int? _amount;
  String? _categoryError;
  String? _amountError;
  String? _submitError;
  bool _saving = false;

  @override
  void dispose() {
    _categoryNameCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving) return;
    final categories = ref.read(expenseCategoriesProvider).valueOrNull ?? [];
    final hasCategories = categories.isNotEmpty;
    setState(() {
      _submitError = null;
      _categoryError = hasCategories && _categoryId == null
          ? 'Chọn loại chi phí'
          : !hasCategories && _categoryNameCtrl.text.trim().isEmpty
          ? 'Nhập loại chi phí'
          : null;
      _amountError = (_amount == null || _amount! <= 0)
          ? 'Nhập số tiền lớn hơn 0'
          : null;
    });
    if (_categoryError != null || _amountError != null) return;

    setState(() => _saving = true);
    try {
      final repo = ref.read(expenseRepositoryProvider);
      var categoryId = _categoryId;
      categoryId ??= await repo
          .createCategory(name: _categoryNameCtrl.text, defaultAmount: _amount)
          .unwrap();
      await repo
          .createEntry(
            categoryId: categoryId,
            amount: _amount!,
            paidAt: DateTime.now(),
            note: _noteCtrl.text,
          )
          .unwrap();
      ref
        ..invalidate(expenseCategoriesProvider)
        ..invalidate(expenseEntriesProvider)
        ..invalidate(expenseSummaryProvider);
    } on Object catch (e) {
      if (!mounted) return;
      setState(() {
        _submitError = '$e';
        _saving = false;
      });
      return;
    }
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final categoriesAsync = ref.watch(expenseCategoriesProvider);
    final categories = categoriesAsync.valueOrNull ?? const <ExpenseCategory>[];
    final hasCategories = categories.isNotEmpty;
    return AnimatedPadding(
      padding: MediaQuery.of(context).viewInsets,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      child: Container(
        decoration: BoxDecoration(
          color: c.surfaceElev,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: c.surfaceHover,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Thêm chi phí',
                        style: TextStyle(
                          color: c.textPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(TablerIcons.x),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (categoriesAsync.isLoading && !categoriesAsync.hasValue)
                  const Padding(
                    padding: EdgeInsets.all(18),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (hasCategories)
                  KSelect<String>(
                    label: 'Loại chi phí',
                    value: _categoryId,
                    placeholder: 'Chọn loại chi phí',
                    errorText: _categoryError,
                    options: [
                      for (final category in categories)
                        KSelectOption<String>(
                          value: category.id,
                          label: category.name,
                          icon: TablerIcons.receipt,
                        ),
                    ],
                    onChanged: (v) {
                      final picked = categories.firstWhere((c) => c.id == v);
                      setState(() {
                        _categoryId = v;
                        _categoryError = null;
                        _amount ??= picked.defaultAmount;
                      });
                    },
                  )
                else
                  KTextField(
                    label: 'Loại chi phí mới',
                    controller: _categoryNameCtrl,
                    placeholder: 'VD: Nhập hàng, mặt bằng',
                    errorText: _categoryError,
                    leadingIcon: const Icon(TablerIcons.receipt),
                    textInputAction: TextInputAction.next,
                  ),
                const SizedBox(height: 12),
                KCurrencyField(
                  label: 'Số tiền',
                  value: _amount,
                  errorText: _amountError,
                  onChanged: (v) => setState(() => _amount = v),
                  hideMultipliers: true,
                ),
                KTextField(
                  label: 'Ghi chú',
                  controller: _noteCtrl,
                  placeholder: 'Không bắt buộc',
                  leadingIcon: const Icon(TablerIcons.note),
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _save(),
                ),
                if (_submitError != null) ...[
                  const SizedBox(height: 10),
                  Text(
                    _submitError!,
                    style: TextStyle(
                      color: c.danger,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _saving
                            ? null
                            : () => Navigator.of(context).pop(),
                        child: const Text('Hủy'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: _saving ? null : _save,
                        icon: const Icon(TablerIcons.check),
                        label: Text(_saving ? 'Đang lưu' : 'Lưu'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ExpenseDateGroup {
  const _ExpenseDateGroup({required this.date, required this.entries});

  final DateTime date;
  final List<ExpenseEntry> entries;

  Iterable<ExpenseEntry> get activeEntries =>
      entries.where((entry) => !entry.isVoided);

  int get activeCount => activeEntries.length;
  bool get hasVoided => activeCount != entries.length;

  int get total => activeEntries.fold(0, (sum, entry) => sum + entry.amount);
}

List<_ExpenseDateGroup> _groupEntriesByPaidDate(List<ExpenseEntry> entries) {
  final sorted = [...entries]..sort((a, b) => b.paidAt.compareTo(a.paidAt));
  final buckets = <DateTime, List<ExpenseEntry>>{};
  for (final entry in sorted) {
    final date = _dateOnly(entry.paidAt);
    buckets.putIfAbsent(date, () => <ExpenseEntry>[]).add(entry);
  }
  return [
    for (final date in buckets.keys)
      _ExpenseDateGroup(date: date, entries: buckets[date]!),
  ];
}

DateTime _dateOnly(DateTime date) {
  final local = date.toLocal();
  return DateTime(local.year, local.month, local.day);
}

String _formatExpenseDate(DateTime date) {
  return DateFormat('dd/MM/yyyy').format(date);
}

String _formatDateRange(DateTimeRange range) {
  final formatter = DateFormat('dd/MM/yyyy');
  return '${formatter.format(range.start)} - ${formatter.format(range.end)}';
}

String? _selectedCategoryLabel(
  List<ExpenseCategory> categories,
  String? categoryId,
) {
  if (categoryId == null) return null;
  for (final category in categories) {
    if (category.id == categoryId) return category.name;
  }
  return null;
}

String _compactMoney(int value) {
  if (value >= 1000000000) {
    return '${(value / 1000000000).toStringAsFixed(1)}t';
  }
  if (value >= 1000000) {
    return '${(value / 1000000).toStringAsFixed(1)}tr';
  }
  if (value >= 1000) {
    return '${(value / 1000).round()}k';
  }
  return '$value';
}
