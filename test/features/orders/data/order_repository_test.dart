import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/core/network/api_exception.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/features/orders/data/order_repository.dart';
import 'package:kuru_mobile/features/orders/models/order_cart_draft.dart';
import 'package:kuru_mobile/features/orders/models/order_detail.dart';
import 'package:kuru_mobile/features/orders/models/order_line_item.dart';
import 'package:kuru_mobile/features/orders/models/order_list_filters.dart';
import 'package:kuru_mobile/features/orders/models/order_overview_page.dart';
import 'package:kuru_mobile/features/orders/models/order_payment_method.dart';
import 'package:kuru_mobile/features/orders/models/order_status.dart';
import 'package:mocktail/mocktail.dart';

class _MockDio extends Mock implements Dio {}

class _FakeRequestOptions extends Fake implements RequestOptions {}

// ─────────────────────── top-level fixture helpers ───────────────────────────

Map<String, dynamic> orderSummaryJson({String id = 'ord-1'}) =>
    <String, dynamic>{
      'id': id,
      'orgId': 'org-1',
      'orderNumber': 'ORD-001',
      'status': 'PENDING',
      'paymentStatus': 'UNPAID',
      'totalAmount': 50000.0,
      'paidAmount': 0.0,
      'itemCount': 1,
      'createdAt': '2026-05-23T00:00:00.000Z',
      'saleChannel': 'SHOP',
    };

Map<String, dynamic> orderDetailJson({String id = 'ord-1'}) =>
    <String, dynamic>{
      'id': id,
      'orgId': 'org-1',
      'orderNumber': 'ORD-001',
      'status': 'PENDING',
      'paymentStatus': 'UNPAID',
      'subtotal': 50000.0,
      'totalAmount': 50000.0,
      'paidAmount': 0.0,
      'changeAmount': 0.0,
      'itemCount': 1,
      'createdAt': '2026-05-23T00:00:00.000Z',
      'updatedAt': '2026-05-23T00:00:00.000Z',
      'createdBy': 'user-1',
      'saleChannel': 'SHOP',
      'items': <dynamic>[],
      'payments': <dynamic>[],
    };

// Minimal OrderLineItem fixture used in createOrder tests.
const lineItem = OrderLineItem(
  productId: 'p_1',
  productName: 'X',
  baseUnitCode: 'pcs',
  qty: 1,
  unitPrice: 10000,
);

void main() {
  setUpAll(() {
    registerFallbackValue(_FakeRequestOptions());
  });

  late _MockDio dio;
  late OrderRepository repo;

  setUp(() {
    dio = _MockDio();
    repo = OrderRepository(dio, uuidFactory: () => 'fixed-uuid');
  });

  // ─────────────────────────── helpers ─────────────────────────────────────

  Response<dynamic> ok200(Map<String, dynamic> data) => Response<dynamic>(
    statusCode: 200,
    requestOptions: RequestOptions(),
    data: <String, dynamic>{
      'success': true,
      'data': data,
      'timestamp': '2026-05-23T00:00:00.000Z',
    },
  );

  Response<dynamic> ok201(Map<String, dynamic> data) => Response<dynamic>(
    statusCode: 201,
    requestOptions: RequestOptions(),
    data: <String, dynamic>{
      'success': true,
      'data': data,
      'timestamp': '2026-05-23T00:00:00.000Z',
    },
  );

  DioException dioError400(String message, {String code = 'BAD_REQUEST'}) {
    final req = RequestOptions();
    return DioException(
      requestOptions: req,
      response: Response<dynamic>(
        statusCode: 400,
        requestOptions: req,
        data: <String, dynamic>{
          'success': false,
          'error': <String, dynamic>{'message': message, 'code': code},
          'timestamp': '2026-05-23T00:00:00.000Z',
        },
      ),
      type: DioExceptionType.badResponse,
    );
  }

  // ─────────────────────────── tests ───────────────────────────────────────

  group('newIdempotencyKey', () {
    test('delegates to the injected factory', () {
      expect(repo.newIdempotencyKey(), 'fixed-uuid');
    });
  });

  // ─── getOrderOverview ─────────────────────────────────────────────────────

  group('getOrderOverview', () {
    test(
      'builds query with orgId + defaults, parses paginated response',
      () async {
        when(
          () => dio.get<dynamic>(
            any(),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer(
          (_) async => ok200(<String, dynamic>{
            'orders': <dynamic>[orderSummaryJson()],
            'total': 1,
            'page': 1,
            'limit': 20,
          }),
        );

        final result = await repo.getOrderOverview(
          orgId: 'org-1',
          filters: const OrderListFilters(),
        );

        expect(result, isA<ApiSuccess<OrderOverviewPage>>());
        final page = (result as ApiSuccess<OrderOverviewPage>).data;
        expect(page.orders, hasLength(1));
        expect(page.total, 1);
        expect(page.orders.first.id, 'ord-1');

        final captured =
            verify(
                  () => dio.get<dynamic>(
                    '/order/GetOrderOverview',
                    queryParameters: captureAny(named: 'queryParameters'),
                  ),
                ).captured.single
                as Map<String, dynamic>;
        expect(captured['orgId'], 'org-1');
        expect(captured['page'], 1);
        expect(captured['limit'], 20);
        // Optional fields must NOT be present when not supplied.
        expect(captured.containsKey('searchString'), isFalse);
        expect(captured.containsKey('status'), isFalse);
        expect(captured.containsKey('paymentStatus'), isFalse);
      },
    );

    test('includes optional filter fields when provided', () async {
      final from = DateTime.utc(2026, 3, 15);
      final to = DateTime.utc(2026, 12, 31);
      when(
        () => dio.get<dynamic>(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer(
        (_) async => ok200(<String, dynamic>{
          'orders': <dynamic>[],
          'total': 0,
          'page': 2,
          'limit': 10,
        }),
      );

      await repo.getOrderOverview(
        orgId: 'org-1',
        filters: OrderListFilters(
          page: 2,
          limit: 10,
          search: 'nike',
          status: OrderStatus.pending,
          fromDate: from,
          toDate: to,
        ),
      );

      final captured =
          verify(
                () => dio.get<dynamic>(
                  '/order/GetOrderOverview',
                  queryParameters: captureAny(named: 'queryParameters'),
                ),
              ).captured.single
              as Map<String, dynamic>;
      expect(captured['searchString'], 'nike');
      expect(captured['status'], 'PENDING');
      expect(captured['fromDate'], from.toIso8601String());
      expect(captured['toDate'], to.toIso8601String());
      expect(captured['page'], 2);
      expect(captured['limit'], 10);
    });

    test(
      '400 → ApiFailure<OrderOverviewPage> with BadRequestException',
      () async {
        when(
          () => dio.get<dynamic>(
            any(),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenThrow(dioError400('Invalid filter'));

        final result = await repo.getOrderOverview(
          orgId: 'org-1',
          filters: const OrderListFilters(),
        );

        expect(result, isA<ApiFailure<OrderOverviewPage>>());
        final failure = result as ApiFailure<OrderOverviewPage>;
        expect(failure.err, isA<BadRequestException>());
        expect((failure.err as BadRequestException).message, 'Invalid filter');
      },
    );
  });

  // ─── getOrderById ─────────────────────────────────────────────────────────

  group('getOrderById', () {
    test('200 parses and returns OrderDetail', () async {
      when(
        () => dio.get<dynamic>(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer((_) async => ok200(orderDetailJson()));

      final result = await repo.getOrderById('ord-1');

      expect(result, isA<ApiSuccess<OrderDetail>>());
      final detail = (result as ApiSuccess<OrderDetail>).data;
      expect(detail.id, 'ord-1');
      expect(detail.orderNumber, 'ORD-001');
      expect(detail.status, OrderStatus.pending);
    });

    test('passes orderId as query parameter', () async {
      when(
        () => dio.get<dynamic>(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer((_) async => ok200(orderDetailJson(id: 'ord-99')));

      await repo.getOrderById('ord-99');

      final captured =
          verify(
                () => dio.get<dynamic>(
                  '/order/GetOrderById',
                  queryParameters: captureAny(named: 'queryParameters'),
                ),
              ).captured.single
              as Map<String, dynamic>;
      expect(captured['orderId'], 'ord-99');
    });

    test('400 → ApiFailure<OrderDetail> with BadRequestException', () async {
      when(
        () => dio.get<dynamic>(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenThrow(dioError400('Order not found', code: 'NOT_FOUND'));

      final result = await repo.getOrderById('ord-missing');

      expect(result, isA<ApiFailure<OrderDetail>>());
      expect(
        (result as ApiFailure<OrderDetail>).err,
        isA<BadRequestException>(),
      );
    });
  });

  // ─── createOrder ──────────────────────────────────────────────────────────

  group('createOrder', () {
    test('returns orderId from 201 response', () async {
      when(() => dio.post<dynamic>(any(), data: any(named: 'data'))).thenAnswer(
        (_) async => ok201(<String, dynamic>{'orderId': 'new-ord-1'}),
      );

      final result = await repo.createOrder(
        orgId: 'org-1',
        idempotencyKey: 'fixed-uuid',
        draft: const OrderCartDraft(items: [lineItem]),
      );

      expect(result, isA<ApiSuccess<String>>());
      expect((result as ApiSuccess<String>).data, 'new-ord-1');
    });

    test('sends required fields + omits null/empty optional fields', () async {
      when(
        () => dio.post<dynamic>(any(), data: any(named: 'data')),
      ).thenAnswer((_) async => ok201(<String, dynamic>{'orderId': 'ord-2'}));

      await repo.createOrder(
        orgId: 'org-1',
        idempotencyKey: 'fixed-uuid',
        storeId: 'store-1',
        draft: const OrderCartDraft(
          items: [lineItem],
          customerName: '', // empty → must NOT appear in body
        ),
      );

      final body =
          verify(
                () => dio.post<dynamic>(
                  '/order/CreateOrder',
                  data: captureAny(named: 'data'),
                ),
              ).captured.single
              as Map<String, dynamic>;
      expect(body['orgId'], 'org-1');
      expect(body['idempotencyKey'], 'fixed-uuid');
      expect(body['saleChannel'], 'SHOP');
      expect(body['storeId'], 'store-1');
      final items = body['items'] as List<dynamic>;
      expect(items, hasLength(1));
      expect(items.first, containsPair('productId', 'p_1'));
      // Empty customerName must be stripped.
      expect(body.containsKey('customerName'), isFalse);
      // No payment supplied.
      expect(body.containsKey('payment'), isFalse);
    });

    test('200 response also accepted and returns orderId', () async {
      when(
        () => dio.post<dynamic>(any(), data: any(named: 'data')),
      ).thenAnswer((_) async => ok200(<String, dynamic>{'orderId': 'ord-3'}));

      final result = await repo.createOrder(
        orgId: 'org-1',
        idempotencyKey: 'fixed-uuid',
        draft: const OrderCartDraft(items: [lineItem]),
      );

      expect(result, isA<ApiSuccess<String>>());
      expect((result as ApiSuccess<String>).data, 'ord-3');
    });

    test('400 → ApiFailure<String> with BadRequestException', () async {
      when(
        () => dio.post<dynamic>(any(), data: any(named: 'data')),
      ).thenThrow(dioError400('Items list is empty'));

      final result = await repo.createOrder(
        orgId: 'org-1',
        idempotencyKey: 'fixed-uuid',
        draft: const OrderCartDraft(items: [lineItem]),
      );

      expect(result, isA<ApiFailure<String>>());
      final failure = result as ApiFailure<String>;
      expect(failure.err, isA<BadRequestException>());
      expect(
        (failure.err as BadRequestException).message,
        'Items list is empty',
      );
    });
  });

  // ─── updateOrderStatus ────────────────────────────────────────────────────

  group('updateOrderStatus', () {
    test('omits cancelledReason when status != cancelled', () async {
      when(
        () => dio.post<dynamic>(any(), data: any(named: 'data')),
      ).thenAnswer((_) async => ok200(<String, dynamic>{}));

      await repo.updateOrderStatus(
        orderId: 'ord-1',
        status: OrderStatus.completed,
        cancelledReason: 'should be stripped',
      );

      final body =
          verify(
                () => dio.post<dynamic>(
                  '/order/UpdateOrderStatus',
                  data: captureAny(named: 'data'),
                ),
              ).captured.single
              as Map<String, dynamic>;
      expect(body['orderId'], 'ord-1');
      expect(body['status'], 'COMPLETED');
      expect(body.containsKey('cancelledReason'), isFalse);
    });

    test('sends cancelledReason when status == cancelled', () async {
      when(
        () => dio.post<dynamic>(any(), data: any(named: 'data')),
      ).thenAnswer((_) async => ok200(<String, dynamic>{}));

      await repo.updateOrderStatus(
        orderId: 'ord-1',
        status: OrderStatus.cancelled,
        cancelledReason: 'customer asked',
      );

      final body =
          verify(
                () => dio.post<dynamic>(
                  '/order/UpdateOrderStatus',
                  data: captureAny(named: 'data'),
                ),
              ).captured.single
              as Map<String, dynamic>;
      expect(body['status'], 'CANCELLED');
      expect(body['cancelledReason'], 'customer asked');
    });

    test('returns ApiSuccess<void> on 200', () async {
      when(
        () => dio.post<dynamic>(any(), data: any(named: 'data')),
      ).thenAnswer((_) async => ok200(<String, dynamic>{}));

      final result = await repo.updateOrderStatus(
        orderId: 'ord-1',
        status: OrderStatus.pending,
      );

      expect(result, isA<ApiSuccess<void>>());
    });
  });

  // ─── addOrderPayment ──────────────────────────────────────────────────────

  group('addOrderPayment', () {
    test('builds body with idempotencyKey + wire method + amount; '
        'returns paymentId', () async {
      when(
        () => dio.post<dynamic>(any(), data: any(named: 'data')),
      ).thenAnswer((_) async => ok201(<String, dynamic>{'paymentId': 'pay-1'}));

      final result = await repo.addOrderPayment(
        orderId: 'ord-1',
        idempotencyKey: 'fixed-uuid',
        method: OrderPaymentMethod.bankTransfer,
        amount: 50000,
      );

      expect(result, isA<ApiSuccess<String>>());
      expect((result as ApiSuccess<String>).data, 'pay-1');

      final body =
          verify(
                () => dio.post<dynamic>(
                  '/order/AddOrderPayment',
                  data: captureAny(named: 'data'),
                ),
              ).captured.single
              as Map<String, dynamic>;
      expect(body['orderId'], 'ord-1');
      expect(body['idempotencyKey'], 'fixed-uuid');
      expect(body['method'], 'BANK_TRANSFER');
      expect(body['amount'], 50000.0);
      expect(body.containsKey('reference'), isFalse);
      expect(body.containsKey('note'), isFalse);
    });

    test('400 → ApiFailure<String> with BadRequestException', () async {
      when(
        () => dio.post<dynamic>(any(), data: any(named: 'data')),
      ).thenThrow(dioError400('Amount exceeds total'));

      final result = await repo.addOrderPayment(
        orderId: 'ord-1',
        idempotencyKey: 'fixed-uuid',
        method: OrderPaymentMethod.cash,
        amount: 999999,
      );

      expect(result, isA<ApiFailure<String>>());
      expect((result as ApiFailure<String>).err, isA<BadRequestException>());
    });
  });

  // ─── voidOrder ────────────────────────────────────────────────────────────

  group('voidOrder', () {
    test(
      'posts minimal body {orderId: ...} and returns ApiSuccess<void>',
      () async {
        when(
          () => dio.post<dynamic>(any(), data: any(named: 'data')),
        ).thenAnswer((_) async => ok200(<String, dynamic>{}));

        final result = await repo.voidOrder(orderId: 'ord-1');

        expect(result, isA<ApiSuccess<void>>());

        final body =
            verify(
                  () => dio.post<dynamic>(
                    '/order/VoidOrder',
                    data: captureAny(named: 'data'),
                  ),
                ).captured.single
                as Map<String, dynamic>;
        expect(body, equals(<String, dynamic>{'orderId': 'ord-1'}));
      },
    );

    test('400 → ApiFailure<void> with BadRequestException', () async {
      when(
        () => dio.post<dynamic>(any(), data: any(named: 'data')),
      ).thenThrow(dioError400('Cannot void a completed order'));

      final result = await repo.voidOrder(orderId: 'ord-1');

      expect(result, isA<ApiFailure<void>>());
      expect((result as ApiFailure<void>).err, isA<BadRequestException>());
    });
  });
}
