enum OrderSaleChannel {
  shop,
  ecommerce;

  String toWire() => switch (this) {
    OrderSaleChannel.shop => 'SHOP',
    OrderSaleChannel.ecommerce => 'ECOMMERCE',
  };

  static OrderSaleChannel fromWire(String? wire) => switch (wire) {
    'SHOP' => OrderSaleChannel.shop,
    'ECOMMERCE' => OrderSaleChannel.ecommerce,
    _ => OrderSaleChannel.shop,
  };
}
