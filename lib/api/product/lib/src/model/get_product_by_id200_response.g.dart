// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_product_by_id200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GetProductById200Response extends GetProductById200Response {
  @override
  final bool success;
  @override
  final ProductResponse data;
  @override
  final DateTime timestamp;

  factory _$GetProductById200Response([
    void Function(GetProductById200ResponseBuilder)? updates,
  ]) => (GetProductById200ResponseBuilder()..update(updates))._build();

  _$GetProductById200Response._({
    required this.success,
    required this.data,
    required this.timestamp,
  }) : super._();
  @override
  GetProductById200Response rebuild(
    void Function(GetProductById200ResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  GetProductById200ResponseBuilder toBuilder() =>
      GetProductById200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GetProductById200Response &&
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
    return (newBuiltValueToStringHelper(r'GetProductById200Response')
          ..add('success', success)
          ..add('data', data)
          ..add('timestamp', timestamp))
        .toString();
  }
}

class GetProductById200ResponseBuilder
    implements
        Builder<GetProductById200Response, GetProductById200ResponseBuilder> {
  _$GetProductById200Response? _$v;

  bool? _success;
  bool? get success => _$this._success;
  set success(bool? success) => _$this._success = success;

  ProductResponseBuilder? _data;
  ProductResponseBuilder get data => _$this._data ??= ProductResponseBuilder();
  set data(ProductResponseBuilder? data) => _$this._data = data;

  DateTime? _timestamp;
  DateTime? get timestamp => _$this._timestamp;
  set timestamp(DateTime? timestamp) => _$this._timestamp = timestamp;

  GetProductById200ResponseBuilder() {
    GetProductById200Response._defaults(this);
  }

  GetProductById200ResponseBuilder get _$this {
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
  void replace(GetProductById200Response other) {
    _$v = other as _$GetProductById200Response;
  }

  @override
  void update(void Function(GetProductById200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GetProductById200Response build() => _build();

  _$GetProductById200Response _build() {
    _$GetProductById200Response _$result;
    try {
      _$result =
          _$v ??
          _$GetProductById200Response._(
            success: BuiltValueNullFieldError.checkNotNull(
              success,
              r'GetProductById200Response',
              'success',
            ),
            data: data.build(),
            timestamp: BuiltValueNullFieldError.checkNotNull(
              timestamp,
              r'GetProductById200Response',
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
          r'GetProductById200Response',
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
