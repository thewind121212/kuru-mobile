// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_container_lots_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CreateContainerLotsResponse extends CreateContainerLotsResponse {
  @override
  final bool success;
  @override
  final String? error;
  @override
  final BuiltList<String>? createdIds;

  factory _$CreateContainerLotsResponse([
    void Function(CreateContainerLotsResponseBuilder)? updates,
  ]) => (CreateContainerLotsResponseBuilder()..update(updates))._build();

  _$CreateContainerLotsResponse._({
    required this.success,
    this.error,
    this.createdIds,
  }) : super._();
  @override
  CreateContainerLotsResponse rebuild(
    void Function(CreateContainerLotsResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CreateContainerLotsResponseBuilder toBuilder() =>
      CreateContainerLotsResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreateContainerLotsResponse &&
        success == other.success &&
        error == other.error &&
        createdIds == other.createdIds;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, success.hashCode);
    _$hash = $jc(_$hash, error.hashCode);
    _$hash = $jc(_$hash, createdIds.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CreateContainerLotsResponse')
          ..add('success', success)
          ..add('error', error)
          ..add('createdIds', createdIds))
        .toString();
  }
}

class CreateContainerLotsResponseBuilder
    implements
        Builder<
          CreateContainerLotsResponse,
          CreateContainerLotsResponseBuilder
        > {
  _$CreateContainerLotsResponse? _$v;

  bool? _success;
  bool? get success => _$this._success;
  set success(bool? success) => _$this._success = success;

  String? _error;
  String? get error => _$this._error;
  set error(String? error) => _$this._error = error;

  ListBuilder<String>? _createdIds;
  ListBuilder<String> get createdIds =>
      _$this._createdIds ??= ListBuilder<String>();
  set createdIds(ListBuilder<String>? createdIds) =>
      _$this._createdIds = createdIds;

  CreateContainerLotsResponseBuilder() {
    CreateContainerLotsResponse._defaults(this);
  }

  CreateContainerLotsResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _success = $v.success;
      _error = $v.error;
      _createdIds = $v.createdIds?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CreateContainerLotsResponse other) {
    _$v = other as _$CreateContainerLotsResponse;
  }

  @override
  void update(void Function(CreateContainerLotsResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreateContainerLotsResponse build() => _build();

  _$CreateContainerLotsResponse _build() {
    _$CreateContainerLotsResponse _$result;
    try {
      _$result =
          _$v ??
          _$CreateContainerLotsResponse._(
            success: BuiltValueNullFieldError.checkNotNull(
              success,
              r'CreateContainerLotsResponse',
              'success',
            ),
            error: error,
            createdIds: _createdIds?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'createdIds';
        _createdIds?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CreateContainerLotsResponse',
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
