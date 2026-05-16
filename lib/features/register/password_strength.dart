import 'package:flutter/material.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';

enum PwLabel { weak, fair, good, strong }

class PwStrength {
  const PwStrength({required this.bars, required this.label});
  final int bars; // 0–4
  final PwLabel label;
}

PwStrength passwordStrength(String pw) {
  if (pw.isEmpty) return const PwStrength(bars: 0, label: PwLabel.weak);
  var bars = 0;
  if (pw.length >= 8) bars++;
  final hasUpper = pw.contains(RegExp('[A-Z]'));
  final hasDigit = pw.contains(RegExp('[0-9]'));
  final hasSymbol =
      pw.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>_\-+=/\\\[\]~`]'));
  if (hasUpper && hasDigit) bars++;
  if (hasSymbol) bars++;
  if (pw.length >= 12) bars++;
  final label = switch (bars) {
    <= 1 => PwLabel.weak,
    2 => PwLabel.fair,
    3 => PwLabel.good,
    _ => PwLabel.strong,
  };
  return PwStrength(bars: bars, label: label);
}

/// Visual 4-bar meter + label + char count.
class PasswordStrengthMeter extends StatelessWidget {
  const PasswordStrengthMeter({
    required this.password,
    super.key,
    this.minChars = 8,
  });

  final String password;
  final int minChars;

  String _labelText(PwLabel l, AppLocalizations loc) => switch (l) {
        PwLabel.weak => loc.registerStrengthWeak,
        PwLabel.fair => loc.registerStrengthFair,
        PwLabel.good => loc.registerStrengthGood,
        PwLabel.strong => loc.registerStrengthStrong,
      };

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final l = AppLocalizations.of(context)!;
    final s = passwordStrength(password);
    final barColor = switch (s.label) {
      PwLabel.weak => c.danger,
      PwLabel.fair => c.warning,
      PwLabel.good => c.success,
      PwLabel.strong => c.success,
    };
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: List.generate(4, (i) {
              final on = i < s.bars;
              return Expanded(
                child: Container(
                  margin: const EdgeInsets.only(right: 4),
                  height: 4,
                  decoration: BoxDecoration(
                    color: on ? barColor : c.borderSoft,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${l.registerStrengthLabel}: ${_labelText(s.label, l)}',
                style: TextStyle(fontSize: 11, color: c.textMuted),
              ),
              Text(
                l.registerStrengthCharsCount(password.length, minChars),
                style: TextStyle(fontSize: 11, color: c.textMuted),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
