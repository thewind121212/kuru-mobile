// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brand_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BrandResponse extends BrandResponse {
  @override
  final String id;
  @override
  final String orgId;
  @override
  final String name;
  @override
  final String? slug;
  @override
  final String? logoUrl;
  @override
  final bool isDelete;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  factory _$BrandResponse([void Function(BrandResponseBuilder)? updates]) =>
      (BrandResponseBuilder()..update(updates))._build();

  _$BrandResponse._({
    required this.id,
    required this.orgId,
    required this.name,
    this.slug,
    this.logoUrl,
    required this.isDelete,
    required this.createdAt,
    required this.updatedAt,
  }) : super._();
  @override
  BrandResponse rebuild(void Function(BrandResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BrandResponseBuilder toBuilder() => BrandResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BrandResponse &&
        id == other.id &&
        orgId == other.orgId &&
        name == other.name &&
        slug == other.slug &&
        logoUrl == other.logoUrl &&
        isDelete == other.isDelete &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, orgId.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, slug.hashCode);
    _$hash = $jc(_$hash, logoUrl.hashCode);
    _$hash = $jc(_$hash, isDelete.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BrandResponse')
          ..add('id', id)
          ..add('orgId', orgId)
          ..add('name', name)
          ..add('slug', slug)
          ..add('logoUrl', logoUrl)
          ..add('isDelete', isDelete)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class BrandResponseBuilder
    implements Builder<BrandResponse, BrandResponseBuilder> {
  _$BrandResponse? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _orgId;
  String? get orgId => _$this._orgId;
  set orgId(String? orgId) => _$this._orgId = orgId;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _slug;
  String? get slug => _$this._slug;
  set slug(String? slug) => _$this._slug = slug;

  String? _logoUrl;
  String? get logoUrl => _$this._logoUrl;
  set logoUrl(String? logoUrl) => _$this._logoUrl = logoUrl;

  bool? _isDelete;
  bool? get isDelete => _$this._isDelete;
  set isDelete(bool? isDelete) => _$this._isDelete = isDelete;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  BrandResponseBuilder() {
    BrandResponse._defaults(this);
  }

  BrandResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _orgId = $v.orgId;
      _name = $v.name;
      _slug = $v.slug;
      _logoUrl = $v.logoUrl;
      _isDelete = $v.isDelete;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BrandResponse other) {
    _$v = other as _$BrandResponse;
  }

  @override
  void update(void Function(BrandResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BrandResponse build() => _build();

  _$BrandResponse _build() {
    final _$result =
        _$v ??
        _$BrandResponse._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'BrandResponse', 'id'),
          orgId: BuiltValueNullFieldError.checkNotNull(
            orgId,
            r'BrandResponse',
            'orgId',
          ),
          name: BuiltValueNullFieldError.checkNotNull(
            name,
            r'BrandResponse',
            'name',
          ),
          slug: slug,
          logoUrl: logoUrl,
          isDelete: BuiltValueNullFieldError.checkNotNull(
            isDelete,
            r'BrandResponse',
            'isDelete',
          ),
          createdAt: BuiltValueNullFieldError.checkNotNull(
            createdAt,
            r'BrandResponse',
            'createdAt',
          ),
          updatedAt: BuiltValueNullFieldError.checkNotNull(
            updatedAt,
            r'BrandResponse',
            'updatedAt',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
