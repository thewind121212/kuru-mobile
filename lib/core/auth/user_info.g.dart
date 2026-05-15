// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserInfoImpl _$$UserInfoImplFromJson(Map<String, dynamic> json) =>
    _$UserInfoImpl(
      email: json['email'] as String?,
      name: json['name'] as String?,
      orgInfos:
          (json['orgInfos'] as List<dynamic>?)
              ?.map((e) => OrgInfo.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <OrgInfo>[],
      disabledOrgInfos:
          (json['disabledOrgInfos'] as List<dynamic>?)
              ?.map((e) => OrgInfo.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <OrgInfo>[],
      avatarStyle: json['avatarStyle'] as String?,
      avatarSeed: json['avatarSeed'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      totpEnabled: json['totpEnabled'] as bool? ?? false,
      pendingInviteCount: (json['pendingInviteCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$UserInfoImplToJson(_$UserInfoImpl instance) =>
    <String, dynamic>{
      'email': instance.email,
      'name': instance.name,
      'orgInfos': instance.orgInfos,
      'disabledOrgInfos': instance.disabledOrgInfos,
      'avatarStyle': instance.avatarStyle,
      'avatarSeed': instance.avatarSeed,
      'avatarUrl': instance.avatarUrl,
      'totpEnabled': instance.totpEnabled,
      'pendingInviteCount': instance.pendingInviteCount,
    };
