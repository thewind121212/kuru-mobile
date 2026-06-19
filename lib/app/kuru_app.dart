import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuru_mobile/app/router.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/app/theme/theme_mode_controller.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/core/i18n/locale_controller.dart';
import 'package:toastification/toastification.dart';

class KuruApp extends ConsumerWidget {
  const KuruApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.watch(themeControllerProvider);
    final themeMode = ref.watch(themeModeControllerProvider);
    final router = ref.watch(routerProvider);
    final locale = ref.watch(localeControllerProvider);
    return ToastificationWrapper(
      child: MaterialApp.router(
        title: 'TuiBuonBan',
        debugShowCheckedModeBanner: false,
        theme: buildKuruTheme(palette, Brightness.light),
        darkTheme: buildKuruTheme(palette, Brightness.dark),
        themeMode: themeMode,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: locale,
        routerConfig: router,
      ),
    );
  }
}
