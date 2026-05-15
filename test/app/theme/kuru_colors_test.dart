import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';

void main() {
  test('purple light resolves to purple light colors', () {
    final colors = KuruPalette.purple.resolve(Brightness.light);
    expect(colors.primary, const Color(0xFF9C27B0));
    expect(colors.pageBg, const Color(0xFFF5F0FA));
  });

  test('purple dark uses midnight tokens', () {
    final colors = KuruPalette.purple.resolve(Brightness.dark);
    expect(colors.primary, const Color(0xFFE040FB));
    expect(colors.pageBg, const Color(0xFF08080C));
  });

  test('indigo light uses indigo tokens', () {
    final colors = KuruPalette.indigo.resolve(Brightness.light);
    expect(colors.primary, const Color(0xFF4F46E5));
  });

  test('indigo dark synthesizes from midnight structure', () {
    final colors = KuruPalette.indigo.resolve(Brightness.dark);
    expect(colors.primary, const Color(0xFF818CF8));
    expect(colors.pageBg, const Color(0xFF080814));
  });
}
