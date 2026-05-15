// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

UserInfo _$UserInfoFromJson(Map<String, dynamic> json) {
  return _UserInfo.fromJson(json);
}

/// @nodoc
mixin _$UserInfo {
  String? get email => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  List<OrgInfo> get orgInfos => throw _privateConstructorUsedError;
  List<OrgInfo> get disabledOrgInfos => throw _privateConstructorUsedError;
  String? get avatarStyle => throw _privateConstructorUsedError;
  String? get avatarSeed => throw _privateConstructorUsedError;
  String? get avatarUrl => throw _privateConstructorUsedError;
  bool get totpEnabled => throw _privateConstructorUsedError;
  int get pendingInviteCount => throw _privateConstructorUsedError;

  /// Serializes this UserInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserInfoCopyWith<UserInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserInfoCopyWith<$Res> {
  factory $UserInfoCopyWith(UserInfo value, $Res Function(UserInfo) then) =
      _$UserInfoCopyWithImpl<$Res, UserInfo>;
  @useResult
  $Res call({
    String? email,
    String? name,
    List<OrgInfo> orgInfos,
    List<OrgInfo> disabledOrgInfos,
    String? avatarStyle,
    String? avatarSeed,
    String? avatarUrl,
    bool totpEnabled,
    int pendingInviteCount,
  });
}

/// @nodoc
class _$UserInfoCopyWithImpl<$Res, $Val extends UserInfo>
    implements $UserInfoCopyWith<$Res> {
  _$UserInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = freezed,
    Object? name = freezed,
    Object? orgInfos = null,
    Object? disabledOrgInfos = null,
    Object? avatarStyle = freezed,
    Object? avatarSeed = freezed,
    Object? avatarUrl = freezed,
    Object? totpEnabled = null,
    Object? pendingInviteCount = null,
  }) {
    return _then(
      _value.copyWith(
            email: freezed == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String?,
            name: freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String?,
            orgInfos: null == orgInfos
                ? _value.orgInfos
                : orgInfos // ignore: cast_nullable_to_non_nullable
                      as List<OrgInfo>,
            disabledOrgInfos: null == disabledOrgInfos
                ? _value.disabledOrgInfos
                : disabledOrgInfos // ignore: cast_nullable_to_non_nullable
                      as List<OrgInfo>,
            avatarStyle: freezed == avatarStyle
                ? _value.avatarStyle
                : avatarStyle // ignore: cast_nullable_to_non_nullable
                      as String?,
            avatarSeed: freezed == avatarSeed
                ? _value.avatarSeed
                : avatarSeed // ignore: cast_nullable_to_non_nullable
                      as String?,
            avatarUrl: freezed == avatarUrl
                ? _value.avatarUrl
                : avatarUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            totpEnabled: null == totpEnabled
                ? _value.totpEnabled
                : totpEnabled // ignore: cast_nullable_to_non_nullable
                      as bool,
            pendingInviteCount: null == pendingInviteCount
                ? _value.pendingInviteCount
                : pendingInviteCount // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserInfoImplCopyWith<$Res>
    implements $UserInfoCopyWith<$Res> {
  factory _$$UserInfoImplCopyWith(
    _$UserInfoImpl value,
    $Res Function(_$UserInfoImpl) then,
  ) = __$$UserInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? email,
    String? name,
    List<OrgInfo> orgInfos,
    List<OrgInfo> disabledOrgInfos,
    String? avatarStyle,
    String? avatarSeed,
    String? avatarUrl,
    bool totpEnabled,
    int pendingInviteCount,
  });
}

/// @nodoc
class __$$UserInfoImplCopyWithImpl<$Res>
    extends _$UserInfoCopyWithImpl<$Res, _$UserInfoImpl>
    implements _$$UserInfoImplCopyWith<$Res> {
  __$$UserInfoImplCopyWithImpl(
    _$UserInfoImpl _value,
    $Res Function(_$UserInfoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = freezed,
    Object? name = freezed,
    Object? orgInfos = null,
    Object? disabledOrgInfos = null,
    Object? avatarStyle = freezed,
    Object? avatarSeed = freezed,
    Object? avatarUrl = freezed,
    Object? totpEnabled = null,
    Object? pendingInviteCount = null,
  }) {
    return _then(
      _$UserInfoImpl(
        email: freezed == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String?,
        name: freezed == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String?,
        orgInfos: null == orgInfos
            ? _value._orgInfos
            : orgInfos // ignore: cast_nullable_to_non_nullable
                  as List<OrgInfo>,
        disabledOrgInfos: null == disabledOrgInfos
            ? _value._disabledOrgInfos
            : disabledOrgInfos // ignore: cast_nullable_to_non_nullable
                  as List<OrgInfo>,
        avatarStyle: freezed == avatarStyle
            ? _value.avatarStyle
            : avatarStyle // ignore: cast_nullable_to_non_nullable
                  as String?,
        avatarSeed: freezed == avatarSeed
            ? _value.avatarSeed
            : avatarSeed // ignore: cast_nullable_to_non_nullable
                  as String?,
        avatarUrl: freezed == avatarUrl
            ? _value.avatarUrl
            : avatarUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        totpEnabled: null == totpEnabled
            ? _value.totpEnabled
            : totpEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        pendingInviteCount: null == pendingInviteCount
            ? _value.pendingInviteCount
            : pendingInviteCount // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserInfoImpl implements _UserInfo {
  const _$UserInfoImpl({
    this.email,
    this.name,
    final List<OrgInfo> orgInfos = const <OrgInfo>[],
    final List<OrgInfo> disabledOrgInfos = const <OrgInfo>[],
    this.avatarStyle,
    this.avatarSeed,
    this.avatarUrl,
    this.totpEnabled = false,
    this.pendingInviteCount = 0,
  }) : _orgInfos = orgInfos,
       _disabledOrgInfos = disabledOrgInfos;

  factory _$UserInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserInfoImplFromJson(json);

  @override
  final String? email;
  @override
  final String? name;
  final List<OrgInfo> _orgInfos;
  @override
  @JsonKey()
  List<OrgInfo> get orgInfos {
    if (_orgInfos is EqualUnmodifiableListView) return _orgInfos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_orgInfos);
  }

  final List<OrgInfo> _disabledOrgInfos;
  @override
  @JsonKey()
  List<OrgInfo> get disabledOrgInfos {
    if (_disabledOrgInfos is EqualUnmodifiableListView)
      return _disabledOrgInfos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_disabledOrgInfos);
  }

  @override
  final String? avatarStyle;
  @override
  final String? avatarSeed;
  @override
  final String? avatarUrl;
  @override
  @JsonKey()
  final bool totpEnabled;
  @override
  @JsonKey()
  final int pendingInviteCount;

  @override
  String toString() {
    return 'UserInfo(email: $email, name: $name, orgInfos: $orgInfos, disabledOrgInfos: $disabledOrgInfos, avatarStyle: $avatarStyle, avatarSeed: $avatarSeed, avatarUrl: $avatarUrl, totpEnabled: $totpEnabled, pendingInviteCount: $pendingInviteCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserInfoImpl &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(other._orgInfos, _orgInfos) &&
            const DeepCollectionEquality().equals(
              other._disabledOrgInfos,
              _disabledOrgInfos,
            ) &&
            (identical(other.avatarStyle, avatarStyle) ||
                other.avatarStyle == avatarStyle) &&
            (identical(other.avatarSeed, avatarSeed) ||
                other.avatarSeed == avatarSeed) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.totpEnabled, totpEnabled) ||
                other.totpEnabled == totpEnabled) &&
            (identical(other.pendingInviteCount, pendingInviteCount) ||
                other.pendingInviteCount == pendingInviteCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    email,
    name,
    const DeepCollectionEquality().hash(_orgInfos),
    const DeepCollectionEquality().hash(_disabledOrgInfos),
    avatarStyle,
    avatarSeed,
    avatarUrl,
    totpEnabled,
    pendingInviteCount,
  );

  /// Create a copy of UserInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserInfoImplCopyWith<_$UserInfoImpl> get copyWith =>
      __$$UserInfoImplCopyWithImpl<_$UserInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserInfoImplToJson(this);
  }
}

abstract class _UserInfo implements UserInfo {
  const factory _UserInfo({
    final String? email,
    final String? name,
    final List<OrgInfo> orgInfos,
    final List<OrgInfo> disabledOrgInfos,
    final String? avatarStyle,
    final String? avatarSeed,
    final String? avatarUrl,
    final bool totpEnabled,
    final int pendingInviteCount,
  }) = _$UserInfoImpl;

  factory _UserInfo.fromJson(Map<String, dynamic> json) =
      _$UserInfoImpl.fromJson;

  @override
  String? get email;
  @override
  String? get name;
  @override
  List<OrgInfo> get orgInfos;
  @override
  List<OrgInfo> get disabledOrgInfos;
  @override
  String? get avatarStyle;
  @override
  String? get avatarSeed;
  @override
  String? get avatarUrl;
  @override
  bool get totpEnabled;
  @override
  int get pendingInviteCount;

  /// Create a copy of UserInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserInfoImplCopyWith<_$UserInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
