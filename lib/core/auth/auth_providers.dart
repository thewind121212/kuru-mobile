import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuru_mobile/core/auth/auth_repository.dart';
import 'package:kuru_mobile/core/auth/user_info.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:supertokens_flutter/supertokens.dart';

/// Currently-selected org id. Null until bootstrap completes successfully.
class CurrentOrgIdController extends Notifier<String?> {
  @override
  String? build() => null;

  String? get orgId => state;
  set orgId(String? id) => state = id;
  void clear() => state = null;
}

final currentOrgIdProvider =
    NotifierProvider<CurrentOrgIdController, String?>(
  CurrentOrgIdController.new,
);

/// Bridge to the dio client: every interceptor read reads the *current*
/// value (Riverpod handles this automatically because the dio provider
/// has access to `ref`).
final _orgIdBridgeProvider = Provider<String?>((ref) {
  return ref.watch(currentOrgIdProvider);
});

/// One-shot bootstrap: does the user have a valid session? If so, fetch
/// their orgs and pick the first one.
final appBootstrapProvider = FutureProvider<BootstrapResult>((ref) async {
  // wire the bridge first so the dio interceptor reads live state
  ref.read(_orgIdBridgeProvider);

  final hasSession = await SuperTokens.doesSessionExist();
  if (!hasSession) return const BootstrapUnauthed();

  final repo = ref.read(authRepositoryProvider);
  final result = await repo.getUserInfo();
  return switch (result) {
    ApiSuccess<UserInfo>(:final data) => () {
        // Auto-pick first org for MVP; OrgPicker comes in Plan 2.
        // Defer the state mutation to a microtask so we don't mutate another
        // provider's state during this provider's build (Riverpod logs a
        // warning otherwise and edge cases can loop).
        if (data.orgInfos.isNotEmpty) {
          Future.microtask(() {
            ref.read(currentOrgIdProvider.notifier).orgId =
                data.orgInfos.first.id;
          });
        }
        return BootstrapAuthed(data);
      }(),
      ApiFailure<UserInfo>() => const BootstrapUnauthed(),
  };
});

sealed class BootstrapResult {
  const BootstrapResult();
}

class BootstrapUnauthed extends BootstrapResult {
  const BootstrapUnauthed();
}

class BootstrapAuthed extends BootstrapResult {
  const BootstrapAuthed(this.user);
  final UserInfo user;
}
