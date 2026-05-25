import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuru_mobile/core/auth/auth_providers.dart';
import 'package:kuru_mobile/core/auth/supertokens_setup.dart';
import 'package:kuru_mobile/core/env/env.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/core/network/dio_client.dart';
import 'package:kuru_mobile/features/imports/data/purchase_repository.dart';
import 'package:kuru_mobile/features/imports/models/purchase_entry.dart';
import 'package:kuru_mobile/features/imports/models/purchase_entry_status.dart';
import 'package:kuru_mobile/features/imports/models/purchase_summary.dart';

final purchaseDioProvider = Provider<Dio>((ref) {
  final shared = ref.watch(dioProvider);
  final d = Dio(shared.options.copyWith(baseUrl: '${Env.apiBaseUrl}/api/v1'));
  wireSuperTokensToDio(d);
  d.interceptors.addAll(shared.interceptors);
  return d;
});

final purchaseRepositoryProvider = Provider<PurchaseRepository>((ref) {
  return PurchaseRepository(ref.watch(purchaseDioProvider));
});

final purchaseEntriesProvider = FutureProvider<PurchaseEntryPage>((ref) async {
  ref.watch(currentOrgIdProvider);
  return ref.watch(purchaseRepositoryProvider).listEntries().unwrap();
});

final purchaseEntryDetailProvider =
    FutureProvider.family<PurchaseEntryDetail, String>((ref, id) async {
      ref.watch(currentOrgIdProvider);
      return ref.watch(purchaseRepositoryProvider).getEntryById(id).unwrap();
    });

final purchasePostedSummaryProvider = FutureProvider<PurchaseSummary>((
  ref,
) async {
  ref.watch(currentOrgIdProvider);
  return ref
      .watch(purchaseRepositoryProvider)
      .summary(status: PurchaseEntryStatus.posted)
      .unwrap();
});
