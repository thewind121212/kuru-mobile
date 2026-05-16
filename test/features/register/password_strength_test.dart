import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/features/register/password_strength.dart';

void main() {
  group('passwordStrength', () {
    test('empty → 0 bars', () {
      expect(passwordStrength('').bars, 0);
    });

    test('len >= 8 → at least 1 bar', () {
      expect(passwordStrength('aaaaaaaa').bars, greaterThanOrEqualTo(1));
    });

    test('upper + digit → at least 2 bars', () {
      expect(passwordStrength('Aaaaaaa1').bars, greaterThanOrEqualTo(2));
    });

    test('upper + digit + symbol → at least 3 bars', () {
      expect(passwordStrength('Aaaaaaa1!').bars, greaterThanOrEqualTo(3));
    });

    test('len >= 12 + symbol + digit + upper → 4 bars', () {
      expect(passwordStrength('Aaaaaaaa1!ab').bars, 4);
    });

    test('label matches bar count', () {
      expect(passwordStrength('').label, PwLabel.weak);
      expect(passwordStrength('aaaaaaaa').label, PwLabel.weak);
      expect(passwordStrength('Aaaaaaaa1').label, PwLabel.fair);
      expect(passwordStrength('Aaaaaaa1!').label, PwLabel.good);
      expect(passwordStrength('Aaaaaaaa1!ab').label, PwLabel.strong);
    });
  });
}
