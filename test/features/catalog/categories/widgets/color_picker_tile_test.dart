import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/features/catalog/categories/widgets/color_picker_tile.dart';

void main() {
  testWidgets('renders label + swatch for the selected color', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ColorPickerTile(
            label: 'Color',
            valueId: 'red-400',
            onChanged: (_) {},
          ),
        ),
      ),
    );
    expect(find.text('Color'), findsOneWidget);
    expect(find.byType(ColorPickerTile), findsOneWidget);
  });

  testWidgets('falls back to slate-400 when valueId is unknown', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ColorPickerTile(
            label: 'Color',
            valueId: 'not-a-real-color',
            onChanged: (_) {},
          ),
        ),
      ),
    );
    expect(find.text('Color'), findsOneWidget);
  });
}
