import 'package:dio/dio.dart';
import 'package:kuru_mobile/core/logging/log.dart';
import 'package:kuru_mobile/core/network/api_exception.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/core/network/dio_client.dart' show mapDioError;
import 'package:kuru_mobile/features/imports/models/purchase_draft_line.dart';
import 'package:kuru_mobile/features/imports/models/purchase_entry.dart';
import 'package:kuru_mobile/features/imports/models/purchase_entry_status.dart';
import 'package:kuru_mobile/features/imports/models/purchase_summary.dart';

class PurchaseRepository {
  const PurchaseRepository(this._dio);

  final Dio _dio;

  Future<ApiResult<PurchaseEntryPage>> listEntries({
    PurchaseEntryStatus? status,
    int page = 1,
    int limit = 50,
  }) async {
    try {
      final res = await _dio.get<dynamic>(
        '/purchase/ListPurchaseEntries',
        queryParameters: <String, dynamic>{
          if (status != null) 'status': status.wire,
          'page': page,
          'limit': limit,
        },
      );
      final data = _data(res);
      final entries = (data['entries'] as List<dynamic>? ?? const [])
          .map((e) => PurchaseEntryOverview.fromJson(e as Map<String, dynamic>))
          .where((e) => e.id.isNotEmpty)
          .toList();
      log.i('ListPurchaseEntries ← ${res.statusCode} count=${entries.length}');
      return ApiResult.success(
        PurchaseEntryPage(
          entries: entries,
          total: ((data['total'] as num?) ?? entries.length).toInt(),
          page: ((data['page'] as num?) ?? page).toInt(),
          limit: ((data['limit'] as num?) ?? limit).toInt(),
        ),
      );
    } on DioException catch (e) {
      log.w('ListPurchaseEntries failed: ${e.message}');
      return ApiResult.failure(_extract(e));
    }
  }

  Future<ApiResult<PurchaseEntryDetail>> getEntryById(String id) async {
    try {
      final res = await _dio.get<dynamic>(
        '/purchase/GetPurchaseEntry',
        queryParameters: <String, dynamic>{'id': id},
      );
      final data = _data(res);
      final entryJson =
          data['entry'] as Map<String, dynamic>? ??
          data['purchaseEntry'] as Map<String, dynamic>? ??
          data;
      log.i('GetPurchaseEntry ← ${res.statusCode} id=$id');
      return ApiResult.success(PurchaseEntryDetail.fromJson(entryJson));
    } on DioException catch (e) {
      log.w('GetPurchaseEntry failed: ${e.message}');
      return ApiResult.failure(_extract(e));
    }
  }

  Future<ApiResult<PurchaseSummary>> summary({
    PurchaseEntryStatus? status,
  }) async {
    try {
      final res = await _dio.get<dynamic>(
        '/purchase/PurchaseSummaryReport',
        queryParameters: <String, dynamic>{
          if (status != null) 'status': status.wire,
        },
      );
      final summary = PurchaseSummary.fromJson(_data(res));
      log.i(
        'PurchaseSummaryReport ← ${res.statusCode} total=${summary.totalCost}',
      );
      return ApiResult.success(summary);
    } on DioException catch (e) {
      log.w('PurchaseSummaryReport failed: ${e.message}');
      return ApiResult.failure(_extract(e));
    }
  }

  Future<ApiResult<String>> createEntry({
    required List<PurchaseDraftLine> lines,
    String? warehouseId,
    String? invoiceDate,
    String? note,
  }) async {
    try {
      final res = await _dio.post<dynamic>(
        '/purchase/CreatePurchaseEntry',
        data: <String, dynamic>{
          'warehouseId': warehouseId,
          'singleWarehouseMode': true,
          'invoiceDate': invoiceDate,
          if (note != null && note.trim().isNotEmpty) 'note': note.trim(),
          'items': lines.map((line) => line.toRequestJson()).toList(),
        },
      );
      final data = _data(res);
      final id = data['id'] as String? ?? '';
      log.i('CreatePurchaseEntry ← ${res.statusCode} id=$id');
      return ApiResult.success(id);
    } on DioException catch (e) {
      log.w('CreatePurchaseEntry failed: ${e.message}');
      return ApiResult.failure(_extract(e));
    }
  }

  Future<ApiResult<void>> postEntry(String id) async {
    try {
      final res = await _dio.post<dynamic>(
        '/purchase/PostPurchaseEntry',
        data: <String, dynamic>{'id': id},
      );
      log.i('PostPurchaseEntry ← ${res.statusCode} id=$id');
      return ApiResult.success(null);
    } on DioException catch (e) {
      log.w('PostPurchaseEntry failed: ${e.message}');
      return ApiResult.failure(_extract(e));
    }
  }

  Future<ApiResult<String>> createAndPost({
    required List<PurchaseDraftLine> lines,
    required String warehouseId,
    String? note,
  }) async {
    final idResult = await createEntry(
      lines: lines,
      warehouseId: warehouseId,
      invoiceDate: _today(),
      note: note,
    );
    switch (idResult) {
      case ApiFailure<String>():
        return idResult;
      case ApiSuccess<String>(:final data):
        final posted = await postEntry(data);
        return switch (posted) {
          ApiSuccess<void>() => ApiResult.success(data),
          ApiFailure<void>(:final err) => ApiResult.failure(err),
        };
    }
  }

  Map<String, dynamic> _data(Response<dynamic> res) {
    final body = res.data as Map<String, dynamic>;
    return body['data'] as Map<String, dynamic>;
  }

  ApiException _extract(DioException e) {
    final attached = e.error;
    if (attached is ApiException) return attached;
    return mapDioError(e);
  }

  String _today() {
    final now = DateTime.now();
    final month = now.month.toString().padLeft(2, '0');
    final day = now.day.toString().padLeft(2, '0');
    return '${now.year}-$month-$day';
  }
}
