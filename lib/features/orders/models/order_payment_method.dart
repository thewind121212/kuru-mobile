enum OrderPaymentMethod {
  cash,
  bankTransfer,
  card,
  other;

  String toWire() => switch (this) {
    OrderPaymentMethod.cash => 'CASH',
    OrderPaymentMethod.bankTransfer => 'BANK_TRANSFER',
    OrderPaymentMethod.card => 'CARD',
    OrderPaymentMethod.other => 'OTHER',
  };

  static OrderPaymentMethod fromWire(String? wire) => switch (wire) {
    'CASH' => OrderPaymentMethod.cash,
    'BANK_TRANSFER' => OrderPaymentMethod.bankTransfer,
    'CARD' => OrderPaymentMethod.card,
    'OTHER' => OrderPaymentMethod.other,
    _ => OrderPaymentMethod.other,
  };
}
