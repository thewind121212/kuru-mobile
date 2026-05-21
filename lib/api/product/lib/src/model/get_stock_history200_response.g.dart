// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_stock_history200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GetStockHistory200Response extends GetStockHistory200Response {
  @override
  final bool success;
  @override
  final GetStockHistoryResponse data;
  @override
  final DateTime timestamp;

  factory _$GetStockHistory200Response([
    void Function(GetStockHistory200ResponseBuilder)? updates,
  ]) => (GetStockHistory200ResponseBuilder()..update(updates))._build();

  _$GetStockHistory200Response._({
    required this.success,
    required this.data,
    required this.timestamp,
  }) : super._();
  @override
  GetStockHistory200Response rebuild(
    void Function(GetStockHistory200ResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  GetStockHistory200ResponseBuilder toBuilder() =>
      GetStockHistory200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GetStockHistory200Response &&
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
    return (newBuiltValueToStringHelper(r'GetStockHistory200Response')
          ..add('success', success)
          ..add('data', data)
          ..add('timestamp', timestamp))
        .toString();
  }
}

class GetStockHistory200ResponseBuilder
    implements
        Builder<GetStockHistory200Response, GetStockHistory200ResponseBuilder> {
  _$GetStockHistory200Response? _$v;

  bool? _success;
  bool? get success => _$this._success;
  set success(bool? success) => _$this._success = success;

  GetStockHistoryResponseBuilder? _data;
  GetStockHistoryResponseBuilder get data =>
      _$this._data ??= GetStockHistoryResponseBuilder();
  set data(GetStockHistoryResponseBuilder? data) => _$this._data = data;

  DateTime? _timestamp;
  DateTime? get timestamp => _$this._timestamp;
  set timestamp(DateTime? timestamp) => _$this._timestamp = timestamp;

  GetStockHistory200ResponseBuilder() {
    GetStockHistory200Response._defaults(this);
  }

  GetStockHistory200ResponseBuilder get _$this {
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
  void replace(GetStockHistory200Response other) {
    _$v = other as _$GetStockHistory200Response;
  }

  @override
  void update(void Function(GetStockHistory200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GetStockHistory200Response build() => _build();

  _$GetStockHistory200Response _build() {
    _$GetStockHistory200Response _$result;
    try {
      _$result =
          _$v ??
          _$GetStockHistory200Response._(
            success: BuiltValueNullFieldError.checkNotNull(
              success,
              r'GetStockHistory200Response',
              'success',
            ),
            data: data.build(),
            timestamp: BuiltValueNullFieldError.checkNotNull(
              timestamp,
              r'GetStockHistory200Response',
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
          r'GetStockHistory200Response',
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
