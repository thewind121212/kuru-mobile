class ExpenseSummary {
  const ExpenseSummary({
    required this.total,
    required this.monthTotal,
    required this.count,
  });

  factory ExpenseSummary.empty() {
    return const ExpenseSummary(total: 0, monthTotal: 0, count: 0);
  }

  factory ExpenseSummary.fromReportJson(Map<String, dynamic> json) {
    return ExpenseSummary(
      total: _parseAmount(json['total']),
      monthTotal: _parseAmount(json['total']),
      count: (json['entryCount'] as num?)?.toInt() ?? 0,
    );
  }

  final int total;
  final int monthTotal;
  final int count;

  static int _parseAmount(Object? raw) {
    if (raw == null) return 0;
    if (raw is num) return raw.toInt();
    return int.tryParse(raw.toString()) ?? 0;
  }
}
