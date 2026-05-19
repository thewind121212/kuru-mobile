// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_brand_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UpdateBrandRequest extends UpdateBrandRequest {
  @override
  final String brandId;
  @override
  final String? name;
  @override
  final String? slug;
  @override
  final String? logoUrl;

  factory _$UpdateBrandRequest([
    void Function(UpdateBrandRequestBuilder)? updates,
  ]) => (UpdateBrandRequestBuilder()..update(updates))._build();

  _$UpdateBrandRequest._({
    required this.brandId,
    this.name,
    this.slug,
    this.logoUrl,
  }) : super._();
  @override
  UpdateBrandRequest rebuild(
    void Function(UpdateBrandRequestBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  UpdateBrandRequestBuilder toBuilder() =>
      UpdateBrandRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UpdateBrandRequest &&
        brandId == other.brandId &&
        name == other.name &&
        slug == other.slug &&
        logoUrl == other.logoUrl;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, brandId.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, slug.hashCode);
    _$hash = $jc(_$hash, logoUrl.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UpdateBrandRequest')
          ..add('brandId', brandId)
          ..add('name', name)
          ..add('slug', slug)
          ..add('logoUrl', logoUrl))
        .toString();
  }
}

class UpdateBrandRequestBuilder
    implements Builder<UpdateBrandRequest, UpdateBrandRequestBuilder> {
  _$UpdateBrandRequest? _$v;

  String? _brandId;
  String? get brandId => _$this._brandId;
  set brandId(String? brandId) => _$this._brandId = brandId;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _slug;
  String? get slug => _$this._slug;
  set slug(String? slug) => _$this._slug = slug;

  String? _logoUrl;
  String? get logoUrl => _$this._logoUrl;
  set logoUrl(String? logoUrl) => _$this._logoUrl = logoUrl;

  UpdateBrandRequestBuilder() {
    UpdateBrandRequest._defaults(this);
  }

  UpdateBrandRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _brandId = $v.brandId;
      _name = $v.name;
      _slug = $v.slug;
      _logoUrl = $v.logoUrl;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UpdateBrandRequest other) {
    _$v = other as _$UpdateBrandRequest;
  }

  @override
  void update(void Function(UpdateBrandRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UpdateBrandRequest build() => _build();

  _$UpdateBrandRequest _build() {
    final _$result =
        _$v ??
        _$UpdateBrandRequest._(
          brandId: BuiltValueNullFieldError.checkNotNull(
            brandId,
            r'UpdateBrandRequest',
            'brandId',
          ),
          name: name,
          slug: slug,
          logoUrl: logoUrl,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
