// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_product_barcodes200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UpdateProductBarcodes200Response
    extends UpdateProductBarcodes200Response {
  @override
  final bool success;
  @override
  final UpdateProductBarcodesResponse data;
  @override
  final DateTime timestamp;

  factory _$UpdateProductBarcodes200Response([
    void Function(UpdateProductBarcodes200ResponseBuilder)? updates,
  ]) => (UpdateProductBarcodes200ResponseBuilder()..update(updates))._build();

  _$UpdateProductBarcodes200Response._({
    required this.success,
    required this.data,
    required this.timestamp,
  }) : super._();
  @override
  UpdateProductBarcodes200Response rebuild(
    void Function(UpdateProductBarcodes200ResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  UpdateProductBarcodes200ResponseBuilder toBuilder() =>
      UpdateProductBarcodes200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UpdateProductBarcodes200Response &&
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
    return (newBuiltValueToStringHelper(r'UpdateProductBarcodes200Response')
          ..add('success', success)
          ..add('data', data)
          ..add('timestamp', timestamp))
        .toString();
  }
}

class UpdateProductBarcodes200ResponseBuilder
    implements
        Builder<
          UpdateProductBarcodes200Response,
          UpdateProductBarcodes200ResponseBuilder
        > {
  _$UpdateProductBarcodes200Response? _$v;

  bool? _success;
  bool? get success => _$this._success;
  set success(bool? success) => _$this._success = success;

  UpdateProductBarcodesResponseBuilder? _data;
  UpdateProductBarcodesResponseBuilder get data =>
      _$this._data ??= UpdateProductBarcodesResponseBuilder();
  set data(UpdateProductBarcodesResponseBuilder? data) => _$this._data = data;

  DateTime? _timestamp;
  DateTime? get timestamp => _$this._timestamp;
  set timestamp(DateTime? timestamp) => _$this._timestamp = timestamp;

  UpdateProductBarcodes200ResponseBuilder() {
    UpdateProductBarcodes200Response._defaults(this);
  }

  UpdateProductBarcodes200ResponseBuilder get _$this {
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
  void replace(UpdateProductBarcodes200Response other) {
    _$v = other as _$UpdateProductBarcodes200Response;
  }

  @override
  void update(void Function(UpdateProductBarcodes200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UpdateProductBarcodes200Response build() => _build();

  _$UpdateProductBarcodes200Response _build() {
    _$UpdateProductBarcodes200Response _$result;
    try {
      _$result =
          _$v ??
          _$UpdateProductBarcodes200Response._(
            success: BuiltValueNullFieldError.checkNotNull(
              success,
              r'UpdateProductBarcodes200Response',
              'success',
            ),
            data: data.build(),
            timestamp: BuiltValueNullFieldError.checkNotNull(
              timestamp,
              r'UpdateProductBarcodes200Response',
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
          r'UpdateProductBarcodes200Response',
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
