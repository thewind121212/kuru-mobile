// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'security_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SecurityStatusImpl _$$SecurityStatusImplFromJson(Map<String, dynamic> json) =>
    _$SecurityStatusImpl(
      totpEnabled: json['totpEnabled'] as bool? ?? false,
      recoveryCodesRemaining:
          (json['recoveryCodesRemaining'] as num?)?.toInt() ?? 0,
      passkeyCount: (json['passkeyCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$SecurityStatusImplToJson(
  _$SecurityStatusImpl instance,
) => <String, dynamic>{
  'totpEnabled': instance.totpEnabled,
  'recoveryCodesRemaining': instance.recoveryCodesRemaining,
  'passkeyCount': instance.passkeyCount,
};
