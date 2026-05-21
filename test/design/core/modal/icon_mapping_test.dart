import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/design/core/modal/icon_mapping.dart';

void main() {
  test('kCuratedIcons has at least 30 entries', () {
    expect(kCuratedIcons.length, greaterThanOrEqualTo(30));
  });

  test('every retail-essential name is present', () {
    const essentials = [
      'box',
      'package',
      'tag',
      'tags',
      'shopping-cart',
      'shopping-bag',
      'building-store',
      'building-warehouse',
      'truck',
      'barcode',
      'receipt',
      'wallet',
      'coins',
      'credit-card',
      'percentage',
      'scale',
      'ruler',
      'palette',
      'shirt',
      'coffee',
      'pizza',
      'apple',
      'meat',
      'bottle',
      'tool',
      'device-laptop',
      'camera',
      'book',
      'heart',
      'star',
      'layout-grid',
    ];
    for (final name in essentials) {
      expect(
        kCuratedIcons.containsKey(name),
        isTrue,
        reason: 'missing $name from kCuratedIcons',
      );
    }
  });

  test('resolveIconName returns null for unknown name', () {
    expect(resolveIconName('not-an-icon'), isNull);
  });

  test('resolveIconName returns IconData for known name', () {
    expect(resolveIconName('box'), isNotNull);
    expect(resolveIconName('layout-grid'), isNotNull);
  });

  test('searchIconsByName filters by substring case-insensitively', () {
    final results = searchIconsByName('shop');
    expect(results.length, greaterThanOrEqualTo(2));
    expect(results.every((e) => e.name.contains('shop')), isTrue);
  });

  test('searchIconsByName with empty query returns full curated set', () {
    final results = searchIconsByName('');
    expect(results.length, kCuratedIcons.length);
  });
}
