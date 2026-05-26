// flutter_tabler_icons uses snake_case symbols.
// ignore_for_file: non_constant_identifier_names
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
import 'package:kuru_mobile/core/auth/auth_providers.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/features/expenses/models/expense_summary.dart';
import 'package:kuru_mobile/features/expenses/providers/expense_providers.dart';
import 'package:kuru_mobile/features/imports/models/purchase_summary.dart';
import 'package:kuru_mobile/features/imports/providers/purchase_providers.dart';
import 'package:kuru_mobile/features/orders/models/order_list_filters.dart';
import 'package:kuru_mobile/features/orders/models/order_overview_page.dart';
import 'package:kuru_mobile/features/orders/models/order_payment_status.dart';
import 'package:kuru_mobile/features/orders/models/order_status.dart';
import 'package:kuru_mobile/features/orders/models/order_summary.dart';
import 'package:kuru_mobile/features/orders/providers/order_providers.dart';

final homeLedgerProvider = FutureProvider<HomeLedgerSnapshot>((ref) async {
  ref.watch(currentOrgIdProvider);
  final expenseSummary = await ref.watch(expenseSummaryProvider.future);
  final purchaseSummary = await ref.watch(purchasePostedSummaryProvider.future);
  final orgId = ref.read(currentOrgIdProvider);
  if (orgId == null) throw StateError('No org selected');

  final page = await ref
      .read(orderRepositoryProvider)
      .getOrderOverview(
        orgId: orgId,
        filters: const OrderListFilters(limit: 10),
      )
      .unwrap();

  return HomeLedgerSnapshot.fromPage(
    page,
    expenseSummary: expenseSummary,
    purchaseSummary: purchaseSummary,
  );
});

class HomeLedgerSnapshot {
  const HomeLedgerSnapshot({
    required this.orders,
    required this.totalOrders,
    required this.salesTotal,
    required this.collected,
    required this.receivable,
    required this.expenses,
    required this.expenseCount,
  });

  factory HomeLedgerSnapshot.fromPage(
    OrderOverviewPage page, {
    required ExpenseSummary expenseSummary,
    required PurchaseSummary purchaseSummary,
  }) {
    final booked = page.orders.where((o) => o.status != OrderStatus.cancelled);
    var salesTotal = 0.0;
    var collected = 0.0;
    var receivable = 0.0;

    for (final order in booked) {
      salesTotal += order.totalAmount;
      collected += order.paidAmount;
      receivable += math.max(0, order.totalAmount - order.paidAmount);
    }

    return HomeLedgerSnapshot(
      orders: page.orders,
      totalOrders: page.total,
      salesTotal: salesTotal,
      collected: collected,
      receivable: receivable,
      expenses: expenseSummary.monthTotal + purchaseSummary.totalCost,
      expenseCount: expenseSummary.count + purchaseSummary.entryCount,
    );
  }

  final List<OrderSummary> orders;
  final int totalOrders;
  final double salesTotal;
  final double collected;
  final double receivable;
  final int expenses;
  final int expenseCount;

  double get balance => collected - expenses;
}

class HomeStubScreen extends ConsumerWidget {
  const HomeStubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = kuruColors(context);
    final bootstrap = ref.watch(appBootstrapProvider);

    return Scaffold(
      backgroundColor: c.pageBg,
      body: SafeArea(
        bottom: false,
        child: bootstrap.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (state) {
            if (state is! BootstrapAuthed) {
              return const Center(child: Text('No session'));
            }
            final org = state.user.orgInfos.isNotEmpty
                ? state.user.orgInfos.first
                : null;
            return _HomeLedgerView(
              userName: state.user.name ?? state.user.email ?? 'kuru',
              orgName: org?.name ?? 'Cửa hàng',
            );
          },
        ),
      ),
    );
  }
}

class _HomeLedgerView extends ConsumerWidget {
  const _HomeLedgerView({required this.userName, required this.orgName});

  final String userName;
  final String orgName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = kuruColors(context);
    final ledger = ref.watch(homeLedgerProvider);

    return RefreshIndicator(
      onRefresh: () => ref.refresh(homeLedgerProvider.future),
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Sổ cái',
                              style: TextStyle(
                                color: c.textPrimary,
                                fontSize: 32,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.8,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$orgName · Xin chào $userName',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13,
                                color: c.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: ledger.when(
              loading: () => const _LedgerLoading(),
              error: (e, _) => _LedgerError(
                message: '$e',
                onRetry: () => ref.invalidate(homeLedgerProvider),
              ),
              data: (snapshot) => _LedgerBody(snapshot: snapshot),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 112)),
        ],
      ),
    );
  }
}

class _LedgerBody extends StatelessWidget {
  const _LedgerBody({required this.snapshot});

  final HomeLedgerSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final money = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: 'đ',
      decimalDigits: 0,
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _BalanceCard(
            balance: money.format(snapshot.balance),
            collected: money.format(snapshot.collected),
            receivable: money.format(snapshot.receivable),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _MetricCard(
                  icon: TablerIcons.receipt_2,
                  iconBg: const Color(0xFFE7F1FB),
                  iconFg: const Color(0xFF2563EB),
                  label: 'Doanh thu',
                  value: money.format(snapshot.salesTotal),
                  footnote: '${snapshot.totalOrders} đơn hàng',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _MetricCard(
                  icon: TablerIcons.wallet,
                  iconBg: const Color(0xFFE6F7F0),
                  iconFg: const Color(0xFF059669),
                  label: 'Đã thu',
                  value: money.format(snapshot.collected),
                  footnote: 'Tiền vào',
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _MetricCard(
                  icon: TablerIcons.clock_dollar,
                  iconBg: const Color(0xFFFEF6E5),
                  iconFg: const Color(0xFFD97706),
                  label: 'Còn phải thu',
                  value: money.format(snapshot.receivable),
                  footnote: 'Công nợ khách',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _MetricCard(
                  icon: TablerIcons.cash_banknote_off,
                  iconBg: const Color(0xFFFBE9EC),
                  iconFg: const Color(0xFFE11D48),
                  label: 'Chi phí',
                  value: money.format(snapshot.expenses),
                  footnote: '${snapshot.expenseCount} khoản đã ghi',
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const _QuickActions(),
          const SizedBox(height: 18),
          _SectionHeader(
            title: 'Sổ tiền gần đây',
            actionLabel: 'Xem đơn',
            onTap: () => context.go('/orders'),
          ),
          const SizedBox(height: 10),
          if (snapshot.orders.isEmpty)
            _EmptyLedgerCard(onCreate: () => context.push('/orders/new'))
          else
            ...snapshot.orders
                .take(5)
                .map(
                  (order) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _LedgerRow(order: order, money: money),
                  ),
                ),
          const SizedBox(height: 8),
          _ExpenseShortcut(onTap: () => context.go('/expenses')),
        ],
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({
    required this.balance,
    required this.collected,
    required this.receivable,
  });

  final String balance;
  final String collected;
  final String receivable;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: c.primary,
        borderRadius: BorderRadius.circular(22),
        boxShadow: c.shadowMd,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(TablerIcons.scale, color: Colors.white),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
                  'Dòng tiền',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            balance,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 34,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Số dư tạm tính từ đơn hàng đã ghi nhận',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.78),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _BalancePill(label: 'Đã thu', value: collected),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _BalancePill(label: 'Phải thu', value: receivable),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BalancePill extends StatelessWidget {
  const _BalancePill({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.icon,
    required this.iconBg,
    required this.iconFg,
    required this.label,
    required this.value,
    required this.footnote,
  });

  final IconData icon;
  final Color iconBg;
  final Color iconFg;
  final String label;
  final String value;
  final String footnote;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: c.surfaceElev,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20, color: iconFg),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              color: c.textMuted,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: c.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            footnote,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 12, color: c.textMuted),
          ),
        ],
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _QuickAction(
            icon: TablerIcons.cash_register,
            label: 'Bán hàng',
            onTap: () => context.push('/pos'),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _QuickAction(
            icon: TablerIcons.plus,
            label: 'Tạo đơn',
            onTap: () => context.push('/orders/new'),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _QuickAction(
            icon: TablerIcons.package,
            label: 'Kho',
            onTap: () => context.go('/catalog/products'),
          ),
        ),
      ],
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Material(
      color: c.surfaceElev,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Column(
            children: [
              Icon(icon, color: c.primary, size: 22),
              const SizedBox(height: 6),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: c.textPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.actionLabel,
    required this.onTap,
  });

  final String title;
  final String actionLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: c.textPrimary,
            ),
          ),
        ),
        TextButton(onPressed: onTap, child: Text(actionLabel)),
      ],
    );
  }
}

class _LedgerRow extends StatelessWidget {
  const _LedgerRow({required this.order, required this.money});

  final OrderSummary order;
  final NumberFormat money;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final isPaid = order.paymentStatus == OrderPaymentStatus.paid;
    final isCancelled = order.status == OrderStatus.cancelled;
    final iconColor = isCancelled
        ? c.danger
        : isPaid
        ? c.success
        : c.warning;
    final iconBg = isCancelled
        ? c.dangerSoft
        : isPaid
        ? c.successSoft
        : c.warningSoft;

    return Material(
      color: c.surfaceElev,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: () => context.push('/orders/${order.id}'),
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(_orderIcon(order), color: iconColor, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (order.customerName?.isNotEmpty ?? false)
                          ? order.customerName!
                          : order.orderNumber,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: c.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${order.orderNumber} · ${_paymentLabel(order)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12, color: c.textMuted),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    money.format(order.totalAmount),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: isCancelled ? c.textMuted : c.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    DateFormat('dd/MM').format(order.createdAt),
                    style: TextStyle(fontSize: 12, color: c.textMuted),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _orderIcon(OrderSummary order) {
    if (order.status == OrderStatus.cancelled) return TablerIcons.ban;
    if (order.paymentStatus == OrderPaymentStatus.paid) {
      return TablerIcons.circle_check;
    }
    return TablerIcons.clock;
  }

  String _paymentLabel(OrderSummary order) {
    if (order.status == OrderStatus.cancelled) return 'Đã hủy';
    return switch (order.paymentStatus) {
      OrderPaymentStatus.paid => 'Đã thanh toán',
      OrderPaymentStatus.partial => 'Thanh toán một phần',
      OrderPaymentStatus.unpaid => 'Chưa thanh toán',
    };
  }
}

class _EmptyLedgerCard extends StatelessWidget {
  const _EmptyLedgerCard({required this.onCreate});

  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: c.surfaceElev,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Icon(TablerIcons.receipt_off, size: 42, color: c.textMuted),
          const SizedBox(height: 10),
          Text(
            'Chưa có giao dịch',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: c.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Tạo đơn đầu tiên để sổ cái bắt đầu ghi dòng tiền.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: c.textMuted),
          ),
          const SizedBox(height: 14),
          FilledButton.icon(
            onPressed: onCreate,
            icon: const Icon(TablerIcons.plus),
            label: const Text('Tạo đơn'),
          ),
        ],
      ),
    );
  }
}

class _ExpenseShortcut extends StatelessWidget {
  const _ExpenseShortcut({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Material(
      color: c.surfaceElev,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: c.dangerSoft,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(TablerIcons.cash_banknote_off, color: c.danger),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quản lý chi phí',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: c.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Ghi nhận tiền nhập hàng, vận chuyển '
                      'và chi phí vận hành.',
                      style: TextStyle(fontSize: 12, color: c.textMuted),
                    ),
                  ],
                ),
              ),
              Icon(TablerIcons.chevron_right, color: c.textMuted),
            ],
          ),
        ),
      ),
    );
  }
}

class _LedgerLoading extends StatelessWidget {
  const _LedgerLoading();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(48),
      child: Center(child: CircularProgressIndicator()),
    );
  }
}

class _LedgerError extends StatelessWidget {
  const _LedgerError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: c.surfaceElev,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [
            Icon(TablerIcons.alert_circle, size: 40, color: c.danger),
            const SizedBox(height: 10),
            Text(
              'Không tải được sổ cái',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: c.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: c.textMuted),
            ),
            const SizedBox(height: 14),
            OutlinedButton(onPressed: onRetry, child: const Text('Tải lại')),
          ],
        ),
      ),
    );
  }
}
