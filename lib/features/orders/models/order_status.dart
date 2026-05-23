enum OrderStatus {
  draft,
  pending,
  completed,
  cancelled;

  String toWire() => switch (this) {
    OrderStatus.draft => 'DRAFT',
    OrderStatus.pending => 'PENDING',
    OrderStatus.completed => 'COMPLETED',
    OrderStatus.cancelled => 'CANCELLED',
  };

  /// Defaults to [draft] for null / empty / unknown values. We deliberately
  /// don't throw — a new server-side enum value should not crash the app.
  static OrderStatus fromWire(String? wire) => switch (wire) {
    'DRAFT' => OrderStatus.draft,
    'PENDING' => OrderStatus.pending,
    'COMPLETED' => OrderStatus.completed,
    'CANCELLED' => OrderStatus.cancelled,
    _ => OrderStatus.draft,
  };
}
