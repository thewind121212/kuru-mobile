// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'adjust_product_stock200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdjustProductStock200Response extends AdjustProductStock200Response {
  @override
  final bool success;
  @override
  final AdjustProductStockResponse data;
  @override
  final DateTime timestamp;

  factory _$AdjustProductStock200Response([
    void Function(AdjustProductStock200ResponseBuilder)? updates,
  ]) => (AdjustProductStock200ResponseBuilder()..update(updates))._build();

  _$AdjustProductStock200Response._({
    required this.success,
    required this.data,
    required this.timestamp,
  }) : super._();
  @override
  AdjustProductStock200Response rebuild(
    void Function(AdjustProductStock200ResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdjustProductStock200ResponseBuilder toBuilder() =>
      AdjustProductStock200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdjustProductStock200Response &&
        success == other.success &&
        data == other.data &&
        timestamp == other.timestamp;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, success.hashCode);
    _$hash = $jc(_$hash, data.hashCode);
    _$hash = $jc(_$hash, timestamp.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdjustProductStock200Response')
          ..add('success', success)
          ..add('data', data)
          ..add('timestamp', timestamp))
        .toString();
  }
}

class AdjustProductStock200ResponseBuilder
    implements
        Builder<
          AdjustProductStock200Response,
          AdjustProductStock200ResponseBuilder
        > {
  _$AdjustProductStock200Response? _$v;

  bool? _success;
  bool? get success => _$this._success;
  set success(bool? success) => _$this._success = success;

  AdjustProductStockResponseBuilder? _data;
  AdjustProductStockResponseBuilder get data =>
      _$this._data ??= AdjustProductStockResponseBuilder();
  set data(AdjustProductStockResponseBuilder? data) => _$this._data = data;

  DateTime? _timestamp;
  DateTime? get timestamp => _$this._timestamp;
  set timestamp(DateTime? timestamp) => _$this._timestamp = timestamp;

  AdjustProductStock200ResponseBuilder() {
    AdjustProductStock200Response._defaults(this);
  }

  AdjustProductStock200ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _success = $v.success;
      _data = $v.data.toBuilder();
      _timestamp = $v.timestamp;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdjustProductStock200Response other) {
    _$v = other as _$AdjustProductStock200Response;
  }

  @override
  void update(void Function(AdjustProductStock200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdjustProductStock200Response build() => _build();

  _$AdjustProductStock200Response _build() {
    _$AdjustProductStock200Response _$result;
    try {
      _$result =
          _$v ??
          _$AdjustProductStock200Response._(
            success: BuiltValueNullFieldError.checkNotNull(
              success,
              r'AdjustProductStock200Response',
              'success',
            ),
            data: data.build(),
            timestamp: BuiltValueNullFieldError.checkNotNull(
              timestamp,
              r'AdjustProductStock200Response',
              'timestamp',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdjustProductStock200Response',
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
