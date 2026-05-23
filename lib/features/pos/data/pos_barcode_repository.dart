import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuru_mobile/core/logging/log.dart';
import 'package:kuru_mobile/core/network/api_exception.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/core/network/dio_client.dart' show mapDioError;
import 'package:kuru_mobile/features/catalog/products/providers/product_providers.dart';

final posBarcodeRepositoryProvider = Provider<PosBarcodeRepository>((ref) {
  return PosBarcodeRepository(ref.watch(productDioProvider));
});

class PosBarcodeRepository {
  PosBarcodeRepository(this._dio);

  final Dio _dio;

  Future<ApiResult<PosBarcodeLookup>> lookup(String barcode) async {
    try {
      final value = barcode.trim();
      if (value.isEmpty) {
        return ApiResult.failure(const BadRequestException('Barcode is empty'));
      }
      final res = await _dio.get<dynamic>(
        '/barcode/LookupBarcode',
        queryParameters: {'barcode': value},
      );
      final data =
          (res.data as Map<String, dynamic>)['data'] as Map<String, dynamic>?;
      if (data == null || data['productId'] == null) {
        return ApiResult.failure(const UnknownException('Barcode not found'));
      }
      log.i('LookupBarcode ← ${res.statusCode} barcode=$value');
      return ApiResult.success(PosBarcodeLookup.fromJson(data));
    } on DioException catch (e) {
      log.w('LookupBarcode failed: ${e.message}');
      return ApiResult.failure(mapDioError(e));
    }
  }
}

class PosBarcodeLookup {
  const PosBarcodeLookup({
    required this.barcodeValue,
    required this.productId,
    required this.productName,
    required this.sellPrice,
    required this.baseUnitCode,
    this.variantId,
    this.variantName,
    this.imageUrl,
    this.variantImageUrl,
    this.uomSellPrice,
  });

  final String barcodeValue;
  final String productId;
  final String productName;
  final double sellPrice;
  final String baseUnitCode;
  final String? variantId;
  final String? variantName;
  final String? imageUrl;
  final String? variantImageUrl;
  final double? uomSellPrice;

  factory PosBarcodeLookup.fromJson(Map<String, dynamic> json) {
    String? nullIfEmpty(Object? value) {
      final s = value as String?;
      return s == null || s.isEmpty ? null : s;
    }

    return PosBarcodeLookup(
      barcodeValue: json['barcodeValue'] as String? ?? '',
      productId: json['productId'] as String,
      productName: json['productName'] as String,
      sellPrice: ((json['sellPrice'] as num?) ?? 0).toDouble(),
      baseUnitCode: json['baseUnitCode'] as String? ?? '',
      variantId: nullIfEmpty(json['variantId']),
      variantName: nullIfEmpty(json['variantName']),
      imageUrl: nullIfEmpty(json['imageUrl']),
      variantImageUrl: nullIfEmpty(json['variantImageUrl']),
      uomSellPrice: (json['uomSellPrice'] as num?)?.toDouble(),
    );
  }
}
