// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_brand_by_id200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GetBrandById200Response extends GetBrandById200Response {
  @override
  final bool success;
  @override
  final BrandResponse data;
  @override
  final DateTime timestamp;

  factory _$GetBrandById200Response([
    void Function(GetBrandById200ResponseBuilder)? updates,
  ]) => (GetBrandById200ResponseBuilder()..update(updates))._build();

  _$GetBrandById200Response._({
    required this.success,
    required this.data,
    required this.timestamp,
  }) : super._();
  @override
  GetBrandById200Response rebuild(
    void Function(GetBrandById200ResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  GetBrandById200ResponseBuilder toBuilder() =>
      GetBrandById200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GetBrandById200Response &&
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
    return (newBuiltValueToStringHelper(r'GetBrandById200Response')
          ..add('success', success)
          ..add('data', data)
          ..add('timestamp', timestamp))
        .toString();
  }
}

class GetBrandById200ResponseBuilder
    implements
        Builder<GetBrandById200Response, GetBrandById200ResponseBuilder> {
  _$GetBrandById200Response? _$v;

  bool? _success;
  bool? get success => _$this._success;
  set success(bool? success) => _$this._success = success;

  BrandResponseBuilder? _data;
  BrandResponseBuilder get data => _$this._data ??= BrandResponseBuilder();
  set data(BrandResponseBuilder? data) => _$this._data = data;

  DateTime? _timestamp;
  DateTime? get timestamp => _$this._timestamp;
  set timestamp(DateTime? timestamp) => _$this._timestamp = timestamp;

  GetBrandById200ResponseBuilder() {
    GetBrandById200Response._defaults(this);
  }

  GetBrandById200ResponseBuilder get _$this {
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
  void replace(GetBrandById200Response other) {
    _$v = other as _$GetBrandById200Response;
  }

  @override
  void update(void Function(GetBrandById200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GetBrandById200Response build() => _build();

  _$GetBrandById200Response _build() {
    _$GetBrandById200Response _$result;
    try {
      _$result =
          _$v ??
          _$GetBrandById200Response._(
            success: BuiltValueNullFieldError.checkNotNull(
              success,
              r'GetBrandById200Response',
              'success',
            ),
            data: data.build(),
            timestamp: BuiltValueNullFieldError.checkNotNull(
              timestamp,
              r'GetBrandById200Response',
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
          r'GetBrandById200Response',
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
