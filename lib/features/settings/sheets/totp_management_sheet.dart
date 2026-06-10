import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
import 'package:kuru_mobile/core/feedback/k_notify.dart';
import 'package:kuru_mobile/core/network/api_exception.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/core/profile/profile_providers.dart';
import 'package:kuru_mobile/core/profile/profile_repository.dart';
import 'package:kuru_mobile/core/profile/security_status.dart';
import 'package:kuru_mobile/design/core/feedback/k_badge.dart';
import 'package:kuru_mobile/design/core/input/k_danger_btn.dart';
import 'package:kuru_mobile/design/core/input/k_secondary_btn.dart';
import 'package:kuru_mobile/design/core/modal/k_modal_sheet.dart';
import 'package:kuru_mobile/design/widgets/k_form_field.dart';

enum _TotpFlow { idle, enablePassword, qr, recovery, disable, regenerate }

Future<void> showTotpManagementSheet(BuildContext context) {
  return showKModalSheet<void>(
    context: context,
    title: 'Xác thực 2 lớp',
    builder: (_) => const _TotpManagementBody(),
  );
}

class _TotpManagementBody extends ConsumerStatefulWidget {
  const _TotpManagementBody();

  @override
  ConsumerState<_TotpManagementBody> createState() =>
      _TotpManagementBodyState();
}

class _TotpManagementBodyState extends ConsumerState<_TotpManagementBody> {
  final _enablePassword = TextEditingController();
  final _setupCode = TextEditingController();
  final _disablePassword = TextEditingController();
  final _disableCode = TextEditingController();
  final _regenPassword = TextEditingController();

  _TotpFlow _flow = _TotpFlow.idle;
  TotpDeviceSetup? _setup;
  List<String> _recoveryCodes = const [];
  bool _recoveryFromRegenerate = false;
  bool _busy = false;

  String? _enablePasswordError;
  String? _setupCodeError;
  String? _disablePasswordError;
  String? _disableCodeError;
  String? _regenPasswordError;

  @override
  void initState() {
    super.initState();
    _enablePassword.addListener(() {
      if (_enablePasswordError != null && mounted) {
        setState(() => _enablePasswordError = null);
      }
    });
    _setupCode.addListener(() {
      if (_setupCodeError != null && mounted) {
        setState(() => _setupCodeError = null);
      }
    });
    _disablePassword.addListener(() {
      if (_disablePasswordError != null && mounted) {
        setState(() => _disablePasswordError = null);
      }
    });
    _disableCode.addListener(() {
      if (_disableCodeError != null && mounted) {
        setState(() => _disableCodeError = null);
      }
    });
    _regenPassword.addListener(() {
      if (_regenPasswordError != null && mounted) {
        setState(() => _regenPasswordError = null);
      }
    });
  }

  @override
  void dispose() {
    _enablePassword.dispose();
    _setupCode.dispose();
    _disablePassword.dispose();
    _disableCode.dispose();
    _regenPassword.dispose();
    super.dispose();
  }

  ProfileRepository get _repo => ref.read(profileRepositoryProvider);

  void _resetFlow() {
    setState(() {
      _flow = _TotpFlow.idle;
      _setup = null;
      _recoveryCodes = const [];
      _recoveryFromRegenerate = false;
      _busy = false;
      _enablePassword.clear();
      _setupCode.clear();
      _disablePassword.clear();
      _disableCode.clear();
      _regenPassword.clear();
      _enablePasswordError = null;
      _setupCodeError = null;
      _disablePasswordError = null;
      _disableCodeError = null;
      _regenPasswordError = null;
    });
  }

  Future<void> _createDevice() async {
    final password = _enablePassword.text;
    setState(() {
      _enablePasswordError = password.isEmpty ? 'Nhập mật khẩu' : null;
    });
    if (_enablePasswordError != null) return;

    setState(() => _busy = true);
    final result = await _repo.createTotpDevice(password: password);
    if (!mounted) return;
    setState(() => _busy = false);

    switch (result) {
      case ApiSuccess<TotpDeviceSetup>(:final data):
        if (data.deviceName.isEmpty ||
            data.secret.isEmpty ||
            data.qrCodeString.isEmpty) {
          KNotify.warning(context, 'Không tạo được mã QR. Thử lại.');
          return;
        }
        setState(() {
          _setup = data;
          _enablePassword.clear();
          _flow = _TotpFlow.qr;
        });
      case ApiFailure<TotpDeviceSetup>(:final err):
        setState(() => _enablePasswordError = _credentialMessage(err));
    }
  }

  Future<void> _verifyDevice() async {
    final setup = _setup;
    if (setup == null) return;
    final code = _setupCode.text.trim();
    setState(() {
      _setupCodeError = code.length != 6 ? 'Nhập mã 6 chữ số' : null;
    });
    if (_setupCodeError != null) return;

    setState(() => _busy = true);
    final result = await _repo.verifyTotpDevice(
      deviceName: setup.deviceName,
      code: code,
    );
    if (!mounted) return;
    setState(() => _busy = false);

    switch (result) {
      case ApiSuccess<TotpDeviceVerification>(:final data):
        if (!data.verified) {
          setState(() => _setupCodeError = 'Mã xác thực không đúng');
          return;
        }
        if (data.recoveryCodes.isEmpty) {
          KNotify.warning(
            context,
            '2FA đã bật nhưng chưa có mã khôi phục. Hãy tạo lại mã.',
          );
          ref.invalidate(securityStatusProvider);
          _resetFlow();
          return;
        }
        setState(() {
          _setupCode.clear();
          _recoveryCodes = data.recoveryCodes;
          _recoveryFromRegenerate = false;
          _flow = _TotpFlow.recovery;
        });
      case ApiFailure<TotpDeviceVerification>(:final err):
        setState(() => _setupCodeError = _credentialMessage(err));
    }
  }

  Future<void> _disableTotp() async {
    final password = _disablePassword.text;
    final code = _disableCode.text.trim();
    setState(() {
      _disablePasswordError = password.isEmpty ? 'Nhập mật khẩu' : null;
      _disableCodeError = code.length != 6 ? 'Nhập mã 6 chữ số' : null;
    });
    if (_disablePasswordError != null || _disableCodeError != null) return;

    setState(() => _busy = true);
    final result = await _repo.disableTotp(password: password, totpCode: code);
    if (!mounted) return;
    setState(() => _busy = false);

    switch (result) {
      case ApiSuccess<void>():
        KNotify.success(context, 'Đã tắt 2FA');
        ref.invalidate(securityStatusProvider);
        _resetFlow();
      case ApiFailure<void>(:final err):
        final message = _credentialMessage(err);
        if (_looksLikeCodeError(err)) {
          setState(() => _disableCodeError = message);
        } else {
          setState(() => _disablePasswordError = message);
        }
    }
  }

  Future<void> _regenerateCodes() async {
    final password = _regenPassword.text;
    setState(() {
      _regenPasswordError = password.isEmpty ? 'Nhập mật khẩu' : null;
    });
    if (_regenPasswordError != null) return;

    setState(() => _busy = true);
    final result = await _repo.regenerateRecoveryCodes(password: password);
    if (!mounted) return;
    setState(() => _busy = false);

    switch (result) {
      case ApiSuccess<List<String>>(:final data):
        if (data.isEmpty) {
          KNotify.warning(context, 'Không nhận được mã khôi phục mới');
          return;
        }
        setState(() {
          _regenPassword.clear();
          _recoveryCodes = data;
          _recoveryFromRegenerate = true;
          _flow = _TotpFlow.recovery;
        });
      case ApiFailure<List<String>>(:final err):
        setState(() => _regenPasswordError = _credentialMessage(err));
    }
  }

  Future<void> _copyRecoveryCodes() async {
    await Clipboard.setData(ClipboardData(text: _recoveryCodes.join('\n')));
    if (!mounted) return;
    KNotify.success(context, 'Đã sao chép mã khôi phục');
  }

  void _finishRecovery() {
    final message = _recoveryFromRegenerate
        ? 'Đã tạo mã khôi phục mới'
        : 'Đã bật 2FA';
    ref.invalidate(securityStatusProvider);
    _resetFlow();
    KNotify.success(context, message);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 180),
      child: switch (_flow) {
        _TotpFlow.idle => _IdleView(
          key: const ValueKey('idle'),
          status: ref.watch(securityStatusProvider),
          onEnable: () => setState(() => _flow = _TotpFlow.enablePassword),
          onDisable: () => setState(() => _flow = _TotpFlow.disable),
          onRegenerate: () => setState(() => _flow = _TotpFlow.regenerate),
          onRetry: () => ref.invalidate(securityStatusProvider),
        ),
        _TotpFlow.enablePassword => _PasswordStep(
          key: const ValueKey('enable-password'),
          title: 'Xác nhận mật khẩu',
          description: 'Nhập mật khẩu để tạo thiết bị xác thực mới.',
          controller: _enablePassword,
          errorText: _enablePasswordError,
          busy: _busy,
          primaryLabel: 'Tiếp tục',
          onSubmit: _createDevice,
          onCancel: _resetFlow,
        ),
        _TotpFlow.qr => _QrStep(
          key: const ValueKey('qr'),
          setup: _setup!,
          codeController: _setupCode,
          codeError: _setupCodeError,
          busy: _busy,
          onSubmit: _verifyDevice,
          onCancel: _resetFlow,
        ),
        _TotpFlow.recovery => _RecoveryCodesStep(
          key: const ValueKey('recovery'),
          codes: _recoveryCodes,
          regenerate: _recoveryFromRegenerate,
          onCopy: _copyRecoveryCodes,
          onDone: _finishRecovery,
        ),
        _TotpFlow.disable => _DisableStep(
          key: const ValueKey('disable'),
          passwordController: _disablePassword,
          codeController: _disableCode,
          passwordError: _disablePasswordError,
          codeError: _disableCodeError,
          busy: _busy,
          onSubmit: _disableTotp,
          onCancel: _resetFlow,
        ),
        _TotpFlow.regenerate => _PasswordStep(
          key: const ValueKey('regenerate'),
          title: 'Tạo lại mã khôi phục',
          description:
              'Nhập mật khẩu để tạo bộ mã khôi phục mới. '
              'Bộ mã cũ sẽ hết hiệu lực.',
          controller: _regenPassword,
          errorText: _regenPasswordError,
          busy: _busy,
          primaryLabel: 'Tạo mã mới',
          onSubmit: _regenerateCodes,
          onCancel: _resetFlow,
        ),
      },
    );
  }
}

class _IdleView extends StatelessWidget {
  const _IdleView({
    required this.status,
    required this.onEnable,
    required this.onDisable,
    required this.onRegenerate,
    required this.onRetry,
    super.key,
  });

  final AsyncValue<SecurityStatus> status;
  final VoidCallback onEnable;
  final VoidCallback onDisable;
  final VoidCallback onRegenerate;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return status.when(
      data: (data) => _IdleStatus(
        status: data,
        onEnable: onEnable,
        onDisable: onDisable,
        onRegenerate: onRegenerate,
      ),
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => _ErrorState(onRetry: onRetry),
    );
  }
}

class _IdleStatus extends StatelessWidget {
  const _IdleStatus({
    required this.status,
    required this.onEnable,
    required this.onDisable,
    required this.onRegenerate,
  });

  final SecurityStatus status;
  final VoidCallback onEnable;
  final VoidCallback onDisable;
  final VoidCallback onRegenerate;

  @override
  Widget build(BuildContext context) {
    final enabled = status.totpEnabled;
    final c = kuruColors(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _StatusCard(status: status),
        const SizedBox(height: 14),
        Text(
          enabled
              ? 'Tài khoản đang được bảo vệ bằng ứng dụng xác thực.'
              : 'Bật 2FA để yêu cầu mã từ ứng dụng xác thực sau khi đăng nhập.',
          style: TextStyle(
            color: c.textMuted,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            height: 1.35,
          ),
        ),
        const SizedBox(height: 14),
        if (enabled) ...[
          Row(
            children: [
              Expanded(
                child: KSecondaryBtn(
                  label: 'Tạo lại mã',
                  size: KBtnSize.md,
                  onPressed: onRegenerate,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: KDangerBtn(
                  label: 'Tắt 2FA',
                  size: KBtnSize.md,
                  onPressed: onDisable,
                ),
              ),
            ],
          ),
        ] else
          FilledButton.icon(
            onPressed: onEnable,
            icon: const Icon(Icons.shield_outlined),
            label: const Text('Bật 2FA'),
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(46),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
      ],
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.status});

  final SecurityStatus status;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final enabled = status.totpEnabled;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: c.surfaceElev,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: c.borderSoft),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: enabled ? c.successSoft : c.surfaceHover,
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: Icon(
              enabled ? Icons.shield_outlined : Icons.shield_outlined,
              color: enabled ? c.success : c.textMuted,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Xác thực 2 lớp',
                        style: TextStyle(
                          color: c.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    KBadge(
                      label: enabled ? 'Bật' : 'Tắt',
                      tone: enabled ? KBadgeTone.success : KBadgeTone.neutral,
                    ),
                  ],
                ),
                if (enabled) ...[
                  const SizedBox(height: 3),
                  Text(
                    'Còn ${status.recoveryCodesRemaining} mã khôi phục',
                    style: TextStyle(
                      color: c.textMuted,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PasswordStep extends StatelessWidget {
  const _PasswordStep({
    required this.title,
    required this.description,
    required this.controller,
    required this.errorText,
    required this.busy,
    required this.primaryLabel,
    required this.onSubmit,
    required this.onCancel,
    super.key,
  });

  final String title;
  final String description;
  final TextEditingController controller;
  final String? errorText;
  final bool busy;
  final String primaryLabel;
  final VoidCallback onSubmit;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _StepHeader(title: title, description: description),
        const SizedBox(height: 14),
        KFormField(
          controller: controller,
          label: 'Mật khẩu',
          obscureText: true,
          errorText: errorText,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => busy ? null : onSubmit(),
        ),
        const SizedBox(height: 16),
        _ButtonRow(
          busy: busy,
          primaryLabel: primaryLabel,
          primaryColor: c.accent600,
          onPrimary: onSubmit,
          onCancel: onCancel,
        ),
      ],
    );
  }
}

class _QrStep extends StatelessWidget {
  const _QrStep({
    required this.setup,
    required this.codeController,
    required this.codeError,
    required this.busy,
    required this.onSubmit,
    required this.onCancel,
    super.key,
  });

  final TotpDeviceSetup setup;
  final TextEditingController codeController;
  final String? codeError;
  final bool busy;
  final VoidCallback onSubmit;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _StepHeader(
          title: 'Quét mã QR',
          description:
              'Dùng Google Authenticator, 1Password, Authy '
              'hoặc ứng dụng tương tự.',
        ),
        const SizedBox(height: 14),
        Center(
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: c.borderSoft),
            ),
            child: BarcodeWidget(
              barcode: Barcode.qrCode(),
              data: setup.qrCodeString,
              width: 180,
              height: 180,
              drawText: false,
              errorBuilder: (_, __) => const SizedBox(
                width: 180,
                height: 180,
                child: Center(child: Icon(Icons.qr_code_2, size: 48)),
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),
        _SecretBox(secret: setup.secret),
        const SizedBox(height: 14),
        _OtpField(
          controller: codeController,
          label: 'Mã xác thực',
          errorText: codeError,
          onSubmitted: (_) => busy ? null : onSubmit(),
        ),
        const SizedBox(height: 16),
        _ButtonRow(
          busy: busy,
          primaryLabel: 'Xác minh',
          primaryColor: c.accent600,
          onPrimary: onSubmit,
          onCancel: onCancel,
        ),
      ],
    );
  }
}

class _DisableStep extends StatelessWidget {
  const _DisableStep({
    required this.passwordController,
    required this.codeController,
    required this.passwordError,
    required this.codeError,
    required this.busy,
    required this.onSubmit,
    required this.onCancel,
    super.key,
  });

  final TextEditingController passwordController;
  final TextEditingController codeController;
  final String? passwordError;
  final String? codeError;
  final bool busy;
  final VoidCallback onSubmit;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _StepHeader(
          title: 'Tắt 2FA',
          description:
              'Nhập mật khẩu và mã xác thực hiện tại để tắt bảo vệ 2 lớp.',
        ),
        const SizedBox(height: 14),
        KFormField(
          controller: passwordController,
          label: 'Mật khẩu',
          obscureText: true,
          errorText: passwordError,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 12),
        _OtpField(
          controller: codeController,
          label: 'Mã xác thực',
          errorText: codeError,
          onSubmitted: (_) => busy ? null : onSubmit(),
        ),
        const SizedBox(height: 16),
        _ButtonRow(
          busy: busy,
          primaryLabel: 'Tắt 2FA',
          primaryColor: c.danger,
          onPrimary: onSubmit,
          onCancel: onCancel,
        ),
      ],
    );
  }
}

class _RecoveryCodesStep extends StatelessWidget {
  const _RecoveryCodesStep({
    required this.codes,
    required this.regenerate,
    required this.onCopy,
    required this.onDone,
    super.key,
  });

  final List<String> codes;
  final bool regenerate;
  final VoidCallback onCopy;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _StepHeader(
          title: regenerate ? 'Mã khôi phục mới' : 'Lưu mã khôi phục',
          description:
              'Mỗi mã chỉ dùng được một lần khi bạn không có '
              'thiết bị xác thực.',
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: c.warningSoft,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: c.warning.withValues(alpha: 0.25)),
          ),
          child: Text(
            'Lưu các mã này ở nơi an toàn. Bạn sẽ không xem lại được '
            'bộ mã này sau khi đóng màn hình.',
            style: TextStyle(
              color: c.warning,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              height: 1.35,
            ),
          ),
        ),
        const SizedBox(height: 12),
        _RecoveryCodeGrid(codes: codes),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: KSecondaryBtn(
                label: 'Sao chép',
                size: KBtnSize.md,
                onPressed: onCopy,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: FilledButton(
                onPressed: onDone,
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Đã lưu',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _RecoveryCodeGrid extends StatelessWidget {
  const _RecoveryCodeGrid({required this.codes});

  final List<String> codes;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: c.surfaceHover,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: c.borderSoft),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final code in codes)
            Container(
              width: (MediaQuery.sizeOf(context).width - 72) / 2,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 9),
              decoration: BoxDecoration(
                color: c.surfaceElev,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: c.borderSoft),
              ),
              alignment: Alignment.center,
              child: Text(
                code,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: c.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'monospace',
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SecretBox extends StatelessWidget {
  const _SecretBox({required this.secret});

  final String secret;

  Future<void> _copy(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: secret));
    if (!context.mounted) return;
    KNotify.success(context, 'Đã sao chép khóa thủ công');
  }

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Material(
      color: c.surfaceHover,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: () => _copy(context),
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: c.borderSoft),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Khóa thủ công',
                      style: TextStyle(
                        color: c.textMuted,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      secret,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: c.textPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'monospace',
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.copy, color: c.textMuted, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}

class _OtpField extends StatelessWidget {
  const _OtpField({
    required this.controller,
    required this.label,
    this.errorText,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final String label;
  final String? errorText;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final hasError = errorText != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          onSubmitted: onSubmitted,
          maxLength: 6,
          textAlign: TextAlign.center,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          style: TextStyle(
            color: c.textPrimary,
            fontSize: 22,
            fontWeight: FontWeight.w900,
            letterSpacing: 0,
          ),
          decoration: InputDecoration(
            labelText: label,
            counterText: '',
            filled: true,
            fillColor: c.surfaceElev,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 15,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: hasError ? c.danger : c.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: hasError ? c.danger : c.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: hasError ? c.danger : c.accent500,
                width: 1.5,
              ),
            ),
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 5),
          Text(
            errorText!,
            style: TextStyle(
              color: c.danger,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }
}

class _StepHeader extends StatelessWidget {
  const _StepHeader({required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: c.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          description,
          style: TextStyle(
            color: c.textMuted,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            height: 1.35,
          ),
        ),
      ],
    );
  }
}

class _ButtonRow extends StatelessWidget {
  const _ButtonRow({
    required this.busy,
    required this.primaryLabel,
    required this.primaryColor,
    required this.onPrimary,
    required this.onCancel,
  });

  final bool busy;
  final String primaryLabel;
  final Color primaryColor;
  final VoidCallback onPrimary;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: KSecondaryBtn(
            label: 'Hủy',
            size: KBtnSize.md,
            onPressed: busy ? null : onCancel,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: FilledButton(
            onPressed: busy ? null : onPrimary,
            style: FilledButton.styleFrom(
              backgroundColor: primaryColor,
              minimumSize: const Size.fromHeight(40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              busy ? 'Đang xử lý...' : primaryLabel,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
        ),
      ],
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c.surfaceElev,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: c.borderSoft),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Không tải được trạng thái bảo mật',
            style: TextStyle(
              color: c.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          KSecondaryBtn(
            label: 'Thử lại',
            size: KBtnSize.md,
            onPressed: onRetry,
          ),
        ],
      ),
    );
  }
}

String _credentialMessage(ApiException err) {
  final raw = err.message.trim();
  final lower = raw.toLowerCase();
  if (lower.contains('password')) return 'Mật khẩu không đúng';
  if (lower.contains('invalid code') || lower.contains('totp')) {
    return 'Mã xác thực không đúng';
  }
  if (lower.contains('too many')) {
    return 'Quá nhiều lần thử. Vui lòng đợi vài phút.';
  }
  if (err is NetworkException || err is TimeoutException) {
    return 'Không kết nối được máy chủ';
  }
  return raw.isEmpty ? 'Thao tác thất bại' : raw;
}

bool _looksLikeCodeError(ApiException err) {
  final lower = err.message.toLowerCase();
  return lower.contains('code') || lower.contains('totp');
}
