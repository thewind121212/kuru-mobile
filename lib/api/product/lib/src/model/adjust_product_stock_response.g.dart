// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'adjust_product_stock_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdjustProductStockResponse extends AdjustProductStockResponse {
  @override
  final bool success;
  @override
  final String? error;

  factory _$AdjustProductStockResponse([
    void Function(AdjustProductStockResponseBuilder)? updates,
  ]) => (AdjustProductStockResponseBuilder()..update(updates))._build();

  _$AdjustProductStockResponse._({required this.success, this.error})
    : super._();
  @override
  AdjustProductStockResponse rebuild(
    void Function(AdjustProductStockResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdjustProductStockResponseBuilder toBuilder() =>
      AdjustProductStockResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdjustProductStockResponse &&
        success == other.success &&
        error == other.error;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, success.hashCode);
    _$hash = $jc(_$hash, error.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdjustProductStockResponse')
          ..add('success', success)
          ..add('error', error))
        .toString();
  }
}

class AdjustProductStockResponseBuilder
    implements
        Builder<AdjustProductStockResponse, AdjustProductStockResponseBuilder> {
  _$AdjustProductStockResponse? _$v;

  bool? _success;
  bool? get success => _$this._success;
  set success(bool? success) => _$this._success = success;

  String? _error;
  String? get error => _$this._error;
  set error(String? error) => _$this._error = error;

  AdjustProductStockResponseBuilder() {
    AdjustProductStockResponse._defaults(this);
  }

  AdjustProductStockResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _success = $v.success;
      _error = $v.error;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdjustProductStockResponse other) {
    _$v = other as _$AdjustProductStockResponse;
  }

  @override
  void update(void Function(AdjustProductStockResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdjustProductStockResponse build() => _build();

  _$AdjustProductStockResponse _build() {
    final _$result =
        _$v ??
        _$AdjustProductStockResponse._(
          success: BuiltValueNullFieldError.checkNotNull(
            success,
            r'AdjustProductStockResponse',
            'success',
          ),
          error: error,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
