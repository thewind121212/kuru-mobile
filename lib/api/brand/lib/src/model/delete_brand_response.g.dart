// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_brand_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DeleteBrandResponse extends DeleteBrandResponse {
  @override
  final bool success;
  @override
  final String? error;

  factory _$DeleteBrandResponse([
    void Function(DeleteBrandResponseBuilder)? updates,
  ]) => (DeleteBrandResponseBuilder()..update(updates))._build();

  _$DeleteBrandResponse._({required this.success, this.error}) : super._();
  @override
  DeleteBrandResponse rebuild(
    void Function(DeleteBrandResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  DeleteBrandResponseBuilder toBuilder() =>
      DeleteBrandResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DeleteBrandResponse &&
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
    return (newBuiltValueToStringHelper(r'DeleteBrandResponse')
          ..add('success', success)
          ..add('error', error))
        .toString();
  }
}

class DeleteBrandResponseBuilder
    implements Builder<DeleteBrandResponse, DeleteBrandResponseBuilder> {
  _$DeleteBrandResponse? _$v;

  bool? _success;
  bool? get success => _$this._success;
  set success(bool? success) => _$this._success = success;

  String? _error;
  String? get error => _$this._error;
  set error(String? error) => _$this._error = error;

  DeleteBrandResponseBuilder() {
    DeleteBrandResponse._defaults(this);
  }

  DeleteBrandResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _success = $v.success;
      _error = $v.error;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DeleteBrandResponse other) {
    _$v = other as _$DeleteBrandResponse;
  }

  @override
  void update(void Function(DeleteBrandResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DeleteBrandResponse build() => _build();

  _$DeleteBrandResponse _build() {
    final _$result =
        _$v ??
        _$DeleteBrandResponse._(
          success: BuiltValueNullFieldError.checkNotNull(
            success,
            r'DeleteBrandResponse',
            'success',
          ),
          error: error,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
