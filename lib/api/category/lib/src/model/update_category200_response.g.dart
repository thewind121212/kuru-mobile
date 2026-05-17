// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_category200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UpdateCategory200Response extends UpdateCategory200Response {
  @override
  final bool success;
  @override
  final UpdateCategoryResponse data;
  @override
  final DateTime timestamp;

  factory _$UpdateCategory200Response([
    void Function(UpdateCategory200ResponseBuilder)? updates,
  ]) => (UpdateCategory200ResponseBuilder()..update(updates))._build();

  _$UpdateCategory200Response._({
    required this.success,
    required this.data,
    required this.timestamp,
  }) : super._();
  @override
  UpdateCategory200Response rebuild(
    void Function(UpdateCategory200ResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  UpdateCategory200ResponseBuilder toBuilder() =>
      UpdateCategory200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UpdateCategory200Response &&
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
    return (newBuiltValueToStringHelper(r'UpdateCategory200Response')
          ..add('success', success)
          ..add('data', data)
          ..add('timestamp', timestamp))
        .toString();
  }
}

class UpdateCategory200ResponseBuilder
    implements
        Builder<UpdateCategory200Response, UpdateCategory200ResponseBuilder> {
  _$UpdateCategory200Response? _$v;

  bool? _success;
  bool? get success => _$this._success;
  set success(bool? success) => _$this._success = success;

  UpdateCategoryResponseBuilder? _data;
  UpdateCategoryResponseBuilder get data =>
      _$this._data ??= UpdateCategoryResponseBuilder();
  set data(UpdateCategoryResponseBuilder? data) => _$this._data = data;

  DateTime? _timestamp;
  DateTime? get timestamp => _$this._timestamp;
  set timestamp(DateTime? timestamp) => _$this._timestamp = timestamp;

  UpdateCategory200ResponseBuilder() {
    UpdateCategory200Response._defaults(this);
  }

  UpdateCategory200ResponseBuilder get _$this {
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
  void replace(UpdateCategory200Response other) {
    _$v = other as _$UpdateCategory200Response;
  }

  @override
  void update(void Function(UpdateCategory200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UpdateCategory200Response build() => _build();

  _$UpdateCategory200Response _build() {
    _$UpdateCategory200Response _$result;
    try {
      _$result =
          _$v ??
          _$UpdateCategory200Response._(
            success: BuiltValueNullFieldError.checkNotNull(
              success,
              r'UpdateCategory200Response',
              'success',
            ),
            data: data.build(),
            timestamp: BuiltValueNullFieldError.checkNotNull(
              timestamp,
              r'UpdateCategory200Response',
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
          r'UpdateCategory200Response',
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
