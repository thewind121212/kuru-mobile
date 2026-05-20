import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/core/profile/store_settings_repository.dart';
import 'package:kuru_mobile/features/settings/store_screen.dart';
import 'package:mocktail/mocktail.dart';

class _FakeRepo extends Mock implements StoreSettingsRepository {}

void main() {
  setUpAll(() {
    registerFallbackValue('');
  });

  testWidgets('shows current timezone label after load', (tester) async {
    final repo = _FakeRepo();
    when(repo.getStoreSettings).thenAnswer(
      (_) async => ApiResult.success(
        const StoreSettings(timezone: 'Asia/Ho_Chi_Minh', name: 'Tiệm'),
      ),
    );
    when(
      () => repo.updateStoreSettings(timezone: any(named: 'timezone')),
    ).thenAnswer((_) async => ApiResult.success(null));
    await tester.pumpWidget(
      ProviderScope(
        overrides: [storeSettingsRepositoryProvider.overrideWithValue(repo)],
        child: MaterialApp(
          theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
          home: const StoreScreen(),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.text('Việt Nam (GMT+7)'), findsOneWidget);
  });
}
