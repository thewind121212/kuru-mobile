import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuru_mobile/core/auth/auth_providers.dart';
import 'package:kuru_mobile/core/auth/biometric_providers.dart';
import 'package:kuru_mobile/core/auth/biometric_repository.dart';
import 'package:kuru_mobile/core/feedback/k_notify.dart';
import 'package:kuru_mobile/core/network/api_exception.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/core/profile/profile_providers.dart';
import 'package:kuru_mobile/design/core/modal/k_modal_sheet.dart';
import 'package:kuru_mobile/design/widgets/k_form_field.dart';

Future<bool> showEnableBiometricSheet(BuildContext context) async {
  final ok = await showKModalSheet<bool>(
    context: context,
    title: 'Bật FaceID / Vân tay',
    builder: (sheetCtx) => const _EnableBiometricBody(),
  );
  return ok ?? false;
}

class _EnableBiometricBody extends ConsumerStatefulWidget {
  const _EnableBiometricBody();
  @override
  ConsumerState<_EnableBiometricBody> createState() =>
      _EnableBiometricBodyState();
}

class _EnableBiometricBodyState extends ConsumerState<_EnableBiometricBody> {
  final _pw = TextEditingController();
  String? _error;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _pw.addListener(() {
      if (_error != null && mounted) setState(() => _error = null);
    });
  }

  @override
  void dispose() {
    _pw.dispose();
    super.dispose();
  }

  Future<void> _confirm() async {
    final email = ref
        .read(appBootstrapProvider)
        .maybeWhen(
          data: (b) => b is BootstrapAuthed ? b.user.email : null,
          orElse: () => null,
        );
    if (email == null) return;
    setState(() => _busy = true);
    final verify = await ref
        .read(profileRepositoryProvider)
        .verifyPassword(_pw.text);
    if (!mounted) return;
    switch (verify) {
      case ApiSuccess<bool>(:final data) when data == false:
        setState(() {
          _busy = false;
          _error = 'Mật khẩu không đúng';
        });
        return;
      case ApiFailure<bool>(:final err):
        setState(() => _busy = false);
        if (err is BadRequestException) {
          setState(() => _error = err.message);
        } else {
          KNotify.networkError(
            context,
            'Không xác minh được mật khẩu',
            onRetry: _confirm,
          );
        }
        return;
      case ApiSuccess<bool>():
        break;
    }
    try {
      await ref
          .read(biometricRepositoryProvider)
          .enable(email: email, password: _pw.text);
      if (!mounted) return;
      KNotify.success(context, 'Đã bật FaceID');
      Navigator.of(context).pop(true);
    } on BiometricAuthCancelled {
      if (!mounted) return;
      setState(() => _busy = false);
      Navigator.of(context).pop(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Nhập mật khẩu để bật đăng nhập sinh trắc.'),
        const SizedBox(height: 12),
        KFormField(
          controller: _pw,
          label: 'Mật khẩu',
          obscureText: true,
          errorText: _error,
        ),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: _busy ? null : _confirm,
          child: Text(_busy ? 'Đang xác minh…' : 'Tiếp tục'),
        ),
      ],
    );
  }
}
