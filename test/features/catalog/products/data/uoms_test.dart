import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/features/catalog/products/data/uoms.dart';

void main() {
  test('AVAILABLE_UOMS includes core counting units', () {
    final codes = AVAILABLE_UOMS.map((u) => u.code).toSet();
    expect(codes, containsAll(['each', 'piece', 'box', 'kg', 'g', 'l', 'm']));
  });
  test('default unit "each" exists with vi label "Cái"', () {
    final each = AVAILABLE_UOMS.firstWhere((u) => u.code == 'each');
    expect(each.labelVi, 'Cái');
    expect(each.type, 'count');
  });
  test('resolveUomLabel returns vi label for known code', () {
    expect(resolveUomLabel('kg'), 'kg');
    expect(resolveUomLabel('each'), 'Cái');
  });
  test('resolveUomLabel falls back to the code for unknown', () {
    expect(resolveUomLabel('mystery'), 'mystery');
  });
  test('uomsByType groups by type', () {
    final groups = uomsByType();
    expect(groups.keys, containsAll(['count', 'pack', 'weight', 'volume']));
  });
}
