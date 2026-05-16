/// Email format check matching the WHATWG HTML living standard for
/// `<input type="email">`. Same regex the browser uses, ported to Dart.
///
/// Reference:
///   https://html.spec.whatwg.org/multipage/input.html#valid-e-mail-address
///
/// This deliberately rejects:
/// - Empty / whitespace-only input
/// - Missing `@`, missing local part, missing domain, missing TLD
/// - Spaces anywhere
/// - Multiple `@`s
///
/// It deliberately ACCEPTS:
/// - Dots, plus tags, hyphens in the local part
/// - Subdomains (`a@mail.example.co.vn`)
/// - Digits and hyphens in the host (but not leading/trailing per RFC 1034)
///
/// Use [isValidEmail] for boolean checks; if you need a localized error
/// message, the call site is the right place to map false → "Email không
/// hợp lệ" (so we don't drag AppLocalizations into core validators).
bool isValidEmail(String input) {
  final trimmed = input.trim();
  if (trimmed.isEmpty) return false;
  // WHATWG HTML5 email regex (anchored).
  final re = RegExp(
    r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+"
    r'@'
    r'[a-zA-Z0-9]'
    r'(?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?'
    r'(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)+'
    r'$',
  );
  return re.hasMatch(trimmed);
}
