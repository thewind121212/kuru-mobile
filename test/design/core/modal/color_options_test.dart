import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/design/core/modal/color_options.dart';

void main() {
  test('kAllColors has 26 entries matching web colorOptions.ts', () {
    expect(kAllColors.length, 26);
  });

  test('kAllColors first 5 ids are the "quick" set', () {
    expect(
      kAllColors.take(5).map((c) => c.id).toList(),
      ['slate-400', 'red-400', 'orange-400', 'amber-400', 'yellow-400'],
    );
  });

  test('every entry has unique id, label, and resolved swatch', () {
    final ids = kAllColors.map((c) => c.id).toSet();
    expect(ids.length, kAllColors.length);

    for (final c in kAllColors) {
      expect(c.label, isNotEmpty);
      expect(c.swatch, isA<Color>());
    }
  });

  test('resolveColor returns null for unknown id', () {
    expect(resolveColor('not-a-color'), isNull);
  });

  test('resolveColor returns matching swatch for known id', () {
    expect(resolveColor('red-400'), const Color(0xFFF87171));
    expect(resolveColor('indigo-500'), const Color(0xFF6366F1));
  });
}
