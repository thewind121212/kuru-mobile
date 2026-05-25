class PurchaseSummary {
  const PurchaseSummary({
    required this.totalCost,
    required this.totalQty,
    required this.entryCount,
  });

  final int totalCost;
  final num totalQty;
  final int entryCount;

  factory PurchaseSummary.empty() {
    return const PurchaseSummary(totalCost: 0, totalQty: 0, entryCount: 0);
  }

  factory PurchaseSummary.fromJson(Map<String, dynamic> json) {
    return PurchaseSummary(
      totalCost: ((json['totalCost'] as num?) ?? 0).round(),
      totalQty: (json['totalQty'] as num?) ?? 0,
      entryCount: ((json['entryCount'] as num?) ?? 0).toInt(),
    );
  }
}
