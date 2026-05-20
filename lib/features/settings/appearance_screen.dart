import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/core/i18n/locale_controller.dart';

class AppearanceScreen extends ConsumerWidget {
  const AppearanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = kuruColors(context);
    final palette = ref.watch(themeControllerProvider);
    final locale = ref.watch(localeControllerProvider);
    return Scaffold(
      backgroundColor: c.pageBg,
      appBar: AppBar(
        backgroundColor: c.pageBg,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: const BackButton(),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.only(bottom: 32),
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(24, 4, 24, 22),
              child: Text(
                'Giao diện',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.8,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 10),
              child: Text(
                'Màu chủ đề',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: c.textMuted,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(vertical: 18),
              decoration: BoxDecoration(
                color: c.surfaceElev,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 28,
                runSpacing: 16,
                children: [
                  for (final p in KuruPalette.values)
                    _Swatch(
                      key: ValueKey('palette.${p.name}'),
                      label: p.label,
                      color: p.resolve(Brightness.light).primary,
                      selected: palette == p,
                      onTap: () => ref
                          .read(themeControllerProvider.notifier)
                          .setPalette(p),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 10),
              child: Text(
                'Ngôn ngữ',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: c.textMuted,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: c.surfaceElev,
                borderRadius: BorderRadius.circular(18),
              ),
              clipBehavior: Clip.antiAlias,
              child: RadioGroup<String>(
                groupValue: locale.languageCode,
                onChanged: (v) {
                  if (v == null) return;
                  ref
                      .read(localeControllerProvider.notifier)
                      .setLocale(Locale(v));
                },
                child: Column(
                  children: [
                    for (final loc in LocaleController.supported)
                      RadioListTile<String>(
                        key: ValueKey('locale.${loc.languageCode}'),
                        value: loc.languageCode,
                        title: Text(
                          loc.languageCode == 'vi' ? 'Tiếng Việt' : 'English',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Swatch extends StatelessWidget {
  const _Swatch({
    required this.label,
    required this.color,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final String label;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: selected ? color : Colors.transparent,
                width: 3,
              ),
              boxShadow: [
                if (selected)
                  BoxShadow(
                    color: color.withValues(alpha: 0.35),
                    blurRadius: 10,
                  ),
              ],
            ),
            child: selected
                ? const Icon(Icons.check, color: Colors.white, size: 26)
                : null,
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: c.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
