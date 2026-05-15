import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kuru_mobile/core/auth/org_info.dart';

part 'user_info.freezed.dart';
part 'user_info.g.dart';

@freezed
class UserInfo with _$UserInfo {
  const factory UserInfo({
    String? email,
    String? name,
    @Default(<OrgInfo>[]) List<OrgInfo> orgInfos,
    @Default(<OrgInfo>[]) List<OrgInfo> disabledOrgInfos,
    String? avatarStyle,
    String? avatarSeed,
    String? avatarUrl,
    @Default(false) bool totpEnabled,
    @Default(0) int pendingInviteCount,
  }) = _UserInfo;

  factory UserInfo.fromJson(Map<String, dynamic> json) =>
      _$UserInfoFromJson(json);
}
