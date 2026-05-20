// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_brand_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CreateBrandResponse extends CreateBrandResponse {
  @override
  final String? brandId;

  factory _$CreateBrandResponse([
    void Function(CreateBrandResponseBuilder)? updates,
  ]) => (CreateBrandResponseBuilder()..update(updates))._build();

  _$CreateBrandResponse._({this.brandId}) : super._();
  @override
  CreateBrandResponse rebuild(
    void Function(CreateBrandResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CreateBrandResponseBuilder toBuilder() =>
      CreateBrandResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreateBrandResponse && brandId == other.brandId;
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
      r'CreateBrandResponse',
    )..add('brandId', brandId)).toString();
  }
}

class CreateBrandResponseBuilder
    implements Builder<CreateBrandResponse, CreateBrandResponseBuilder> {
  _$CreateBrandResponse? _$v;

  String? _brandId;
  String? get brandId => _$this._brandId;
  set brandId(String? brandId) => _$this._brandId = brandId;

  CreateBrandResponseBuilder() {
    CreateBrandResponse._defaults(this);
  }

  CreateBrandResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _brandId = $v.brandId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CreateBrandResponse other) {
    _$v = other as _$CreateBrandResponse;
  }

  @override
  void update(void Function(CreateBrandResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreateBrandResponse build() => _build();

  _$CreateBrandResponse _build() {
    final _$result = _$v ?? _$CreateBrandResponse._(brandId: brandId);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
