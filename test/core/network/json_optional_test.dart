import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/core/network/json_optional.dart';

void main() {
  group('JsonOptional', () {
    test('set holds value', () {
      const opt = JsonOptional.set('hello');
      expect(opt.isSet, true);
      expect(opt.value, 'hello');
    });
    test('clear has null value but is set', () {
      const opt = JsonOptional<String>.clear();
      expect(opt.isSet, true);
      expect(opt.value, isNull);
    });

    test('writeTo includes key for set value', () {
      final m = <String, dynamic>{};
      const JsonOptional.set('x').writeTo(m, 'name');
      expect(m, {'name': 'x'});
    });
    test('writeTo writes explicit null for clear', () {
      final m = <String, dynamic>{};
      const JsonOptional<String>.clear().writeTo(m, 'name');
      expect(m.containsKey('name'), true);
      expect(m['name'], isNull);
    });
    test('null Optional omits the key entirely', () {
      final m = <String, dynamic>{};
      JsonOptional.writeIfPresent<String>(m, 'name', null);
      expect(m.containsKey('name'), false);
    });
  });
}
