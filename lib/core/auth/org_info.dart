import 'package:freezed_annotation/freezed_annotation.dart';

part 'org_info.freezed.dart';
part 'org_info.g.dart';

@freezed
class OrgInfo with _$OrgInfo {
  const factory OrgInfo({
    required String id,
    required String name,
    required String role,
  }) = _OrgInfo;

  factory OrgInfo.fromJson(Map<String, dynamic> json) =>
      _$OrgInfoFromJson(json);
}
