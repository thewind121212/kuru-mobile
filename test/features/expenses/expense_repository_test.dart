import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/features/expenses/data/expense_repository.dart';
import 'package:kuru_mobile/features/expenses/models/expense_category.dart';
import 'package:kuru_mobile/features/expenses/models/expense_entry.dart';
import 'package:mocktail/mocktail.dart';

class _MockDio extends Mock implements Dio {}

Map<String, dynamic> _categoryJson() => <String, dynamic>{
  'id': 'cat-1',
  'orgId': 'org-1',
  'name': 'Nhập hàng',
  'frequency': 'IRREGULAR',
  'defaultAmount': '120000',
  'isSystem': false,
  'isDelete': false,
  'createdAt': '2026-05-25T00:00:00.000Z',
  'updatedAt': '2026-05-25T00:00:00.000Z',
};

Map<String, dynamic> _entryJson({
  String id = 'exp-1',
  bool isDelete = false,
  String source = 'MANUAL',
  String? purchaseEntryId,
  String? purchaseEntryNumber,
  Map<String, dynamic>? purchaseEntry,
  List<Map<String, dynamic>>? linkedPurchaseEntries,
  String? storeId,
  String? storeName,
  String? scope,
  Object? voidedAt,
  String? voidReason,
}) => <String, dynamic>{
  'id': id,
  'orgId': 'org-1',
  'categoryId': 'cat-1',
  'categoryName': 'Nhập hàng',
  'amount': '120000',
  'paidAt': '2026-05-25T00:00:00.000Z',
  'isDelete': isDelete,
  'createdBy': 'user-1',
  'createdAt': '2026-05-25T00:00:00.000Z',
  'updatedAt': '2026-05-25T00:00:00.000Z',
  'source': source,
  if (purchaseEntryId != null) 'purchaseEntryId': purchaseEntryId,
  if (purchaseEntryNumber != null) 'purchaseEntryNumber': purchaseEntryNumber,
  if (purchaseEntry != null) 'purchaseEntry': purchaseEntry,
  if (linkedPurchaseEntries != null)
    'linkedPurchaseEntries': linkedPurchaseEntries,
  if (storeId != null) 'storeId': storeId,
  if (storeName != null) 'storeName': storeName,
  if (scope != null) 'scope': scope,
  if (voidedAt != null) 'voidedAt': voidedAt,
  if (voidReason != null) 'voidReason': voidReason,
};

void main() {
  late _MockDio dio;
  late ExpenseRepository repo;

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
    repo = ExpenseRepository(dio);
  });

  test('listCategories parses backend categories', () async {
    when(
      () => dio.get<dynamic>(
        '/expense/ListExpenseCategories',
        queryParameters: any(named: 'queryParameters'),
      ),
    ).thenAnswer(
      (_) async => ok(<String, dynamic>{
        'categories': <dynamic>[_categoryJson()],
      }),
    );

    final result = await repo.listCategories();

    expect(result, isA<ApiSuccess<List<ExpenseCategory>>>());
    final categories = (result as ApiSuccess<List<ExpenseCategory>>).data;
    expect(categories.single.name, 'Nhập hàng');
    expect(categories.single.defaultAmount, 120000);
  });

  test('listEntries parses backend entries', () async {
    when(
      () => dio.get<dynamic>(
        '/expense/ListExpenseEntries',
        queryParameters: any(named: 'queryParameters'),
      ),
    ).thenAnswer(
      (_) async => ok(<String, dynamic>{
        'entries': <dynamic>[
          _entryJson(),
          _entryJson(
            id: 'exp-2',
            voidedAt: '2026-05-25T01:00:00.000Z',
            voidReason: 'cancelled import',
          ),
          _entryJson(id: 'exp-3', isDelete: true),
        ],
      }),
    );

    final result = await repo.listEntries(limit: 10);

    expect(result, isA<ApiSuccess<List<ExpenseEntry>>>());
    final entries = (result as ApiSuccess<List<ExpenseEntry>>).data;
    expect(entries, hasLength(3));
    expect(entries.first.categoryName, 'Nhập hàng');
    expect(entries.first.amount, 120000);
    expect(entries[1].isVoided, isTrue);
    expect(entries[1].voidReason, 'cancelled import');
    expect(entries[2].isVoided, isTrue);
  });

  test('listEntries parses import purchase references', () async {
    when(
      () => dio.get<dynamic>(
        '/expense/ListExpenseEntries',
        queryParameters: any(named: 'queryParameters'),
      ),
    ).thenAnswer(
      (_) async => ok(<String, dynamic>{
        'entries': <dynamic>[
          _entryJson(
            source: 'PURCHASE_ENTRY',
            purchaseEntryId: 'pe-1',
            purchaseEntryNumber: 'PE-20260525-0001',
          ),
        ],
      }),
    );

    final result = await repo.listEntries(limit: 10);

    final entry = (result as ApiSuccess<List<ExpenseEntry>>).data.single;
    expect(entry.importEntryId, 'pe-1');
    expect(entry.importEntryNumber, 'PE-20260525-0001');
    expect(entry.hasImportRef, isTrue);
    expect(entry.matches('PE-20260525'), isTrue);
  });

  test(
    'listEntries parses import branch warehouses from linked purchases',
    () async {
      when(
        () => dio.get<dynamic>(
          '/expense/ListExpenseEntries',
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer(
        (_) async => ok(<String, dynamic>{
          'entries': <dynamic>[
            _entryJson(
              source: 'PUSHED',
              linkedPurchaseEntries: <Map<String, dynamic>>[
                <String, dynamic>{
                  'id': 'pe-1',
                  'entryNumber': 'PE-20260525-0001',
                  'warehouses': <Map<String, dynamic>>[
                    <String, dynamic>{
                      'id': '2be35f86-5668-4a29-a45a-c9c268981915',
                      'name': 'Chi nhánh Quận 1',
                    },
                    <String, dynamic>{
                      'id': '2be35f86-5668-4a29-a45a-c9c268981915',
                      'name': 'Chi nhánh Quận 1',
                    },
                  ],
                },
              ],
            ),
          ],
        }),
      );

      final result = await repo.listEntries(limit: 10);

      final entry = (result as ApiSuccess<List<ExpenseEntry>>).data.single;
      expect(entry.importEntryId, 'pe-1');
      expect(entry.importEntryNumber, 'PE-20260525-0001');
      expect(entry.linkedPurchaseEntries, hasLength(1));
      expect(entry.linkedImportWarehousesDeduped, hasLength(1));
      expect(
        entry.linkedImportWarehousesDeduped.single.name,
        'Chi nhánh Quận 1',
      );
      expect(entry.branchDisplayName, 'Chi nhánh Quận 1');
      expect(entry.isBranchScoped, isTrue);
      expect(entry.matches('Quận 1'), isTrue);
    },
  );

  test('listEntries parses branch scope by name', () async {
    when(
      () => dio.get<dynamic>(
        '/expense/ListExpenseEntries',
        queryParameters: any(named: 'queryParameters'),
      ),
    ).thenAnswer(
      (_) async => ok(<String, dynamic>{
        'entries': <dynamic>[
          _entryJson(
            source: 'PUSH',
            storeId: '2be35f86-5668-4a29-a45a-c9c268981915',
            storeName: 'Chi nhánh Quận 1',
            scope: 'BRANCH',
          ),
        ],
      }),
    );

    final result = await repo.listEntries(limit: 10);

    final entry = (result as ApiSuccess<List<ExpenseEntry>>).data.single;
    expect(entry.source, 'PUSH');
    expect(entry.storeId, '2be35f86-5668-4a29-a45a-c9c268981915');
    expect(entry.storeName, 'Chi nhánh Quận 1');
    expect(entry.isBranchScoped, isTrue);
    expect(entry.branchDisplayName, 'Chi nhánh Quận 1');
  });

  test('getEntryById fetches one expense detail', () async {
    when(
      () => dio.get<dynamic>(
        '/expense/GetExpenseEntry',
        queryParameters: any(named: 'queryParameters'),
      ),
    ).thenAnswer(
      (_) async => ok(<String, dynamic>{
        'entry': _entryJson(
          source: 'PURCHASE_ENTRY',
          purchaseEntry: <String, dynamic>{
            'id': 'pe-1',
            'entryNumber': 'PE-20260525-0001',
          },
        ),
      }),
    );

    final result = await repo.getEntryById('exp-1');

    final entry = (result as ApiSuccess<ExpenseEntry>).data;
    expect(entry.id, 'exp-1');
    expect(entry.importEntryId, 'pe-1');
    expect(entry.importEntryNumber, 'PE-20260525-0001');
    final captured =
        verify(
              () => dio.get<dynamic>(
                '/expense/GetExpenseEntry',
                queryParameters: captureAny(named: 'queryParameters'),
              ),
            ).captured.single
            as Map<String, dynamic>;
    expect(captured['id'], 'exp-1');
  });

  test('createEntry sends backend request shape', () async {
    when(
      () => dio.post<dynamic>(
        '/expense/CreateExpenseEntry',
        data: any(named: 'data'),
      ),
    ).thenAnswer(
      (_) async => ok(<String, dynamic>{'id': 'exp-1'}, statusCode: 201),
    );

    final result = await repo.createEntry(
      categoryId: 'cat-1',
      amount: 120000,
      paidAt: DateTime(2026, 5, 25),
      note: 'morning stock',
    );

    expect((result as ApiSuccess<String>).data, 'exp-1');
    final captured =
        verify(
              () => dio.post<dynamic>(
                '/expense/CreateExpenseEntry',
                data: captureAny(named: 'data'),
              ),
            ).captured.single
            as Map<String, dynamic>;
    expect(captured['categoryId'], 'cat-1');
    expect(captured['amount'], '120000');
    expect(captured['paidAt'], '2026-05-25');
    expect(captured['note'], 'morning stock');
  });
}
