// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_product200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DeleteProduct200Response extends DeleteProduct200Response {
  @override
  final bool success;
  @override
  final DeleteProductResponse data;
  @override
  final DateTime timestamp;

  factory _$DeleteProduct200Response([
    void Function(DeleteProduct200ResponseBuilder)? updates,
  ]) => (DeleteProduct200ResponseBuilder()..update(updates))._build();

  _$DeleteProduct200Response._({
    required this.success,
    required this.data,
    required this.timestamp,
  }) : super._();
  @override
  DeleteProduct200Response rebuild(
    void Function(DeleteProduct200ResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  DeleteProduct200ResponseBuilder toBuilder() =>
      DeleteProduct200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DeleteProduct200Response &&
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
    return (newBuiltValueToStringHelper(r'DeleteProduct200Response')
          ..add('success', success)
          ..add('data', data)
          ..add('timestamp', timestamp))
        .toString();
  }
}

class DeleteProduct200ResponseBuilder
    implements
        Builder<DeleteProduct200Response, DeleteProduct200ResponseBuilder> {
  _$DeleteProduct200Response? _$v;

  bool? _success;
  bool? get success => _$this._success;
  set success(bool? success) => _$this._success = success;

  DeleteProductResponseBuilder? _data;
  DeleteProductResponseBuilder get data =>
      _$this._data ??= DeleteProductResponseBuilder();
  set data(DeleteProductResponseBuilder? data) => _$this._data = data;

  DateTime? _timestamp;
  DateTime? get timestamp => _$this._timestamp;
  set timestamp(DateTime? timestamp) => _$this._timestamp = timestamp;

  DeleteProduct200ResponseBuilder() {
    DeleteProduct200Response._defaults(this);
  }

  DeleteProduct200ResponseBuilder get _$this {
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
  void replace(DeleteProduct200Response other) {
    _$v = other as _$DeleteProduct200Response;
  }

  @override
  void update(void Function(DeleteProduct200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DeleteProduct200Response build() => _build();

  _$DeleteProduct200Response _build() {
    _$DeleteProduct200Response _$result;
    try {
      _$result =
          _$v ??
          _$DeleteProduct200Response._(
            success: BuiltValueNullFieldError.checkNotNull(
              success,
              r'DeleteProduct200Response',
              'success',
            ),
            data: data.build(),
            timestamp: BuiltValueNullFieldError.checkNotNull(
              timestamp,
              r'DeleteProduct200Response',
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
          r'DeleteProduct200Response',
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
