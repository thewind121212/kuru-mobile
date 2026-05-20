// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_product_barcode_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CreateProductBarcodeRequest extends CreateProductBarcodeRequest {
  @override
  final String value;
  @override
  final bool? isActive;

  factory _$CreateProductBarcodeRequest([
    void Function(CreateProductBarcodeRequestBuilder)? updates,
  ]) => (CreateProductBarcodeRequestBuilder()..update(updates))._build();

  _$CreateProductBarcodeRequest._({required this.value, this.isActive})
    : super._();
  @override
  CreateProductBarcodeRequest rebuild(
    void Function(CreateProductBarcodeRequestBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CreateProductBarcodeRequestBuilder toBuilder() =>
      CreateProductBarcodeRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreateProductBarcodeRequest &&
        value == other.value &&
        isActive == other.isActive;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, value.hashCode);
    _$hash = $jc(_$hash, isActive.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CreateProductBarcodeRequest')
          ..add('value', value)
          ..add('isActive', isActive))
        .toString();
  }
}

class CreateProductBarcodeRequestBuilder
    implements
        Builder<
          CreateProductBarcodeRequest,
          CreateProductBarcodeRequestBuilder
        > {
  _$CreateProductBarcodeRequest? _$v;

  String? _value;
  String? get value => _$this._value;
  set value(String? value) => _$this._value = value;

  bool? _isActive;
  bool? get isActive => _$this._isActive;
  set isActive(bool? isActive) => _$this._isActive = isActive;

  CreateProductBarcodeRequestBuilder() {
    CreateProductBarcodeRequest._defaults(this);
  }

  CreateProductBarcodeRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _value = $v.value;
      _isActive = $v.isActive;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CreateProductBarcodeRequest other) {
    _$v = other as _$CreateProductBarcodeRequest;
  }

  @override
  void update(void Function(CreateProductBarcodeRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreateProductBarcodeRequest build() => _build();

  _$CreateProductBarcodeRequest _build() {
    final _$result =
        _$v ??
        _$CreateProductBarcodeRequest._(
          value: BuiltValueNullFieldError.checkNotNull(
            value,
            r'CreateProductBarcodeRequest',
            'value',
          ),
          isActive: isActive,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
