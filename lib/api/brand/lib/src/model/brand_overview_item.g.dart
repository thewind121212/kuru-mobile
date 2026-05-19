// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brand_overview_item.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BrandOverviewItem extends BrandOverviewItem {
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
  final int productCount;

  factory _$BrandOverviewItem([
    void Function(BrandOverviewItemBuilder)? updates,
  ]) => (BrandOverviewItemBuilder()..update(updates))._build();

  _$BrandOverviewItem._({
    required this.id,
    required this.orgId,
    required this.name,
    this.slug,
    this.logoUrl,
    required this.productCount,
  }) : super._();
  @override
  BrandOverviewItem rebuild(void Function(BrandOverviewItemBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BrandOverviewItemBuilder toBuilder() =>
      BrandOverviewItemBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BrandOverviewItem &&
        id == other.id &&
        orgId == other.orgId &&
        name == other.name &&
        slug == other.slug &&
        logoUrl == other.logoUrl &&
        productCount == other.productCount;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, orgId.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, slug.hashCode);
    _$hash = $jc(_$hash, logoUrl.hashCode);
    _$hash = $jc(_$hash, productCount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BrandOverviewItem')
          ..add('id', id)
          ..add('orgId', orgId)
          ..add('name', name)
          ..add('slug', slug)
          ..add('logoUrl', logoUrl)
          ..add('productCount', productCount))
        .toString();
  }
}

class BrandOverviewItemBuilder
    implements Builder<BrandOverviewItem, BrandOverviewItemBuilder> {
  _$BrandOverviewItem? _$v;

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

  int? _productCount;
  int? get productCount => _$this._productCount;
  set productCount(int? productCount) => _$this._productCount = productCount;

  BrandOverviewItemBuilder() {
    BrandOverviewItem._defaults(this);
  }

  BrandOverviewItemBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _orgId = $v.orgId;
      _name = $v.name;
      _slug = $v.slug;
      _logoUrl = $v.logoUrl;
      _productCount = $v.productCount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BrandOverviewItem other) {
    _$v = other as _$BrandOverviewItem;
  }

  @override
  void update(void Function(BrandOverviewItemBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BrandOverviewItem build() => _build();

  _$BrandOverviewItem _build() {
    final _$result =
        _$v ??
        _$BrandOverviewItem._(
          id: BuiltValueNullFieldError.checkNotNull(
            id,
            r'BrandOverviewItem',
            'id',
          ),
          orgId: BuiltValueNullFieldError.checkNotNull(
            orgId,
            r'BrandOverviewItem',
            'orgId',
          ),
          name: BuiltValueNullFieldError.checkNotNull(
            name,
            r'BrandOverviewItem',
            'name',
          ),
          slug: slug,
          logoUrl: logoUrl,
          productCount: BuiltValueNullFieldError.checkNotNull(
            productCount,
            r'BrandOverviewItem',
            'productCount',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
