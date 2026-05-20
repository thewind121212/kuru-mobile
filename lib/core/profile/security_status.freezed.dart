// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'security_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SecurityStatus _$SecurityStatusFromJson(Map<String, dynamic> json) {
  return _SecurityStatus.fromJson(json);
}

/// @nodoc
mixin _$SecurityStatus {
  bool get totpEnabled => throw _privateConstructorUsedError;
  int get recoveryCodesRemaining => throw _privateConstructorUsedError;
  int get passkeyCount => throw _privateConstructorUsedError;

  /// Serializes this SecurityStatus to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SecurityStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SecurityStatusCopyWith<SecurityStatus> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SecurityStatusCopyWith<$Res> {
  factory $SecurityStatusCopyWith(
    SecurityStatus value,
    $Res Function(SecurityStatus) then,
  ) = _$SecurityStatusCopyWithImpl<$Res, SecurityStatus>;
  @useResult
  $Res call({bool totpEnabled, int recoveryCodesRemaining, int passkeyCount});
}

/// @nodoc
class _$SecurityStatusCopyWithImpl<$Res, $Val extends SecurityStatus>
    implements $SecurityStatusCopyWith<$Res> {
  _$SecurityStatusCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SecurityStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totpEnabled = null,
    Object? recoveryCodesRemaining = null,
    Object? passkeyCount = null,
  }) {
    return _then(
      _value.copyWith(
            totpEnabled: null == totpEnabled
                ? _value.totpEnabled
                : totpEnabled // ignore: cast_nullable_to_non_nullable
                      as bool,
            recoveryCodesRemaining: null == recoveryCodesRemaining
                ? _value.recoveryCodesRemaining
                : recoveryCodesRemaining // ignore: cast_nullable_to_non_nullable
                      as int,
            passkeyCount: null == passkeyCount
                ? _value.passkeyCount
                : passkeyCount // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SecurityStatusImplCopyWith<$Res>
    implements $SecurityStatusCopyWith<$Res> {
  factory _$$SecurityStatusImplCopyWith(
    _$SecurityStatusImpl value,
    $Res Function(_$SecurityStatusImpl) then,
  ) = __$$SecurityStatusImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool totpEnabled, int recoveryCodesRemaining, int passkeyCount});
}

/// @nodoc
class __$$SecurityStatusImplCopyWithImpl<$Res>
    extends _$SecurityStatusCopyWithImpl<$Res, _$SecurityStatusImpl>
    implements _$$SecurityStatusImplCopyWith<$Res> {
  __$$SecurityStatusImplCopyWithImpl(
    _$SecurityStatusImpl _value,
    $Res Function(_$SecurityStatusImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SecurityStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totpEnabled = null,
    Object? recoveryCodesRemaining = null,
    Object? passkeyCount = null,
  }) {
    return _then(
      _$SecurityStatusImpl(
        totpEnabled: null == totpEnabled
            ? _value.totpEnabled
            : totpEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        recoveryCodesRemaining: null == recoveryCodesRemaining
            ? _value.recoveryCodesRemaining
            : recoveryCodesRemaining // ignore: cast_nullable_to_non_nullable
                  as int,
        passkeyCount: null == passkeyCount
            ? _value.passkeyCount
            : passkeyCount // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SecurityStatusImpl implements _SecurityStatus {
  const _$SecurityStatusImpl({
    this.totpEnabled = false,
    this.recoveryCodesRemaining = 0,
    this.passkeyCount = 0,
  });

  factory _$SecurityStatusImpl.fromJson(Map<String, dynamic> json) =>
      _$$SecurityStatusImplFromJson(json);

  @override
  @JsonKey()
  final bool totpEnabled;
  @override
  @JsonKey()
  final int recoveryCodesRemaining;
  @override
  @JsonKey()
  final int passkeyCount;

  @override
  String toString() {
    return 'SecurityStatus(totpEnabled: $totpEnabled, recoveryCodesRemaining: $recoveryCodesRemaining, passkeyCount: $passkeyCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SecurityStatusImpl &&
            (identical(other.totpEnabled, totpEnabled) ||
                other.totpEnabled == totpEnabled) &&
            (identical(other.recoveryCodesRemaining, recoveryCodesRemaining) ||
                other.recoveryCodesRemaining == recoveryCodesRemaining) &&
            (identical(other.passkeyCount, passkeyCount) ||
                other.passkeyCount == passkeyCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    totpEnabled,
    recoveryCodesRemaining,
    passkeyCount,
  );

  /// Create a copy of SecurityStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SecurityStatusImplCopyWith<_$SecurityStatusImpl> get copyWith =>
      __$$SecurityStatusImplCopyWithImpl<_$SecurityStatusImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SecurityStatusImplToJson(this);
  }
}

abstract class _SecurityStatus implements SecurityStatus {
  const factory _SecurityStatus({
    final bool totpEnabled,
    final int recoveryCodesRemaining,
    final int passkeyCount,
  }) = _$SecurityStatusImpl;

  factory _SecurityStatus.fromJson(Map<String, dynamic> json) =
      _$SecurityStatusImpl.fromJson;

  @override
  bool get totpEnabled;
  @override
  int get recoveryCodesRemaining;
  @override
  int get passkeyCount;

  /// Create a copy of SecurityStatus
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SecurityStatusImplCopyWith<_$SecurityStatusImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
