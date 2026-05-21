// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upsert_umo_input.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UpsertUmoInput extends UpsertUmoInput {
  @override
  final String? id;
  @override
  final String label;
  @override
  final int ratio;
  @override
  final double? sellPrice;
  @override
  final String? barcode;

  factory _$UpsertUmoInput([void Function(UpsertUmoInputBuilder)? updates]) =>
      (UpsertUmoInputBuilder()..update(updates))._build();

  _$UpsertUmoInput._({
    this.id,
    required this.label,
    required this.ratio,
    this.sellPrice,
    this.barcode,
  }) : super._();
  @override
  UpsertUmoInput rebuild(void Function(UpsertUmoInputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UpsertUmoInputBuilder toBuilder() => UpsertUmoInputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UpsertUmoInput &&
        id == other.id &&
        label == other.label &&
        ratio == other.ratio &&
        sellPrice == other.sellPrice &&
        barcode == other.barcode;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, ratio.hashCode);
    _$hash = $jc(_$hash, sellPrice.hashCode);
    _$hash = $jc(_$hash, barcode.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UpsertUmoInput')
          ..add('id', id)
          ..add('label', label)
          ..add('ratio', ratio)
          ..add('sellPrice', sellPrice)
          ..add('barcode', barcode))
        .toString();
  }
}

class UpsertUmoInputBuilder
    implements Builder<UpsertUmoInput, UpsertUmoInputBuilder> {
  _$UpsertUmoInput? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  int? _ratio;
  int? get ratio => _$this._ratio;
  set ratio(int? ratio) => _$this._ratio = ratio;

  double? _sellPrice;
  double? get sellPrice => _$this._sellPrice;
  set sellPrice(double? sellPrice) => _$this._sellPrice = sellPrice;

  String? _barcode;
  String? get barcode => _$this._barcode;
  set barcode(String? barcode) => _$this._barcode = barcode;

  UpsertUmoInputBuilder() {
    UpsertUmoInput._defaults(this);
  }

  UpsertUmoInputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _label = $v.label;
      _ratio = $v.ratio;
      _sellPrice = $v.sellPrice;
      _barcode = $v.barcode;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UpsertUmoInput other) {
    _$v = other as _$UpsertUmoInput;
  }

  @override
  void update(void Function(UpsertUmoInputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UpsertUmoInput build() => _build();

  _$UpsertUmoInput _build() {
    final _$result =
        _$v ??
        _$UpsertUmoInput._(
          id: id,
          label: BuiltValueNullFieldError.checkNotNull(
            label,
            r'UpsertUmoInput',
            'label',
          ),
          ratio: BuiltValueNullFieldError.checkNotNull(
            ratio,
            r'UpsertUmoInput',
            'ratio',
          ),
          sellPrice: sellPrice,
          barcode: barcode,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
