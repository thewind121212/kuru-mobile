import 'package:freezed_annotation/freezed_annotation.dart';

part 'security_status.freezed.dart';
part 'security_status.g.dart';

@freezed
class SecurityStatus with _$SecurityStatus {
  const factory SecurityStatus({
    @Default(false) bool totpEnabled,
    @Default(0) int recoveryCodesRemaining,
    @Default(0) int passkeyCount,
  }) = _SecurityStatus;

  factory SecurityStatus.fromJson(Map<String, dynamic> json) =>
      _$SecurityStatusFromJson(json);
}
