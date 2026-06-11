import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuru_mobile/core/logging/log.dart';
import 'package:kuru_mobile/core/network/api_exception.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/core/network/dio_client.dart' show mapDioError;
import 'package:kuru_mobile/features/catalog/products/providers/product_providers.dart';

final posCustomerDisplayRepositoryProvider =
    Provider<PosCustomerDisplayRepository>((ref) {
      return PosCustomerDisplayRepository(ref.watch(productDioProvider));
    });

class PosCustomerDisplayRepository {
  PosCustomerDisplayRepository(this._dio);

  final Dio _dio;

  Future<ApiResult<List<PosDisplayTerminal>>> listTerminals({
    required String storeId,
  }) async {
    try {
      final trimmed = storeId.trim();
      if (trimmed.isEmpty) {
        return ApiResult.failure(
          const BadRequestException('Store is required'),
        );
      }
      final res = await _dio.post<dynamic>(
        '/customer-display/ListTerminals',
        data: {'storeId': trimmed},
      );
      final data = _unwrapData(res.data);
      final raw = data['terminals'] as List<dynamic>? ?? const [];
      final terminals = raw
          .whereType<Map<String, dynamic>>()
          .map(PosDisplayTerminal.fromJson)
          .where((terminal) => terminal.id.isNotEmpty)
          .toList();
      log.i('ListTerminals ← ${res.statusCode} count=${terminals.length}');
      return ApiResult.success(terminals);
    } on DioException catch (e) {
      log.w('ListTerminals failed: ${e.message}');
      return ApiResult.failure(mapDioError(e));
    }
  }

  Future<ApiResult<List<PosPairedDisplay>>> listPairedDisplays({
    String? storeId,
    String? terminalId,
  }) async {
    try {
      final body = <String, dynamic>{};
      final trimmedStoreId = storeId?.trim();
      if (trimmedStoreId != null && trimmedStoreId.isNotEmpty) {
        body['storeId'] = trimmedStoreId;
      }
      final trimmedTerminalId = terminalId?.trim();
      if (trimmedTerminalId != null && trimmedTerminalId.isNotEmpty) {
        body['terminalId'] = trimmedTerminalId;
      }
      if (body.isEmpty) {
        return ApiResult.failure(
          const BadRequestException('Store or terminal is required'),
        );
      }
      final res = await _dio.post<dynamic>(
        '/customer-display/ListPairedDisplays',
        data: body,
      );
      final data = _unwrapData(res.data);
      final raw = data['displays'] as List<dynamic>? ?? const [];
      final displays = raw
          .whereType<Map<String, dynamic>>()
          .map(PosPairedDisplay.fromJson)
          .where((display) => display.id.isNotEmpty)
          .toList();
      log.i('ListPairedDisplays ← ${res.statusCode} count=${displays.length}');
      return ApiResult.success(displays);
    } on DioException catch (e) {
      log.w('ListPairedDisplays failed: ${e.message}');
      return ApiResult.failure(mapDioError(e));
    }
  }

  Future<ApiResult<PosPairSession>> createPairSession({
    required String terminalId,
    String? name,
    String? description,
    String? rebindDeviceId,
  }) async {
    try {
      final trimmed = terminalId.trim();
      if (trimmed.isEmpty) {
        return ApiResult.failure(
          const BadRequestException('Terminal is required'),
        );
      }
      final body = <String, dynamic>{'terminalId': trimmed};
      final trimmedName = name?.trim();
      if (trimmedName != null && trimmedName.isNotEmpty) {
        body['name'] = trimmedName;
      }
      final trimmedDescription = description?.trim();
      if (trimmedDescription != null && trimmedDescription.isNotEmpty) {
        body['description'] = trimmedDescription;
      }
      final rebind = rebindDeviceId?.trim();
      if (rebind != null && rebind.isNotEmpty) {
        body['rebindDeviceId'] = rebind;
      }
      final res = await _dio.post<dynamic>(
        '/customer-display/CreatePairSession',
        data: body,
      );
      final data = _unwrapData(res.data);
      final code = data['code'] as String? ?? '';
      if (code.isEmpty) {
        return ApiResult.failure(
          const UnknownException('Pair code response is empty'),
        );
      }
      log.i('CreatePairSession ← ${res.statusCode} terminal=$trimmed');
      return ApiResult.success(PosPairSession.fromJson(data));
    } on DioException catch (e) {
      log.w('CreatePairSession failed: ${e.message}');
      return ApiResult.failure(mapDioError(e));
    }
  }

  Future<ApiResult<bool>> cancelPairSession({
    required String terminalId,
  }) async {
    try {
      final trimmed = terminalId.trim();
      if (trimmed.isEmpty) {
        return ApiResult.failure(
          const BadRequestException('Terminal is required'),
        );
      }
      final res = await _dio.post<dynamic>(
        '/customer-display/CancelPairSession',
        data: {'terminalId': trimmed},
      );
      final data = _unwrapData(res.data);
      log.i('CancelPairSession ← ${res.statusCode} terminal=$trimmed');
      return ApiResult.success(data['cancelled'] == true);
    } on DioException catch (e) {
      log.w('CancelPairSession failed: ${e.message}');
      return ApiResult.failure(mapDioError(e));
    }
  }

  Future<ApiResult<PosDisplayPushResult>> pushCart({
    required String terminalId,
    required List<PosDisplayCartItem> items,
    required double subtotal,
    required double discount,
    required double total,
    required String sessionId,
    bool takeOver = false,
    String? customerName,
  }) async {
    try {
      final trimmed = terminalId.trim();
      if (trimmed.isEmpty) {
        return ApiResult.failure(
          const BadRequestException('Terminal is required'),
        );
      }
      final body = <String, dynamic>{
        'terminalId': trimmed,
        'items': items.map((item) => item.toJson()).toList(),
        'subtotal': subtotal,
        'discount': discount,
        'total': total,
        'sessionId': sessionId,
        'takeOver': takeOver,
      };
      final trimmedCustomerName = customerName?.trim();
      if (trimmedCustomerName != null && trimmedCustomerName.isNotEmpty) {
        body['customerName'] = trimmedCustomerName;
      }
      final res = await _dio.post<dynamic>(
        '/customer-display/PushDisplayCart',
        data: body,
      );
      final data = _unwrapData(res.data);
      log.i('PushDisplayCart ← ${res.statusCode} terminal=$trimmed');
      return ApiResult.success(PosDisplayPushResult.fromJson(data));
    } on DioException catch (e) {
      log.w('PushDisplayCart failed: ${e.message}');
      return ApiResult.failure(mapDioError(e));
    }
  }

  Map<String, dynamic> _unwrapData(dynamic value) {
    if (value is Map<String, dynamic>) {
      final data = value['data'];
      if (data is Map<String, dynamic>) return data;
      return value;
    }
    return const {};
  }
}

class PosDisplayTerminal {
  const PosDisplayTerminal({
    required this.id,
    required this.name,
    required this.isDefault,
  });

  final String id;
  final String name;
  final bool isDefault;

  factory PosDisplayTerminal.fromJson(Map<String, dynamic> json) {
    return PosDisplayTerminal(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      isDefault: json['isDefault'] == true,
    );
  }
}

class PosPairedDisplay {
  const PosPairedDisplay({
    required this.id,
    required this.name,
    required this.terminalId,
    required this.terminalName,
    required this.status,
    this.lastSeenAt,
    this.pairedAt,
    this.description,
  });

  final String id;
  final String name;
  final String terminalId;
  final String terminalName;
  final String status;
  final DateTime? lastSeenAt;
  final DateTime? pairedAt;
  final String? description;

  bool get isPaired => status == 'PAIRED';

  bool get isOnline {
    final seen = lastSeenAt;
    if (seen == null) return false;
    return DateTime.now().difference(seen).inMilliseconds < 45000;
  }

  factory PosPairedDisplay.fromJson(Map<String, dynamic> json) {
    return PosPairedDisplay(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      terminalId: json['terminalId'] as String? ?? '',
      terminalName: json['terminalName'] as String? ?? '',
      status: json['status'] as String? ?? '',
      lastSeenAt: _parseProtoTimestamp(json['lastSeenAt']),
      pairedAt: _parseProtoTimestamp(json['pairedAt']),
      description: _emptyToNull(json['description'] as String?),
    );
  }
}

class PosPairSession {
  const PosPairSession({required this.code, this.expiresAt});

  final String code;
  final DateTime? expiresAt;

  factory PosPairSession.fromJson(Map<String, dynamic> json) {
    return PosPairSession(
      code: json['code'] as String? ?? '',
      expiresAt: _parseProtoTimestamp(json['expiresAt']),
    );
  }
}

class PosDisplayCartItem {
  const PosDisplayCartItem({
    required this.id,
    required this.name,
    required this.qty,
    required this.unitPrice,
    required this.lineTotal,
    this.imageUrl,
    this.variant,
  });

  final String id;
  final String name;
  final double qty;
  final double unitPrice;
  final double lineTotal;
  final String? imageUrl;
  final String? variant;

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'id': id,
      'name': name,
      'qty': qty,
      'unitPrice': unitPrice,
      'lineTotal': lineTotal,
    };
    final trimmedImage = imageUrl?.trim();
    if (trimmedImage != null && trimmedImage.isNotEmpty) {
      json['imageUrl'] = trimmedImage;
    }
    final trimmedVariant = variant?.trim();
    if (trimmedVariant != null && trimmedVariant.isNotEmpty) {
      json['variant'] = trimmedVariant;
    }
    return json;
  }
}

class PosDisplayPushResult {
  const PosDisplayPushResult({required this.ok, required this.accepted});

  final bool ok;
  final bool accepted;

  factory PosDisplayPushResult.fromJson(Map<String, dynamic> json) {
    return PosDisplayPushResult(
      ok: json['ok'] != false,
      accepted: json['accepted'] != false,
    );
  }
}

DateTime? _parseProtoTimestamp(Object? value) {
  if (value is String) return DateTime.tryParse(value);
  if (value is Map<String, dynamic>) {
    final seconds = value['seconds'];
    final nanos = value['nanos'];
    final secondsInt = switch (seconds) {
      final int v => v,
      final String v => int.tryParse(v),
      final num v => v.toInt(),
      _ => null,
    };
    if (secondsInt == null) return null;
    final nanosInt = switch (nanos) {
      final int v => v,
      final String v => int.tryParse(v) ?? 0,
      final num v => v.toInt(),
      _ => 0,
    };
    return DateTime.fromMillisecondsSinceEpoch(
      secondsInt * 1000 + nanosInt ~/ 1000000,
      isUtc: true,
    ).toLocal();
  }
  return null;
}

String? _emptyToNull(String? value) {
  final trimmed = value?.trim();
  return trimmed == null || trimmed.isEmpty ? null : trimmed;
}
