enum PurchaseEntryStatus {
  draft('DRAFT'),
  posted('POSTED'),
  cancelled('CANCELLED');

  const PurchaseEntryStatus(this.wire);

  final String wire;

  static PurchaseEntryStatus fromWire(String? value) {
    return switch (value) {
      'DRAFT' => PurchaseEntryStatus.draft,
      'POSTED' => PurchaseEntryStatus.posted,
      'CANCELLED' => PurchaseEntryStatus.cancelled,
      _ => PurchaseEntryStatus.draft,
    };
  }
}
