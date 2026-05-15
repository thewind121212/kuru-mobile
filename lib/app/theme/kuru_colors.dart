import 'package:flutter/material.dart';

/// All design tokens for one (palette, brightness) combination.
/// Ported from design/kuru/project/kuru-theme.js.
@immutable
class KuruColors extends ThemeExtension<KuruColors> {
  const KuruColors({
    required this.pageBg,
    required this.surface,
    required this.surfaceElev,
    required this.surfaceHover,
    required this.border,
    required this.borderSoft,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.textInverse,
    required this.overlay,
    required this.primary,
    required this.primaryHover,
    required this.primarySoft,
    required this.secondary,
    required this.secondarySoft,
    required this.success,
    required this.successSoft,
    required this.warning,
    required this.warningSoft,
    required this.danger,
    required this.dangerSoft,
    required this.highlight,
    required this.accent50,
    required this.accent100,
    required this.accent200,
    required this.accent300,
    required this.accent400,
    required this.accent500,
    required this.accent600,
    required this.accent700,
    required this.accent800,
    required this.ambient1,
    required this.ambient2,
    required this.shadowSm,
    required this.shadowMd,
    required this.shadowPop,
    required this.glassTint,
  });

  final Color pageBg;
  final Color surface;
  final Color surfaceElev;
  final Color surfaceHover;
  final Color border;
  final Color borderSoft;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color textInverse;
  final Color overlay;
  final Color primary;
  final Color primaryHover;
  final Color primarySoft;
  final Color secondary;
  final Color secondarySoft;
  final Color success;
  final Color successSoft;
  final Color warning;
  final Color warningSoft;
  final Color danger;
  final Color dangerSoft;
  final Color highlight;
  final Color accent50;
  final Color accent100;
  final Color accent200;
  final Color accent300;
  final Color accent400;
  final Color accent500;
  final Color accent600;
  final Color accent700;
  final Color accent800;
  final Color ambient1;
  final Color ambient2;
  final List<BoxShadow> shadowSm;
  final List<BoxShadow> shadowMd;
  final List<BoxShadow> shadowPop;
  final Color glassTint;

  @override
  KuruColors copyWith({Color? pageBg}) {
    // Plan 1 doesn't need a real copyWith; palettes are baked constants.
    return this;
  }

  @override
  KuruColors lerp(ThemeExtension<KuruColors>? other, double t) {
    if (other is! KuruColors) return this;
    // Material transitions; we don't tween cross-palette in v1
    // (no live switcher).
    return t < 0.5 ? this : other;
  }
}

/// Convenience accessor: `kuruColors(context).primary`.
KuruColors kuruColors(BuildContext context) =>
    Theme.of(context).extension<KuruColors>()!;
