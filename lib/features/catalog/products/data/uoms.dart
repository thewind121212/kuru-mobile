// Ported verbatim from kuru-web's CreateProduct/constants.ts.
// Source of truth: web's hardcoded constant (no BE endpoint exposes units).

class Uom {
  const Uom({
    required this.code,
    required this.labelVi,
    required this.labelEn,
    required this.type,
  });
  final String code;
  final String labelVi;
  final String labelEn;
  final String type;
}

// Name preserved as UPPER_SNAKE_CASE to match the web source-of-truth (grep parity).
// ignore: constant_identifier_names
const List<Uom> AVAILABLE_UOMS = [
  // counting
  Uom(code: 'each', labelVi: 'Cái', labelEn: 'Each', type: 'count'),
  Uom(code: 'piece', labelVi: 'Chiếc', labelEn: 'Piece', type: 'count'),
  Uom(code: 'set', labelVi: 'Bộ', labelEn: 'Set', type: 'count'),
  Uom(code: 'pair', labelVi: 'Đôi/Cặp', labelEn: 'Pair', type: 'count'),
  Uom(code: 'doz', labelVi: 'Tá', labelEn: 'Dozen', type: 'count'),
  // packaging
  Uom(code: 'box', labelVi: 'Hộp', labelEn: 'Box', type: 'pack'),
  Uom(code: 'carton', labelVi: 'Thùng', labelEn: 'Carton', type: 'pack'),
  Uom(code: 'pack', labelVi: 'Gói', labelEn: 'Pack', type: 'pack'),
  Uom(code: 'bag', labelVi: 'Bao/Túi', labelEn: 'Bag', type: 'pack'),
  Uom(code: 'roll', labelVi: 'Cuộn', labelEn: 'Roll', type: 'pack'),
  Uom(code: 'bundle', labelVi: 'Bó', labelEn: 'Bundle', type: 'pack'),
  Uom(code: 'can', labelVi: 'Lon', labelEn: 'Can', type: 'pack'),
  Uom(code: 'bottle', labelVi: 'Chai', labelEn: 'Bottle', type: 'pack'),
  Uom(code: 'jar', labelVi: 'Hũ/Lọ', labelEn: 'Jar', type: 'pack'),
  Uom(code: 'tray', labelVi: 'Khay', labelEn: 'Tray', type: 'pack'),
  Uom(code: 'pallet', labelVi: 'Pallet', labelEn: 'Pallet', type: 'pack'),
  // weight
  Uom(code: 'mg', labelVi: 'mg', labelEn: 'Milligram', type: 'weight'),
  Uom(code: 'g', labelVi: 'g (Gam)', labelEn: 'Gram', type: 'weight'),
  Uom(code: 'kg', labelVi: 'kg', labelEn: 'Kilogram', type: 'weight'),
  Uom(code: 'ton', labelVi: 'Tấn', labelEn: 'Ton', type: 'weight'),
  // volume
  Uom(code: 'ml', labelVi: 'ml', labelEn: 'Milliliter', type: 'volume'),
  Uom(code: 'l', labelVi: 'Lít', labelEn: 'Liter', type: 'volume'),
  Uom(code: 'gal', labelVi: 'Galông', labelEn: 'Gallon', type: 'volume'),
  // length / area
  Uom(code: 'mm', labelVi: 'mm', labelEn: 'Millimeter', type: 'length'),
  Uom(code: 'cm', labelVi: 'cm', labelEn: 'Centimeter', type: 'length'),
  Uom(code: 'm', labelVi: 'Mét', labelEn: 'Meter', type: 'length'),
  Uom(code: 'm2', labelVi: 'm²', labelEn: 'Square Meter', type: 'area'),
  // pharma
  Uom(code: 'tablet', labelVi: 'Viên', labelEn: 'Tablet', type: 'count'),
  Uom(code: 'capsule', labelVi: 'Viên nang', labelEn: 'Capsule', type: 'count'),
  Uom(code: 'blister', labelVi: 'Vỉ', labelEn: 'Blister', type: 'pack'),
  Uom(code: 'ampoule', labelVi: 'Ống', labelEn: 'Ampoule', type: 'volume'),
  Uom(code: 'vial', labelVi: 'Lọ', labelEn: 'Vial', type: 'pack'),
];

String resolveUomLabel(String code) {
  for (final u in AVAILABLE_UOMS) {
    if (u.code == code) return u.labelVi;
  }
  return code;
}

Map<String, List<Uom>> uomsByType() {
  final m = <String, List<Uom>>{};
  for (final u in AVAILABLE_UOMS) {
    m.putIfAbsent(u.type, () => []).add(u);
  }
  return m;
}
