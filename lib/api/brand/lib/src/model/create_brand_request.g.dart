// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_brand_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CreateBrandRequest extends CreateBrandRequest {
  @override
  final String name;
  @override
  final String? slug;
  @override
  final String? logoUrl;

  factory _$CreateBrandRequest([
    void Function(CreateBrandRequestBuilder)? updates,
  ]) => (CreateBrandRequestBuilder()..update(updates))._build();

  _$CreateBrandRequest._({required this.name, this.slug, this.logoUrl})
    : super._();
  @override
  CreateBrandRequest rebuild(
    void Function(CreateBrandRequestBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CreateBrandRequestBuilder toBuilder() =>
      CreateBrandRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreateBrandRequest &&
        name == other.name &&
        slug == other.slug &&
        logoUrl == other.logoUrl;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, slug.hashCode);
    _$hash = $jc(_$hash, logoUrl.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CreateBrandRequest')
          ..add('name', name)
          ..add('slug', slug)
          ..add('logoUrl', logoUrl))
        .toString();
  }
}

class CreateBrandRequestBuilder
    implements Builder<CreateBrandRequest, CreateBrandRequestBuilder> {
  _$CreateBrandRequest? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _slug;
  String? get slug => _$this._slug;
  set slug(String? slug) => _$this._slug = slug;

  String? _logoUrl;
  String? get logoUrl => _$this._logoUrl;
  set logoUrl(String? logoUrl) => _$this._logoUrl = logoUrl;

  CreateBrandRequestBuilder() {
    CreateBrandRequest._defaults(this);
  }

  CreateBrandRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _slug = $v.slug;
      _logoUrl = $v.logoUrl;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CreateBrandRequest other) {
    _$v = other as _$CreateBrandRequest;
  }

  @override
  void update(void Function(CreateBrandRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreateBrandRequest build() => _build();

  _$CreateBrandRequest _build() {
    final _$result =
        _$v ??
        _$CreateBrandRequest._(
          name: BuiltValueNullFieldError.checkNotNull(
            name,
            r'CreateBrandRequest',
            'name',
          ),
          slug: slug,
          logoUrl: logoUrl,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
