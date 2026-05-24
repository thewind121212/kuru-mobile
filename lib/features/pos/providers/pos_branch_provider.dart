import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuru_mobile/core/auth/auth_providers.dart';
import 'package:kuru_mobile/main.dart' show sharedPrefsProvider;

const _posBranchKeyPrefix = 'kuru.pos.branch.v1';

class PosBranchController extends Notifier<String?> {
  @override
  String? build() {
    final orgId = ref.watch(currentOrgIdProvider);
    if (orgId == null) return null;
    return ref
        .read(sharedPrefsProvider)
        .getString('$_posBranchKeyPrefix.$orgId');
  }

  Future<void> setBranch(String warehouseId) async {
    final orgId = ref.read(currentOrgIdProvider);
    if (orgId == null) return;
    await ref
        .read(sharedPrefsProvider)
        .setString('$_posBranchKeyPrefix.$orgId', warehouseId);
    state = warehouseId;
  }
}

final posSelectedBranchIdProvider =
    NotifierProvider<PosBranchController, String?>(PosBranchController.new);
