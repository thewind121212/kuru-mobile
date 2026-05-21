enum ProductStatus {
  active,
  inactive,
  archived;

  String get wire => switch (this) {
    ProductStatus.active => 'ACTIVE',
    ProductStatus.inactive => 'INACTIVE',
    ProductStatus.archived => 'ARCHIVED',
  };

  static ProductStatus fromWire(String? wire) => switch (wire) {
    'ACTIVE' => ProductStatus.active,
    'INACTIVE' => ProductStatus.inactive,
    'ARCHIVED' => ProductStatus.archived,
    _ => ProductStatus.active,
  };
}
