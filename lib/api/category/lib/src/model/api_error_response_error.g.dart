// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_error_response_error.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiErrorResponseError extends ApiErrorResponseError {
  @override
  final String message;
  @override
  final String? code;
  @override
  final BuiltMap<String, JsonObject?>? details;

  factory _$ApiErrorResponseError([
    void Function(ApiErrorResponseErrorBuilder)? updates,
  ]) => (ApiErrorResponseErrorBuilder()..update(updates))._build();

  _$ApiErrorResponseError._({required this.message, this.code, this.details})
    : super._();
  @override
  ApiErrorResponseError rebuild(
    void Function(ApiErrorResponseErrorBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  ApiErrorResponseErrorBuilder toBuilder() =>
      ApiErrorResponseErrorBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiErrorResponseError &&
        message == other.message &&
        code == other.code &&
        details == other.details;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, message.hashCode);
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, details.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ApiErrorResponseError')
          ..add('message', message)
          ..add('code', code)
          ..add('details', details))
        .toString();
  }
}

class ApiErrorResponseErrorBuilder
    implements Builder<ApiErrorResponseError, ApiErrorResponseErrorBuilder> {
  _$ApiErrorResponseError? _$v;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  MapBuilder<String, JsonObject?>? _details;
  MapBuilder<String, JsonObject?> get details =>
      _$this._details ??= MapBuilder<String, JsonObject?>();
  set details(MapBuilder<String, JsonObject?>? details) =>
      _$this._details = details;

  ApiErrorResponseErrorBuilder() {
    ApiErrorResponseError._defaults(this);
  }

  ApiErrorResponseErrorBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _message = $v.message;
      _code = $v.code;
      _details = $v.details?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiErrorResponseError other) {
    _$v = other as _$ApiErrorResponseError;
  }

  @override
  void update(void Function(ApiErrorResponseErrorBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiErrorResponseError build() => _build();

  _$ApiErrorResponseError _build() {
    _$ApiErrorResponseError _$result;
    try {
      _$result =
          _$v ??
          _$ApiErrorResponseError._(
            message: BuiltValueNullFieldError.checkNotNull(
              message,
              r'ApiErrorResponseError',
              'message',
            ),
            code: code,
            details: _details?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'details';
        _details?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'ApiErrorResponseError',
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
