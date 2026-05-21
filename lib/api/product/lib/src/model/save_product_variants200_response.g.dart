// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'save_product_variants200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SaveProductVariants200Response extends SaveProductVariants200Response {
  @override
  final bool success;
  @override
  final SaveProductVariantsResponse data;
  @override
  final DateTime timestamp;

  factory _$SaveProductVariants200Response([
    void Function(SaveProductVariants200ResponseBuilder)? updates,
  ]) => (SaveProductVariants200ResponseBuilder()..update(updates))._build();

  _$SaveProductVariants200Response._({
    required this.success,
    required this.data,
    required this.timestamp,
  }) : super._();
  @override
  SaveProductVariants200Response rebuild(
    void Function(SaveProductVariants200ResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  SaveProductVariants200ResponseBuilder toBuilder() =>
      SaveProductVariants200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SaveProductVariants200Response &&
        success == other.success &&
        data == other.data &&
        timestamp == other.timestamp;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, success.hashCode);
    _$hash = $jc(_$hash, data.hashCode);
    _$hash = $jc(_$hash, timestamp.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SaveProductVariants200Response')
          ..add('success', success)
          ..add('data', data)
          ..add('timestamp', timestamp))
        .toString();
  }
}

class SaveProductVariants200ResponseBuilder
    implements
        Builder<
          SaveProductVariants200Response,
          SaveProductVariants200ResponseBuilder
        > {
  _$SaveProductVariants200Response? _$v;

  bool? _success;
  bool? get success => _$this._success;
  set success(bool? success) => _$this._success = success;

  SaveProductVariantsResponseBuilder? _data;
  SaveProductVariantsResponseBuilder get data =>
      _$this._data ??= SaveProductVariantsResponseBuilder();
  set data(SaveProductVariantsResponseBuilder? data) => _$this._data = data;

  DateTime? _timestamp;
  DateTime? get timestamp => _$this._timestamp;
  set timestamp(DateTime? timestamp) => _$this._timestamp = timestamp;

  SaveProductVariants200ResponseBuilder() {
    SaveProductVariants200Response._defaults(this);
  }

  SaveProductVariants200ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _success = $v.success;
      _data = $v.data.toBuilder();
      _timestamp = $v.timestamp;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SaveProductVariants200Response other) {
    _$v = other as _$SaveProductVariants200Response;
  }

  @override
  void update(void Function(SaveProductVariants200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SaveProductVariants200Response build() => _build();

  _$SaveProductVariants200Response _build() {
    _$SaveProductVariants200Response _$result;
    try {
      _$result =
          _$v ??
          _$SaveProductVariants200Response._(
            success: BuiltValueNullFieldError.checkNotNull(
              success,
              r'SaveProductVariants200Response',
              'success',
            ),
            data: data.build(),
            timestamp: BuiltValueNullFieldError.checkNotNull(
              timestamp,
              r'SaveProductVariants200Response',
              'timestamp',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'SaveProductVariants200Response',
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
