import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuru_mobile/core/auth/auth_providers.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/features/pos/data/pos_customer_display_repository.dart';
import 'package:kuru_mobile/main.dart' show sharedPrefsProvider;
import 'package:uuid/uuid.dart';

const _posTerminalKeyPrefix = 'kuru.pos.terminal.v1';

final posDisplaySessionIdProvider = Provider<String>((ref) {
  return const Uuid().v4();
});

class PosTerminalController extends FamilyNotifier<String?, String> {
  @override
  String? build(String branchId) {
    final orgId = ref.watch(currentOrgIdProvider);
    if (orgId == null || branchId.trim().isEmpty) return null;
    return ref
        .read(sharedPrefsProvider)
        .getString('$_posTerminalKeyPrefix.$orgId.$branchId');
  }

  Future<void> setTerminal(String terminalId) async {
    final orgId = ref.read(currentOrgIdProvider);
    final branchId = arg.trim();
    if (orgId == null || branchId.isEmpty) return;
    await ref
        .read(sharedPrefsProvider)
        .setString('$_posTerminalKeyPrefix.$orgId.$branchId', terminalId);
    state = terminalId;
  }
}

final posSelectedTerminalIdProvider =
    NotifierProviderFamily<PosTerminalController, String?, String>(
      PosTerminalController.new,
    );

final posDisplayTerminalsProvider =
    FutureProvider.family<List<PosDisplayTerminal>, String>((ref, branchId) {
      ref.watch(currentOrgIdProvider);
      final repo = ref.watch(posCustomerDisplayRepositoryProvider);
      return repo.listTerminals(storeId: branchId).unwrap();
    });

final posPairedDisplaysProvider =
    FutureProvider.family<List<PosPairedDisplay>, String>((ref, branchId) {
      ref.watch(currentOrgIdProvider);
      final repo = ref.watch(posCustomerDisplayRepositoryProvider);
      return repo.listPairedDisplays(storeId: branchId).unwrap();
    });
