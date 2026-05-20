// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_container_lots200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CreateContainerLots200Response extends CreateContainerLots200Response {
  @override
  final bool success;
  @override
  final CreateContainerLotsResponse data;
  @override
  final DateTime timestamp;

  factory _$CreateContainerLots200Response([
    void Function(CreateContainerLots200ResponseBuilder)? updates,
  ]) => (CreateContainerLots200ResponseBuilder()..update(updates))._build();

  _$CreateContainerLots200Response._({
    required this.success,
    required this.data,
    required this.timestamp,
  }) : super._();
  @override
  CreateContainerLots200Response rebuild(
    void Function(CreateContainerLots200ResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CreateContainerLots200ResponseBuilder toBuilder() =>
      CreateContainerLots200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreateContainerLots200Response &&
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
    return (newBuiltValueToStringHelper(r'CreateContainerLots200Response')
          ..add('success', success)
          ..add('data', data)
          ..add('timestamp', timestamp))
        .toString();
  }
}

class CreateContainerLots200ResponseBuilder
    implements
        Builder<
          CreateContainerLots200Response,
          CreateContainerLots200ResponseBuilder
        > {
  _$CreateContainerLots200Response? _$v;

  bool? _success;
  bool? get success => _$this._success;
  set success(bool? success) => _$this._success = success;

  CreateContainerLotsResponseBuilder? _data;
  CreateContainerLotsResponseBuilder get data =>
      _$this._data ??= CreateContainerLotsResponseBuilder();
  set data(CreateContainerLotsResponseBuilder? data) => _$this._data = data;

  DateTime? _timestamp;
  DateTime? get timestamp => _$this._timestamp;
  set timestamp(DateTime? timestamp) => _$this._timestamp = timestamp;

  CreateContainerLots200ResponseBuilder() {
    CreateContainerLots200Response._defaults(this);
  }

  CreateContainerLots200ResponseBuilder get _$this {
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
  void replace(CreateContainerLots200Response other) {
    _$v = other as _$CreateContainerLots200Response;
  }

  @override
  void update(void Function(CreateContainerLots200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreateContainerLots200Response build() => _build();

  _$CreateContainerLots200Response _build() {
    _$CreateContainerLots200Response _$result;
    try {
      _$result =
          _$v ??
          _$CreateContainerLots200Response._(
            success: BuiltValueNullFieldError.checkNotNull(
              success,
              r'CreateContainerLots200Response',
              'success',
            ),
            data: data.build(),
            timestamp: BuiltValueNullFieldError.checkNotNull(
              timestamp,
              r'CreateContainerLots200Response',
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
          r'CreateContainerLots200Response',
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
