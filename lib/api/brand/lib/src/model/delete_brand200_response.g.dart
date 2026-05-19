// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_brand200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DeleteBrand200Response extends DeleteBrand200Response {
  @override
  final bool success;
  @override
  final DeleteBrandResponse data;
  @override
  final DateTime timestamp;

  factory _$DeleteBrand200Response([
    void Function(DeleteBrand200ResponseBuilder)? updates,
  ]) => (DeleteBrand200ResponseBuilder()..update(updates))._build();

  _$DeleteBrand200Response._({
    required this.success,
    required this.data,
    required this.timestamp,
  }) : super._();
  @override
  DeleteBrand200Response rebuild(
    void Function(DeleteBrand200ResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  DeleteBrand200ResponseBuilder toBuilder() =>
      DeleteBrand200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DeleteBrand200Response &&
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
    return (newBuiltValueToStringHelper(r'DeleteBrand200Response')
          ..add('success', success)
          ..add('data', data)
          ..add('timestamp', timestamp))
        .toString();
  }
}

class DeleteBrand200ResponseBuilder
    implements Builder<DeleteBrand200Response, DeleteBrand200ResponseBuilder> {
  _$DeleteBrand200Response? _$v;

  bool? _success;
  bool? get success => _$this._success;
  set success(bool? success) => _$this._success = success;

  DeleteBrandResponseBuilder? _data;
  DeleteBrandResponseBuilder get data =>
      _$this._data ??= DeleteBrandResponseBuilder();
  set data(DeleteBrandResponseBuilder? data) => _$this._data = data;

  DateTime? _timestamp;
  DateTime? get timestamp => _$this._timestamp;
  set timestamp(DateTime? timestamp) => _$this._timestamp = timestamp;

  DeleteBrand200ResponseBuilder() {
    DeleteBrand200Response._defaults(this);
  }

  DeleteBrand200ResponseBuilder get _$this {
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
  void replace(DeleteBrand200Response other) {
    _$v = other as _$DeleteBrand200Response;
  }

  @override
  void update(void Function(DeleteBrand200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DeleteBrand200Response build() => _build();

  _$DeleteBrand200Response _build() {
    _$DeleteBrand200Response _$result;
    try {
      _$result =
          _$v ??
          _$DeleteBrand200Response._(
            success: BuiltValueNullFieldError.checkNotNull(
              success,
              r'DeleteBrand200Response',
              'success',
            ),
            data: data.build(),
            timestamp: BuiltValueNullFieldError.checkNotNull(
              timestamp,
              r'DeleteBrand200Response',
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
          r'DeleteBrand200Response',
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
