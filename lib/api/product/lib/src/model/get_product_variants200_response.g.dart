// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_product_variants200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GetProductVariants200Response extends GetProductVariants200Response {
  @override
  final bool success;
  @override
  final GetProductVariantsResponse data;
  @override
  final DateTime timestamp;

  factory _$GetProductVariants200Response([
    void Function(GetProductVariants200ResponseBuilder)? updates,
  ]) => (GetProductVariants200ResponseBuilder()..update(updates))._build();

  _$GetProductVariants200Response._({
    required this.success,
    required this.data,
    required this.timestamp,
  }) : super._();
  @override
  GetProductVariants200Response rebuild(
    void Function(GetProductVariants200ResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  GetProductVariants200ResponseBuilder toBuilder() =>
      GetProductVariants200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GetProductVariants200Response &&
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
    return (newBuiltValueToStringHelper(r'GetProductVariants200Response')
          ..add('success', success)
          ..add('data', data)
          ..add('timestamp', timestamp))
        .toString();
  }
}

class GetProductVariants200ResponseBuilder
    implements
        Builder<
          GetProductVariants200Response,
          GetProductVariants200ResponseBuilder
        > {
  _$GetProductVariants200Response? _$v;

  bool? _success;
  bool? get success => _$this._success;
  set success(bool? success) => _$this._success = success;

  GetProductVariantsResponseBuilder? _data;
  GetProductVariantsResponseBuilder get data =>
      _$this._data ??= GetProductVariantsResponseBuilder();
  set data(GetProductVariantsResponseBuilder? data) => _$this._data = data;

  DateTime? _timestamp;
  DateTime? get timestamp => _$this._timestamp;
  set timestamp(DateTime? timestamp) => _$this._timestamp = timestamp;

  GetProductVariants200ResponseBuilder() {
    GetProductVariants200Response._defaults(this);
  }

  GetProductVariants200ResponseBuilder get _$this {
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
  void replace(GetProductVariants200Response other) {
    _$v = other as _$GetProductVariants200Response;
  }

  @override
  void update(void Function(GetProductVariants200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GetProductVariants200Response build() => _build();

  _$GetProductVariants200Response _build() {
    _$GetProductVariants200Response _$result;
    try {
      _$result =
          _$v ??
          _$GetProductVariants200Response._(
            success: BuiltValueNullFieldError.checkNotNull(
              success,
              r'GetProductVariants200Response',
              'success',
            ),
            data: data.build(),
            timestamp: BuiltValueNullFieldError.checkNotNull(
              timestamp,
              r'GetProductVariants200Response',
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
          r'GetProductVariants200Response',
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
