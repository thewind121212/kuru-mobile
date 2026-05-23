import 'package:dio/dio.dart';
import 'package:kuru_mobile/core/logging/log.dart';
import 'package:kuru_mobile/core/network/api_exception.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/core/network/dio_client.dart' show mapDioError;
import 'package:kuru_mobile/features/orders/models/order_cart_draft.dart';
import 'package:kuru_mobile/features/orders/models/order_detail.dart';
import 'package:kuru_mobile/features/orders/models/order_line_item.dart';
import 'package:kuru_mobile/features/orders/models/order_list_filters.dart';
import 'package:kuru_mobile/features/orders/models/order_overview_page.dart';
import 'package:kuru_mobile/features/orders/models/order_payment_method.dart';
import 'package:kuru_mobile/features/orders/models/order_status.dart';
import 'package:uuid/uuid.dart';

/// Hand-built request maps per CLAUDE.md (Zod DTO is the contract; no codegen).
class OrderRepository {
  OrderRepository(this._dio, {String Function()? uuidFactory})
    : _uuid = uuidFactory ?? (() => const Uuid().v4());

  final Dio _dio;
  final String Function() _uuid;

  /// Generates a fresh UUIDv4 idempotency key.
  /// Callers (e.g. OrderCartNotifier) invoke this before submitting an order.
  String newIdempotencyKey() => _uuid();

  Future<ApiResult<OrderOverviewPage>> getOrderOverview({
    required String orgId,
    required OrderListFilters filters,
  }) async {
    try {
      final q = <String, dynamic>{
        'orgId': orgId,
        'page': filters.page,
        'limit': filters.limit,
      };
      if (filters.search != null && filters.search!.isNotEmpty) {
        q['searchString'] = filters.search;
      }
      if (filters.status != null) q['status'] = filters.status!.toWire();
      if (filters.paymentStatus != null) {
        q['paymentStatus'] = filters.paymentStatus!.toWire();
      }
      if (filters.fromDate != null) {
        q['fromDate'] = filters.fromDate!.toIso8601String();
      }
      if (filters.toDate != null) {
        q['toDate'] = filters.toDate!.toIso8601String();
      }
      if (filters.saleChannel != null) {
        q['saleChannel'] = filters.saleChannel!.toWire();
      }

      final res = await _dio.get<dynamic>(
        '/order/GetOrderOverview',
        queryParameters: q,
      );
      final data =
          (res.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
      final count = (data['orders'] as List?)?.length ?? 0;
      log.i('GetOrderOverview ← ${res.statusCode} count=$count');
      return ApiResult.success(OrderOverviewPage.fromJson(data));
    } on DioException catch (e) {
      log.w('GetOrderOverview failed: ${e.message}');
      return ApiResult.failure(_extract(e));
    }
  }

  Future<ApiResult<OrderDetail>> getOrderById(String orderId) async {
    try {
      final res = await _dio.get<dynamic>(
        '/order/GetOrderById',
        queryParameters: {'orderId': orderId},
      );
      final data =
          (res.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
      log.i('GetOrderById ← ${res.statusCode} orderId=$orderId');
      return ApiResult.success(OrderDetail.fromJson(data));
    } on DioException catch (e) {
      log.w('GetOrderById failed: ${e.message}');
      return ApiResult.failure(_extract(e));
    }
  }

  Future<ApiResult<String>> createOrder({
    required String orgId,
    required String idempotencyKey,
    required OrderCartDraft draft,
    OrderPaymentInput? payment,
  }) async {
    try {
      String? trimOrNull(String? s) {
        final t = s?.trim();
        return (t == null || t.isEmpty) ? null : t;
      }

      final body = <String, dynamic>{
        'orgId': orgId,
        'idempotencyKey': idempotencyKey,
        'items': draft.items.map(_lineItemToJson).toList(),
      };

      final customerName = trimOrNull(draft.customerName);
      if (customerName != null) body['customerName'] = customerName;
      final customerPhone = trimOrNull(draft.customerPhone);
      if (customerPhone != null) body['customerPhone'] = customerPhone;
      final note = trimOrNull(draft.note);
      if (note != null) body['note'] = note;

      if (draft.discountType != null && draft.discountValue != null) {
        body['discountType'] = draft.discountType!.toWire();
        body['discountValue'] = draft.discountValue;
      }
      body['saleChannel'] = draft.saleChannel.toWire();

      if (payment != null) body['payment'] = payment.toJson();

      final res = await _dio.post<dynamic>('/order/CreateOrder', data: body);
      if (res.statusCode != 200 && res.statusCode != 201) {
        log.w('CreateOrder unexpected status ${res.statusCode}');
      }
      final data =
          (res.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
      final orderId = data['orderId'] as String?;
      if (orderId == null) {
        log.w('CreateOrder missing orderId in response');
        return ApiResult.failure(
          ServerException(
            'Server did not return an orderId',
            statusCode: res.statusCode ?? 0,
          ),
        );
      }
      log.i('CreateOrder ← ${res.statusCode} orderId=$orderId');
      return ApiResult.success(orderId);
    } on DioException catch (e) {
      log.w('CreateOrder failed: ${e.message}');
      return ApiResult.failure(_extract(e));
    }
  }

  Future<ApiResult<void>> updateOrderStatus({
    required String orderId,
    required OrderStatus status,
    String? cancelledReason,
    String? note,
  }) async {
    try {
      final body = <String, dynamic>{
        'orderId': orderId,
        'status': status.toWire(),
      };
      if (status == OrderStatus.cancelled &&
          cancelledReason != null &&
          cancelledReason.trim().isNotEmpty) {
        body['cancelledReason'] = cancelledReason.trim();
      }
      if (note != null && note.trim().isNotEmpty) {
        body['note'] = note.trim();
      }
      await _dio.post<dynamic>('/order/UpdateOrderStatus', data: body);
      log.i('UpdateOrderStatus ← orderId=$orderId status=${status.toWire()}');
      return ApiResult.success(null);
    } on DioException catch (e) {
      log.w('UpdateOrderStatus failed: ${e.message}');
      return ApiResult.failure(_extract(e));
    }
  }

  Future<ApiResult<String>> addOrderPayment({
    required String orderId,
    required String idempotencyKey,
    required OrderPaymentMethod method,
    required double amount,
    String? reference,
    String? note,
  }) async {
    try {
      final body = <String, dynamic>{
        'orderId': orderId,
        'idempotencyKey': idempotencyKey,
        'method': method.toWire(),
        'amount': amount,
      };
      if (reference != null && reference.trim().isNotEmpty) {
        body['reference'] = reference.trim();
      }
      if (note != null && note.trim().isNotEmpty) {
        body['note'] = note.trim();
      }
      final res = await _dio.post<dynamic>(
        '/order/AddOrderPayment',
        data: body,
      );
      final data =
          (res.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
      final paymentId = data['paymentId'] as String? ?? '';
      log.i('AddOrderPayment ← ${res.statusCode} paymentId=$paymentId');
      return ApiResult.success(paymentId);
    } on DioException catch (e) {
      log.w('AddOrderPayment failed: ${e.message}');
      return ApiResult.failure(_extract(e));
    }
  }

  Future<ApiResult<void>> voidOrder({required String orderId}) async {
    try {
      await _dio.post<dynamic>(
        '/order/VoidOrder',
        data: <String, dynamic>{'orderId': orderId},
      );
      log.i('VoidOrder ← orderId=$orderId');
      return ApiResult.success(null);
    } on DioException catch (e) {
      log.w('VoidOrder failed: ${e.message}');
      return ApiResult.failure(_extract(e));
    }
  }

  Map<String, dynamic> _lineItemToJson(OrderLineItem item) {
    final m = <String, dynamic>{
      'productId': item.productId,
      'productName': item.productName,
      'baseUnitCode': item.baseUnitCode,
      'qty': item.qty,
      'unitPrice': item.unitPrice,
    };
    if (item.variantId != null && item.variantId!.isNotEmpty) {
      m['variantId'] = item.variantId;
    }
    if (item.variantName != null && item.variantName!.isNotEmpty) {
      m['variantName'] = item.variantName;
    }
    if (item.imageUrl != null && item.imageUrl!.isNotEmpty) {
      m['imageUrl'] = item.imageUrl;
    }
    if (item.barcode != null && item.barcode!.isNotEmpty) {
      m['barcode'] = item.barcode;
    }
    if (item.discountType != null && item.discountValue != null) {
      m['discountType'] = item.discountType!.toWire();
      m['discountValue'] = item.discountValue;
    }
    return m;
  }

  /// Converts a [DioException] into a typed [ApiException].
  ///
  /// Prefers any [ApiException] already attached to `e.error` by the
  /// error-mapping interceptor — those carry exact status-code semantics.
  /// Falls back to [mapDioError] for raw exceptions (e.g. from unit tests).
  ApiException _extract(DioException e) {
    final mapped = mapDioError(e);
    return mapped;
  }
}

class OrderPaymentInput {
  const OrderPaymentInput({
    required this.method,
    required this.amount,
    this.reference,
    this.note,
  });

  final OrderPaymentMethod method;
  final double amount;
  final String? reference;
  final String? note;

  Map<String, dynamic> toJson() {
    final m = <String, dynamic>{'method': method.toWire(), 'amount': amount};
    if (reference != null && reference!.isNotEmpty) m['reference'] = reference;
    if (note != null && note!.isNotEmpty) m['note'] = note;
    return m;
  }
}
