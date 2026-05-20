import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
import 'package:kuru_mobile/core/auth/auth_providers.dart';
import 'package:kuru_mobile/core/auth/user_info.dart';
import 'package:kuru_mobile/core/feedback/k_notify.dart';
import 'package:kuru_mobile/core/network/api_exception.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/core/profile/profile_providers.dart';
import 'package:kuru_mobile/design/core/catalog/k_avatar.dart';
import 'package:kuru_mobile/design/core/feedback/k_spinner.dart';
import 'package:kuru_mobile/design/widgets/k_form_field.dart';
import 'package:kuru_mobile/design/widgets/k_primary_btn.dart';
import 'package:kuru_mobile/features/settings/sheets/avatar_picker_sheet.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});
  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _nameCtrl = TextEditingController();
  String? _nameError;
  String? _avatarStyle;
  String? _avatarSeed;
  bool _saving = false;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl.addListener(() {
      if (_nameError != null && mounted) {
        setState(() => _nameError = null);
      }
    });
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  void _hydrate(UserInfo user) {
    if (_initialized) return;
    _nameCtrl.text = user.name ?? '';
    _avatarStyle = user.avatarStyle;
    _avatarSeed = user.avatarSeed;
    _initialized = true;
  }

  Future<void> _save() async {
    final name = _nameCtrl.text.trim();
    if (name.length < 2 || name.length > 32) {
      setState(() => _nameError = 'Tên phải từ 2 đến 32 ký tự');
      return;
    }
    setState(() {
      _nameError = null;
      _saving = true;
    });
    final repo = ref.read(profileRepositoryProvider);
    final result = await repo.updateProfile(
      name: name,
      avatarStyle: _avatarStyle,
      avatarSeed: _avatarSeed,
    );
    if (!mounted) return;
    setState(() => _saving = false);
    switch (result) {
      case ApiSuccess<void>():
        KNotify.success(context, 'Đã lưu hồ sơ');
        ref.invalidate(appBootstrapProvider);
        await Navigator.of(context).maybePop();
      case ApiFailure<void>(:final err):
        if (err is BadRequestException) {
          setState(() => _nameError = err.message);
        } else {
          KNotify.networkError(context, 'Không lưu được hồ sơ', onRetry: _save);
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final bootstrap = ref.watch(appBootstrapProvider);
    final user = bootstrap.maybeWhen(
      data: (b) => b is BootstrapAuthed ? b.user : null,
      orElse: () => null,
    );
    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    _hydrate(user);
    return Scaffold(
      backgroundColor: c.pageBg,
      appBar: AppBar(
        backgroundColor: c.pageBg,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: const BackButton(),
        title: Text(
          'Hồ sơ',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: c.textPrimary,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            const SizedBox(height: 12),
            Center(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      final result = await showAvatarPickerSheet(
                        context,
                        currentName: user.name ?? '',
                        currentStyle: _avatarStyle,
                        currentSeed: _avatarSeed,
                      );
                      if (result != null) {
                        setState(() {
                          _avatarStyle = result.style;
                          _avatarSeed = result.seed;
                        });
                      }
                    },
                    child: KAvatar(
                      name: _nameCtrl.text.isEmpty
                          ? (user.name ?? '')
                          : _nameCtrl.text,
                      size: 104,
                      avatarStyle: _avatarStyle,
                      avatarSeed: _avatarSeed,
                      avatarUrl: user.avatarUrl,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Nhấn để đổi ảnh đại diện',
                    style: TextStyle(color: c.textMuted, fontSize: 13),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.email ?? '',
                    style: TextStyle(color: c.textMuted, fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            KFormField(
              controller: _nameCtrl,
              label: 'Tên hiển thị',
              errorText: _nameError,
            ),
            const SizedBox(height: 24),
            KPrimaryBtn(
              fullWidth: true,
              onPressed: _saving ? null : _save,
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
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
