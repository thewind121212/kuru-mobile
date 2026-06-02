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
    this.storeName,
    this.scope,
    this.importEntryId,
    this.importEntryNumber,
    this.linkedPurchaseEntries = const [],
    this.voidedAt,
    this.voidedBy,
    this.voidReason,
  });

  factory ExpenseEntry.fromJson(Map<String, dynamic> json) {
    final source = json['source'] as String? ?? 'MANUAL';
    final linkedPurchaseEntries = _parseLinkedPurchaseEntries(
      json['linkedPurchaseEntries'],
    );
    final storeRef =
        _mapOrNull(json['store']) ??
        _mapOrNull(json['branch']) ??
        _mapOrNull(json['warehouse']);
    final importRef =
        _mapOrNull(json['importRef']) ??
        _mapOrNull(json['purchaseEntry']) ??
        _mapOrNull(json['purchase']) ??
        _mapOrNull(json['sourceRef']) ??
        _mapOrNull(json['reference']);
    final explicitImportEntryId = _firstString([
      json['importEntryId'],
      json['purchaseEntryId'],
      json['purchaseId'],
      importRef?['id'],
      importRef?['entryId'],
      importRef?['purchaseEntryId'],
      importRef?['importEntryId'],
    ]);
    final linkedImportEntryId = _firstString(
      linkedPurchaseEntries.map((entry) => entry.id),
    );
    final sourceBackedRefId = _isImportSource(source)
        ? _firstString([
            json['referenceId'],
            json['sourceRefId'],
            json['sourceId'],
            json['refId'],
          ])
        : null;
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
      source: source,
      subscriptionId: json['subscriptionId'] as String?,
      cycleDate: parseProtoDate(json['cycleDate']),
      storeId: _firstString([
        json['storeId'],
        json['branchId'],
        json['warehouseId'],
        storeRef?['id'],
        storeRef?['storeId'],
        storeRef?['branchId'],
      ]),
      storeName: _firstString([
        json['storeName'],
        json['branchName'],
        json['warehouseName'],
        json['storeDisplayName'],
        json['branchDisplayName'],
        json['warehouseDisplayName'],
        storeRef?['name'],
        storeRef?['storeName'],
        storeRef?['branchName'],
        storeRef?['displayName'],
        storeRef?['storeDisplayName'],
        storeRef?['branchDisplayName'],
      ]),
      scope: _firstString([
        json['scope'],
        json['expenseScope'],
        json['appliesTo'],
        json['visibilityScope'],
      ]),
      importEntryId:
          explicitImportEntryId ?? linkedImportEntryId ?? sourceBackedRefId,
      importEntryNumber: _firstString([
        json['importEntryNumber'],
        json['purchaseEntryNumber'],
        json['entryNumber'],
        json['referenceNumber'],
        json['sourceRefNumber'],
        importRef?['entryNumber'],
        importRef?['number'],
        importRef?['code'],
        importRef?['invoiceRef'],
        ...linkedPurchaseEntries.map((entry) => entry.entryNumber),
      ]),
      linkedPurchaseEntries: linkedPurchaseEntries,
      voidedAt: parseProtoDate(json['voidedAt']),
      voidedBy: json['voidedBy'] as String?,
      voidReason: json['voidReason'] as String?,
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
  final String? storeName;
  final String? scope;
  final String? importEntryId;
  final String? importEntryNumber;
  final List<ExpenseLinkedPurchaseEntry> linkedPurchaseEntries;
  final DateTime? voidedAt;
  final String? voidedBy;
  final String? voidReason;

  String get title => categoryName;
  bool get isVoided => isDelete || voidedAt != null;

  bool get isOrgWide {
    if (linkedImportWarehousesDeduped.isNotEmpty) return false;
    final normalized = scope?.toUpperCase();
    if (normalized != null) {
      if (normalized.contains('ORG') || normalized.contains('ORGANIZATION')) {
        return true;
      }
      if (normalized.contains('STORE') ||
          normalized.contains('BRANCH') ||
          normalized.contains('WAREHOUSE')) {
        return false;
      }
    }
    return !_notBlank(storeId) && !_notBlank(storeName);
  }

  bool get isBranchScoped => !isOrgWide;

  String? get branchDisplayName {
    final linkedWarehouse = linkedImportWarehousesDeduped.firstOrNull;
    final linkedName = linkedWarehouse?.name.trim();
    if (linkedName != null && linkedName.isNotEmpty) return linkedName;
    final name = storeName?.trim();
    if (name != null && name.isNotEmpty) return name;
    return null;
  }

  List<ExpenseLinkedWarehouse> get linkedImportWarehousesDeduped {
    final seen = <String>{};
    final warehouses = <ExpenseLinkedWarehouse>[];
    for (final purchaseEntry in linkedPurchaseEntries) {
      for (final warehouse in purchaseEntry.warehouses) {
        final name = warehouse.name.trim();
        if (name.isEmpty) continue;
        final id = warehouse.id.trim();
        final key = id.isNotEmpty ? id : name.toLowerCase();
        if (seen.add(key)) {
          warehouses.add(ExpenseLinkedWarehouse(id: id, name: name));
        }
      }
    }
    return warehouses;
  }

  bool get hasImportRef =>
      _notBlank(resolvedImportEntryId) ||
      _notBlank(resolvedImportEntryNumber) ||
      linkedPurchaseEntries.isNotEmpty;

  String? get resolvedImportEntryId =>
      _firstString([importEntryId, ...linkedPurchaseEntries.map((e) => e.id)]);

  String? get resolvedImportEntryNumber => _firstString([
    importEntryNumber,
    ...linkedPurchaseEntries.map((e) => e.entryNumber),
  ]);

  String get importRefLabel {
    final number = resolvedImportEntryNumber?.trim();
    if (number != null && number.isNotEmpty) return number;
    final id = resolvedImportEntryId?.trim();
    return id == null || id.isEmpty ? 'Phiếu nhập' : 'Phiếu nhập $id';
  }

  bool matches(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return true;
    return categoryName.toLowerCase().contains(q) ||
        (note?.toLowerCase().contains(q) ?? false) ||
        (importEntryNumber?.toLowerCase().contains(q) ?? false) ||
        (importEntryId?.toLowerCase().contains(q) ?? false) ||
        linkedPurchaseEntries.any((entry) => entry.matches(q));
  }

  static int _parseAmount(Object? raw) {
    if (raw == null) return 0;
    if (raw is num) return raw.toInt();
    return int.tryParse(raw.toString()) ?? 0;
  }

  static Map<String, dynamic>? _mapOrNull(Object? raw) {
    if (raw is Map<String, dynamic>) return raw;
    if (raw is Map) return raw.cast<String, dynamic>();
    return null;
  }

  static String? _firstString(Iterable<Object?> values) {
    for (final value in values) {
      final text = value?.toString().trim();
      if (text != null && text.isNotEmpty) return text;
    }
    return null;
  }

  static bool _isImportSource(String source) {
    final normalized = source.toUpperCase();
    return normalized.contains('IMPORT') || normalized.contains('PURCHASE');
  }

  static List<ExpenseLinkedPurchaseEntry> _parseLinkedPurchaseEntries(
    Object? raw,
  ) {
    if (raw is! List) return const [];
    return raw
        .map(_mapOrNull)
        .whereType<Map<String, dynamic>>()
        .map(ExpenseLinkedPurchaseEntry.fromJson)
        .toList();
  }

  static bool _notBlank(String? value) =>
      value != null && value.trim().isNotEmpty;
}

class ExpenseLinkedPurchaseEntry {
  const ExpenseLinkedPurchaseEntry({
    required this.id,
    required this.entryNumber,
    this.warehouses = const [],
  });

  factory ExpenseLinkedPurchaseEntry.fromJson(Map<String, dynamic> json) {
    return ExpenseLinkedPurchaseEntry(
      id:
          ExpenseEntry._firstString([
            json['id'],
            json['purchaseEntryId'],
            json['importEntryId'],
          ]) ??
          '',
      entryNumber:
          ExpenseEntry._firstString([
            json['entryNumber'],
            json['purchaseEntryNumber'],
            json['importEntryNumber'],
            json['number'],
            json['code'],
          ]) ??
          '',
      warehouses: ExpenseLinkedWarehouse.listFromJson(json['warehouses']),
    );
  }

  final String id;
  final String entryNumber;
  final List<ExpenseLinkedWarehouse> warehouses;

  bool matches(String query) {
    return id.toLowerCase().contains(query) ||
        entryNumber.toLowerCase().contains(query) ||
        warehouses.any((warehouse) => warehouse.matches(query));
  }
}

class ExpenseLinkedWarehouse {
  const ExpenseLinkedWarehouse({required this.id, required this.name});

  factory ExpenseLinkedWarehouse.fromJson(Map<String, dynamic> json) {
    return ExpenseLinkedWarehouse(
      id:
          ExpenseEntry._firstString([
            json['id'],
            json['warehouseId'],
            json['branchId'],
            json['storeId'],
          ]) ??
          '',
      name:
          ExpenseEntry._firstString([
            json['name'],
            json['warehouseName'],
            json['branchName'],
            json['storeName'],
            json['displayName'],
          ]) ??
          '',
    );
  }

  final String id;
  final String name;

  bool matches(String query) {
    return id.toLowerCase().contains(query) ||
        name.toLowerCase().contains(query);
  }

  static List<ExpenseLinkedWarehouse> listFromJson(Object? raw) {
    if (raw is! List) return const [];
    return raw
        .map(ExpenseEntry._mapOrNull)
        .whereType<Map<String, dynamic>>()
        .map(ExpenseLinkedWarehouse.fromJson)
        .toList();
  }
}

extension _IterableFirstOrNull<T> on Iterable<T> {
  T? get firstOrNull {
    final iterator = this.iterator;
    if (!iterator.moveNext()) return null;
    return iterator.current;
  }
}
