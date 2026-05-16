// The flutter_tabler_icons package exports constants in snake_case
// (e.g. `shopping_cart`), which clashes with Dart's lowerCamelCase
// convention. Suppressing the lint here keeps the IconData map readable
// while still flagging accidental snake_case in our own identifiers.
// ignore_for_file: non_constant_identifier_names
import 'package:flutter/widgets.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

/// A curated, retail-relevant icon paired with its persistence name.
class KCuratedIcon {
  const KCuratedIcon(this.name, this.icon);
  final String name;
  final IconData icon;
}

/// Stable kebab-case name → IconData. Names mirror kuru-web's
/// `iconHelpers.ts` STATIC_ICON_MAP so the BE stores the same strings
/// for both clients.
const Map<String, IconData> kCuratedIcons = {
  'box':                  TablerIcons.box,
  'package':              TablerIcons.package,
  'tag':                  TablerIcons.tag,
  'tags':                 TablerIcons.tags,
  'shopping-cart':        TablerIcons.shopping_cart,
  'shopping-bag':         TablerIcons.shopping_bag,
  'building-store':       TablerIcons.building_store,
  'building-warehouse':   TablerIcons.building_warehouse,
  'truck':                TablerIcons.truck,
  'barcode':              TablerIcons.barcode,
  'receipt':              TablerIcons.receipt,
  'wallet':               TablerIcons.wallet,
  'coins':                TablerIcons.coins,
  'credit-card':          TablerIcons.credit_card,
  'percentage':           TablerIcons.percentage,
  'scale':                TablerIcons.scale,
  'ruler':                TablerIcons.ruler,
  'palette':              TablerIcons.palette,
  'shirt':                TablerIcons.shirt,
  'coffee':               TablerIcons.coffee,
  'pizza':                TablerIcons.pizza,
  'apple':                TablerIcons.apple,
  'meat':                 TablerIcons.meat,
  'bottle':               TablerIcons.bottle,
  'tool':                 TablerIcons.tool,
  'device-laptop':        TablerIcons.device_laptop,
  'camera':               TablerIcons.camera,
  'book':                 TablerIcons.book,
  'heart':                TablerIcons.heart,
  'star':                 TablerIcons.star,
  'layout-grid':          TablerIcons.layout_grid,
};

/// Returns IconData for [name], or null if not in the curated set.
IconData? resolveIconName(String name) => kCuratedIcons[name];

/// Returns curated icons whose name contains [query] (case-insensitive).
/// Empty query returns all curated icons.
List<KCuratedIcon> searchIconsByName(String query) {
  final entries = kCuratedIcons.entries
      .map((e) => KCuratedIcon(e.key, e.value))
      .toList();
  if (query.isEmpty) return entries;
  final lower = query.toLowerCase();
  return entries.where((e) => e.name.toLowerCase().contains(lower)).toList();
}
