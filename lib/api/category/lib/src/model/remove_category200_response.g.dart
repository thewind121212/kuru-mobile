// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remove_category200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RemoveCategory200Response extends RemoveCategory200Response {
  @override
  final bool success;
  @override
  final RemoveCategoryResponse data;
  @override
  final DateTime timestamp;

  factory _$RemoveCategory200Response([
    void Function(RemoveCategory200ResponseBuilder)? updates,
  ]) => (RemoveCategory200ResponseBuilder()..update(updates))._build();

  _$RemoveCategory200Response._({
    required this.success,
    required this.data,
    required this.timestamp,
  }) : super._();
  @override
  RemoveCategory200Response rebuild(
    void Function(RemoveCategory200ResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  RemoveCategory200ResponseBuilder toBuilder() =>
      RemoveCategory200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RemoveCategory200Response &&
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
    return (newBuiltValueToStringHelper(r'RemoveCategory200Response')
          ..add('success', success)
          ..add('data', data)
          ..add('timestamp', timestamp))
        .toString();
  }
}

class RemoveCategory200ResponseBuilder
    implements
        Builder<RemoveCategory200Response, RemoveCategory200ResponseBuilder> {
  _$RemoveCategory200Response? _$v;

  bool? _success;
  bool? get success => _$this._success;
  set success(bool? success) => _$this._success = success;

  RemoveCategoryResponseBuilder? _data;
  RemoveCategoryResponseBuilder get data =>
      _$this._data ??= RemoveCategoryResponseBuilder();
  set data(RemoveCategoryResponseBuilder? data) => _$this._data = data;

  DateTime? _timestamp;
  DateTime? get timestamp => _$this._timestamp;
  set timestamp(DateTime? timestamp) => _$this._timestamp = timestamp;

  RemoveCategory200ResponseBuilder() {
    RemoveCategory200Response._defaults(this);
  }

  RemoveCategory200ResponseBuilder get _$this {
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
  void replace(RemoveCategory200Response other) {
    _$v = other as _$RemoveCategory200Response;
  }

  @override
  void update(void Function(RemoveCategory200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RemoveCategory200Response build() => _build();

  _$RemoveCategory200Response _build() {
    _$RemoveCategory200Response _$result;
    try {
      _$result =
          _$v ??
          _$RemoveCategory200Response._(
            success: BuiltValueNullFieldError.checkNotNull(
              success,
              r'RemoveCategory200Response',
              'success',
            ),
            data: data.build(),
            timestamp: BuiltValueNullFieldError.checkNotNull(
              timestamp,
              r'RemoveCategory200Response',
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
          r'RemoveCategory200Response',
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
