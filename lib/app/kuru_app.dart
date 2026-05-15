import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';

class KuruApp extends ConsumerWidget {
  const KuruApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.watch(themeControllerProvider);
    return MaterialApp(
      title: 'Kuru',
      debugShowCheckedModeBanner: false,
      theme: buildKuruTheme(palette, Brightness.light),
      darkTheme: buildKuruTheme(palette, Brightness.dark),
      themeMode: ThemeMode.system,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('vi'),
      home: const _BootPlaceholder(),
    );
  }
}

class _BootPlaceholder extends StatelessWidget {
  const _BootPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('kuru — foundation OK')),
    );
  }
}
