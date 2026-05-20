// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_product_variant200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CreateProductVariant200Response
    extends CreateProductVariant200Response {
  @override
  final bool success;
  @override
  final CreateProductVariantResponse data;
  @override
  final DateTime timestamp;

  factory _$CreateProductVariant200Response([
    void Function(CreateProductVariant200ResponseBuilder)? updates,
  ]) => (CreateProductVariant200ResponseBuilder()..update(updates))._build();

  _$CreateProductVariant200Response._({
    required this.success,
    required this.data,
    required this.timestamp,
  }) : super._();
  @override
  CreateProductVariant200Response rebuild(
    void Function(CreateProductVariant200ResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CreateProductVariant200ResponseBuilder toBuilder() =>
      CreateProductVariant200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreateProductVariant200Response &&
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
    return (newBuiltValueToStringHelper(r'CreateProductVariant200Response')
          ..add('success', success)
          ..add('data', data)
          ..add('timestamp', timestamp))
        .toString();
  }
}

class CreateProductVariant200ResponseBuilder
    implements
        Builder<
          CreateProductVariant200Response,
          CreateProductVariant200ResponseBuilder
        > {
  _$CreateProductVariant200Response? _$v;

  bool? _success;
  bool? get success => _$this._success;
  set success(bool? success) => _$this._success = success;

  CreateProductVariantResponseBuilder? _data;
  CreateProductVariantResponseBuilder get data =>
      _$this._data ??= CreateProductVariantResponseBuilder();
  set data(CreateProductVariantResponseBuilder? data) => _$this._data = data;

  DateTime? _timestamp;
  DateTime? get timestamp => _$this._timestamp;
  set timestamp(DateTime? timestamp) => _$this._timestamp = timestamp;

  CreateProductVariant200ResponseBuilder() {
    CreateProductVariant200Response._defaults(this);
  }

  CreateProductVariant200ResponseBuilder get _$this {
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
  void replace(CreateProductVariant200Response other) {
    _$v = other as _$CreateProductVariant200Response;
  }

  @override
  void update(void Function(CreateProductVariant200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreateProductVariant200Response build() => _build();

  _$CreateProductVariant200Response _build() {
    _$CreateProductVariant200Response _$result;
    try {
      _$result =
          _$v ??
          _$CreateProductVariant200Response._(
            success: BuiltValueNullFieldError.checkNotNull(
              success,
              r'CreateProductVariant200Response',
              'success',
            ),
            data: data.build(),
            timestamp: BuiltValueNullFieldError.checkNotNull(
              timestamp,
              r'CreateProductVariant200Response',
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
          r'CreateProductVariant200Response',
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
