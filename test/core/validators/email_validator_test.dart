import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/core/validators/email_validator.dart';

void main() {
  group('isValidEmail', () {
    test('returns false for empty input', () {
      expect(isValidEmail(''), isFalse);
    });

    test('returns false for whitespace-only input', () {
      expect(isValidEmail('   '), isFalse);
    });

    test('returns false when missing @', () {
      expect(isValidEmail('alicegmail.com'), isFalse);
    });

    test('returns false when missing domain', () {
      expect(isValidEmail('alice@'), isFalse);
    });

    test('returns false when missing TLD', () {
      expect(isValidEmail('alice@gmail'), isFalse);
    });

    test('returns false when missing local part', () {
      expect(isValidEmail('@gmail.com'), isFalse);
    });

    test('returns false when contains spaces', () {
      expect(isValidEmail('alice @gmail.com'), isFalse);
      expect(isValidEmail('alice@gmail .com'), isFalse);
    });

    test('returns false with two @', () {
      expect(isValidEmail('a@b@c.com'), isFalse);
    });

    test('returns true for a plain valid email', () {
      expect(isValidEmail('alice@gmail.com'), isTrue);
    });

    test('returns true with dots in local part', () {
      expect(isValidEmail('alice.bob@gmail.com'), isTrue);
    });

    test('returns true with subdomain', () {
      expect(isValidEmail('alice@mail.simplestore.io.vn'), isTrue);
    });

    test('returns true with + tag', () {
      expect(isValidEmail('alice+work@gmail.com'), isTrue);
    });

    test('returns true with digits and hyphen in domain', () {
      expect(isValidEmail('a@store-01.vn'), isTrue);
    });

    test('trims surrounding whitespace before checking', () {
      expect(isValidEmail('  alice@gmail.com  '), isTrue);
    });
  });
}
