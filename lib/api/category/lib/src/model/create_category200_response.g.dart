// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_category200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CreateCategory200Response extends CreateCategory200Response {
  @override
  final bool success;
  @override
  final CreateCategoryResponse data;
  @override
  final DateTime timestamp;

  factory _$CreateCategory200Response([
    void Function(CreateCategory200ResponseBuilder)? updates,
  ]) => (CreateCategory200ResponseBuilder()..update(updates))._build();

  _$CreateCategory200Response._({
    required this.success,
    required this.data,
    required this.timestamp,
  }) : super._();
  @override
  CreateCategory200Response rebuild(
    void Function(CreateCategory200ResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CreateCategory200ResponseBuilder toBuilder() =>
      CreateCategory200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreateCategory200Response &&
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
    return (newBuiltValueToStringHelper(r'CreateCategory200Response')
          ..add('success', success)
          ..add('data', data)
          ..add('timestamp', timestamp))
        .toString();
  }
}

class CreateCategory200ResponseBuilder
    implements
        Builder<CreateCategory200Response, CreateCategory200ResponseBuilder> {
  _$CreateCategory200Response? _$v;

  bool? _success;
  bool? get success => _$this._success;
  set success(bool? success) => _$this._success = success;

  CreateCategoryResponseBuilder? _data;
  CreateCategoryResponseBuilder get data =>
      _$this._data ??= CreateCategoryResponseBuilder();
  set data(CreateCategoryResponseBuilder? data) => _$this._data = data;

  DateTime? _timestamp;
  DateTime? get timestamp => _$this._timestamp;
  set timestamp(DateTime? timestamp) => _$this._timestamp = timestamp;

  CreateCategory200ResponseBuilder() {
    CreateCategory200Response._defaults(this);
  }

  CreateCategory200ResponseBuilder get _$this {
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
  void replace(CreateCategory200Response other) {
    _$v = other as _$CreateCategory200Response;
  }

  @override
  void update(void Function(CreateCategory200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreateCategory200Response build() => _build();

  _$CreateCategory200Response _build() {
    _$CreateCategory200Response _$result;
    try {
      _$result =
          _$v ??
          _$CreateCategory200Response._(
            success: BuiltValueNullFieldError.checkNotNull(
              success,
              r'CreateCategory200Response',
              'success',
            ),
            data: data.build(),
            timestamp: BuiltValueNullFieldError.checkNotNull(
              timestamp,
              r'CreateCategory200Response',
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
          r'CreateCategory200Response',
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
