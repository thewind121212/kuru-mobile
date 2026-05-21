// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_container_lots_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GetContainerLotsResponse extends GetContainerLotsResponse {
  @override
  final BuiltList<ContainerLotResponse>? containerLots;

  factory _$GetContainerLotsResponse([
    void Function(GetContainerLotsResponseBuilder)? updates,
  ]) => (GetContainerLotsResponseBuilder()..update(updates))._build();

  _$GetContainerLotsResponse._({this.containerLots}) : super._();
  @override
  GetContainerLotsResponse rebuild(
    void Function(GetContainerLotsResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  GetContainerLotsResponseBuilder toBuilder() =>
      GetContainerLotsResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GetContainerLotsResponse &&
        containerLots == other.containerLots;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, containerLots.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'GetContainerLotsResponse',
    )..add('containerLots', containerLots)).toString();
  }
}

class GetContainerLotsResponseBuilder
    implements
        Builder<GetContainerLotsResponse, GetContainerLotsResponseBuilder> {
  _$GetContainerLotsResponse? _$v;

  ListBuilder<ContainerLotResponse>? _containerLots;
  ListBuilder<ContainerLotResponse> get containerLots =>
      _$this._containerLots ??= ListBuilder<ContainerLotResponse>();
  set containerLots(ListBuilder<ContainerLotResponse>? containerLots) =>
      _$this._containerLots = containerLots;

  GetContainerLotsResponseBuilder() {
    GetContainerLotsResponse._defaults(this);
  }

  GetContainerLotsResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _containerLots = $v.containerLots?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GetContainerLotsResponse other) {
    _$v = other as _$GetContainerLotsResponse;
  }

  @override
  void update(void Function(GetContainerLotsResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GetContainerLotsResponse build() => _build();

  _$GetContainerLotsResponse _build() {
    _$GetContainerLotsResponse _$result;
    try {
      _$result =
          _$v ??
          _$GetContainerLotsResponse._(containerLots: _containerLots?.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'containerLots';
        _containerLots?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'GetContainerLotsResponse',
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
