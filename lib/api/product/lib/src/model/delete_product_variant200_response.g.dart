// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_product_variant200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DeleteProductVariant200Response
    extends DeleteProductVariant200Response {
  @override
  final bool success;
  @override
  final DeleteProductVariantResponse data;
  @override
  final DateTime timestamp;

  factory _$DeleteProductVariant200Response([
    void Function(DeleteProductVariant200ResponseBuilder)? updates,
  ]) => (DeleteProductVariant200ResponseBuilder()..update(updates))._build();

  _$DeleteProductVariant200Response._({
    required this.success,
    required this.data,
    required this.timestamp,
  }) : super._();
  @override
  DeleteProductVariant200Response rebuild(
    void Function(DeleteProductVariant200ResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  DeleteProductVariant200ResponseBuilder toBuilder() =>
      DeleteProductVariant200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DeleteProductVariant200Response &&
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
    return (newBuiltValueToStringHelper(r'DeleteProductVariant200Response')
          ..add('success', success)
          ..add('data', data)
          ..add('timestamp', timestamp))
        .toString();
  }
}

class DeleteProductVariant200ResponseBuilder
    implements
        Builder<
          DeleteProductVariant200Response,
          DeleteProductVariant200ResponseBuilder
        > {
  _$DeleteProductVariant200Response? _$v;

  bool? _success;
  bool? get success => _$this._success;
  set success(bool? success) => _$this._success = success;

  DeleteProductVariantResponseBuilder? _data;
  DeleteProductVariantResponseBuilder get data =>
      _$this._data ??= DeleteProductVariantResponseBuilder();
  set data(DeleteProductVariantResponseBuilder? data) => _$this._data = data;

  DateTime? _timestamp;
  DateTime? get timestamp => _$this._timestamp;
  set timestamp(DateTime? timestamp) => _$this._timestamp = timestamp;

  DeleteProductVariant200ResponseBuilder() {
    DeleteProductVariant200Response._defaults(this);
  }

  DeleteProductVariant200ResponseBuilder get _$this {
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
  void replace(DeleteProductVariant200Response other) {
    _$v = other as _$DeleteProductVariant200Response;
  }

  @override
  void update(void Function(DeleteProductVariant200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DeleteProductVariant200Response build() => _build();

  _$DeleteProductVariant200Response _build() {
    _$DeleteProductVariant200Response _$result;
    try {
      _$result =
          _$v ??
          _$DeleteProductVariant200Response._(
            success: BuiltValueNullFieldError.checkNotNull(
              success,
              r'DeleteProductVariant200Response',
              'success',
            ),
            data: data.build(),
            timestamp: BuiltValueNullFieldError.checkNotNull(
              timestamp,
              r'DeleteProductVariant200Response',
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
          r'DeleteProductVariant200Response',
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
