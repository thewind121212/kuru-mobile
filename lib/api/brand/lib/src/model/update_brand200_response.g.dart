// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_brand200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UpdateBrand200Response extends UpdateBrand200Response {
  @override
  final bool success;
  @override
  final UpdateBrandResponse data;
  @override
  final DateTime timestamp;

  factory _$UpdateBrand200Response([
    void Function(UpdateBrand200ResponseBuilder)? updates,
  ]) => (UpdateBrand200ResponseBuilder()..update(updates))._build();

  _$UpdateBrand200Response._({
    required this.success,
    required this.data,
    required this.timestamp,
  }) : super._();
  @override
  UpdateBrand200Response rebuild(
    void Function(UpdateBrand200ResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  UpdateBrand200ResponseBuilder toBuilder() =>
      UpdateBrand200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UpdateBrand200Response &&
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
    return (newBuiltValueToStringHelper(r'UpdateBrand200Response')
          ..add('success', success)
          ..add('data', data)
          ..add('timestamp', timestamp))
        .toString();
  }
}

class UpdateBrand200ResponseBuilder
    implements Builder<UpdateBrand200Response, UpdateBrand200ResponseBuilder> {
  _$UpdateBrand200Response? _$v;

  bool? _success;
  bool? get success => _$this._success;
  set success(bool? success) => _$this._success = success;

  UpdateBrandResponseBuilder? _data;
  UpdateBrandResponseBuilder get data =>
      _$this._data ??= UpdateBrandResponseBuilder();
  set data(UpdateBrandResponseBuilder? data) => _$this._data = data;

  DateTime? _timestamp;
  DateTime? get timestamp => _$this._timestamp;
  set timestamp(DateTime? timestamp) => _$this._timestamp = timestamp;

  UpdateBrand200ResponseBuilder() {
    UpdateBrand200Response._defaults(this);
  }

  UpdateBrand200ResponseBuilder get _$this {
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
  void replace(UpdateBrand200Response other) {
    _$v = other as _$UpdateBrand200Response;
  }

  @override
  void update(void Function(UpdateBrand200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UpdateBrand200Response build() => _build();

  _$UpdateBrand200Response _build() {
    _$UpdateBrand200Response _$result;
    try {
      _$result =
          _$v ??
          _$UpdateBrand200Response._(
            success: BuiltValueNullFieldError.checkNotNull(
              success,
              r'UpdateBrand200Response',
              'success',
            ),
            data: data.build(),
            timestamp: BuiltValueNullFieldError.checkNotNull(
              timestamp,
              r'UpdateBrand200Response',
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
          r'UpdateBrand200Response',
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
