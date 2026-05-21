// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_container_lots200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GetContainerLots200Response extends GetContainerLots200Response {
  @override
  final bool success;
  @override
  final GetContainerLotsResponse data;
  @override
  final DateTime timestamp;

  factory _$GetContainerLots200Response([
    void Function(GetContainerLots200ResponseBuilder)? updates,
  ]) => (GetContainerLots200ResponseBuilder()..update(updates))._build();

  _$GetContainerLots200Response._({
    required this.success,
    required this.data,
    required this.timestamp,
  }) : super._();
  @override
  GetContainerLots200Response rebuild(
    void Function(GetContainerLots200ResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  GetContainerLots200ResponseBuilder toBuilder() =>
      GetContainerLots200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GetContainerLots200Response &&
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
    return (newBuiltValueToStringHelper(r'GetContainerLots200Response')
          ..add('success', success)
          ..add('data', data)
          ..add('timestamp', timestamp))
        .toString();
  }
}

class GetContainerLots200ResponseBuilder
    implements
        Builder<
          GetContainerLots200Response,
          GetContainerLots200ResponseBuilder
        > {
  _$GetContainerLots200Response? _$v;

  bool? _success;
  bool? get success => _$this._success;
  set success(bool? success) => _$this._success = success;

  GetContainerLotsResponseBuilder? _data;
  GetContainerLotsResponseBuilder get data =>
      _$this._data ??= GetContainerLotsResponseBuilder();
  set data(GetContainerLotsResponseBuilder? data) => _$this._data = data;

  DateTime? _timestamp;
  DateTime? get timestamp => _$this._timestamp;
  set timestamp(DateTime? timestamp) => _$this._timestamp = timestamp;

  GetContainerLots200ResponseBuilder() {
    GetContainerLots200Response._defaults(this);
  }

  GetContainerLots200ResponseBuilder get _$this {
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
  void replace(GetContainerLots200Response other) {
    _$v = other as _$GetContainerLots200Response;
  }

  @override
  void update(void Function(GetContainerLots200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GetContainerLots200Response build() => _build();

  _$GetContainerLots200Response _build() {
    _$GetContainerLots200Response _$result;
    try {
      _$result =
          _$v ??
          _$GetContainerLots200Response._(
            success: BuiltValueNullFieldError.checkNotNull(
              success,
              r'GetContainerLots200Response',
              'success',
            ),
            data: data.build(),
            timestamp: BuiltValueNullFieldError.checkNotNull(
              timestamp,
              r'GetContainerLots200Response',
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
          r'GetContainerLots200Response',
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
