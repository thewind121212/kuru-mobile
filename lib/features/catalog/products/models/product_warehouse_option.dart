import 'package:flutter/foundation.dart';

@immutable
class ProductWarehouseOption {
  const ProductWarehouseOption({
    required this.warehouseId,
    required this.name,
    this.address,
  });

  final String warehouseId;
  final String name;
  final String? address;

  factory ProductWarehouseOption.fromJson(Map<String, dynamic> json) {
    return ProductWarehouseOption(
      warehouseId:
          json['warehouseId'] as String? ?? json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      address: json['address'] as String?,
    );
  }
}
