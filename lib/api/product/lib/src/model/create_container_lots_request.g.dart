// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_container_lots_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CreateContainerLotsRequest extends CreateContainerLotsRequest {
  @override
  final String productId;
  @override
  final BuiltList<CreateContainerLotInput>? lots;

  factory _$CreateContainerLotsRequest([
    void Function(CreateContainerLotsRequestBuilder)? updates,
  ]) => (CreateContainerLotsRequestBuilder()..update(updates))._build();

  _$CreateContainerLotsRequest._({required this.productId, this.lots})
    : super._();
  @override
  CreateContainerLotsRequest rebuild(
    void Function(CreateContainerLotsRequestBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CreateContainerLotsRequestBuilder toBuilder() =>
      CreateContainerLotsRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreateContainerLotsRequest &&
        productId == other.productId &&
        lots == other.lots;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, productId.hashCode);
    _$hash = $jc(_$hash, lots.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CreateContainerLotsRequest')
          ..add('productId', productId)
          ..add('lots', lots))
        .toString();
  }
}

class CreateContainerLotsRequestBuilder
    implements
        Builder<CreateContainerLotsRequest, CreateContainerLotsRequestBuilder> {
  _$CreateContainerLotsRequest? _$v;

  String? _productId;
  String? get productId => _$this._productId;
  set productId(String? productId) => _$this._productId = productId;

  ListBuilder<CreateContainerLotInput>? _lots;
  ListBuilder<CreateContainerLotInput> get lots =>
      _$this._lots ??= ListBuilder<CreateContainerLotInput>();
  set lots(ListBuilder<CreateContainerLotInput>? lots) => _$this._lots = lots;

  CreateContainerLotsRequestBuilder() {
    CreateContainerLotsRequest._defaults(this);
  }

  CreateContainerLotsRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _productId = $v.productId;
      _lots = $v.lots?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CreateContainerLotsRequest other) {
    _$v = other as _$CreateContainerLotsRequest;
  }

  @override
  void update(void Function(CreateContainerLotsRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreateContainerLotsRequest build() => _build();

  _$CreateContainerLotsRequest _build() {
    _$CreateContainerLotsRequest _$result;
    try {
      _$result =
          _$v ??
          _$CreateContainerLotsRequest._(
            productId: BuiltValueNullFieldError.checkNotNull(
              productId,
              r'CreateContainerLotsRequest',
              'productId',
            ),
            lots: _lots?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'lots';
        _lots?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CreateContainerLotsRequest',
          _$failedField,
          e.toString(),
        );
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
