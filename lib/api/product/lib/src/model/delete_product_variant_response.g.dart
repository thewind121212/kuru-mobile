// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_product_variant_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DeleteProductVariantResponse extends DeleteProductVariantResponse {
  @override
  final bool success;
  @override
  final String? error;

  factory _$DeleteProductVariantResponse([
    void Function(DeleteProductVariantResponseBuilder)? updates,
  ]) => (DeleteProductVariantResponseBuilder()..update(updates))._build();

  _$DeleteProductVariantResponse._({required this.success, this.error})
    : super._();
  @override
  DeleteProductVariantResponse rebuild(
    void Function(DeleteProductVariantResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  DeleteProductVariantResponseBuilder toBuilder() =>
      DeleteProductVariantResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DeleteProductVariantResponse &&
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
    return (newBuiltValueToStringHelper(r'DeleteProductVariantResponse')
          ..add('success', success)
          ..add('error', error))
        .toString();
  }
}

class DeleteProductVariantResponseBuilder
    implements
        Builder<
          DeleteProductVariantResponse,
          DeleteProductVariantResponseBuilder
        > {
  _$DeleteProductVariantResponse? _$v;

  bool? _success;
  bool? get success => _$this._success;
  set success(bool? success) => _$this._success = success;

  String? _error;
  String? get error => _$this._error;
  set error(String? error) => _$this._error = error;

  DeleteProductVariantResponseBuilder() {
    DeleteProductVariantResponse._defaults(this);
  }

  DeleteProductVariantResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _success = $v.success;
      _error = $v.error;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DeleteProductVariantResponse other) {
    _$v = other as _$DeleteProductVariantResponse;
  }

  @override
  void update(void Function(DeleteProductVariantResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DeleteProductVariantResponse build() => _build();

  _$DeleteProductVariantResponse _build() {
    final _$result =
        _$v ??
        _$DeleteProductVariantResponse._(
          success: BuiltValueNullFieldError.checkNotNull(
            success,
            r'DeleteProductVariantResponse',
            'success',
          ),
          error: error,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
