// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_category_by_id200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GetCategoryById200Response extends GetCategoryById200Response {
  @override
  final bool success;
  @override
  final CategoryResponse data;
  @override
  final DateTime timestamp;

  factory _$GetCategoryById200Response(
          [void Function(GetCategoryById200ResponseBuilder)? updates]) =>
      (GetCategoryById200ResponseBuilder()..update(updates))._build();

  _$GetCategoryById200Response._(
      {required this.success, required this.data, required this.timestamp})
      : super._();
  @override
  GetCategoryById200Response rebuild(
          void Function(GetCategoryById200ResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GetCategoryById200ResponseBuilder toBuilder() =>
      GetCategoryById200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GetCategoryById200Response &&
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
    return (newBuiltValueToStringHelper(r'GetCategoryById200Response')
          ..add('success', success)
          ..add('data', data)
          ..add('timestamp', timestamp))
        .toString();
  }
}

class GetCategoryById200ResponseBuilder
    implements
        Builder<GetCategoryById200Response, GetCategoryById200ResponseBuilder> {
  _$GetCategoryById200Response? _$v;

  bool? _success;
  bool? get success => _$this._success;
  set success(bool? success) => _$this._success = success;

  CategoryResponseBuilder? _data;
  CategoryResponseBuilder get data =>
      _$this._data ??= CategoryResponseBuilder();
  set data(CategoryResponseBuilder? data) => _$this._data = data;

  DateTime? _timestamp;
  DateTime? get timestamp => _$this._timestamp;
  set timestamp(DateTime? timestamp) => _$this._timestamp = timestamp;

  GetCategoryById200ResponseBuilder() {
    GetCategoryById200Response._defaults(this);
  }

  GetCategoryById200ResponseBuilder get _$this {
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
  void replace(GetCategoryById200Response other) {
    _$v = other as _$GetCategoryById200Response;
  }

  @override
  void update(void Function(GetCategoryById200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GetCategoryById200Response build() => _build();

  _$GetCategoryById200Response _build() {
    _$GetCategoryById200Response _$result;
    try {
      _$result = _$v ??
          _$GetCategoryById200Response._(
            success: BuiltValueNullFieldError.checkNotNull(
                success, r'GetCategoryById200Response', 'success'),
            data: data.build(),
            timestamp: BuiltValueNullFieldError.checkNotNull(
                timestamp, r'GetCategoryById200Response', 'timestamp'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'GetCategoryById200Response', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
