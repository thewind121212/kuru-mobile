// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_product200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CreateProduct200Response extends CreateProduct200Response {
  @override
  final bool success;
  @override
  final CreateProductResponse data;
  @override
  final DateTime timestamp;

  factory _$CreateProduct200Response([
    void Function(CreateProduct200ResponseBuilder)? updates,
  ]) => (CreateProduct200ResponseBuilder()..update(updates))._build();

  _$CreateProduct200Response._({
    required this.success,
    required this.data,
    required this.timestamp,
  }) : super._();
  @override
  CreateProduct200Response rebuild(
    void Function(CreateProduct200ResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CreateProduct200ResponseBuilder toBuilder() =>
      CreateProduct200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreateProduct200Response &&
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
    return (newBuiltValueToStringHelper(r'CreateProduct200Response')
          ..add('success', success)
          ..add('data', data)
          ..add('timestamp', timestamp))
        .toString();
  }
}

class CreateProduct200ResponseBuilder
    implements
        Builder<CreateProduct200Response, CreateProduct200ResponseBuilder> {
  _$CreateProduct200Response? _$v;

  bool? _success;
  bool? get success => _$this._success;
  set success(bool? success) => _$this._success = success;

  CreateProductResponseBuilder? _data;
  CreateProductResponseBuilder get data =>
      _$this._data ??= CreateProductResponseBuilder();
  set data(CreateProductResponseBuilder? data) => _$this._data = data;

  DateTime? _timestamp;
  DateTime? get timestamp => _$this._timestamp;
  set timestamp(DateTime? timestamp) => _$this._timestamp = timestamp;

  CreateProduct200ResponseBuilder() {
    CreateProduct200Response._defaults(this);
  }

  CreateProduct200ResponseBuilder get _$this {
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
  void replace(CreateProduct200Response other) {
    _$v = other as _$CreateProduct200Response;
  }

  @override
  void update(void Function(CreateProduct200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreateProduct200Response build() => _build();

  _$CreateProduct200Response _build() {
    _$CreateProduct200Response _$result;
    try {
      _$result =
          _$v ??
          _$CreateProduct200Response._(
            success: BuiltValueNullFieldError.checkNotNull(
              success,
              r'CreateProduct200Response',
              'success',
            ),
            data: data.build(),
            timestamp: BuiltValueNullFieldError.checkNotNull(
              timestamp,
              r'CreateProduct200Response',
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
          r'CreateProduct200Response',
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
