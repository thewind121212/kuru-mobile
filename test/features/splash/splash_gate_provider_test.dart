import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/core/auth/auth_providers.dart';
import 'package:kuru_mobile/features/splash/splash_screen.dart';

void main() {
  group('splashGateProvider', () {
    test(
      'holds for at least 800ms when bootstrap resolves instantly',
      () async {
        final container = ProviderContainer(
          overrides: [
            appBootstrapProvider.overrideWith(
              (ref) async => const BootstrapUnauthed(),
            ),
          ],
        );
        addTearDown(container.dispose);

        final start = DateTime.now();
        await container.read(splashGateProvider.future);
        final elapsed = DateTime.now().difference(start);

        expect(
          elapsed,
          greaterThanOrEqualTo(const Duration(milliseconds: 780)),
          reason: 'gate must enforce ~800ms floor (allow 20ms slack)',
        );
      },
    );

    test(
      'does not add extra delay when bootstrap already exceeds 800ms',
      () async {
        final container = ProviderContainer(
          overrides: [
            appBootstrapProvider.overrideWith((ref) async {
              await Future<void>.delayed(const Duration(milliseconds: 1100));
              return const BootstrapUnauthed();
            }),
          ],
        );
        addTearDown(container.dispose);

        final start = DateTime.now();
        await container.read(splashGateProvider.future);
        final elapsed = DateTime.now().difference(start);

        expect(
          elapsed,
          greaterThanOrEqualTo(const Duration(milliseconds: 1080)),
        );
        expect(
          elapsed,
          lessThan(const Duration(milliseconds: 1400)),
          reason: 'no significant artificial delay should be added',
        );
      },
    );

    test('propagates bootstrap errors after the floor', () async {
      final container = ProviderContainer(
        overrides: [
          appBootstrapProvider.overrideWith(
            (ref) async => throw StateError('boom'),
          ),
        ],
      );
      addTearDown(container.dispose);

      await expectLater(
        container.read(splashGateProvider.future),
        throwsA(isA<StateError>()),
      );
    });
  });
}
