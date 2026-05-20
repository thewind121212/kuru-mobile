// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_product_info200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UpdateProductInfo200Response extends UpdateProductInfo200Response {
  @override
  final bool success;
  @override
  final UpdateProductInfoResponse data;
  @override
  final DateTime timestamp;

  factory _$UpdateProductInfo200Response([
    void Function(UpdateProductInfo200ResponseBuilder)? updates,
  ]) => (UpdateProductInfo200ResponseBuilder()..update(updates))._build();

  _$UpdateProductInfo200Response._({
    required this.success,
    required this.data,
    required this.timestamp,
  }) : super._();
  @override
  UpdateProductInfo200Response rebuild(
    void Function(UpdateProductInfo200ResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  UpdateProductInfo200ResponseBuilder toBuilder() =>
      UpdateProductInfo200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UpdateProductInfo200Response &&
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
    return (newBuiltValueToStringHelper(r'UpdateProductInfo200Response')
          ..add('success', success)
          ..add('data', data)
          ..add('timestamp', timestamp))
        .toString();
  }
}

class UpdateProductInfo200ResponseBuilder
    implements
        Builder<
          UpdateProductInfo200Response,
          UpdateProductInfo200ResponseBuilder
        > {
  _$UpdateProductInfo200Response? _$v;

  bool? _success;
  bool? get success => _$this._success;
  set success(bool? success) => _$this._success = success;

  UpdateProductInfoResponseBuilder? _data;
  UpdateProductInfoResponseBuilder get data =>
      _$this._data ??= UpdateProductInfoResponseBuilder();
  set data(UpdateProductInfoResponseBuilder? data) => _$this._data = data;

  DateTime? _timestamp;
  DateTime? get timestamp => _$this._timestamp;
  set timestamp(DateTime? timestamp) => _$this._timestamp = timestamp;

  UpdateProductInfo200ResponseBuilder() {
    UpdateProductInfo200Response._defaults(this);
  }

  UpdateProductInfo200ResponseBuilder get _$this {
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
  void replace(UpdateProductInfo200Response other) {
    _$v = other as _$UpdateProductInfo200Response;
  }

  @override
  void update(void Function(UpdateProductInfo200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UpdateProductInfo200Response build() => _build();

  _$UpdateProductInfo200Response _build() {
    _$UpdateProductInfo200Response _$result;
    try {
      _$result =
          _$v ??
          _$UpdateProductInfo200Response._(
            success: BuiltValueNullFieldError.checkNotNull(
              success,
              r'UpdateProductInfo200Response',
              'success',
            ),
            data: data.build(),
            timestamp: BuiltValueNullFieldError.checkNotNull(
              timestamp,
              r'UpdateProductInfo200Response',
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
          r'UpdateProductInfo200Response',
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
