// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_product_overview200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GetProductOverview200Response extends GetProductOverview200Response {
  @override
  final bool success;
  @override
  final GetProductOverviewResponse data;
  @override
  final DateTime timestamp;

  factory _$GetProductOverview200Response([
    void Function(GetProductOverview200ResponseBuilder)? updates,
  ]) => (GetProductOverview200ResponseBuilder()..update(updates))._build();

  _$GetProductOverview200Response._({
    required this.success,
    required this.data,
    required this.timestamp,
  }) : super._();
  @override
  GetProductOverview200Response rebuild(
    void Function(GetProductOverview200ResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  GetProductOverview200ResponseBuilder toBuilder() =>
      GetProductOverview200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GetProductOverview200Response &&
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
    return (newBuiltValueToStringHelper(r'GetProductOverview200Response')
          ..add('success', success)
          ..add('data', data)
          ..add('timestamp', timestamp))
        .toString();
  }
}

class GetProductOverview200ResponseBuilder
    implements
        Builder<
          GetProductOverview200Response,
          GetProductOverview200ResponseBuilder
        > {
  _$GetProductOverview200Response? _$v;

  bool? _success;
  bool? get success => _$this._success;
  set success(bool? success) => _$this._success = success;

  GetProductOverviewResponseBuilder? _data;
  GetProductOverviewResponseBuilder get data =>
      _$this._data ??= GetProductOverviewResponseBuilder();
  set data(GetProductOverviewResponseBuilder? data) => _$this._data = data;

  DateTime? _timestamp;
  DateTime? get timestamp => _$this._timestamp;
  set timestamp(DateTime? timestamp) => _$this._timestamp = timestamp;

  GetProductOverview200ResponseBuilder() {
    GetProductOverview200Response._defaults(this);
  }

  GetProductOverview200ResponseBuilder get _$this {
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
  void replace(GetProductOverview200Response other) {
    _$v = other as _$GetProductOverview200Response;
  }

  @override
  void update(void Function(GetProductOverview200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GetProductOverview200Response build() => _build();

  _$GetProductOverview200Response _build() {
    _$GetProductOverview200Response _$result;
    try {
      _$result =
          _$v ??
          _$GetProductOverview200Response._(
            success: BuiltValueNullFieldError.checkNotNull(
              success,
              r'GetProductOverview200Response',
              'success',
            ),
            data: data.build(),
            timestamp: BuiltValueNullFieldError.checkNotNull(
              timestamp,
              r'GetProductOverview200Response',
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
          r'GetProductOverview200Response',
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
