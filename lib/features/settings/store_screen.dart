import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
import 'package:kuru_mobile/core/feedback/k_notify.dart';
import 'package:kuru_mobile/core/network/api_exception.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/core/profile/store_settings_repository.dart';
import 'package:kuru_mobile/design/core/catalog/k_settings_row.dart';
import 'package:kuru_mobile/design/core/feedback/k_spinner.dart';
import 'package:kuru_mobile/design/widgets/k_primary_btn.dart';
import 'package:kuru_mobile/features/settings/sheets/timezone_picker_sheet.dart';

class StoreScreen extends ConsumerStatefulWidget {
  const StoreScreen({super.key});
  @override
  ConsumerState<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends ConsumerState<StoreScreen> {
  StoreSettings? _settings;
  String? _selectedTz;
  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final repo = ref.read(storeSettingsRepositoryProvider);
    final r = await repo.getStoreSettings();
    if (!mounted) return;
    switch (r) {
      case ApiSuccess<StoreSettings>(:final data):
        setState(() {
          _settings = data;
          _selectedTz = data.timezone;
          _loading = false;
        });
      case ApiFailure<StoreSettings>():
        setState(() => _loading = false);
        KNotify.networkError(
          context,
          'Không tải được thiết lập cửa hàng',
          onRetry: _load,
        );
    }
  }

  Future<void> _save() async {
    final tz = _selectedTz;
    if (tz == null) return;
    setState(() => _saving = true);
    final repo = ref.read(storeSettingsRepositoryProvider);
    final r = await repo.updateStoreSettings(timezone: tz);
    if (!mounted) return;
    setState(() => _saving = false);
    switch (r) {
      case ApiSuccess<void>():
        KNotify.success(context, 'Đã lưu múi giờ');
        await Navigator.of(context).maybePop();
      case ApiFailure<void>(:final err):
        if (err is BadRequestException) {
          KNotify.warning(context, err.message);
        } else {
          KNotify.networkError(context, 'Lưu thất bại', onRetry: _save);
        }
    }
  }

  String _labelFor(String tz) {
    for (final entry in kCuratedTimezones) {
      if (entry.id == tz) return entry.label;
    }
    return tz;
  }

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    if (_loading) {
      return Scaffold(
        backgroundColor: c.pageBg,
        appBar: AppBar(
          title: const Text('Cửa hàng'),
          backgroundColor: c.surfaceElev,
          elevation: 0,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    final tzLabel = _selectedTz == null ? '' : _labelFor(_selectedTz!);
    return Scaffold(
      backgroundColor: c.pageBg,
      appBar: AppBar(
        title: const Text('Cửa hàng'),
        backgroundColor: c.surfaceElev,
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: KSettingsRow(
                leadingIcon: Icons.public,
                iconBackground: const Color(0xFFEDE9FE),
                iconColor: const Color(0xFF6D28D9),
                label: 'Múi giờ',
                trailingText: tzLabel,
                onTap: () async {
                  final tz = await showTimezonePickerSheet(
                    context,
                    current: _selectedTz ?? '',
                  );
                  if (tz != null) setState(() => _selectedTz = tz);
                },
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: KPrimaryBtn(
                fullWidth: true,
                onPressed:
                    _saving ||
                        _selectedTz == null ||
                        _selectedTz == _settings?.timezone
                    ? null
                    : _save,
                child: _saving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: KSpinner(color: Colors.white),
                      )
                    : const Text(
                        'Lưu',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
