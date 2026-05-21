// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upsert_barcode_input.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UpsertBarcodeInput extends UpsertBarcodeInput {
  @override
  final String? id;
  @override
  final String barcode;

  factory _$UpsertBarcodeInput([
    void Function(UpsertBarcodeInputBuilder)? updates,
  ]) => (UpsertBarcodeInputBuilder()..update(updates))._build();

  _$UpsertBarcodeInput._({this.id, required this.barcode}) : super._();
  @override
  UpsertBarcodeInput rebuild(
    void Function(UpsertBarcodeInputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  UpsertBarcodeInputBuilder toBuilder() =>
      UpsertBarcodeInputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UpsertBarcodeInput &&
        id == other.id &&
        barcode == other.barcode;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, barcode.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UpsertBarcodeInput')
          ..add('id', id)
          ..add('barcode', barcode))
        .toString();
  }
}

class UpsertBarcodeInputBuilder
    implements Builder<UpsertBarcodeInput, UpsertBarcodeInputBuilder> {
  _$UpsertBarcodeInput? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _barcode;
  String? get barcode => _$this._barcode;
  set barcode(String? barcode) => _$this._barcode = barcode;

  UpsertBarcodeInputBuilder() {
    UpsertBarcodeInput._defaults(this);
  }

  UpsertBarcodeInputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _barcode = $v.barcode;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UpsertBarcodeInput other) {
    _$v = other as _$UpsertBarcodeInput;
  }

  @override
  void update(void Function(UpsertBarcodeInputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UpsertBarcodeInput build() => _build();

  _$UpsertBarcodeInput _build() {
    final _$result =
        _$v ??
        _$UpsertBarcodeInput._(
          id: id,
          barcode: BuiltValueNullFieldError.checkNotNull(
            barcode,
            r'UpsertBarcodeInput',
            'barcode',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
