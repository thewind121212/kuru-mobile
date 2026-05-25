import 'package:dio/dio.dart';
import 'package:kuru_mobile/core/logging/log.dart';
import 'package:kuru_mobile/core/network/api_exception.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/core/network/dio_client.dart' show mapDioError;
import 'package:kuru_mobile/features/expenses/models/expense_category.dart';
import 'package:kuru_mobile/features/expenses/models/expense_entry.dart';
import 'package:kuru_mobile/features/expenses/models/expense_summary.dart';

class ExpenseRepository {
  ExpenseRepository(this._dio);

  final Dio _dio;

  Future<ApiResult<List<ExpenseCategory>>> listCategories({
    String? search,
  }) async {
    try {
      final res = await _dio.get<dynamic>(
        '/expense/ListExpenseCategories',
        queryParameters: {
          if (search != null && search.trim().isNotEmpty)
            'search': search.trim(),
        },
      );
      final data = _data(res);
      final categories = (data['categories'] as List<dynamic>? ?? const [])
          .map((e) => ExpenseCategory.fromJson(e as Map<String, dynamic>))
          .where((e) => !e.isDelete)
          .toList();
      log.i(
        'ListExpenseCategories ← ${res.statusCode} count=${categories.length}',
      );
      return ApiResult.success(categories);
    } on DioException catch (e) {
      log.w('ListExpenseCategories failed: ${e.message}');
      return ApiResult.failure(_extract(e));
    }
  }

  Future<ApiResult<String>> createCategory({
    required String name,
    String frequency = 'IRREGULAR',
    int? defaultAmount,
  }) async {
    try {
      final res = await _dio.post<dynamic>(
        '/expense/CreateExpenseCategory',
        data: <String, dynamic>{
          'name': name.trim(),
          'frequency': frequency,
          if (defaultAmount != null && defaultAmount > 0)
            'defaultAmount': '$defaultAmount',
        },
      );
      final id = _data(res)['id'] as String? ?? '';
      log.i('CreateExpenseCategory ← ${res.statusCode} id=$id');
      return ApiResult.success(id);
    } on DioException catch (e) {
      log.w('CreateExpenseCategory failed: ${e.message}');
      return ApiResult.failure(_extract(e));
    }
  }

  Future<ApiResult<List<ExpenseEntry>>> listEntries({
    String? from,
    String? to,
    String? categoryId,
    String? search,
    int limit = 50,
  }) async {
    try {
      final res = await _dio.get<dynamic>(
        '/expense/ListExpenseEntries',
        queryParameters: {
          if (from != null) 'from': from,
          if (to != null) 'to': to,
          if (categoryId != null && categoryId.isNotEmpty)
            'categoryId': categoryId,
          if (search != null && search.trim().isNotEmpty)
            'search': search.trim(),
          'limit': limit,
        },
      );
      final data = _data(res);
      final entries = (data['entries'] as List<dynamic>? ?? const [])
          .map((e) => ExpenseEntry.fromJson(e as Map<String, dynamic>))
          .where((e) => !e.isDelete)
          .toList();
      log.i('ListExpenseEntries ← ${res.statusCode} count=${entries.length}');
      return ApiResult.success(entries);
    } on DioException catch (e) {
      log.w('ListExpenseEntries failed: ${e.message}');
      return ApiResult.failure(_extract(e));
    }
  }

  Future<ApiResult<ExpenseSummary>> summaryForMonth({
    required int year,
    required int month,
  }) async {
    try {
      final res = await _dio.get<dynamic>(
        '/expense/ExpenseSummaryReport',
        queryParameters: {'period': 'month', 'year': year, 'month': month},
      );
      final summary = ExpenseSummary.fromReportJson(_data(res));
      log.i('ExpenseSummaryReport ← ${res.statusCode} total=${summary.total}');
      return ApiResult.success(summary);
    } on DioException catch (e) {
      log.w('ExpenseSummaryReport failed: ${e.message}');
      return ApiResult.failure(_extract(e));
    }
  }

  Future<ApiResult<String>> createEntry({
    required String categoryId,
    required int amount,
    required DateTime paidAt,
    String? note,
  }) async {
    try {
      final res = await _dio.post<dynamic>(
        '/expense/CreateExpenseEntry',
        data: <String, dynamic>{
          'categoryId': categoryId,
          'amount': '$amount',
          'paidAt': _dateOnly(paidAt),
          if (note != null && note.trim().isNotEmpty) 'note': note.trim(),
        },
      );
      final id = _data(res)['id'] as String? ?? '';
      log.i('CreateExpenseEntry ← ${res.statusCode} id=$id');
      return ApiResult.success(id);
    } on DioException catch (e) {
      log.w('CreateExpenseEntry failed: ${e.message}');
      return ApiResult.failure(_extract(e));
    }
  }

  Future<ApiResult<void>> deleteEntry(String id) async {
    try {
      await _dio.post<dynamic>(
        '/expense/DeleteExpenseEntry',
        data: <String, dynamic>{'id': id},
      );
      log.i('DeleteExpenseEntry ← id=$id');
      return ApiResult.success(null);
    } on DioException catch (e) {
      log.w('DeleteExpenseEntry failed: ${e.message}');
      return ApiResult.failure(_extract(e));
    }
  }

  Map<String, dynamic> _data(Response<dynamic> res) {
    final body = res.data as Map<String, dynamic>;
    return body['data'] as Map<String, dynamic>;
  }

  ApiException _extract(DioException e) {
    final mapped = e.error;
    if (mapped is ApiException) return mapped;
    return mapDioError(e);
  }

  String _dateOnly(DateTime date) {
    final local = date.toLocal();
    final m = local.month.toString().padLeft(2, '0');
    final d = local.day.toString().padLeft(2, '0');
    return '${local.year}-$m-$d';
  }
}
