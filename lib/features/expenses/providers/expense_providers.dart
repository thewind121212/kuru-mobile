import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuru_mobile/core/auth/auth_providers.dart';
import 'package:kuru_mobile/core/auth/supertokens_setup.dart';
import 'package:kuru_mobile/core/env/env.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/core/network/dio_client.dart';
import 'package:kuru_mobile/features/expenses/data/expense_repository.dart';
import 'package:kuru_mobile/features/expenses/models/expense_category.dart';
import 'package:kuru_mobile/features/expenses/models/expense_entry.dart';
import 'package:kuru_mobile/features/expenses/models/expense_summary.dart';

final expenseDioProvider = Provider<Dio>((ref) {
  final shared = ref.watch(dioProvider);
  final d = Dio(shared.options.copyWith(baseUrl: '${Env.apiBaseUrl}/api/v1'));
  wireSuperTokensToDio(d);
  d.interceptors.addAll(shared.interceptors);
  return d;
});

final expenseRepositoryProvider = Provider<ExpenseRepository>((ref) {
  return ExpenseRepository(ref.watch(expenseDioProvider));
});

final expenseCategoriesProvider = FutureProvider<List<ExpenseCategory>>((
  ref,
) async {
  ref.watch(currentOrgIdProvider);
  return ref.watch(expenseRepositoryProvider).listCategories().unwrap();
});

final expenseEntriesProvider = FutureProvider<List<ExpenseEntry>>((ref) async {
  ref.watch(currentOrgIdProvider);
  return ref.watch(expenseRepositoryProvider).listEntries().unwrap();
});

final expenseSummaryProvider = FutureProvider<ExpenseSummary>((ref) async {
  ref.watch(currentOrgIdProvider);
  final now = DateTime.now();
  return ref
      .watch(expenseRepositoryProvider)
      .summaryForMonth(year: now.year, month: now.month)
      .unwrap();
});
