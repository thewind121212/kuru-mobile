// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_product_variant200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UpdateProductVariant200Response
    extends UpdateProductVariant200Response {
  @override
  final bool success;
  @override
  final UpdateProductVariantResponse data;
  @override
  final DateTime timestamp;

  factory _$UpdateProductVariant200Response([
    void Function(UpdateProductVariant200ResponseBuilder)? updates,
  ]) => (UpdateProductVariant200ResponseBuilder()..update(updates))._build();

  _$UpdateProductVariant200Response._({
    required this.success,
    required this.data,
    required this.timestamp,
  }) : super._();
  @override
  UpdateProductVariant200Response rebuild(
    void Function(UpdateProductVariant200ResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  UpdateProductVariant200ResponseBuilder toBuilder() =>
      UpdateProductVariant200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UpdateProductVariant200Response &&
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
    return (newBuiltValueToStringHelper(r'UpdateProductVariant200Response')
          ..add('success', success)
          ..add('data', data)
          ..add('timestamp', timestamp))
        .toString();
  }
}

class UpdateProductVariant200ResponseBuilder
    implements
        Builder<
          UpdateProductVariant200Response,
          UpdateProductVariant200ResponseBuilder
        > {
  _$UpdateProductVariant200Response? _$v;

  bool? _success;
  bool? get success => _$this._success;
  set success(bool? success) => _$this._success = success;

  UpdateProductVariantResponseBuilder? _data;
  UpdateProductVariantResponseBuilder get data =>
      _$this._data ??= UpdateProductVariantResponseBuilder();
  set data(UpdateProductVariantResponseBuilder? data) => _$this._data = data;

  DateTime? _timestamp;
  DateTime? get timestamp => _$this._timestamp;
  set timestamp(DateTime? timestamp) => _$this._timestamp = timestamp;

  UpdateProductVariant200ResponseBuilder() {
    UpdateProductVariant200Response._defaults(this);
  }

  UpdateProductVariant200ResponseBuilder get _$this {
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
  void replace(UpdateProductVariant200Response other) {
    _$v = other as _$UpdateProductVariant200Response;
  }

  @override
  void update(void Function(UpdateProductVariant200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UpdateProductVariant200Response build() => _build();

  _$UpdateProductVariant200Response _build() {
    _$UpdateProductVariant200Response _$result;
    try {
      _$result =
          _$v ??
          _$UpdateProductVariant200Response._(
            success: BuiltValueNullFieldError.checkNotNull(
              success,
              r'UpdateProductVariant200Response',
              'success',
            ),
            data: data.build(),
            timestamp: BuiltValueNullFieldError.checkNotNull(
              timestamp,
              r'UpdateProductVariant200Response',
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
          r'UpdateProductVariant200Response',
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
