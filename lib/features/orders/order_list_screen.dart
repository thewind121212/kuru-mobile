import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/design/core/feedback/k_empty_state.dart';
import 'package:kuru_mobile/design/core/feedback/k_skeleton.dart';
import 'package:kuru_mobile/design/core/input/k_search_bar.dart';
import 'package:kuru_mobile/design/core/input/k_secondary_btn.dart';
import 'package:kuru_mobile/design/core/input/k_tab_nav.dart';
import 'package:kuru_mobile/design/core/layout/k_page_header.dart';
import 'package:kuru_mobile/features/orders/models/order_status.dart';
import 'package:kuru_mobile/features/orders/providers/order_providers.dart';
import 'package:kuru_mobile/features/orders/widgets/order_filter_sheet.dart';
import 'package:kuru_mobile/features/orders/widgets/order_list_row.dart';

class OrderListScreen extends ConsumerWidget {
  const OrderListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final async = ref.watch(orderListProvider);
    final filters = ref.watch(orderFiltersProvider);
    final notifier = ref.read(orderFiltersProvider.notifier);

    final tabs = <KTabItem<OrderStatus?>>[
      KTabItem(id: null, label: l.orderStatusAll),
      KTabItem(id: OrderStatus.draft, label: l.orderStatusDraft),
      KTabItem(id: OrderStatus.pending, label: l.orderStatusPending),
      KTabItem(id: OrderStatus.completed, label: l.orderStatusCompleted),
      KTabItem(id: OrderStatus.cancelled, label: l.orderStatusCancelled),
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            KPageHeader(
              title: l.orderListTitle,
              actions: [
                IconButton(
                  icon: const Icon(TablerIcons.filter),
                  onPressed: () => showOrderFilterSheet(context),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: KSearchBar(
                hint: l.orderListSearchHint,
                onChanged: notifier.setSearch,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: KTabNav<OrderStatus?>(
                tabs: tabs,
                active: filters.status,
                onChange: notifier.setStatus,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async => ref.invalidate(orderListProvider),
                child: async.when(
                  data: (page) {
                    if (page.orders.isEmpty) {
                      return ListView(
                        children: [
                          KEmptyState(
                            icon: TablerIcons.receipt,
                            title: filters.isEmptyOfFilters
                                ? l.orderListEmptyAll
                                : l.orderListEmptyFiltered,
                            action: filters.isEmptyOfFilters
                                ? KSecondaryBtn(
                                    label: l.orderListEmptyCta,
                                    fullWidth: false,
                                    onPressed: () =>
                                        context.push('/orders/new'),
                                  )
                                : null,
                          ),
                        ],
                      );
                    }
                    return ListView.builder(
                      itemCount: page.orders.length,
                      itemBuilder: (_, i) => OrderListRow(
                        summary: page.orders[i],
                        onTap: () =>
                            context.push('/orders/${page.orders[i].id}'),
                      ),
                    );
                  },
                  loading: () => ListView(
                    children: List.generate(
                      5,
                      (_) => const Padding(
                        padding: EdgeInsets.all(12),
                        child: KSkeleton(height: 56),
                      ),
                    ),
                  ),
                  error: (e, _) => Center(child: Text('$e')),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/orders/new'),
        label: Text(l.orderListNewOrder),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
