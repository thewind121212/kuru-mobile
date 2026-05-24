import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kuru_mobile/features/orders/models/order_summary.dart';

part 'order_overview_page.freezed.dart';

@freezed
class OrderOverviewPage with _$OrderOverviewPage {
  const factory OrderOverviewPage({
    required List<OrderSummary> orders,
    required int total,
    required int page,
    required int limit,
  }) = _OrderOverviewPage;

  const OrderOverviewPage._();

  bool get hasMore => page * limit < total;

  factory OrderOverviewPage.fromJson(Map<String, dynamic> json) {
    return OrderOverviewPage(
      orders: (json['orders'] as List<dynamic>? ?? const [])
          .map((e) => OrderSummary.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num?)?.toInt() ?? 0,
      page: (json['page'] as num?)?.toInt() ?? 1,
      limit: (json['limit'] as num?)?.toInt() ?? 20,
    );
  }
}
