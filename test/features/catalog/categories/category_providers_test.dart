import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_category_api/kuru_category_api.dart' as gen;
import 'package:kuru_mobile/core/network/dio_client.dart';
import 'package:kuru_mobile/features/catalog/categories/providers/category_providers.dart';

void main() {
  test('categoryApiClientProvider builds CategoryApi', () {
    final container = ProviderContainer(
      overrides: [
        dioProvider.overrideWithValue(Dio(BaseOptions(baseUrl: 'http://host'))),
      ],
    );
    addTearDown(container.dispose);

    final api = container.read(categoryApiClientProvider);
    expect(api, isA<gen.CategoryApi>());
  });
}
