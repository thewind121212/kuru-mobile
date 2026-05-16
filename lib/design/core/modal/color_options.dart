import 'package:flutter/material.dart';

/// One color option in the K Color Picker. `id` is the persistence key
/// (kebab-case Tailwind name — matches what kuru-web sends to the BE).
class KColorOption {
  const KColorOption({
    required this.id,
    required this.label,
    required this.swatch,
  });

  final String id;
  final String label;
  final Color swatch;
}

/// 26 colors ported from `../gen-barcode/fe/src/core-design/modal/colorOptions.ts`.
/// Hex values are Tailwind v3 defaults (e.g. `bg-red-400` → `#F87171`).
/// First 5 are the "quick colors" subset.
const List<KColorOption> kAllColors = [
  KColorOption(id: 'slate-400',    label: 'Slate',         swatch: Color(0xFF94A3B8)),
  KColorOption(id: 'red-400',      label: 'Red',           swatch: Color(0xFFF87171)),
  KColorOption(id: 'orange-400',   label: 'Orange',        swatch: Color(0xFFFB923C)),
  KColorOption(id: 'amber-400',    label: 'Amber',         swatch: Color(0xFFFBBF24)),
  KColorOption(id: 'yellow-400',   label: 'Yellow',        swatch: Color(0xFFFACC15)),
  KColorOption(id: 'lime-400',     label: 'Lime',          swatch: Color(0xFFA3E635)),
  KColorOption(id: 'green-400',    label: 'Green',         swatch: Color(0xFF4ADE80)),
  KColorOption(id: 'emerald-400',  label: 'Emerald',       swatch: Color(0xFF34D399)),
  KColorOption(id: 'teal-400',     label: 'Teal',          swatch: Color(0xFF2DD4BF)),
  KColorOption(id: 'cyan-400',     label: 'Cyan',          swatch: Color(0xFF22D3EE)),
  KColorOption(id: 'sky-400',      label: 'Sky',           swatch: Color(0xFF38BDF8)),
  KColorOption(id: 'blue-400',     label: 'Blue',          swatch: Color(0xFF60A5FA)),
  KColorOption(id: 'indigo-400',   label: 'Indigo',        swatch: Color(0xFF818CF8)),
  KColorOption(id: 'violet-400',   label: 'Violet',        swatch: Color(0xFFA78BFA)),
  KColorOption(id: 'purple-400',   label: 'Purple',        swatch: Color(0xFFC084FC)),
  KColorOption(id: 'fuchsia-400',  label: 'Fuchsia',       swatch: Color(0xFFE879F9)),
  KColorOption(id: 'pink-400',     label: 'Pink',          swatch: Color(0xFFF472B6)),
  KColorOption(id: 'rose-400',     label: 'Rose',          swatch: Color(0xFFFB7185)),
  KColorOption(id: 'red-500',      label: 'Red Dark',      swatch: Color(0xFFEF4444)),
  KColorOption(id: 'orange-500',   label: 'Orange Dark',   swatch: Color(0xFFF97316)),
  KColorOption(id: 'green-500',    label: 'Green Dark',    swatch: Color(0xFF22C55E)),
  KColorOption(id: 'blue-500',     label: 'Blue Dark',     swatch: Color(0xFF3B82F6)),
  KColorOption(id: 'indigo-500',   label: 'Indigo Dark',   swatch: Color(0xFF6366F1)),
  KColorOption(id: 'purple-500',   label: 'Purple Dark',   swatch: Color(0xFFA855F7)),
  KColorOption(id: 'pink-500',     label: 'Pink Dark',     swatch: Color(0xFFEC4899)),
  KColorOption(id: 'slate-600',    label: 'Slate Dark',    swatch: Color(0xFF475569)),
];

/// Returns the swatch for [id], or null if unknown.
Color? resolveColor(String id) {
  for (final c in kAllColors) {
    if (c.id == id) return c.swatch;
  }
  return null;
}
