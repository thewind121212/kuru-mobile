import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/core/auth/auth_providers.dart';
import 'package:kuru_mobile/features/expenses/expense_list_screen.dart';
import 'package:kuru_mobile/features/expenses/models/expense_category.dart';
import 'package:kuru_mobile/features/expenses/models/expense_entry.dart';
import 'package:kuru_mobile/features/expenses/models/expense_summary.dart';
import 'package:kuru_mobile/features/expenses/providers/expense_providers.dart';

void main() {
  testWidgets('ExpenseListScreen renders empty state', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          currentOrgIdProvider.overrideWithValue('org-x'),
          expenseCategoriesProvider.overrideWith(
            (ref) async => const <ExpenseCategory>[],
          ),
          expenseEntriesProvider.overrideWith(
            (ref) async => const <ExpenseEntry>[],
          ),
          expenseSummaryProvider.overrideWith(
            (ref) async => ExpenseSummary.empty(),
          ),
        ],
        child: MaterialApp(
          theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
          home: const ExpenseListScreen(),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Chi phí'), findsOneWidget);
    expect(find.text('Chưa có chi phí'), findsOneWidget);
    expect(find.text('Tổng chi trong tháng này'), findsOneWidget);
    expect(
      tester
          .widget<FilledButton>(find.widgetWithText(FilledButton, 'Thêm'))
          .onPressed,
      isNull,
    );
    expect(
      tester
          .widget<FilledButton>(
            find.widgetWithText(FilledButton, 'Thêm chi phí'),
          )
          .onPressed,
      isNull,
    );
  });

  testWidgets('ExpenseListScreen groups entries by paid date', (tester) async {
    final entries = [
      _entry(
        id: 'expense-1',
        categoryName: 'Nhập hàng',
        amount: 100000,
        paidAt: DateTime(2026, 5, 20, 10),
      ),
      _entry(
        id: 'expense-2',
        categoryName: 'Vận chuyển',
        amount: 50000,
        paidAt: DateTime(2026, 5, 20, 8),
      ),
      _entry(
        id: 'expense-3',
        categoryName: 'Mặt bằng',
        amount: 300000,
        paidAt: DateTime(2026, 5, 19, 9),
      ),
    ];

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          currentOrgIdProvider.overrideWithValue('org-x'),
          expenseCategoriesProvider.overrideWith(
            (ref) async => const <ExpenseCategory>[],
          ),
          expenseEntriesProvider.overrideWith((ref) async => entries),
          expenseSummaryProvider.overrideWith(
            (ref) async => const ExpenseSummary(
              total: 450000,
              monthTotal: 450000,
              count: 3,
            ),
          ),
        ],
        child: MaterialApp(
          theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
          home: const ExpenseListScreen(),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Biểu đồ chi theo ngày'), findsOneWidget);
    await tester.drag(find.byType(ListView), const Offset(0, -360));
    await tester.pump();

    expect(find.text('20/05/2026'), findsOneWidget);
    expect(find.text('19/05/2026'), findsOneWidget);
    expect(find.text('2 khoản chi'), findsOneWidget);
    expect(find.text('1 khoản chi'), findsOneWidget);
    expect(find.text('Nhập hàng'), findsWidgets);
    expect(find.text('Vận chuyển'), findsWidgets);
    expect(find.text('Mặt bằng'), findsWidgets);

    await tester.longPress(find.text('Vận chuyển').first);
    await tester.pump();

    expect(find.text('Xóa khoản chi?'), findsNothing);
  });

  testWidgets('ExpenseListScreen opens detail when an expense row is tapped', (
    tester,
  ) async {
    final entries = [
      _entry(
        id: 'expense-nav',
        categoryName: 'Vận chuyển',
        amount: 50000,
        paidAt: DateTime(2026, 5, 20, 8),
      ),
    ];
    final router = GoRouter(
      initialLocation: '/expenses',
      routes: [
        GoRoute(
          path: '/expenses',
          builder: (_, __) => const ExpenseListScreen(),
        ),
        GoRoute(
          path: '/expenses/:id',
          builder: (_, state) =>
              Text('expense detail ${state.pathParameters['id']}'),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          currentOrgIdProvider.overrideWithValue('org-x'),
          expenseCategoriesProvider.overrideWith(
            (ref) async => const <ExpenseCategory>[],
          ),
          expenseEntriesProvider.overrideWith((ref) async => entries),
          expenseSummaryProvider.overrideWith(
            (ref) async =>
                const ExpenseSummary(total: 50000, monthTotal: 50000, count: 1),
          ),
        ],
        child: MaterialApp.router(
          theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
          routerConfig: router,
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.drag(find.byType(ListView), const Offset(0, -360));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Vận chuyển').first);
    await tester.pumpAndSettle();

    expect(find.text('expense detail expense-nav'), findsOneWidget);
  });

  testWidgets('ExpenseListScreen excludes voided entries from totals', (
    tester,
  ) async {
    final entries = [
      _entry(
        id: 'expense-active',
        categoryName: 'Nhập hàng',
        amount: 100000,
        paidAt: DateTime(2026, 5, 20, 10),
      ),
      _entry(
        id: 'expense-voided',
        categoryName: 'Nhập hàng bị hủy',
        amount: 900000,
        paidAt: DateTime(2026, 5, 20, 11),
        voidedAt: DateTime(2026, 5, 20, 12),
        voidReason: 'Phiếu nhập đã hủy',
      ),
    ];
    final money = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: 'đ',
      decimalDigits: 0,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          currentOrgIdProvider.overrideWithValue('org-x'),
          expenseCategoriesProvider.overrideWith(
            (ref) async => const <ExpenseCategory>[],
          ),
          expenseEntriesProvider.overrideWith((ref) async => entries),
          expenseSummaryProvider.overrideWith(
            (ref) async => const ExpenseSummary(
              total: 100000,
              monthTotal: 100000,
              count: 1,
            ),
          ),
        ],
        child: MaterialApp(
          theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
          home: const ExpenseListScreen(),
        ),
      ),
    );
    await tester.pump();
    await tester.drag(find.byType(ListView), const Offset(0, -360));
    await tester.pump();

    expect(find.text('1/2 khoản đang tính'), findsOneWidget);
    expect(find.text('Đã hủy'), findsOneWidget);
    expect(find.text('Lý do hủy: Phiếu nhập đã hủy'), findsOneWidget);
    expect(find.text('-${money.format(900000)}'), findsOneWidget);
    expect(find.text('-${money.format(1000000)}'), findsNothing);
  });
}

ExpenseEntry _entry({
  required String id,
  required String categoryName,
  required int amount,
  required DateTime paidAt,
  DateTime? voidedAt,
  String? voidReason,
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
    source: 'MANUAL',
    voidedAt: voidedAt,
    voidReason: voidReason,
  );
}
