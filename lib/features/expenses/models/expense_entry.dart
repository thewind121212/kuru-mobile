import 'package:kuru_mobile/core/parsing/parse_date.dart';

class ExpenseEntry {
  const ExpenseEntry({
    required this.id,
    required this.orgId,
    required this.categoryId,
    required this.categoryName,
    required this.amount,
    required this.paidAt,
    required this.isDelete,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    required this.source,
    this.note,
    this.receiptKey,
    this.subscriptionId,
    this.cycleDate,
    this.storeId,
  });

  factory ExpenseEntry.fromJson(Map<String, dynamic> json) {
    return ExpenseEntry(
      id: json['id'] as String? ?? '',
      orgId: json['orgId'] as String? ?? '',
      categoryId: json['categoryId'] as String? ?? '',
      categoryName: json['categoryName'] as String? ?? '',
      amount: _parseAmount(json['amount']),
      paidAt: parseProtoDateRequired(json['paidAt'], field: 'paidAt'),
      note: json['note'] as String?,
      receiptKey: json['receiptKey'] as String?,
      isDelete: json['isDelete'] as bool? ?? false,
      createdBy: json['createdBy'] as String? ?? '',
      createdAt: parseProtoDateRequired(json['createdAt'], field: 'createdAt'),
      updatedAt: parseProtoDateRequired(json['updatedAt'], field: 'updatedAt'),
      source: json['source'] as String? ?? 'MANUAL',
      subscriptionId: json['subscriptionId'] as String?,
      cycleDate: parseProtoDate(json['cycleDate']),
      storeId: json['storeId'] as String?,
    );
  }

  final String id;
  final String orgId;
  final String categoryId;
  final String categoryName;
  final int amount;
  final DateTime paidAt;
  final String? note;
  final String? receiptKey;
  final bool isDelete;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String source;
  final String? subscriptionId;
  final DateTime? cycleDate;
  final String? storeId;

  String get title => categoryName;

  bool matches(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return true;
    return categoryName.toLowerCase().contains(q) ||
        (note?.toLowerCase().contains(q) ?? false);
  }

  static int _parseAmount(Object? raw) {
    if (raw == null) return 0;
    if (raw is num) return raw.toInt();
    return int.tryParse(raw.toString()) ?? 0;
  }
}
