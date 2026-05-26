import 'package:kuru_mobile/features/imports/models/purchase_entry_status.dart';

class PurchaseEntryOverview {
  const PurchaseEntryOverview({
    required this.id,
    required this.orgId,
    required this.entryNumber,
    required this.status,
    required this.createdAt,
    required this.totalCost,
    required this.totalQty,
    required this.itemCount,
    this.distributorId,
    this.distributorName,
    this.invoiceRef,
    this.invoiceDate,
    this.paymentMethod,
    this.postedAt,
    this.cancelledAt,
  });

  final String id;
  final String orgId;
  final String entryNumber;
  final PurchaseEntryStatus status;
  final String? distributorId;
  final String? distributorName;
  final String? invoiceRef;
  final DateTime? invoiceDate;
  final String? paymentMethod;
  final DateTime createdAt;
  final DateTime? postedAt;
  final DateTime? cancelledAt;
  final int totalCost;
  final num totalQty;
  final int itemCount;

  factory PurchaseEntryOverview.fromJson(Map<String, dynamic> json) {
    return PurchaseEntryOverview(
      id: json['id'] as String? ?? '',
      orgId: json['orgId'] as String? ?? '',
      entryNumber: json['entryNumber'] as String? ?? '',
      status: PurchaseEntryStatus.fromWire(json['status'] as String?),
      distributorId: json['distributorId'] as String?,
      distributorName: json['distributorName'] as String?,
      invoiceRef: json['invoiceRef'] as String?,
      invoiceDate: _date(json['invoiceDate']),
      paymentMethod: json['paymentMethod'] as String?,
      createdAt:
          _date(json['createdAt']) ?? DateTime.fromMillisecondsSinceEpoch(0),
      postedAt: _date(json['postedAt']),
      cancelledAt: _date(json['cancelledAt']),
      totalCost: ((json['totalCost'] as num?) ?? 0).round(),
      totalQty: (json['totalQty'] as num?) ?? 0,
      itemCount: ((json['itemCount'] as num?) ?? 0).toInt(),
    );
  }
}

class PurchaseEntryPage {
  const PurchaseEntryPage({
    required this.entries,
    required this.total,
    required this.page,
    required this.limit,
  });

  final List<PurchaseEntryOverview> entries;
  final int total;
  final int page;
  final int limit;

  bool get hasMore => entries.length >= limit && total > page * limit;
}

class PurchaseEntryDetail {
  const PurchaseEntryDetail({
    required this.id,
    required this.orgId,
    required this.entryNumber,
    required this.status,
    required this.createdAt,
    required this.totalCost,
    required this.totalQty,
    required this.itemCount,
    required this.items,
    this.distributorId,
    this.distributorName,
    this.invoiceRef,
    this.invoiceDate,
    this.paymentMethod,
    this.postedAt,
    this.cancelledAt,
    this.warehouseId,
    this.warehouseName,
    this.note,
  });

  factory PurchaseEntryDetail.fromJson(Map<String, dynamic> json) {
    final itemsJson =
        json['items'] as List<dynamic>? ??
        json['lines'] as List<dynamic>? ??
        const <dynamic>[];
    final items = itemsJson
        .map((e) => PurchaseEntryLine.fromJson(e as Map<String, dynamic>))
        .toList();
    final computedTotal = items.fold<int>(0, (sum, item) => sum + item.total);
    final computedQty = items.fold<num>(0, (sum, item) => sum + item.qty);
    return PurchaseEntryDetail(
      id: json['id'] as String? ?? '',
      orgId: json['orgId'] as String? ?? '',
      entryNumber: json['entryNumber'] as String? ?? '',
      status: PurchaseEntryStatus.fromWire(json['status'] as String?),
      distributorId: json['distributorId'] as String?,
      distributorName: json['distributorName'] as String?,
      invoiceRef: json['invoiceRef'] as String?,
      invoiceDate: _date(json['invoiceDate']),
      paymentMethod: json['paymentMethod'] as String?,
      createdAt:
          _date(json['createdAt']) ?? DateTime.fromMillisecondsSinceEpoch(0),
      postedAt: _date(json['postedAt']),
      cancelledAt: _date(json['cancelledAt']),
      totalCost: ((json['totalCost'] as num?) ?? computedTotal).round(),
      totalQty: (json['totalQty'] as num?) ?? computedQty,
      itemCount: ((json['itemCount'] as num?) ?? items.length).toInt(),
      warehouseId: json['warehouseId'] as String?,
      warehouseName: json['warehouseName'] as String?,
      note: json['note'] as String?,
      items: items,
    );
  }

  final String id;
  final String orgId;
  final String entryNumber;
  final PurchaseEntryStatus status;
  final String? distributorId;
  final String? distributorName;
  final String? invoiceRef;
  final DateTime? invoiceDate;
  final String? paymentMethod;
  final DateTime createdAt;
  final DateTime? postedAt;
  final DateTime? cancelledAt;
  final int totalCost;
  final num totalQty;
  final int itemCount;
  final String? warehouseId;
  final String? warehouseName;
  final String? note;
  final List<PurchaseEntryLine> items;
}

class PurchaseEntryLine {
  const PurchaseEntryLine({
    required this.id,
    required this.productId,
    required this.productName,
    required this.qty,
    required this.unitCost,
    required this.total,
    this.variantId,
    this.variantName,
    this.warehouseId,
    this.warehouseName,
    this.sku,
    this.barcode,
    this.imageUrl,
    this.variantImageUrl,
  });

  factory PurchaseEntryLine.fromJson(Map<String, dynamic> json) {
    final qty =
        json['qtyInput'] as num? ??
        json['qty'] as num? ??
        json['quantity'] as num? ??
        json['qtyBase'] as num? ??
        0;
    final unitCost =
        (json['unitCostInput'] as num? ?? json['unitCost'] as num?)?.round() ??
        0;
    return PurchaseEntryLine(
      id: json['id'] as String? ?? '',
      productId: json['productId'] as String? ?? '',
      productName:
          json['productName'] as String? ??
          json['name'] as String? ??
          'Sản phẩm',
      variantId: json['variantId'] as String?,
      variantName: json['variantName'] as String?,
      warehouseId: json['warehouseId'] as String?,
      warehouseName: json['warehouseName'] as String?,
      sku: json['sku'] as String?,
      barcode: json['barcode'] as String?,
      imageUrl: _stringOrNull(json['imageUrl']),
      variantImageUrl: _stringOrNull(json['variantImageUrl']),
      qty: qty,
      unitCost: unitCost,
      total:
          (json['total'] as num? ??
                  json['lineTotal'] as num? ??
                  json['totalCost'] as num? ??
                  (qty * unitCost))
              .round(),
    );
  }

  final String id;
  final String productId;
  final String productName;
  final String? variantId;
  final String? variantName;
  final String? warehouseId;
  final String? warehouseName;
  final String? sku;
  final String? barcode;
  final String? imageUrl;
  final String? variantImageUrl;
  final num qty;
  final int unitCost;
  final int total;
}

String? _stringOrNull(Object? value) {
  final raw = value?.toString().trim();
  if (raw == null || raw.isEmpty) return null;
  return raw;
}

DateTime? _date(Object? value) {
  if (value == null) return null;
  return DateTime.tryParse(value.toString());
}
