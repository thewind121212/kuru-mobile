/// Lowercase + NFD-decompose + strip combining marks + đ→d.
///
/// Ports the web FE's `normalizeForSearch`
/// (../gen-barcode/fe/src/components/category-module/MainCategory.tsx:43-51).
/// Used to make 'dien' match 'Điện tử' in category search.
String normalizeForSearch(String input) {
  final trimmed = input.trim();
  if (trimmed.isEmpty) return '';
  final lower = trimmed.toLowerCase();
  final decomposed = _toNfd(lower);
  // Strip Unicode combining marks (range U+0300-U+036F).
  final stripped = decomposed.replaceAll(RegExp(r'[̀-ͯ]'), '');
  // đ is not handled by NFD — replace explicitly.
  return stripped.replaceAll('đ', 'd');
}

/// Manual NFD decomposition for the Vietnamese-relevant precomposed
/// characters. Dart's String has no built-in NFD; this lookup covers the
/// vowels + tone marks we actually need for category-name search. ASCII
/// characters pass through unchanged.
String _toNfd(String input) {
  const table = {
    'à': 'à',
    'á': 'á',
    'ả': 'ả',
    'ã': 'ã',
    'ạ': 'ạ',
    'ă': 'ă',
    'ằ': 'ằ',
    'ắ': 'ắ',
    'ẳ': 'ẳ',
    'ẵ': 'ẵ',
    'ặ': 'ặ',
    'â': 'â',
    'ầ': 'ầ',
    'ấ': 'ấ',
    'ẩ': 'ẩ',
    'ẫ': 'ẫ',
    'ậ': 'ậ',
    'è': 'è',
    'é': 'é',
    'ẻ': 'ẻ',
    'ẽ': 'ẽ',
    'ẹ': 'ẹ',
    'ê': 'ê',
    'ề': 'ề',
    'ế': 'ế',
    'ể': 'ể',
    'ễ': 'ễ',
    'ệ': 'ệ',
    'ì': 'ì',
    'í': 'í',
    'ỉ': 'ỉ',
    'ĩ': 'ĩ',
    'ị': 'ị',
    'ò': 'ò',
    'ó': 'ó',
    'ỏ': 'ỏ',
    'õ': 'õ',
    'ọ': 'ọ',
    'ô': 'ô',
    'ồ': 'ồ',
    'ố': 'ố',
    'ổ': 'ổ',
    'ỗ': 'ỗ',
    'ộ': 'ộ',
    'ơ': 'ơ',
    'ờ': 'ờ',
    'ớ': 'ớ',
    'ở': 'ở',
    'ỡ': 'ỡ',
    'ợ': 'ợ',
    'ù': 'ù',
    'ú': 'ú',
    'ủ': 'ủ',
    'ũ': 'ũ',
    'ụ': 'ụ',
    'ư': 'ư',
    'ừ': 'ừ',
    'ứ': 'ứ',
    'ử': 'ử',
    'ữ': 'ữ',
    'ự': 'ự',
    'ỳ': 'ỳ',
    'ý': 'ý',
    'ỷ': 'ỷ',
    'ỹ': 'ỹ',
    'ỵ': 'ỵ',
  };
  final buf = StringBuffer();
  for (final ch in input.runes) {
    final s = String.fromCharCode(ch);
    buf.write(table[s] ?? s);
  }
  return buf.toString();
}
