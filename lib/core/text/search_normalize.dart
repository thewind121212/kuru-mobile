/// Lowercase + map Vietnamese precomposed characters to their base ASCII
/// letters + đ→d.
///
/// Ports the web FE's `normalizeForSearch`
/// (../gen-barcode/fe/src/components/category-module/MainCategory.tsx:43-51).
/// Used to make 'dien' match 'Điện tử' or 'nuoc' match 'Nước' in search.
///
/// Implementation note: the original approach (NFD decompose + strip combining
/// marks U+0300-U+036F) failed because text editors save source files in NFC,
/// so the table values were precomposed chars identical to the keys — making
/// _toNfd a no-op. The fix maps each Vietnamese precomposed char directly to
/// its base ASCII letter, which is simpler and always correct.
String normalizeForSearch(String input) {
  final trimmed = input.trim();
  if (trimmed.isEmpty) return '';
  final lower = trimmed.toLowerCase();
  final buf = StringBuffer();
  for (final ch in lower.runes) {
    final s = String.fromCharCode(ch);
    buf.write(_kBaseMap[s] ?? s);
  }
  // đ is not in the map (it lowercases from Đ to đ, both outside Latin-1).
  return buf.toString().replaceAll('đ', 'd');
}

/// Maps every Vietnamese precomposed character to its base ASCII letter.
const _kBaseMap = <String, String>{
  // a-based
  'à': 'a', 'á': 'a', 'ả': 'a', 'ã': 'a', 'ạ': 'a',
  'ă': 'a', 'ằ': 'a', 'ắ': 'a', 'ẳ': 'a', 'ẵ': 'a', 'ặ': 'a',
  'â': 'a', 'ầ': 'a', 'ấ': 'a', 'ẩ': 'a', 'ẫ': 'a', 'ậ': 'a',
  // e-based
  'è': 'e', 'é': 'e', 'ẻ': 'e', 'ẽ': 'e', 'ẹ': 'e',
  'ê': 'e', 'ề': 'e', 'ế': 'e', 'ể': 'e', 'ễ': 'e', 'ệ': 'e',
  // i-based
  'ì': 'i', 'í': 'i', 'ỉ': 'i', 'ĩ': 'i', 'ị': 'i',
  // o-based
  'ò': 'o', 'ó': 'o', 'ỏ': 'o', 'õ': 'o', 'ọ': 'o',
  'ô': 'o', 'ồ': 'o', 'ố': 'o', 'ổ': 'o', 'ỗ': 'o', 'ộ': 'o',
  'ơ': 'o', 'ờ': 'o', 'ớ': 'o', 'ở': 'o', 'ỡ': 'o', 'ợ': 'o',
  // u-based
  'ù': 'u', 'ú': 'u', 'ủ': 'u', 'ũ': 'u', 'ụ': 'u',
  'ư': 'u', 'ừ': 'u', 'ứ': 'u', 'ử': 'u', 'ữ': 'u', 'ự': 'u',
  // y-based
  'ỳ': 'y', 'ý': 'y', 'ỷ': 'y', 'ỹ': 'y', 'ỵ': 'y',
};
