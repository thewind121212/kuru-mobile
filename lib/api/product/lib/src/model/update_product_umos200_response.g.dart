// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_product_umos200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UpdateProductUmos200Response extends UpdateProductUmos200Response {
  @override
  final bool success;
  @override
  final UpdateProductUmosResponse data;
  @override
  final DateTime timestamp;

  factory _$UpdateProductUmos200Response([
    void Function(UpdateProductUmos200ResponseBuilder)? updates,
  ]) => (UpdateProductUmos200ResponseBuilder()..update(updates))._build();

  _$UpdateProductUmos200Response._({
    required this.success,
    required this.data,
    required this.timestamp,
  }) : super._();
  @override
  UpdateProductUmos200Response rebuild(
    void Function(UpdateProductUmos200ResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  UpdateProductUmos200ResponseBuilder toBuilder() =>
      UpdateProductUmos200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UpdateProductUmos200Response &&
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
    return (newBuiltValueToStringHelper(r'UpdateProductUmos200Response')
          ..add('success', success)
          ..add('data', data)
          ..add('timestamp', timestamp))
        .toString();
  }
}

class UpdateProductUmos200ResponseBuilder
    implements
        Builder<
          UpdateProductUmos200Response,
          UpdateProductUmos200ResponseBuilder
        > {
  _$UpdateProductUmos200Response? _$v;

  bool? _success;
  bool? get success => _$this._success;
  set success(bool? success) => _$this._success = success;

  UpdateProductUmosResponseBuilder? _data;
  UpdateProductUmosResponseBuilder get data =>
      _$this._data ??= UpdateProductUmosResponseBuilder();
  set data(UpdateProductUmosResponseBuilder? data) => _$this._data = data;

  DateTime? _timestamp;
  DateTime? get timestamp => _$this._timestamp;
  set timestamp(DateTime? timestamp) => _$this._timestamp = timestamp;

  UpdateProductUmos200ResponseBuilder() {
    UpdateProductUmos200Response._defaults(this);
  }

  UpdateProductUmos200ResponseBuilder get _$this {
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
  void replace(UpdateProductUmos200Response other) {
    _$v = other as _$UpdateProductUmos200Response;
  }

  @override
  void update(void Function(UpdateProductUmos200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UpdateProductUmos200Response build() => _build();

  _$UpdateProductUmos200Response _build() {
    _$UpdateProductUmos200Response _$result;
    try {
      _$result =
          _$v ??
          _$UpdateProductUmos200Response._(
            success: BuiltValueNullFieldError.checkNotNull(
              success,
              r'UpdateProductUmos200Response',
              'success',
            ),
            data: data.build(),
            timestamp: BuiltValueNullFieldError.checkNotNull(
              timestamp,
              r'UpdateProductUmos200Response',
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
          r'UpdateProductUmos200Response',
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
