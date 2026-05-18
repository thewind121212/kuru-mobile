import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/core/text/search_normalize.dart';

void main() {
  group('normalizeForSearch', () {
    test('lowercases and trims', () {
      expect(normalizeForSearch('  Hello  '), 'hello');
    });

    test('removes Vietnamese diacritics via NFD', () {
      expect(normalizeForSearch('Điện tử'), 'dien tu');
      expect(normalizeForSearch('Áo dài'), 'ao dai');
      expect(normalizeForSearch('cà phê'), 'ca phe');
    });

    test('handles uppercase Đ', () {
      expect(normalizeForSearch('ĐIỆN'), 'dien');
    });

    test('returns empty string for empty input', () {
      expect(normalizeForSearch(''), '');
      expect(normalizeForSearch('   '), '');
    });

    test('passes through ascii unchanged', () {
      expect(normalizeForSearch('Audio'), 'audio');
    });
  });
}
