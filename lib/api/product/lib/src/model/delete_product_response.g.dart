// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_product_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DeleteProductResponse extends DeleteProductResponse {
  @override
  final bool success;
  @override
  final String? error;

  factory _$DeleteProductResponse([
    void Function(DeleteProductResponseBuilder)? updates,
  ]) => (DeleteProductResponseBuilder()..update(updates))._build();

  _$DeleteProductResponse._({required this.success, this.error}) : super._();
  @override
  DeleteProductResponse rebuild(
    void Function(DeleteProductResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  DeleteProductResponseBuilder toBuilder() =>
      DeleteProductResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DeleteProductResponse &&
        success == other.success &&
        error == other.error;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, success.hashCode);
    _$hash = $jc(_$hash, error.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DeleteProductResponse')
          ..add('success', success)
          ..add('error', error))
        .toString();
  }
}

class DeleteProductResponseBuilder
    implements Builder<DeleteProductResponse, DeleteProductResponseBuilder> {
  _$DeleteProductResponse? _$v;

  bool? _success;
  bool? get success => _$this._success;
  set success(bool? success) => _$this._success = success;

  String? _error;
  String? get error => _$this._error;
  set error(String? error) => _$this._error = error;

  DeleteProductResponseBuilder() {
    DeleteProductResponse._defaults(this);
  }

  DeleteProductResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _success = $v.success;
      _error = $v.error;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DeleteProductResponse other) {
    _$v = other as _$DeleteProductResponse;
  }

  @override
  void update(void Function(DeleteProductResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DeleteProductResponse build() => _build();

  _$DeleteProductResponse _build() {
    final _$result =
        _$v ??
        _$DeleteProductResponse._(
          success: BuiltValueNullFieldError.checkNotNull(
            success,
            r'DeleteProductResponse',
            'success',
          ),
          error: error,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
