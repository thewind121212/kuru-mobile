import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/features/catalog/products/widgets/category_brand_picker_sheet.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
    theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
    home: Scaffold(body: child),
  );

  testWidgets('filters list as user types', (t) async {
    final items = [
      const PickerItem(id: 'c-1', name: 'Đồ uống'),
      const PickerItem(id: 'c-2', name: 'Đồ ăn'),
      const PickerItem(id: 'c-3', name: 'Văn phòng phẩm'),
    ];
    await t.pumpWidget(
      wrap(
        CategoryBrandPickerSheetBody(
          title: 'Chọn danh mục',
          items: items,
          selectedId: null,
        ),
      ),
    );
    expect(find.text('Đồ uống'), findsOneWidget);
    expect(find.text('Văn phòng phẩm'), findsOneWidget);

    await t.enterText(find.byType(TextField), 'văn');
    await t.pump();

    expect(find.text('Đồ uống'), findsNothing);
    expect(find.text('Văn phòng phẩm'), findsOneWidget);
  });

  testWidgets('empty filter result shows "Không tìm thấy"', (t) async {
    await t.pumpWidget(
      wrap(
        const CategoryBrandPickerSheetBody(
          title: 'X',
          items: [PickerItem(id: '1', name: 'A')],
          selectedId: null,
        ),
      ),
    );
    await t.enterText(find.byType(TextField), 'zzz');
    await t.pump();
    expect(find.text('Không tìm thấy'), findsOneWidget);
  });

  testWidgets('Bỏ chọn row is always present at top', (t) async {
    await t.pumpWidget(
      wrap(
        const CategoryBrandPickerSheetBody(
          title: 'X',
          items: [],
          selectedId: 'whatever',
        ),
      ),
    );
    expect(find.text('Bỏ chọn'), findsOneWidget);
  });
}
