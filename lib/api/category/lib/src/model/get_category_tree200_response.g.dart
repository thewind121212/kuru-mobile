// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_category_tree200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GetCategoryTree200Response extends GetCategoryTree200Response {
  @override
  final bool success;
  @override
  final GetCategoryTreeResponse data;
  @override
  final DateTime timestamp;

  factory _$GetCategoryTree200Response(
          [void Function(GetCategoryTree200ResponseBuilder)? updates]) =>
      (GetCategoryTree200ResponseBuilder()..update(updates))._build();

  _$GetCategoryTree200Response._(
      {required this.success, required this.data, required this.timestamp})
      : super._();
  @override
  GetCategoryTree200Response rebuild(
          void Function(GetCategoryTree200ResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GetCategoryTree200ResponseBuilder toBuilder() =>
      GetCategoryTree200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GetCategoryTree200Response &&
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
    return (newBuiltValueToStringHelper(r'GetCategoryTree200Response')
          ..add('success', success)
          ..add('data', data)
          ..add('timestamp', timestamp))
        .toString();
  }
}

class GetCategoryTree200ResponseBuilder
    implements
        Builder<GetCategoryTree200Response, GetCategoryTree200ResponseBuilder> {
  _$GetCategoryTree200Response? _$v;

  bool? _success;
  bool? get success => _$this._success;
  set success(bool? success) => _$this._success = success;

  GetCategoryTreeResponseBuilder? _data;
  GetCategoryTreeResponseBuilder get data =>
      _$this._data ??= GetCategoryTreeResponseBuilder();
  set data(GetCategoryTreeResponseBuilder? data) => _$this._data = data;

  DateTime? _timestamp;
  DateTime? get timestamp => _$this._timestamp;
  set timestamp(DateTime? timestamp) => _$this._timestamp = timestamp;

  GetCategoryTree200ResponseBuilder() {
    GetCategoryTree200Response._defaults(this);
  }

  GetCategoryTree200ResponseBuilder get _$this {
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
  void replace(GetCategoryTree200Response other) {
    _$v = other as _$GetCategoryTree200Response;
  }

  @override
  void update(void Function(GetCategoryTree200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GetCategoryTree200Response build() => _build();

  _$GetCategoryTree200Response _build() {
    _$GetCategoryTree200Response _$result;
    try {
      _$result = _$v ??
          _$GetCategoryTree200Response._(
            success: BuiltValueNullFieldError.checkNotNull(
                success, r'GetCategoryTree200Response', 'success'),
            data: data.build(),
            timestamp: BuiltValueNullFieldError.checkNotNull(
                timestamp, r'GetCategoryTree200Response', 'timestamp'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'GetCategoryTree200Response', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
