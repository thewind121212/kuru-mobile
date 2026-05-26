import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/features/imports/data/purchase_repository.dart';
import 'package:kuru_mobile/features/imports/models/purchase_draft_line.dart';
import 'package:kuru_mobile/features/imports/models/purchase_entry.dart';
import 'package:kuru_mobile/features/imports/models/purchase_entry_status.dart';
import 'package:kuru_mobile/features/imports/models/purchase_summary.dart';
import 'package:mocktail/mocktail.dart';

class _MockDio extends Mock implements Dio {}

void main() {
  late _MockDio dio;
  late PurchaseRepository repo;

  Response<dynamic> ok(Map<String, dynamic> data, {int statusCode = 200}) {
    return Response<dynamic>(
      statusCode: statusCode,
      requestOptions: RequestOptions(),
      data: <String, dynamic>{
        'success': true,
        'data': data,
        'timestamp': '2026-05-25T00:00:00.000Z',
      },
    );
  }

  setUp(() {
    dio = _MockDio();
    repo = PurchaseRepository(dio);
  });

  test('listEntries parses purchase entry overview rows', () async {
    when(
      () => dio.get<dynamic>(
        '/purchase/ListPurchaseEntries',
        queryParameters: any(named: 'queryParameters'),
      ),
    ).thenAnswer(
      (_) async => ok(<String, dynamic>{
        'entries': <dynamic>[
          <String, dynamic>{
            'id': 'pe-1',
            'orgId': 'org-1',
            'entryNumber': 'PE-20260525-0001',
            'status': 'POSTED',
            'createdAt': '2026-05-25T00:00:00.000Z',
            'totalCost': 125000,
            'totalQty': 5,
            'itemCount': 1,
          },
        ],
        'total': 1,
        'page': 1,
        'limit': 50,
      }),
    );

    final result = await repo.listEntries();

    expect(result, isA<ApiSuccess<PurchaseEntryPage>>());
    final page = (result as ApiSuccess<PurchaseEntryPage>).data;
    expect(page.entries.single.entryNumber, 'PE-20260525-0001');
    expect(page.entries.single.status, PurchaseEntryStatus.posted);
    expect(page.entries.single.totalCost, 125000);
  });

  test('summary parses posted purchase total', () async {
    when(
      () => dio.get<dynamic>(
        '/purchase/PurchaseSummaryReport',
        queryParameters: any(named: 'queryParameters'),
      ),
    ).thenAnswer(
      (_) async => ok(<String, dynamic>{
        'totalCost': 240000,
        'totalQty': 12,
        'entryCount': 2,
        'byDistributor': <dynamic>[],
      }),
    );

    final result = await repo.summary(status: PurchaseEntryStatus.posted);

    final summary = (result as ApiSuccess<PurchaseSummary>).data;
    expect(summary.totalCost, 240000);
    final captured =
        verify(
              () => dio.get<dynamic>(
                '/purchase/PurchaseSummaryReport',
                queryParameters: captureAny(named: 'queryParameters'),
              ),
            ).captured.single
            as Map<String, dynamic>;
    expect(captured['status'], 'POSTED');
  });

  test('getEntryById parses purchase detail lines', () async {
    when(
      () => dio.get<dynamic>(
        '/purchase/GetPurchaseEntry',
        queryParameters: any(named: 'queryParameters'),
      ),
    ).thenAnswer(
      (_) async => ok(<String, dynamic>{
        'entry': <String, dynamic>{
          'id': 'pe-1',
          'orgId': 'org-1',
          'entryNumber': 'PE-20260525-0001',
          'status': 'POSTED',
          'createdAt': '2026-05-25T00:00:00.000Z',
          'postedAt': '2026-05-25T01:00:00.000Z',
          'warehouseName': 'Kho chính',
          'totalCost': 125000,
          'totalQty': 5,
          'itemCount': 1,
          'items': <dynamic>[
            <String, dynamic>{
              'id': 'line-1',
              'productId': 'prod-1',
              'productName': 'Coffee',
              'variantName': '500g',
              'warehouseName': 'Kho chính',
              'imageUrl': 'prod-1.webp',
              'variantImageUrl': 'variant-1.webp',
              'qty': 5,
              'unitCost': 25000,
              'total': 125000,
            },
          ],
        },
      }),
    );

    final result = await repo.getEntryById('pe-1');

    expect(result, isA<ApiSuccess<PurchaseEntryDetail>>());
    final detail = (result as ApiSuccess<PurchaseEntryDetail>).data;
    expect(detail.entryNumber, 'PE-20260525-0001');
    expect(detail.items.single.productName, 'Coffee');
    expect(detail.items.single.variantImageUrl, 'variant-1.webp');
    expect(detail.items.single.total, 125000);
    final captured =
        verify(
              () => dio.get<dynamic>(
                '/purchase/GetPurchaseEntry',
                queryParameters: captureAny(named: 'queryParameters'),
              ),
            ).captured.single
            as Map<String, dynamic>;
    expect(captured['id'], 'pe-1');
  });

  test('createEntry sends backend request shape', () async {
    when(
      () => dio.post<dynamic>(
        '/purchase/CreatePurchaseEntry',
        data: any(named: 'data'),
      ),
    ).thenAnswer(
      (_) async => ok(<String, dynamic>{
        'id': 'pe-1',
        'entryNumber': 'PE-1',
      }, statusCode: 201),
    );

    final result = await repo.createEntry(
      warehouseId: 'wh-1',
      invoiceDate: '2026-05-25',
      lines: const [
        PurchaseDraftLine(
          productId: 'prod-1',
          productName: 'Coffee',
          warehouseId: 'wh-1',
          qty: 3,
          unitCost: 12000,
        ),
      ],
    );

    expect((result as ApiSuccess<String>).data, 'pe-1');
    final captured =
        verify(
              () => dio.post<dynamic>(
                '/purchase/CreatePurchaseEntry',
                data: captureAny(named: 'data'),
              ),
            ).captured.single
            as Map<String, dynamic>;
    expect(captured['warehouseId'], 'wh-1');
    expect(captured['singleWarehouseMode'], true);
    expect(captured['invoiceDate'], '2026-05-25');
    final items = captured['items'] as List<dynamic>;
    expect(items.single, containsPair('productId', 'prod-1'));
    expect(items.single, containsPair('qtyInput', 3));
    expect(items.single, containsPair('unitCostInput', 12000));
  });

  test('createAndPost creates then posts purchase entry', () async {
    when(
      () => dio.post<dynamic>(
        '/purchase/CreatePurchaseEntry',
        data: any(named: 'data'),
      ),
    ).thenAnswer(
      (_) async => ok(<String, dynamic>{
        'id': 'pe-1',
        'entryNumber': 'PE-1',
      }, statusCode: 201),
    );
    when(
      () => dio.post<dynamic>(
        '/purchase/PostPurchaseEntry',
        data: any(named: 'data'),
      ),
    ).thenAnswer((_) async => ok(<String, dynamic>{'id': 'pe-1'}));

    final result = await repo.createAndPost(
      warehouseId: 'wh-1',
      lines: const [
        PurchaseDraftLine(
          productId: 'prod-1',
          productName: 'Coffee',
          warehouseId: 'wh-1',
          qty: 1,
          unitCost: 10000,
        ),
      ],
    );

    expect((result as ApiSuccess<String>).data, 'pe-1');
    verify(
      () => dio.post<dynamic>(
        '/purchase/PostPurchaseEntry',
        data: <String, dynamic>{'id': 'pe-1'},
      ),
    ).called(1);
  });
}
