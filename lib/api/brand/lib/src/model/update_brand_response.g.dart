// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_brand_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UpdateBrandResponse extends UpdateBrandResponse {
  @override
  final bool success;
  @override
  final String? error;

  factory _$UpdateBrandResponse([
    void Function(UpdateBrandResponseBuilder)? updates,
  ]) => (UpdateBrandResponseBuilder()..update(updates))._build();

  _$UpdateBrandResponse._({required this.success, this.error}) : super._();
  @override
  UpdateBrandResponse rebuild(
    void Function(UpdateBrandResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  UpdateBrandResponseBuilder toBuilder() =>
      UpdateBrandResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UpdateBrandResponse &&
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
    return (newBuiltValueToStringHelper(r'UpdateBrandResponse')
          ..add('success', success)
          ..add('error', error))
        .toString();
  }
}

class UpdateBrandResponseBuilder
    implements Builder<UpdateBrandResponse, UpdateBrandResponseBuilder> {
  _$UpdateBrandResponse? _$v;

  bool? _success;
  bool? get success => _$this._success;
  set success(bool? success) => _$this._success = success;

  String? _error;
  String? get error => _$this._error;
  set error(String? error) => _$this._error = error;

  UpdateBrandResponseBuilder() {
    UpdateBrandResponse._defaults(this);
  }

  UpdateBrandResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _success = $v.success;
      _error = $v.error;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UpdateBrandResponse other) {
    _$v = other as _$UpdateBrandResponse;
  }

  @override
  void update(void Function(UpdateBrandResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UpdateBrandResponse build() => _build();

  _$UpdateBrandResponse _build() {
    final _$result =
        _$v ??
        _$UpdateBrandResponse._(
          success: BuiltValueNullFieldError.checkNotNull(
            success,
            r'UpdateBrandResponse',
            'success',
          ),
          error: error,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
