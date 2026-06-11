import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/core/auth/auth_providers.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_warehouse_option.dart';
import 'package:kuru_mobile/features/catalog/products/providers/product_providers.dart';
import 'package:kuru_mobile/features/expenses/expense_detail_screen.dart';
import 'package:kuru_mobile/features/expenses/models/expense_entry.dart';
import 'package:kuru_mobile/features/expenses/providers/expense_providers.dart';

void main() {
  testWidgets('ExpenseDetailScreen opens linked import detail', (tester) async {
    final router = GoRouter(
      initialLocation: '/expenses/expense-import',
      routes: [
        GoRoute(
          path: '/expenses/:id',
          builder: (_, state) =>
              ExpenseDetailScreen(entryId: state.pathParameters['id']!),
        ),
        GoRoute(
          path: '/import/:id',
          builder: (_, state) =>
              Text('import detail ${state.pathParameters['id']}'),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          currentOrgIdProvider.overrideWithValue('org-x'),
          productWarehouseOptionsProvider.overrideWith(
            (_) async => const <ProductWarehouseOption>[],
          ),
          expenseEntryDetailProvider('expense-import').overrideWith(
            (_) async => _entry(
              id: 'expense-import',
              categoryName: 'Nhập hàng',
              amount: 250000,
              paidAt: DateTime(2026, 5, 25),
              source: 'PURCHASE_ENTRY',
              importEntryId: 'pe-1',
              importEntryNumber: 'PE-20260525-0001',
            ),
          ),
        ],
        child: MaterialApp.router(
          locale: const Locale('vi'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
          routerConfig: router,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Phiếu nhập liên quan'), findsOneWidget);
    expect(find.text('PE-20260525-0001'), findsOneWidget);

    await tester.tap(find.text('Phiếu nhập liên quan'));
    await tester.pumpAndSettle();

    expect(find.text('import detail pe-1'), findsOneWidget);
  });

  testWidgets('ExpenseDetailScreen shows auto branch scope by name', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          currentOrgIdProvider.overrideWithValue('org-x'),
          productWarehouseOptionsProvider.overrideWith(
            (_) async => const <ProductWarehouseOption>[
              ProductWarehouseOption(
                warehouseId: '2be35f86-5668-4a29-a45a-c9c268981915',
                name: 'Chi nhánh Quận 1',
              ),
            ],
          ),
          expenseEntryDetailProvider('expense-branch').overrideWith(
            (_) async => _entry(
              id: 'expense-branch',
              categoryName: 'Vận chuyển',
              amount: 80000,
              paidAt: DateTime(2026, 5, 25),
              source: 'PUSH',
              storeId: '2be35f86-5668-4a29-a45a-c9c268981915',
              scope: 'BRANCH',
            ),
          ),
        ],
        child: MaterialApp(
          locale: const Locale('vi'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
          home: const ExpenseDetailScreen(entryId: 'expense-branch'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Tự động'), findsWidgets);
    expect(find.text('Phạm vi'), findsOneWidget);
    expect(find.text('Chi nhánh Quận 1'), findsOneWidget);
    expect(find.text('Chi nhánh'), findsNothing);
    expect(find.text('2be35f86-5668-4a29-a45a-c9c268981915'), findsNothing);
  });

  testWidgets(
    'ExpenseDetailScreen uses import warehouse branch from web payload',
    (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            currentOrgIdProvider.overrideWithValue('org-x'),
            productWarehouseOptionsProvider.overrideWith(
              (_) async => const <ProductWarehouseOption>[
                ProductWarehouseOption(
                  warehouseId: '2be35f86-5668-4a29-a45a-c9c268981915',
                  name: 'Chi nhánh lookup should not win',
                ),
              ],
            ),
            expenseEntryDetailProvider('expense-import-branch').overrideWith(
              (_) async => _entry(
                id: 'expense-import-branch',
                categoryName: 'Nhập hàng',
                amount: 180000,
                paidAt: DateTime(2026, 5, 25),
                source: 'PUSHED',
                storeId: '2be35f86-5668-4a29-a45a-c9c268981915',
                storeName: 'Kho fallback',
                scope: 'ORG',
                linkedPurchaseEntries: const <ExpenseLinkedPurchaseEntry>[
                  ExpenseLinkedPurchaseEntry(
                    id: 'pe-1',
                    entryNumber: 'PE-20260525-0001',
                    warehouses: <ExpenseLinkedWarehouse>[
                      ExpenseLinkedWarehouse(
                        id: '2be35f86-5668-4a29-a45a-c9c268981915',
                        name: 'Chi nhánh Quận 1',
                      ),
                      ExpenseLinkedWarehouse(
                        id: 'warehouse-2',
                        name: 'Chi nhánh Quận 3',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
          child: MaterialApp(
            locale: const Locale('vi'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
            home: const ExpenseDetailScreen(entryId: 'expense-import-branch'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Tự động'), findsWidgets);
      expect(find.text('Phạm vi'), findsOneWidget);
      expect(find.text('Chi nhánh Quận 1 +1'), findsOneWidget);
      expect(find.text('Chi nhánh lookup should not win'), findsNothing);
      expect(find.text('Kho fallback'), findsNothing);
      expect(find.text('2be35f86-5668-4a29-a45a-c9c268981915'), findsNothing);
    },
  );

  testWidgets('ExpenseDetailScreen does not fake branch name from id only', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          currentOrgIdProvider.overrideWithValue('org-x'),
          productWarehouseOptionsProvider.overrideWith(
            (_) async => const <ProductWarehouseOption>[],
          ),
          expenseEntryDetailProvider('expense-branch-id').overrideWith(
            (_) async => _entry(
              id: 'expense-branch-id',
              categoryName: 'Vận chuyển',
              amount: 80000,
              paidAt: DateTime(2026, 5, 25),
              source: 'PUSH',
              storeId: '2be35f86-5668-4a29-a45a-c9c268981915',
              scope: 'BRANCH',
            ),
          ),
        ],
        child: MaterialApp(
          locale: const Locale('vi'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
          home: const ExpenseDetailScreen(entryId: 'expense-branch-id'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Phạm vi'), findsOneWidget);
    expect(find.text('Chưa có tên'), findsOneWidget);
    expect(find.text('Chi nhánh'), findsNothing);
    expect(find.text('2be35f86-5668-4a29-a45a-c9c268981915'), findsNothing);
  });

  testWidgets('ExpenseDetailScreen shows manual org-wide scope', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          currentOrgIdProvider.overrideWithValue('org-x'),
          productWarehouseOptionsProvider.overrideWith(
            (_) async => const <ProductWarehouseOption>[],
          ),
          expenseEntryDetailProvider('expense-org').overrideWith(
            (_) async => _entry(
              id: 'expense-org',
              categoryName: 'Mặt bằng',
              amount: 400000,
              paidAt: DateTime(2026, 5, 25),
              source: 'MANUAL',
              scope: 'ORG',
            ),
          ),
        ],
        child: MaterialApp(
          locale: const Locale('vi'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
          home: const ExpenseDetailScreen(entryId: 'expense-org'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Thủ công'), findsWidgets);
    expect(find.text('Phạm vi'), findsOneWidget);
    expect(find.text('Toàn tổ chức'), findsOneWidget);
  });
}

ExpenseEntry _entry({
  required String id,
  required String categoryName,
  required int amount,
  required DateTime paidAt,
  required String source,
  String? storeId,
  String? storeName,
  String? scope,
  String? importEntryId,
  String? importEntryNumber,
  List<ExpenseLinkedPurchaseEntry> linkedPurchaseEntries = const [],
}) {
  return ExpenseEntry(
    id: id,
    orgId: 'org-x',
    categoryId: 'category-$id',
    categoryName: categoryName,
    amount: amount,
    paidAt: paidAt,
    isDelete: false,
    createdBy: 'tester',
    createdAt: paidAt,
    updatedAt: paidAt,
    source: source,
    storeId: storeId,
    storeName: storeName,
    scope: scope,
    importEntryId: importEntryId,
    importEntryNumber: importEntryNumber,
    linkedPurchaseEntries: linkedPurchaseEntries,
  );
}
