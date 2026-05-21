// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_container_lot200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DeleteContainerLot200Response extends DeleteContainerLot200Response {
  @override
  final bool success;
  @override
  final DeleteContainerLotResponse data;
  @override
  final DateTime timestamp;

  factory _$DeleteContainerLot200Response([
    void Function(DeleteContainerLot200ResponseBuilder)? updates,
  ]) => (DeleteContainerLot200ResponseBuilder()..update(updates))._build();

  _$DeleteContainerLot200Response._({
    required this.success,
    required this.data,
    required this.timestamp,
  }) : super._();
  @override
  DeleteContainerLot200Response rebuild(
    void Function(DeleteContainerLot200ResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  DeleteContainerLot200ResponseBuilder toBuilder() =>
      DeleteContainerLot200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DeleteContainerLot200Response &&
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
    return (newBuiltValueToStringHelper(r'DeleteContainerLot200Response')
          ..add('success', success)
          ..add('data', data)
          ..add('timestamp', timestamp))
        .toString();
  }
}

class DeleteContainerLot200ResponseBuilder
    implements
        Builder<
          DeleteContainerLot200Response,
          DeleteContainerLot200ResponseBuilder
        > {
  _$DeleteContainerLot200Response? _$v;

  bool? _success;
  bool? get success => _$this._success;
  set success(bool? success) => _$this._success = success;

  DeleteContainerLotResponseBuilder? _data;
  DeleteContainerLotResponseBuilder get data =>
      _$this._data ??= DeleteContainerLotResponseBuilder();
  set data(DeleteContainerLotResponseBuilder? data) => _$this._data = data;

  DateTime? _timestamp;
  DateTime? get timestamp => _$this._timestamp;
  set timestamp(DateTime? timestamp) => _$this._timestamp = timestamp;

  DeleteContainerLot200ResponseBuilder() {
    DeleteContainerLot200Response._defaults(this);
  }

  DeleteContainerLot200ResponseBuilder get _$this {
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
  void replace(DeleteContainerLot200Response other) {
    _$v = other as _$DeleteContainerLot200Response;
  }

  @override
  void update(void Function(DeleteContainerLot200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DeleteContainerLot200Response build() => _build();

  _$DeleteContainerLot200Response _build() {
    _$DeleteContainerLot200Response _$result;
    try {
      _$result =
          _$v ??
          _$DeleteContainerLot200Response._(
            success: BuiltValueNullFieldError.checkNotNull(
              success,
              r'DeleteContainerLot200Response',
              'success',
            ),
            data: data.build(),
            timestamp: BuiltValueNullFieldError.checkNotNull(
              timestamp,
              r'DeleteContainerLot200Response',
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
          r'DeleteContainerLot200Response',
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
