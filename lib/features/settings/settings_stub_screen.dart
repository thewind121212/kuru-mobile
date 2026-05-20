import 'package:flutter/material.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';

class SettingsStubScreen extends StatelessWidget {
  const SettingsStubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final l = AppLocalizations.of(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Text(
            l.settingsPlaceholder,
            style: TextStyle(fontSize: 16, color: c.textSecondary),
          ),
        ),
      ),
    );
  }
}
