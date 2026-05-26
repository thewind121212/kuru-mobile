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

Map<String, dynamic> _entryJson() => <String, dynamic>{
  'id': 'exp-1',
  'orgId': 'org-1',
  'categoryId': 'cat-1',
  'categoryName': 'Nhập hàng',
  'amount': '120000',
  'paidAt': '2026-05-25T00:00:00.000Z',
  'isDelete': false,
  'createdBy': 'user-1',
  'createdAt': '2026-05-25T00:00:00.000Z',
  'updatedAt': '2026-05-25T00:00:00.000Z',
  'source': 'MANUAL',
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
        'entries': <dynamic>[_entryJson()],
      }),
    );

    final result = await repo.listEntries(limit: 10);

    expect(result, isA<ApiSuccess<List<ExpenseEntry>>>());
    final entries = (result as ApiSuccess<List<ExpenseEntry>>).data;
    expect(entries.single.categoryName, 'Nhập hàng');
    expect(entries.single.amount, 120000);
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
