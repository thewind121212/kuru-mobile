// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_category_overview200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GetCategoryOverview200Response extends GetCategoryOverview200Response {
  @override
  final bool success;
  @override
  final GetCategoryOverviewResponse data;
  @override
  final DateTime timestamp;

  factory _$GetCategoryOverview200Response(
          [void Function(GetCategoryOverview200ResponseBuilder)? updates]) =>
      (GetCategoryOverview200ResponseBuilder()..update(updates))._build();

  _$GetCategoryOverview200Response._(
      {required this.success, required this.data, required this.timestamp})
      : super._();
  @override
  GetCategoryOverview200Response rebuild(
          void Function(GetCategoryOverview200ResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GetCategoryOverview200ResponseBuilder toBuilder() =>
      GetCategoryOverview200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GetCategoryOverview200Response &&
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
    return (newBuiltValueToStringHelper(r'GetCategoryOverview200Response')
          ..add('success', success)
          ..add('data', data)
          ..add('timestamp', timestamp))
        .toString();
  }
}

class GetCategoryOverview200ResponseBuilder
    implements
        Builder<GetCategoryOverview200Response,
            GetCategoryOverview200ResponseBuilder> {
  _$GetCategoryOverview200Response? _$v;

  bool? _success;
  bool? get success => _$this._success;
  set success(bool? success) => _$this._success = success;

  GetCategoryOverviewResponseBuilder? _data;
  GetCategoryOverviewResponseBuilder get data =>
      _$this._data ??= GetCategoryOverviewResponseBuilder();
  set data(GetCategoryOverviewResponseBuilder? data) => _$this._data = data;

  DateTime? _timestamp;
  DateTime? get timestamp => _$this._timestamp;
  set timestamp(DateTime? timestamp) => _$this._timestamp = timestamp;

  GetCategoryOverview200ResponseBuilder() {
    GetCategoryOverview200Response._defaults(this);
  }

  GetCategoryOverview200ResponseBuilder get _$this {
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
  void replace(GetCategoryOverview200Response other) {
    _$v = other as _$GetCategoryOverview200Response;
  }

  @override
  void update(void Function(GetCategoryOverview200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GetCategoryOverview200Response build() => _build();

  _$GetCategoryOverview200Response _build() {
    _$GetCategoryOverview200Response _$result;
    try {
      _$result = _$v ??
          _$GetCategoryOverview200Response._(
            success: BuiltValueNullFieldError.checkNotNull(
                success, r'GetCategoryOverview200Response', 'success'),
            data: data.build(),
            timestamp: BuiltValueNullFieldError.checkNotNull(
                timestamp, r'GetCategoryOverview200Response', 'timestamp'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'GetCategoryOverview200Response', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
