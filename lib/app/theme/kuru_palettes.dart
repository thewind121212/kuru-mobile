import 'package:flutter/material.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';

/// All 4 palettes ported from design/kuru/project/kuru-theme.js.
/// indigoDark is synthesized — kuru-theme.js only defines `indigo` light.
class KuruPalettes {
  static const purpleLight = KuruColors(
    pageBg: Color(0xFFF5F0FA),
    surface: Color(0xFFFAF7FC),
    surfaceElev: Color(0xFFFFFFFF),
    surfaceHover: Color(0xFFEDE4F5),
    border: Color(0xFFD0C0E0),
    borderSoft: Color(0xFFE5DBED),
    textPrimary: Color(0xFF1A1028),
    textSecondary: Color(0xFF554466),
    textMuted: Color(0xFF887799),
    textInverse: Color(0xFFFFFFFF),
    overlay: Color(0x4D08080C),
    primary: Color(0xFF9C27B0),
    primaryHover: Color(0xFF8520A0),
    primarySoft: Color(0x1A9C27B0),
    secondary: Color(0xFF5E35B1),
    secondarySoft: Color(0x1F5E35B1),
    success: Color(0xFF0D9488),
    successSoft: Color(0x1F0D9488),
    warning: Color(0xFFD07000),
    warningSoft: Color(0x1FD07000),
    danger: Color(0xFFC62828),
    dangerSoft: Color(0x1AC62828),
    highlight: Color(0xFFC8A600),
    accent50: Color(0xFFF8EAFB),
    accent100: Color(0xFFF1D7F7),
    accent200: Color(0xFFE8C0F3),
    accent300: Color(0xFFD99AEA),
    accent400: Color(0xFFC96DE0),
    accent500: Color(0xFFB845CB),
    accent600: Color(0xFF9C27B0),
    accent700: Color(0xFF8520A0),
    accent800: Color(0xFF68197E),
    ambient1: Color(0x299C27B0),
    ambient2: Color(0x245E35B1),
    shadowSm: [
      BoxShadow(
        color: Color(0x0F5E35B1),
        blurRadius: 2,
        offset: Offset(0, 1),
      ),
      BoxShadow(
        color: Color(0x335E35B1),
        blurRadius: 22,
        offset: Offset(0, 8),
        spreadRadius: -14,
      ),
    ],
    shadowMd: [
      BoxShadow(
        color: Color(0x2E5E35B1),
        blurRadius: 14,
        offset: Offset(0, 4),
        spreadRadius: -6,
      ),
      BoxShadow(
        color: Color(0x475E35B1),
        blurRadius: 40,
        offset: Offset(0, 16),
        spreadRadius: -22,
      ),
    ],
    shadowPop: [
      BoxShadow(
        color: Color(0x665E35B1),
        blurRadius: 50,
        offset: Offset(0, 22),
        spreadRadius: -22,
      ),
    ],
    glassTint: Color(0x8CFFFFFF),
  );

  static const purpleDark = KuruColors(
    pageBg: Color(0xFF08080C),
    surface: Color(0xFF111118),
    surfaceElev: Color(0xFF1A1A24),
    surfaceHover: Color(0xFF242432),
    border: Color(0xFF2E2E42),
    borderSoft: Color(0xFF232334),
    textPrimary: Color(0xFFE8E0F0),
    textSecondary: Color(0xFFB8AED0),
    textMuted: Color(0xFF7A7090),
    textInverse: Color(0xFF08080C),
    overlay: Color(0xA608080C),
    primary: Color(0xFFE040FB),
    primaryHover: Color(0xFFC830E0),
    primarySoft: Color(0x24E040FB),
    secondary: Color(0xFF7C4DFF),
    secondarySoft: Color(0x297C4DFF),
    success: Color(0xFF2DD4BF),
    successSoft: Color(0x242DD4BF),
    warning: Color(0xFFFF9100),
    warningSoft: Color(0x29FF9100),
    danger: Color(0xFFFF5470),
    dangerSoft: Color(0x29FF5470),
    highlight: Color(0xFFFFEA00),
    accent50: Color(0xFF310925),
    accent100: Color(0xFF6B176F),
    accent200: Color(0xFF9F23B5),
    accent300: Color(0xFFC830E0),
    accent400: Color(0xFFE040FB),
    accent500: Color(0xFFE65AFC),
    accent600: Color(0xFFEA6DFF),
    accent700: Color(0xFFE59BFF),
    accent800: Color(0xFFE9C0FD),
    ambient1: Color(0x2EE040FB),
    ambient2: Color(0x297C4DFF),
    shadowSm: [
      BoxShadow(color: Color(0x66000000), blurRadius: 2, offset: Offset(0, 1)),
      BoxShadow(
        color: Color(0x4DE040FB),
        blurRadius: 28,
        offset: Offset(0, 10),
        spreadRadius: -18,
      ),
    ],
    shadowMd: [
      BoxShadow(
        color: Color(0x80000000),
        blurRadius: 18,
        offset: Offset(0, 6),
        spreadRadius: -10,
      ),
      BoxShadow(
        color: Color(0x66E040FB),
        blurRadius: 52,
        offset: Offset(0, 22),
        spreadRadius: -28,
      ),
    ],
    shadowPop: [
      BoxShadow(
        color: Color(0x8CE040FB),
        blurRadius: 60,
        offset: Offset(0, 26),
        spreadRadius: -22,
      ),
    ],
    glassTint: Color(0x611A1A24),
  );

  static const indigoLight = KuruColors(
    pageBg: Color(0xFFF3F6FF),
    surface: Color(0xFFF8FBFF),
    surfaceElev: Color(0xFFFFFFFF),
    surfaceHover: Color(0xFFE8EFFF),
    border: Color(0xFFC8D4F4),
    borderSoft: Color(0xFFDFE6F8),
    textPrimary: Color(0xFF111827),
    textSecondary: Color(0xFF3F4D67),
    textMuted: Color(0xFF71809C),
    textInverse: Color(0xFFFFFFFF),
    overlay: Color(0x4D0F172A),
    primary: Color(0xFF4F46E5),
    primaryHover: Color(0xFF4338CA),
    primarySoft: Color(0x1A4F46E5),
    secondary: Color(0xFF2563EB),
    secondarySoft: Color(0x1F2563EB),
    success: Color(0xFF0D9488),
    successSoft: Color(0x1F0D9488),
    warning: Color(0xFFB45309),
    warningSoft: Color(0x1FB45309),
    danger: Color(0xFFB91C1C),
    dangerSoft: Color(0x1AB91C1C),
    highlight: Color(0xFFCA8A04),
    accent50: Color(0xFFEEF2FF),
    accent100: Color(0xFFE0E7FF),
    accent200: Color(0xFFC7D2FE),
    accent300: Color(0xFFA5B4FC),
    accent400: Color(0xFF818CF8),
    accent500: Color(0xFF6366F1),
    accent600: Color(0xFF4F46E5),
    accent700: Color(0xFF4338CA),
    accent800: Color(0xFF3730A3),
    ambient1: Color(0x264F46E5),
    ambient2: Color(0x212563EB),
    shadowSm: [
      BoxShadow(
        color: Color(0x0F2563EB),
        blurRadius: 2,
        offset: Offset(0, 1),
      ),
      BoxShadow(
        color: Color(0x382563EB),
        blurRadius: 22,
        offset: Offset(0, 8),
        spreadRadius: -14,
      ),
    ],
    shadowMd: [
      BoxShadow(
        color: Color(0x2E2563EB),
        blurRadius: 14,
        offset: Offset(0, 4),
        spreadRadius: -6,
      ),
      BoxShadow(
        color: Color(0x4D2563EB),
        blurRadius: 40,
        offset: Offset(0, 16),
        spreadRadius: -22,
      ),
    ],
    shadowPop: [
      BoxShadow(
        color: Color(0x6B2563EB),
        blurRadius: 50,
        offset: Offset(0, 22),
        spreadRadius: -22,
      ),
    ],
    glassTint: Color(0x8CFFFFFF),
  );

  /// Synthesized from midnight's structure with the indigo accent ramp.
  static const indigoDark = KuruColors(
    pageBg: Color(0xFF080814),
    surface: Color(0xFF11111F),
    surfaceElev: Color(0xFF1A1A2E),
    surfaceHover: Color(0xFF22223A),
    border: Color(0xFF2A2D4A),
    borderSoft: Color(0xFF20223A),
    textPrimary: Color(0xFFE0E4FF),
    textSecondary: Color(0xFFAEB3D9),
    textMuted: Color(0xFF7A809E),
    textInverse: Color(0xFF080814),
    overlay: Color(0xA608080C),
    primary: Color(0xFF818CF8),
    primaryHover: Color(0xFF6366F1),
    primarySoft: Color(0x24818CF8),
    secondary: Color(0xFF60A5FA),
    secondarySoft: Color(0x2960A5FA),
    success: Color(0xFF2DD4BF),
    successSoft: Color(0x242DD4BF),
    warning: Color(0xFFFB923C),
    warningSoft: Color(0x29FB923C),
    danger: Color(0xFFFF5470),
    dangerSoft: Color(0x29FF5470),
    highlight: Color(0xFFFACC15),
    accent50: Color(0xFF1E1B4B),
    accent100: Color(0xFF312E81),
    accent200: Color(0xFF3730A3),
    accent300: Color(0xFF4338CA),
    accent400: Color(0xFF4F46E5),
    accent500: Color(0xFF6366F1),
    accent600: Color(0xFF818CF8),
    accent700: Color(0xFFA5B4FC),
    accent800: Color(0xFFC7D2FE),
    ambient1: Color(0x2E818CF8),
    ambient2: Color(0x2960A5FA),
    shadowSm: [
      BoxShadow(color: Color(0x66000000), blurRadius: 2, offset: Offset(0, 1)),
      BoxShadow(
        color: Color(0x4D818CF8),
        blurRadius: 28,
        offset: Offset(0, 10),
        spreadRadius: -18,
      ),
    ],
    shadowMd: [
      BoxShadow(
        color: Color(0x80000000),
        blurRadius: 18,
        offset: Offset(0, 6),
        spreadRadius: -10,
      ),
      BoxShadow(
        color: Color(0x66818CF8),
        blurRadius: 52,
        offset: Offset(0, 22),
        spreadRadius: -28,
      ),
    ],
    shadowPop: [
      BoxShadow(
        color: Color(0x8C818CF8),
        blurRadius: 60,
        offset: Offset(0, 26),
        spreadRadius: -22,
      ),
    ],
    glassTint: Color(0x611A1A2E),
  );
}

/// User-selectable palette family. Brightness is decided by the platform.
enum KuruPalette { purple, indigo }

extension KuruPaletteX on KuruPalette {
  KuruColors resolve(Brightness brightness) {
    final dark = brightness == Brightness.dark;
    return switch (this) {
      KuruPalette.purple =>
        dark ? KuruPalettes.purpleDark : KuruPalettes.purpleLight,
      KuruPalette.indigo =>
        dark ? KuruPalettes.indigoDark : KuruPalettes.indigoLight,
    };
  }
}
