import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuru_mobile/core/auth/auth_repository.dart';
import 'package:kuru_mobile/core/auth/user_info.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:supertokens_flutter/supertokens.dart';

/// Explicit override for the current org id — set by OrgPicker or
/// CreateStore. Null means "fall back to bootstrap-derived org".
class CurrentOrgIdController extends Notifier<String?> {
  @override
  String? build() => null;

  String? get orgId => state;
  set orgId(String? id) => state = id;
  void clear() => state = null;
}

final orgIdOverrideProvider = NotifierProvider<CurrentOrgIdController, String?>(
  CurrentOrgIdController.new,
);

/// Derived single source of truth for the current org id.
/// Resolution order:
///   1. Explicit override (`orgIdOverrideProvider`) — used by OrgPicker /
///      CreateStore flows that need to switch orgs intentionally.
///   2. Bootstrap result — auto-picks the first org of an authed user.
/// Returns null when no session, no orgs, or sign-out has cleared both.
///
/// This is consumed by the dio interceptor and any feature that needs the
/// active org. Because it is *derived*, there is no microtask race between
/// bootstrap completion and the first authenticated request firing.
final Provider<String?> currentOrgIdProvider = Provider<String?>((ref) {
  final override = ref.watch(orgIdOverrideProvider);
  if (override != null) return override;
  final boot = ref.watch(appBootstrapProvider).valueOrNull;
  if (boot is BootstrapAuthed) {
    return boot.user.orgInfos.isEmpty ? null : boot.user.orgInfos.first.id;
  }
  return null;
});

/// One-shot bootstrap: does the user have a valid session? If so, fetch
/// their orgs. The active org id is then derived by
/// [currentOrgIdProvider] — bootstrap itself never mutates org state, so
/// there is no microtask race with the first authenticated request.
final FutureProvider<BootstrapResult> appBootstrapProvider =
    FutureProvider<BootstrapResult>((ref) async {
      final hasSession = await SuperTokens.doesSessionExist();
      if (!hasSession) return const BootstrapUnauthed();

      final repo = ref.read(authRepositoryProvider);
      final result = await repo.getUserInfo();
      return switch (result) {
        ApiSuccess<UserInfo>(:final data) =>
          // BE returns totpEnabled=true ONLY while the session's
          // mfaCompleted flag is still false. Once VerifyTotpCode (or
          // UseRecoveryCode) succeeds, the next getUserInfo call returns
          // totpEnabled=false and we transition into BootstrapAuthed on the
          // next invalidate.
          data.totpEnabled ? BootstrapMfaPending(data) : BootstrapAuthed(data),
        ApiFailure<UserInfo>() => const BootstrapUnauthed(),
      };
    });

sealed class BootstrapResult {
  const BootstrapResult();
}

class BootstrapUnauthed extends BootstrapResult {
  const BootstrapUnauthed();
}

/// Session exists but the BE says TOTP is still required for this session.
/// Router redirects to /totp; user verifies, we re-invalidate bootstrap,
/// next call returns BootstrapAuthed.
class BootstrapMfaPending extends BootstrapResult {
  const BootstrapMfaPending(this.user);
  final UserInfo user;
}

class BootstrapAuthed extends BootstrapResult {
  const BootstrapAuthed(this.user);
  final UserInfo user;
}
