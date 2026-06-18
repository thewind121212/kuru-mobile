import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuru_mobile/core/logging/log.dart';
import 'package:kuru_mobile/core/network/api_exception.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/core/network/dio_client.dart' show mapDioError;
import 'package:kuru_mobile/features/catalog/products/providers/product_providers.dart';

final posPaymentQrRepositoryProvider = Provider<PosPaymentQrRepository>((ref) {
  return PosPaymentQrRepository(ref.watch(productDioProvider));
});

class PosPaymentQrRepository {
  PosPaymentQrRepository(this._dio);

  final Dio _dio;

  Future<ApiResult<PosPaymentQr>> generate({
    required String orgId,
    required String refNumber,
    required double amount,
    String? terminalId,
    String? orderId,
  }) async {
    try {
      final trimmedRef = refNumber.trim();
      if (trimmedRef.isEmpty) {
        return ApiResult.failure(
          const BadRequestException('Payment reference is empty'),
        );
      }
      if (amount <= 0) {
        return ApiResult.failure(
          const BadRequestException('Payment amount must be positive'),
        );
      }

      final trimmedTerminalId = terminalId?.trim();
      final trimmedOrderId = orderId?.trim();
      final body = <String, dynamic>{
        'orgId': orgId,
        'refType': 'ORDER',
        'refNumber': trimmedRef,
        'amount': amount,
      };
      if (trimmedTerminalId != null && trimmedTerminalId.isNotEmpty) {
        body['terminalId'] = trimmedTerminalId;
      }
      if (trimmedOrderId != null && trimmedOrderId.isNotEmpty) {
        body['orderId'] = trimmedOrderId;
      }

      final res = await _dio.post<dynamic>('/payment/GenerateQR', data: body);
      final data =
          (res.data as Map<String, dynamic>)['data'] as Map<String, dynamic>?;
      if (data == null) {
        return ApiResult.failure(
          const UnknownException('QR response is empty'),
        );
      }
      log.i('GenerateQR ← ${res.statusCode} ref=$trimmedRef');
      return ApiResult.success(PosPaymentQr.fromJson(data));
    } on DioException catch (e) {
      log.w('GenerateQR failed: ${e.message}');
      return ApiResult.failure(mapDioError(e));
    }
  }
}

class PosPaymentQr {
  const PosPaymentQr({
    required this.qrUrl,
    required this.memo,
    required this.bankCode,
    required this.accountNumber,
    required this.accountName,
  });

  final String qrUrl;
  final String memo;
  final String bankCode;
  final String accountNumber;
  final String accountName;

  factory PosPaymentQr.fromJson(Map<String, dynamic> json) {
    return PosPaymentQr(
      qrUrl: json['qrUrl'] as String? ?? '',
      memo: json['memo'] as String? ?? '',
      bankCode: json['bankCode'] as String? ?? '',
      accountNumber: json['accountNumber'] as String? ?? '',
      accountName: json['accountName'] as String? ?? '',
    );
  }
}
