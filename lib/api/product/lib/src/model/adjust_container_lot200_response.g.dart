// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'adjust_container_lot200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdjustContainerLot200Response extends AdjustContainerLot200Response {
  @override
  final bool success;
  @override
  final AdjustContainerLotResponse data;
  @override
  final DateTime timestamp;

  factory _$AdjustContainerLot200Response([
    void Function(AdjustContainerLot200ResponseBuilder)? updates,
  ]) => (AdjustContainerLot200ResponseBuilder()..update(updates))._build();

  _$AdjustContainerLot200Response._({
    required this.success,
    required this.data,
    required this.timestamp,
  }) : super._();
  @override
  AdjustContainerLot200Response rebuild(
    void Function(AdjustContainerLot200ResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdjustContainerLot200ResponseBuilder toBuilder() =>
      AdjustContainerLot200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdjustContainerLot200Response &&
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
    return (newBuiltValueToStringHelper(r'AdjustContainerLot200Response')
          ..add('success', success)
          ..add('data', data)
          ..add('timestamp', timestamp))
        .toString();
  }
}

class AdjustContainerLot200ResponseBuilder
    implements
        Builder<
          AdjustContainerLot200Response,
          AdjustContainerLot200ResponseBuilder
        > {
  _$AdjustContainerLot200Response? _$v;

  bool? _success;
  bool? get success => _$this._success;
  set success(bool? success) => _$this._success = success;

  AdjustContainerLotResponseBuilder? _data;
  AdjustContainerLotResponseBuilder get data =>
      _$this._data ??= AdjustContainerLotResponseBuilder();
  set data(AdjustContainerLotResponseBuilder? data) => _$this._data = data;

  DateTime? _timestamp;
  DateTime? get timestamp => _$this._timestamp;
  set timestamp(DateTime? timestamp) => _$this._timestamp = timestamp;

  AdjustContainerLot200ResponseBuilder() {
    AdjustContainerLot200Response._defaults(this);
  }

  AdjustContainerLot200ResponseBuilder get _$this {
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
  void replace(AdjustContainerLot200Response other) {
    _$v = other as _$AdjustContainerLot200Response;
  }

  @override
  void update(void Function(AdjustContainerLot200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdjustContainerLot200Response build() => _build();

  _$AdjustContainerLot200Response _build() {
    _$AdjustContainerLot200Response _$result;
    try {
      _$result =
          _$v ??
          _$AdjustContainerLot200Response._(
            success: BuiltValueNullFieldError.checkNotNull(
              success,
              r'AdjustContainerLot200Response',
              'success',
            ),
            data: data.build(),
            timestamp: BuiltValueNullFieldError.checkNotNull(
              timestamp,
              r'AdjustContainerLot200Response',
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
          r'AdjustContainerLot200Response',
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
