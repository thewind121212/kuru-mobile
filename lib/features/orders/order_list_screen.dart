// (flutter_tabler_icons uses snake_case symbols)
// ignore_for_file: non_constant_identifier_names
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/features/orders/models/order_list_filters.dart';
import 'package:kuru_mobile/features/orders/models/order_payment_status.dart';
import 'package:kuru_mobile/features/orders/models/order_sale_channel.dart';
import 'package:kuru_mobile/features/orders/models/order_status.dart';
import 'package:kuru_mobile/features/orders/providers/order_providers.dart';
import 'package:kuru_mobile/features/orders/widgets/order_filter_sheet.dart';
import 'package:kuru_mobile/features/orders/widgets/order_list_row.dart';

class OrderListScreen extends ConsumerStatefulWidget {
  const OrderListScreen({super.key});

  @override
  ConsumerState<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends ConsumerState<OrderListScreen> {
  final _searchCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchCtrl.text = ref.read(orderFiltersProvider).search ?? '';
    _searchCtrl.addListener(_onSearchChanged);
    _scrollCtrl.addListener(_onScroll);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      final s = _searchCtrl.text.trim();
      ref.read(orderFiltersProvider.notifier).setSearch(s.isEmpty ? null : s);
    });
  }

  void _onScroll() {
    if (!_scrollCtrl.hasClients) return;
    final pos = _scrollCtrl.position;
    if (pos.pixels >= pos.maxScrollExtent - 600) {
      ref.read(orderListProvider.notifier).loadMore();
    }
  }

  Future<void> _createOrder() async {
    unawaited(context.push('/orders/new'));
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final c = kuruColors(context);
    final async = ref.watch(orderListProvider);
    final filters = ref.watch(orderFiltersProvider);
    final notifier = ref.read(orderFiltersProvider.notifier);

    final activeFilterCount = _activeFilterCount(filters);
    final activeChips = _activeChips(context, filters, notifier);

    return Scaffold(
      backgroundColor: c.pageBg,
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: () async => ref.invalidate(orderListProvider),
          child: CustomScrollView(
            controller: _scrollCtrl,
            cacheExtent: 900,
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 12, 18, 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          l.orderListTitle,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.8,
                          ),
                        ),
                      ),
                      FilledButton.icon(
                        onPressed: _createOrder,
                        icon: const Icon(TablerIcons.plus),
                        label: Text(l.orderListNewOrder),
                        style: FilledButton.styleFrom(
                          minimumSize: const Size(0, 38),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 14),
                  child: Text(
                    async.maybeWhen(
                      data: (p) => '${p.total} ${_unit(p.total, l)}',
                      orElse: () => 'Đang tải…',
                    ),
                    style: TextStyle(fontSize: 13, color: c.textMuted),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: _OrderFilterBar(
                  searchController: _searchCtrl,
                  hintText: l.orderListSearchHint,
                  activeCount: activeFilterCount,
                  activeChips: activeChips,
                  onFilterTap: () => showOrderFilterSheet(context),
                  onClearAll: notifier.reset,
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                  child: _StatusTabs(
                    active: filters.status,
                    onChange: notifier.setStatus,
                    labels: _statusLabels(l),
                  ),
                ),
              ),
              async.when(
                loading: () => const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(48),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ),
                error: (e, _) => SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Center(child: Text('Không tải được đơn: $e')),
                  ),
                ),
                data: (page) {
                  if (page.orders.isEmpty) {
                    return SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 48),
                        child: Column(
                          children: [
                            const Icon(
                              TablerIcons.receipt,
                              size: 56,
                              color: Color(0xFF94A3B8),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              filters.isEmptyOfFilters
                                  ? l.orderListEmptyAll
                                  : l.orderListEmptyFiltered,
                              style: TextStyle(
                                fontSize: 16,
                                color: c.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Tạo đơn đầu tiên để bắt đầu.',
                              style: TextStyle(
                                fontSize: 13,
                                color: c.textMuted,
                              ),
                            ),
                            if (filters.isEmptyOfFilters) ...[
                              const SizedBox(height: 16),
                              FilledButton(
                                onPressed: _createOrder,
                                child: Text(l.orderListEmptyCta),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  }
                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: c.surfaceElev,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          children: [
                            for (var i = 0; i < page.orders.length; i++) ...[
                              OrderListRow(
                                summary: page.orders[i],
                                onTap: () => context.push(
                                  '/orders/${page.orders[i].id}',
                                ),
                              ),
                              if (i < page.orders.length - 1)
                                Padding(
                                  padding: const EdgeInsets.only(left: 66),
                                  child: Divider(
                                    height: 1,
                                    thickness: 0.5,
                                    color: c.borderSoft,
                                  ),
                                ),
                            ],
                            if (page.hasMore)
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child: Center(
                                  child: SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 96)),
            ],
          ),
        ),
      ),
    );
  }

  String _unit(int n, AppLocalizations l) => n == 1 ? 'đơn hàng' : 'đơn hàng';

  Map<OrderStatus?, String> _statusLabels(AppLocalizations l) => {
    null: l.orderStatusAll,
    OrderStatus.draft: l.orderStatusDraft,
    OrderStatus.pending: l.orderStatusPending,
    OrderStatus.completed: l.orderStatusCompleted,
    OrderStatus.cancelled: l.orderStatusCancelled,
  };

  int _activeFilterCount(OrderListFilters f) {
    var n = 0;
    if (f.paymentStatus != null) n++;
    if (f.saleChannel != null) n++;
    if (f.fromDate != null || f.toDate != null) n++;
    return n;
  }

  List<_OrderChipData> _activeChips(
    BuildContext context,
    OrderListFilters f,
    OrderFiltersNotifier notifier,
  ) {
    final l = AppLocalizations.of(context);
    final chips = <_OrderChipData>[];
    if (f.paymentStatus != null) {
      chips.add(
        _OrderChipData(
          label: 'TT: ${_paymentLabel(f.paymentStatus!, l)}',
          onRemove: () => notifier.setPaymentStatus(null),
        ),
      );
    }
    if (f.saleChannel != null) {
      chips.add(
        _OrderChipData(
          label: 'Kênh: ${_channelLabel(f.saleChannel!, l)}',
          onRemove: () => notifier.setSaleChannel(null),
        ),
      );
    }
    if (f.fromDate != null || f.toDate != null) {
      chips.add(
        _OrderChipData(
          label: _dateLabel(f.fromDate, f.toDate),
          onRemove: () => notifier.setDateRange(null, null),
        ),
      );
    }
    return chips;
  }

  String _paymentLabel(OrderPaymentStatus s, AppLocalizations l) => switch (s) {
    OrderPaymentStatus.unpaid => l.orderPaymentStatusUnpaid,
    OrderPaymentStatus.partial => l.orderPaymentStatusPartial,
    OrderPaymentStatus.paid => l.orderPaymentStatusPaid,
  };

  String _channelLabel(OrderSaleChannel c, AppLocalizations l) => switch (c) {
    OrderSaleChannel.shop => l.orderSaleChannelShop,
    OrderSaleChannel.ecommerce => l.orderSaleChannelEcommerce,
  };

  String _dateLabel(DateTime? from, DateTime? to) {
    final fmt = DateFormat('dd/MM');
    if (from != null && to != null) {
      return '${fmt.format(from)} → ${fmt.format(to)}';
    }
    if (from != null) return 'Từ ${fmt.format(from)}';
    return 'Đến ${fmt.format(to!)}';
  }
}

class _OrderChipData {
  const _OrderChipData({required this.label, required this.onRemove});
  final String label;
  final VoidCallback onRemove;
}

class _OrderFilterBar extends StatelessWidget {
  const _OrderFilterBar({
    required this.searchController,
    required this.hintText,
    required this.activeCount,
    required this.activeChips,
    required this.onFilterTap,
    required this.onClearAll,
  });

  final TextEditingController searchController;
  final String hintText;
  final int activeCount;
  final List<_OrderChipData> activeChips;
  final VoidCallback onFilterTap;
  final VoidCallback onClearAll;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: hintText,
                    prefixIcon: const Icon(TablerIcons.search, size: 18),
                    filled: true,
                    fillColor: c.surfaceElev,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 13),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _FilterButton(count: activeCount, onTap: onFilterTap),
            ],
          ),
          if (activeChips.isNotEmpty) ...[
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final chip in activeChips) ...[
                    _ActiveChip(label: chip.label, onRemove: chip.onRemove),
                    const SizedBox(width: 7),
                  ],
                  TextButton(
                    onPressed: onClearAll,
                    style: TextButton.styleFrom(
                      minimumSize: const Size(0, 32),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text('Xóa lọc'),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _FilterButton extends StatelessWidget {
  const _FilterButton({required this.count, required this.onTap});

  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Material(
      color: c.surfaceElev,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(
              color: count > 0 ? c.accent500 : c.borderSoft,
              width: count > 0 ? 1.4 : 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                TablerIcons.adjustments_horizontal,
                size: 19,
                color: c.textPrimary,
              ),
              if (count > 0) ...[
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
                    '$count',
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

class _ActiveChip extends StatelessWidget {
  const _ActiveChip({required this.label, required this.onRemove});

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

class _StatusTabs extends StatelessWidget {
  const _StatusTabs({
    required this.active,
    required this.onChange,
    required this.labels,
  });

  final OrderStatus? active;
  final ValueChanged<OrderStatus?> onChange;
  final Map<OrderStatus?, String> labels;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final entry in labels.entries) ...[
            _Tab(
              label: entry.value,
              selected: entry.key == active,
              onTap: () => onChange(entry.key),
              colors: c,
            ),
            const SizedBox(width: 6),
          ],
        ],
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.colors,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final KuruColors colors;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? colors.accent600 : colors.surfaceElev,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : colors.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
