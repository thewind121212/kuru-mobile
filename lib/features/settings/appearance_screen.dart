import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/app/theme/theme_mode_controller.dart';
import 'package:kuru_mobile/core/i18n/locale_controller.dart';

class AppearanceScreen extends ConsumerWidget {
  const AppearanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = kuruColors(context);
    final palette = ref.watch(themeControllerProvider);
    final themeMode = ref.watch(themeModeControllerProvider);
    final locale = ref.watch(localeControllerProvider);
    return Scaffold(
      backgroundColor: c.pageBg,
      appBar: AppBar(
        backgroundColor: c.pageBg,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: const BackButton(),
        title: Text(
          'Giao diện',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: c.textPrimary,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.only(top: 16, bottom: 32),
          children: [
            _SectionLabel('Chế độ', c),
            _ThemeModeRow(
              current: themeMode,
              onChanged: (m) =>
                  ref.read(themeModeControllerProvider.notifier).setMode(m),
            ),
            const SizedBox(height: 28),
            _SectionLabel('Màu chủ đề', c),
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
            const SizedBox(height: 28),
            _SectionLabel('Ngôn ngữ', c),
            _LocaleGroup(
              current: locale,
              onChanged: (loc) =>
                  ref.read(localeControllerProvider.notifier).setLocale(loc),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text, this.c);
  final String text;
  final KuruColors c;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(24, 0, 24, 10),
    child: Text(
      text,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: c.textMuted,
      ),
    ),
  );
}

class _ThemeModeRow extends StatelessWidget {
  const _ThemeModeRow({required this.current, required this.onChanged});
  final ThemeMode current;
  final ValueChanged<ThemeMode> onChanged;

  static const _options = <(ThemeMode, String, IconData)>[
    (ThemeMode.system, 'Tự động', Icons.brightness_auto_outlined),
    (ThemeMode.light, 'Sáng', Icons.light_mode_outlined),
    (ThemeMode.dark, 'Tối', Icons.dark_mode_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: c.surfaceElev,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          for (final opt in _options)
            Expanded(
              child: _ThemeModeChip(
                key: ValueKey('themeMode.${opt.$1.name}'),
                label: opt.$2,
                icon: opt.$3,
                selected: current == opt.$1,
                onTap: () => onChanged(opt.$1),
              ),
            ),
        ],
      ),
    );
  }
}

class _ThemeModeChip extends StatelessWidget {
  const _ThemeModeChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
    super.key,
  });
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Material(
      color: selected ? c.primary : Colors.transparent,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 20,
                color: selected ? Colors.white : c.textPrimary,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: selected ? Colors.white : c.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LocaleGroup extends StatelessWidget {
  const _LocaleGroup({required this.current, required this.onChanged});
  final Locale? current;
  final ValueChanged<Locale?> onChanged;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    String currentKey() {
      if (current == null) return 'auto';
      return current!.languageCode;
    }

    final options = <({String key, String label, Locale? value})>[
      (key: 'auto', label: 'Tự động (theo hệ thống)', value: null),
      (key: 'vi', label: 'Tiếng Việt', value: const Locale('vi')),
      (key: 'en', label: 'English', value: const Locale('en')),
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: c.surfaceElev,
        borderRadius: BorderRadius.circular(18),
      ),
      clipBehavior: Clip.antiAlias,
      child: RadioGroup<String>(
        groupValue: currentKey(),
        onChanged: (v) {
          if (v == null) return;
          final picked = options.firstWhere((o) => o.key == v);
          onChanged(picked.value);
        },
        child: Column(
          children: [
            for (final opt in options)
              RadioListTile<String>(
                key: ValueKey('locale.${opt.key}'),
                value: opt.key,
                title: Text(
                  opt.label,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
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
