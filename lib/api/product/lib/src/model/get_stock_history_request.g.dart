// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_stock_history_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GetStockHistoryRequest extends GetStockHistoryRequest {
  @override
  final String? productId;
  @override
  final String? warehouseId;
  @override
  final DateTime? fromDate;
  @override
  final DateTime? toDate;
  @override
  final int? page;
  @override
  final int? limit;
  @override
  final String? variantId;
  @override
  final String? type;

  factory _$GetStockHistoryRequest([
    void Function(GetStockHistoryRequestBuilder)? updates,
  ]) => (GetStockHistoryRequestBuilder()..update(updates))._build();

  _$GetStockHistoryRequest._({
    this.productId,
    this.warehouseId,
    this.fromDate,
    this.toDate,
    this.page,
    this.limit,
    this.variantId,
    this.type,
  }) : super._();
  @override
  GetStockHistoryRequest rebuild(
    void Function(GetStockHistoryRequestBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  GetStockHistoryRequestBuilder toBuilder() =>
      GetStockHistoryRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GetStockHistoryRequest &&
        productId == other.productId &&
        warehouseId == other.warehouseId &&
        fromDate == other.fromDate &&
        toDate == other.toDate &&
        page == other.page &&
        limit == other.limit &&
        variantId == other.variantId &&
        type == other.type;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, productId.hashCode);
    _$hash = $jc(_$hash, warehouseId.hashCode);
    _$hash = $jc(_$hash, fromDate.hashCode);
    _$hash = $jc(_$hash, toDate.hashCode);
    _$hash = $jc(_$hash, page.hashCode);
    _$hash = $jc(_$hash, limit.hashCode);
    _$hash = $jc(_$hash, variantId.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GetStockHistoryRequest')
          ..add('productId', productId)
          ..add('warehouseId', warehouseId)
          ..add('fromDate', fromDate)
          ..add('toDate', toDate)
          ..add('page', page)
          ..add('limit', limit)
          ..add('variantId', variantId)
          ..add('type', type))
        .toString();
  }
}

class GetStockHistoryRequestBuilder
    implements Builder<GetStockHistoryRequest, GetStockHistoryRequestBuilder> {
  _$GetStockHistoryRequest? _$v;

  String? _productId;
  String? get productId => _$this._productId;
  set productId(String? productId) => _$this._productId = productId;

  String? _warehouseId;
  String? get warehouseId => _$this._warehouseId;
  set warehouseId(String? warehouseId) => _$this._warehouseId = warehouseId;

  DateTime? _fromDate;
  DateTime? get fromDate => _$this._fromDate;
  set fromDate(DateTime? fromDate) => _$this._fromDate = fromDate;

  DateTime? _toDate;
  DateTime? get toDate => _$this._toDate;
  set toDate(DateTime? toDate) => _$this._toDate = toDate;

  int? _page;
  int? get page => _$this._page;
  set page(int? page) => _$this._page = page;

  int? _limit;
  int? get limit => _$this._limit;
  set limit(int? limit) => _$this._limit = limit;

  String? _variantId;
  String? get variantId => _$this._variantId;
  set variantId(String? variantId) => _$this._variantId = variantId;

  String? _type;
  String? get type => _$this._type;
  set type(String? type) => _$this._type = type;

  GetStockHistoryRequestBuilder() {
    GetStockHistoryRequest._defaults(this);
  }

  GetStockHistoryRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _productId = $v.productId;
      _warehouseId = $v.warehouseId;
      _fromDate = $v.fromDate;
      _toDate = $v.toDate;
      _page = $v.page;
      _limit = $v.limit;
      _variantId = $v.variantId;
      _type = $v.type;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GetStockHistoryRequest other) {
    _$v = other as _$GetStockHistoryRequest;
  }

  @override
  void update(void Function(GetStockHistoryRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GetStockHistoryRequest build() => _build();

  _$GetStockHistoryRequest _build() {
    final _$result =
        _$v ??
        _$GetStockHistoryRequest._(
          productId: productId,
          warehouseId: warehouseId,
          fromDate: fromDate,
          toDate: toDate,
          page: page,
          limit: limit,
          variantId: variantId,
          type: type,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
