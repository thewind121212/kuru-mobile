// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'resolved_permissions.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ResolvedPermissions {
  OrgRole get orgRole => throw _privateConstructorUsedError;
  List<String> get orgPerms => throw _privateConstructorUsedError;

  /// Create a copy of ResolvedPermissions
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ResolvedPermissionsCopyWith<ResolvedPermissions> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ResolvedPermissionsCopyWith<$Res> {
  factory $ResolvedPermissionsCopyWith(
    ResolvedPermissions value,
    $Res Function(ResolvedPermissions) then,
  ) = _$ResolvedPermissionsCopyWithImpl<$Res, ResolvedPermissions>;
  @useResult
  $Res call({OrgRole orgRole, List<String> orgPerms});
}

/// @nodoc
class _$ResolvedPermissionsCopyWithImpl<$Res, $Val extends ResolvedPermissions>
    implements $ResolvedPermissionsCopyWith<$Res> {
  _$ResolvedPermissionsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ResolvedPermissions
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? orgRole = null, Object? orgPerms = null}) {
    return _then(
      _value.copyWith(
            orgRole: null == orgRole
                ? _value.orgRole
                : orgRole // ignore: cast_nullable_to_non_nullable
                      as OrgRole,
            orgPerms: null == orgPerms
                ? _value.orgPerms
                : orgPerms // ignore: cast_nullable_to_non_nullable
                      as List<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ResolvedPermissionsImplCopyWith<$Res>
    implements $ResolvedPermissionsCopyWith<$Res> {
  factory _$$ResolvedPermissionsImplCopyWith(
    _$ResolvedPermissionsImpl value,
    $Res Function(_$ResolvedPermissionsImpl) then,
  ) = __$$ResolvedPermissionsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({OrgRole orgRole, List<String> orgPerms});
}

/// @nodoc
class __$$ResolvedPermissionsImplCopyWithImpl<$Res>
    extends _$ResolvedPermissionsCopyWithImpl<$Res, _$ResolvedPermissionsImpl>
    implements _$$ResolvedPermissionsImplCopyWith<$Res> {
  __$$ResolvedPermissionsImplCopyWithImpl(
    _$ResolvedPermissionsImpl _value,
    $Res Function(_$ResolvedPermissionsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ResolvedPermissions
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? orgRole = null, Object? orgPerms = null}) {
    return _then(
      _$ResolvedPermissionsImpl(
        orgRole: null == orgRole
            ? _value.orgRole
            : orgRole // ignore: cast_nullable_to_non_nullable
                  as OrgRole,
        orgPerms: null == orgPerms
            ? _value._orgPerms
            : orgPerms // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc

class _$ResolvedPermissionsImpl extends _ResolvedPermissions {
  const _$ResolvedPermissionsImpl({
    required this.orgRole,
    final List<String> orgPerms = const <String>[],
  }) : _orgPerms = orgPerms,
       super._();

  @override
  final OrgRole orgRole;
  final List<String> _orgPerms;
  @override
  @JsonKey()
  List<String> get orgPerms {
    if (_orgPerms is EqualUnmodifiableListView) return _orgPerms;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_orgPerms);
  }

  @override
  String toString() {
    return 'ResolvedPermissions(orgRole: $orgRole, orgPerms: $orgPerms)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ResolvedPermissionsImpl &&
            (identical(other.orgRole, orgRole) || other.orgRole == orgRole) &&
            const DeepCollectionEquality().equals(other._orgPerms, _orgPerms));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    orgRole,
    const DeepCollectionEquality().hash(_orgPerms),
  );

  /// Create a copy of ResolvedPermissions
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ResolvedPermissionsImplCopyWith<_$ResolvedPermissionsImpl> get copyWith =>
      __$$ResolvedPermissionsImplCopyWithImpl<_$ResolvedPermissionsImpl>(
        this,
        _$identity,
      );
}

abstract class _ResolvedPermissions extends ResolvedPermissions {
  const factory _ResolvedPermissions({
    required final OrgRole orgRole,
    final List<String> orgPerms,
  }) = _$ResolvedPermissionsImpl;
  const _ResolvedPermissions._() : super._();

  @override
  OrgRole get orgRole;
  @override
  List<String> get orgPerms;

  /// Create a copy of ResolvedPermissions
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ResolvedPermissionsImplCopyWith<_$ResolvedPermissionsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
