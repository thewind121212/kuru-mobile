import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/design/widgets/k_form_field.dart';

Widget wrap(Widget child, {Locale locale = const Locale('en')}) {
  return MaterialApp(
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
    home: Scaffold(body: child),
  );
}

void main() {
  group('KFormField eye toggle', () {
    testWidgets('does not render the toggle when obscureText is false', (
      tester,
    ) async {
      final controller = TextEditingController();
      await tester.pumpWidget(
        wrap(KFormField(label: 'Email', controller: controller)),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.visibility_outlined), findsNothing);
      expect(find.byIcon(Icons.visibility_off_outlined), findsNothing);
    });

    testWidgets('renders a visibility toggle when obscureText is true, '
        'initially hidden', (tester) async {
      final controller = TextEditingController();
      await tester.pumpWidget(
        wrap(
          KFormField(
            label: 'Password',
            controller: controller,
            obscureText: true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
      expect(find.byIcon(Icons.visibility_off_outlined), findsNothing);

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.obscureText, isTrue);
    });

    testWidgets('tap reveals the password and flips the icon', (tester) async {
      final controller = TextEditingController();
      await tester.pumpWidget(
        wrap(
          KFormField(
            label: 'Password',
            controller: controller,
            obscureText: true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.visibility_outlined));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
      expect(find.byIcon(Icons.visibility_outlined), findsNothing);

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.obscureText, isFalse);
    });

    testWidgets('second tap re-hides the password', (tester) async {
      final controller = TextEditingController();
      await tester.pumpWidget(
        wrap(
          KFormField(
            label: 'Password',
            controller: controller,
            obscureText: true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.visibility_outlined));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.visibility_off_outlined));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.obscureText, isTrue);
    });

    testWidgets('tooltip is localized (en: Show / Hide password)', (
      tester,
    ) async {
      final controller = TextEditingController();
      await tester.pumpWidget(
        wrap(
          KFormField(
            label: 'Password',
            controller: controller,
            obscureText: true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byTooltip('Show password'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.visibility_outlined));
      await tester.pumpAndSettle();

      expect(find.byTooltip('Hide password'), findsOneWidget);
    });

    testWidgets('tooltip is localized in vi locale', (tester) async {
      final controller = TextEditingController();
      await tester.pumpWidget(
        wrap(
          KFormField(
            label: 'Mật khẩu',
            controller: controller,
            obscureText: true,
          ),
          locale: const Locale('vi'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byTooltip('Hiện mật khẩu'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.visibility_outlined));
      await tester.pumpAndSettle();

      expect(find.byTooltip('Ẩn mật khẩu'), findsOneWidget);
    });
  });
}
