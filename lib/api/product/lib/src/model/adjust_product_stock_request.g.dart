// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'adjust_product_stock_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdjustProductStockRequest extends AdjustProductStockRequest {
  @override
  final String productId;
  @override
  final BuiltList<AdjustStockInput>? stocks;
  @override
  final ManualAdjustReason reason;
  @override
  final String? note;

  factory _$AdjustProductStockRequest([
    void Function(AdjustProductStockRequestBuilder)? updates,
  ]) => (AdjustProductStockRequestBuilder()..update(updates))._build();

  _$AdjustProductStockRequest._({
    required this.productId,
    this.stocks,
    required this.reason,
    this.note,
  }) : super._();
  @override
  AdjustProductStockRequest rebuild(
    void Function(AdjustProductStockRequestBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdjustProductStockRequestBuilder toBuilder() =>
      AdjustProductStockRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdjustProductStockRequest &&
        productId == other.productId &&
        stocks == other.stocks &&
        reason == other.reason &&
        note == other.note;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, productId.hashCode);
    _$hash = $jc(_$hash, stocks.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdjustProductStockRequest')
          ..add('productId', productId)
          ..add('stocks', stocks)
          ..add('reason', reason)
          ..add('note', note))
        .toString();
  }
}

class AdjustProductStockRequestBuilder
    implements
        Builder<AdjustProductStockRequest, AdjustProductStockRequestBuilder> {
  _$AdjustProductStockRequest? _$v;

  String? _productId;
  String? get productId => _$this._productId;
  set productId(String? productId) => _$this._productId = productId;

  ListBuilder<AdjustStockInput>? _stocks;
  ListBuilder<AdjustStockInput> get stocks =>
      _$this._stocks ??= ListBuilder<AdjustStockInput>();
  set stocks(ListBuilder<AdjustStockInput>? stocks) => _$this._stocks = stocks;

  ManualAdjustReason? _reason;
  ManualAdjustReason? get reason => _$this._reason;
  set reason(ManualAdjustReason? reason) => _$this._reason = reason;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  AdjustProductStockRequestBuilder() {
    AdjustProductStockRequest._defaults(this);
  }

  AdjustProductStockRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _productId = $v.productId;
      _stocks = $v.stocks?.toBuilder();
      _reason = $v.reason;
      _note = $v.note;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdjustProductStockRequest other) {
    _$v = other as _$AdjustProductStockRequest;
  }

  @override
  void update(void Function(AdjustProductStockRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdjustProductStockRequest build() => _build();

  _$AdjustProductStockRequest _build() {
    _$AdjustProductStockRequest _$result;
    try {
      _$result =
          _$v ??
          _$AdjustProductStockRequest._(
            productId: BuiltValueNullFieldError.checkNotNull(
              productId,
              r'AdjustProductStockRequest',
              'productId',
            ),
            stocks: _stocks?.build(),
            reason: BuiltValueNullFieldError.checkNotNull(
              reason,
              r'AdjustProductStockRequest',
              'reason',
            ),
            note: note,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'stocks';
        _stocks?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdjustProductStockRequest',
          _$failedField,
          e.toString(),
        );
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
