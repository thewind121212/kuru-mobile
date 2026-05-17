// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_error_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiErrorResponse extends ApiErrorResponse {
  @override
  final bool success;
  @override
  final ApiErrorResponseError error;
  @override
  final DateTime timestamp;

  factory _$ApiErrorResponse(
          [void Function(ApiErrorResponseBuilder)? updates]) =>
      (ApiErrorResponseBuilder()..update(updates))._build();

  _$ApiErrorResponse._(
      {required this.success, required this.error, required this.timestamp})
      : super._();
  @override
  ApiErrorResponse rebuild(void Function(ApiErrorResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ApiErrorResponseBuilder toBuilder() =>
      ApiErrorResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiErrorResponse &&
        success == other.success &&
        error == other.error &&
        timestamp == other.timestamp;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, success.hashCode);
    _$hash = $jc(_$hash, error.hashCode);
    _$hash = $jc(_$hash, timestamp.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ApiErrorResponse')
          ..add('success', success)
          ..add('error', error)
          ..add('timestamp', timestamp))
        .toString();
  }
}

class ApiErrorResponseBuilder
    implements Builder<ApiErrorResponse, ApiErrorResponseBuilder> {
  _$ApiErrorResponse? _$v;

  bool? _success;
  bool? get success => _$this._success;
  set success(bool? success) => _$this._success = success;

  ApiErrorResponseErrorBuilder? _error;
  ApiErrorResponseErrorBuilder get error =>
      _$this._error ??= ApiErrorResponseErrorBuilder();
  set error(ApiErrorResponseErrorBuilder? error) => _$this._error = error;

  DateTime? _timestamp;
  DateTime? get timestamp => _$this._timestamp;
  set timestamp(DateTime? timestamp) => _$this._timestamp = timestamp;

  ApiErrorResponseBuilder() {
    ApiErrorResponse._defaults(this);
  }

  ApiErrorResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _success = $v.success;
      _error = $v.error.toBuilder();
      _timestamp = $v.timestamp;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiErrorResponse other) {
    _$v = other as _$ApiErrorResponse;
  }

  @override
  void update(void Function(ApiErrorResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiErrorResponse build() => _build();

  _$ApiErrorResponse _build() {
    _$ApiErrorResponse _$result;
    try {
      _$result = _$v ??
          _$ApiErrorResponse._(
            success: BuiltValueNullFieldError.checkNotNull(
                success, r'ApiErrorResponse', 'success'),
            error: error.build(),
            timestamp: BuiltValueNullFieldError.checkNotNull(
                timestamp, r'ApiErrorResponse', 'timestamp'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'error';
        error.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ApiErrorResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
