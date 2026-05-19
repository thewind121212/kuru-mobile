// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_brand_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DeleteBrandRequest extends DeleteBrandRequest {
  @override
  final String brandId;

  factory _$DeleteBrandRequest([
    void Function(DeleteBrandRequestBuilder)? updates,
  ]) => (DeleteBrandRequestBuilder()..update(updates))._build();

  _$DeleteBrandRequest._({required this.brandId}) : super._();
  @override
  DeleteBrandRequest rebuild(
    void Function(DeleteBrandRequestBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  DeleteBrandRequestBuilder toBuilder() =>
      DeleteBrandRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DeleteBrandRequest && brandId == other.brandId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, brandId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'DeleteBrandRequest',
    )..add('brandId', brandId)).toString();
  }
}

class DeleteBrandRequestBuilder
    implements Builder<DeleteBrandRequest, DeleteBrandRequestBuilder> {
  _$DeleteBrandRequest? _$v;

  String? _brandId;
  String? get brandId => _$this._brandId;
  set brandId(String? brandId) => _$this._brandId = brandId;

  DeleteBrandRequestBuilder() {
    DeleteBrandRequest._defaults(this);
  }

  DeleteBrandRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _brandId = $v.brandId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DeleteBrandRequest other) {
    _$v = other as _$DeleteBrandRequest;
  }

  @override
  void update(void Function(DeleteBrandRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DeleteBrandRequest build() => _build();

  _$DeleteBrandRequest _build() {
    final _$result =
        _$v ??
        _$DeleteBrandRequest._(
          brandId: BuiltValueNullFieldError.checkNotNull(
            brandId,
            r'DeleteBrandRequest',
            'brandId',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
