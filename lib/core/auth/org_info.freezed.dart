// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'org_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

OrgInfo _$OrgInfoFromJson(Map<String, dynamic> json) {
  return _OrgInfo.fromJson(json);
}

/// @nodoc
mixin _$OrgInfo {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get role => throw _privateConstructorUsedError;

  /// Serializes this OrgInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrgInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrgInfoCopyWith<OrgInfo> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrgInfoCopyWith<$Res> {
  factory $OrgInfoCopyWith(OrgInfo value, $Res Function(OrgInfo) then) =
      _$OrgInfoCopyWithImpl<$Res, OrgInfo>;
  @useResult
  $Res call({String id, String name, String role});
}

/// @nodoc
class _$OrgInfoCopyWithImpl<$Res, $Val extends OrgInfo>
    implements $OrgInfoCopyWith<$Res> {
  _$OrgInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrgInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? name = null, Object? role = null}) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            role: null == role
                ? _value.role
                : role // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OrgInfoImplCopyWith<$Res> implements $OrgInfoCopyWith<$Res> {
  factory _$$OrgInfoImplCopyWith(
    _$OrgInfoImpl value,
    $Res Function(_$OrgInfoImpl) then,
  ) = __$$OrgInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name, String role});
}

/// @nodoc
class __$$OrgInfoImplCopyWithImpl<$Res>
    extends _$OrgInfoCopyWithImpl<$Res, _$OrgInfoImpl>
    implements _$$OrgInfoImplCopyWith<$Res> {
  __$$OrgInfoImplCopyWithImpl(
    _$OrgInfoImpl _value,
    $Res Function(_$OrgInfoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OrgInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? name = null, Object? role = null}) {
    return _then(
      _$OrgInfoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        role: null == role
            ? _value.role
            : role // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OrgInfoImpl implements _OrgInfo {
  const _$OrgInfoImpl({
    required this.id,
    required this.name,
    required this.role,
  });

  factory _$OrgInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrgInfoImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String role;

  @override
  String toString() {
    return 'OrgInfo(id: $id, name: $name, role: $role)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrgInfoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.role, role) || other.role == role));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, role);

  /// Create a copy of OrgInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrgInfoImplCopyWith<_$OrgInfoImpl> get copyWith =>
      __$$OrgInfoImplCopyWithImpl<_$OrgInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrgInfoImplToJson(this);
  }
}

abstract class _OrgInfo implements OrgInfo {
  const factory _OrgInfo({
    required final String id,
    required final String name,
    required final String role,
  }) = _$OrgInfoImpl;

  factory _OrgInfo.fromJson(Map<String, dynamic> json) = _$OrgInfoImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get role;

  /// Create a copy of OrgInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrgInfoImplCopyWith<_$OrgInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
