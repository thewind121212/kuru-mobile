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
        title: const Text('Giao diện'),
        backgroundColor: c.surfaceElev,
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Màu chủ đề',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: c.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 16,
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
            const SizedBox(height: 28),
            Text(
              'Ngôn ngữ',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: c.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            RadioGroup<String>(
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
                      ),
                    ),
                ],
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
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: selected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.transparent,
                width: 3,
              ),
              boxShadow: [
                BoxShadow(color: color.withValues(alpha: 0.3), blurRadius: 8),
              ],
            ),
            child: selected
                ? const Icon(Icons.check, color: Colors.white)
                : null,
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
