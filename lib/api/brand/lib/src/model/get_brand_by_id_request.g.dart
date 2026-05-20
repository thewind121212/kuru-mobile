// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_brand_by_id_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GetBrandByIdRequest extends GetBrandByIdRequest {
  @override
  final String brandId;

  factory _$GetBrandByIdRequest([
    void Function(GetBrandByIdRequestBuilder)? updates,
  ]) => (GetBrandByIdRequestBuilder()..update(updates))._build();

  _$GetBrandByIdRequest._({required this.brandId}) : super._();
  @override
  GetBrandByIdRequest rebuild(
    void Function(GetBrandByIdRequestBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  GetBrandByIdRequestBuilder toBuilder() =>
      GetBrandByIdRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GetBrandByIdRequest && brandId == other.brandId;
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
      r'GetBrandByIdRequest',
    )..add('brandId', brandId)).toString();
  }
}

class GetBrandByIdRequestBuilder
    implements Builder<GetBrandByIdRequest, GetBrandByIdRequestBuilder> {
  _$GetBrandByIdRequest? _$v;

  String? _brandId;
  String? get brandId => _$this._brandId;
  set brandId(String? brandId) => _$this._brandId = brandId;

  GetBrandByIdRequestBuilder() {
    GetBrandByIdRequest._defaults(this);
  }

  GetBrandByIdRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _brandId = $v.brandId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GetBrandByIdRequest other) {
    _$v = other as _$GetBrandByIdRequest;
  }

  @override
  void update(void Function(GetBrandByIdRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GetBrandByIdRequest build() => _build();

  _$GetBrandByIdRequest _build() {
    final _$result =
        _$v ??
        _$GetBrandByIdRequest._(
          brandId: BuiltValueNullFieldError.checkNotNull(
            brandId,
            r'GetBrandByIdRequest',
            'brandId',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
