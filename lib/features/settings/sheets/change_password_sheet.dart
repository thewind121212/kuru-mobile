import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuru_mobile/core/feedback/k_notify.dart';
import 'package:kuru_mobile/core/network/api_exception.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/core/profile/profile_providers.dart';
import 'package:kuru_mobile/design/core/modal/k_modal_sheet.dart';
import 'package:kuru_mobile/design/widgets/k_form_field.dart';

Future<void> showChangePasswordSheet(BuildContext context) {
  return showKModalSheet<void>(
    context: context,
    title: 'Đổi mật khẩu',
    builder: (sheetCtx) => const _ChangePasswordBody(),
  );
}

class _ChangePasswordBody extends ConsumerStatefulWidget {
  const _ChangePasswordBody();
  @override
  ConsumerState<_ChangePasswordBody> createState() =>
      _ChangePasswordBodyState();
}

class _ChangePasswordBodyState extends ConsumerState<_ChangePasswordBody> {
  final _old = TextEditingController();
  final _new = TextEditingController();
  final _confirm = TextEditingController();
  String? _oldError;
  String? _newError;
  String? _confirmError;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _old.addListener(() {
      if (_oldError != null && mounted) setState(() => _oldError = null);
    });
    _new.addListener(() {
      if (_newError != null && mounted) setState(() => _newError = null);
    });
    _confirm.addListener(() {
      if (_confirmError != null && mounted) {
        setState(() => _confirmError = null);
      }
    });
  }

  @override
  void dispose() {
    _old.dispose();
    _new.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _oldError = _old.text.isEmpty ? 'Bắt buộc' : null;
      _newError = _new.text.length < 8 ? 'Tối thiểu 8 ký tự' : null;
      _confirmError = _confirm.text != _new.text ? 'Mật khẩu không khớp' : null;
    });
    if (_oldError != null || _newError != null || _confirmError != null) {
      return;
    }
    setState(() => _saving = true);
    final r = await ref
        .read(profileRepositoryProvider)
        .changePassword(oldPassword: _old.text, newPassword: _new.text);
    if (!mounted) return;
    setState(() => _saving = false);
    switch (r) {
      case ApiSuccess<void>():
        KNotify.success(context, 'Đã đổi mật khẩu');
        Navigator.of(context).pop();
      case ApiFailure<void>(:final err):
        if (err is BadRequestException) {
          setState(() => _oldError = err.message);
        } else if (err is UnauthorizedException) {
          KNotify.warning(context, 'Phiên đã hết, đăng nhập lại');
        } else {
          KNotify.networkError(
            context,
            'Đổi mật khẩu thất bại',
            onRetry: _submit,
          );
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        KFormField(
          controller: _old,
          label: 'Mật khẩu hiện tại',
          obscureText: true,
          errorText: _oldError,
        ),
        const SizedBox(height: 12),
        KFormField(
          controller: _new,
          label: 'Mật khẩu mới',
          obscureText: true,
          errorText: _newError,
        ),
        const SizedBox(height: 12),
        KFormField(
          controller: _confirm,
          label: 'Xác nhận mật khẩu',
          obscureText: true,
          errorText: _confirmError,
        ),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: _saving ? null : _submit,
          child: Text(_saving ? 'Đang lưu…' : 'Lưu'),
        ),
      ],
    );
  }
}
