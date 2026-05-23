enum DiscountType {
  percentage,
  fixed;

  String toWire() => switch (this) {
    DiscountType.percentage => 'PERCENTAGE',
    DiscountType.fixed => 'FIXED',
  };

  static DiscountType? fromWire(String? wire) => switch (wire) {
    'PERCENTAGE' => DiscountType.percentage,
    'FIXED' => DiscountType.fixed,
    _ => null,
  };
}
