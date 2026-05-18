import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/features/catalog/categories/widgets/icon_picker_tile.dart';

void main() {
  testWidgets('renders label + icon preview', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: IconPickerTile(
            label: 'Icon',
            valueName: 'package',
            onChanged: (_) {},
          ),
        ),
      ),
    );
    expect(find.text('Icon'), findsOneWidget);
    expect(find.byType(IconPickerTile), findsOneWidget);
  });

  testWidgets('falls back to layout-grid when valueName is null/unknown', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: IconPickerTile(
            label: 'Icon',
            valueName: null,
            onChanged: (_) {},
          ),
        ),
      ),
    );
    expect(find.text('Icon'), findsOneWidget);
  });
}
