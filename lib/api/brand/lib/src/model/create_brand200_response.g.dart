// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_brand200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CreateBrand200Response extends CreateBrand200Response {
  @override
  final bool success;
  @override
  final CreateBrandResponse data;
  @override
  final DateTime timestamp;

  factory _$CreateBrand200Response([
    void Function(CreateBrand200ResponseBuilder)? updates,
  ]) => (CreateBrand200ResponseBuilder()..update(updates))._build();

  _$CreateBrand200Response._({
    required this.success,
    required this.data,
    required this.timestamp,
  }) : super._();
  @override
  CreateBrand200Response rebuild(
    void Function(CreateBrand200ResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CreateBrand200ResponseBuilder toBuilder() =>
      CreateBrand200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreateBrand200Response &&
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
    return (newBuiltValueToStringHelper(r'CreateBrand200Response')
          ..add('success', success)
          ..add('data', data)
          ..add('timestamp', timestamp))
        .toString();
  }
}

class CreateBrand200ResponseBuilder
    implements Builder<CreateBrand200Response, CreateBrand200ResponseBuilder> {
  _$CreateBrand200Response? _$v;

  bool? _success;
  bool? get success => _$this._success;
  set success(bool? success) => _$this._success = success;

  CreateBrandResponseBuilder? _data;
  CreateBrandResponseBuilder get data =>
      _$this._data ??= CreateBrandResponseBuilder();
  set data(CreateBrandResponseBuilder? data) => _$this._data = data;

  DateTime? _timestamp;
  DateTime? get timestamp => _$this._timestamp;
  set timestamp(DateTime? timestamp) => _$this._timestamp = timestamp;

  CreateBrand200ResponseBuilder() {
    CreateBrand200Response._defaults(this);
  }

  CreateBrand200ResponseBuilder get _$this {
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
  void replace(CreateBrand200Response other) {
    _$v = other as _$CreateBrand200Response;
  }

  @override
  void update(void Function(CreateBrand200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreateBrand200Response build() => _build();

  _$CreateBrand200Response _build() {
    _$CreateBrand200Response _$result;
    try {
      _$result =
          _$v ??
          _$CreateBrand200Response._(
            success: BuiltValueNullFieldError.checkNotNull(
              success,
              r'CreateBrand200Response',
              'success',
            ),
            data: data.build(),
            timestamp: BuiltValueNullFieldError.checkNotNull(
              timestamp,
              r'CreateBrand200Response',
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
          r'CreateBrand200Response',
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
