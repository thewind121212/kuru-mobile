enum OrderPaymentStatus {
  unpaid,
  partial,
  paid;

  String toWire() => switch (this) {
    OrderPaymentStatus.unpaid => 'UNPAID',
    OrderPaymentStatus.partial => 'PARTIAL',
    OrderPaymentStatus.paid => 'PAID',
  };

  static OrderPaymentStatus fromWire(String? wire) => switch (wire) {
    'UNPAID' => OrderPaymentStatus.unpaid,
    'PARTIAL' => OrderPaymentStatus.partial,
    'PAID' => OrderPaymentStatus.paid,
    _ => OrderPaymentStatus.unpaid,
  };
}
