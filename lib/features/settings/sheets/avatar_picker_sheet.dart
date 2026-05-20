import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kuru_mobile/core/auth/auth_providers.dart';
import 'package:kuru_mobile/core/feedback/k_notify.dart';
import 'package:kuru_mobile/core/network/api_exception.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/core/profile/profile_providers.dart';
import 'package:kuru_mobile/design/core/catalog/k_avatar.dart';
import 'package:kuru_mobile/design/core/modal/k_modal_sheet.dart';

class AvatarSelection {
  const AvatarSelection({required this.style, required this.seed});
  final String? style;
  final String? seed;
}

// Canonical list — mirrors kuru-web's `AVATAR_STYLES` in
// fe/src/core-design/utils/avatar.ts so a profile picked on the web
// renders consistently in the mobile app and vice versa.
const _dicebearStyles = <({String id, String label})>[
  (id: 'fun-emoji', label: 'Fun Emoji'),
  (id: 'thumbs', label: 'Thumbs'),
  (id: 'pixel-art', label: 'Pixel Art'),
  (id: 'bottts', label: 'Bottts'),
  (id: 'shapes', label: 'Shapes'),
  (id: 'adventurer', label: 'Adventure'),
];

Future<AvatarSelection?> showAvatarPickerSheet(
  BuildContext context, {
  required String currentName,
  String? currentStyle,
  String? currentSeed,
}) {
  return showKModalSheet<AvatarSelection>(
    context: context,
    title: 'Ảnh đại diện',
    builder: (sheetCtx) => _AvatarPickerBody(
      currentName: currentName,
      initialStyle: currentStyle,
      initialSeed: currentSeed,
    ),
  );
}

class _AvatarPickerBody extends ConsumerStatefulWidget {
  const _AvatarPickerBody({
    required this.currentName,
    this.initialStyle,
    this.initialSeed,
  });
  final String currentName;
  final String? initialStyle;
  final String? initialSeed;
  @override
  ConsumerState<_AvatarPickerBody> createState() => _AvatarPickerBodyState();
}

String _randomSeed() {
  final r = Random();
  // Short alphanumeric seed — enough variety for dicebear's renderer.
  const alphabet = 'abcdefghijklmnopqrstuvwxyz0123456789';
  return List.generate(10, (_) => alphabet[r.nextInt(alphabet.length)]).join();
}

class _AvatarPickerBodyState extends ConsumerState<_AvatarPickerBody>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs = TabController(length: 3, vsync: this);
  String? _style;
  String? _seed;
  File? _pickedFile;
  bool _uploading = false;

  @override
  void initState() {
    super.initState();
    _style = widget.initialStyle;
    // Default the seed to the user's display name so the very first
    // render is deterministic; the reroll button replaces it with a
    // random key, which then refreshes every tile at once.
    _seed = widget.initialSeed ?? widget.currentName;
    _tabs.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  Future<void> _pickFromGallery() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 1024,
    );
    if (picked == null) return;
    setState(() => _pickedFile = File(picked.path));
  }

  Future<void> _uploadAndApply() async {
    final file = _pickedFile;
    final bootstrap = ref.read(appBootstrapProvider);
    final user = bootstrap.maybeWhen(
      data: (b) => b is BootstrapAuthed ? b.user : null,
      orElse: () => null,
    );
    final userId = (user?.orgInfos.isNotEmpty ?? false)
        ? user!.orgInfos.first.id
        : null;
    if (file == null) return;
    if (userId == null) return;
    setState(() => _uploading = true);
    final result = await ref
        .read(profileRepositoryProvider)
        .uploadAvatar(file: file, userId: userId);
    if (!mounted) return;
    setState(() => _uploading = false);
    switch (result) {
      case ApiSuccess<String>():
        ref.invalidate(appBootstrapProvider);
        if (!context.mounted) return;
        Navigator.of(
          context,
        ).pop(const AvatarSelection(style: 'upload', seed: null));
      case ApiFailure<String>(:final err):
        if (err is BadRequestException) {
          KNotify.warning(context, err.message);
        } else {
          KNotify.networkError(
            context,
            'Tải ảnh thất bại',
            onRetry: _uploadAndApply,
          );
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 460,
      child: Column(
        children: [
          TabBar(
            controller: _tabs,
            tabs: const [
              Tab(text: 'Chữ cái'),
              Tab(text: 'Hình vẽ'),
              Tab(text: 'Tải lên'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabs,
              children: [_initialsTab(), _dicebearTab(), _uploadTab()],
            ),
          ),
          if (_tabs.index == 1 && _style != null)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => setState(() => _seed = _randomSeed()),
                      icon: const Icon(Icons.casino_outlined),
                      label: const Text('Đổi ngẫu nhiên'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FilledButton(
                      onPressed: () => Navigator.of(context).pop(
                        AvatarSelection(
                          style: _style,
                          seed: _seed ?? widget.currentName,
                        ),
                      ),
                      child: const Text('Dùng kiểu này'),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _initialsTab() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 24),
          KAvatar(name: widget.currentName, size: 96),
          const SizedBox(height: 16),
          const Text('Tạo từ tên hiển thị'),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => Navigator.of(
              context,
            ).pop(const AvatarSelection(style: null, seed: null)),
            child: const Text('Dùng chữ cái'),
          ),
        ],
      ),
    );
  }

  Widget _dicebearTab() {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),
      itemCount: _dicebearStyles.length,
      itemBuilder: (_, i) {
        final s = _dicebearStyles[i];
        final selected = _style == s.id;
        // Every tile shares the same _seed so a single "Đổi ngẫu nhiên"
        // tap repaints every preview at once. Selecting a tile is a
        // pure style swap; the seed never changes from tapping.
        final tileSeed = _seed ?? widget.currentName;
        return GestureDetector(
          onTap: () {
            if (selected) return;
            setState(() => _style = s.id);
          },
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: selected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).dividerColor,
                width: selected ? 2 : 1,
              ),
            ),
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Center(
                    child: SizedBox(
                      width: 64,
                      height: 64,
                      child: KAvatar(
                        // ValueKey forces a fresh Element + ImageStream
                        // whenever the seed changes so a reroll really
                        // refetches the new dicebear URL.
                        key: ValueKey('${s.id}-$tileSeed'),
                        name: widget.currentName,
                        size: 64,
                        avatarStyle: s.id,
                        avatarSeed: tileSeed,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  s.label,
                  style: const TextStyle(fontSize: 11),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _uploadTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 8),
          GestureDetector(
            onTap: _pickFromGallery,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
              ),
              alignment: Alignment.center,
              child: _pickedFile == null
                  ? const Icon(Icons.add_a_photo, size: 36)
                  : ClipOval(
                      child: Image.file(
                        _pickedFile!,
                        width: 140,
                        height: 140,
                        fit: BoxFit.cover,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _pickedFile == null || _uploading
                ? null
                : _uploadAndApply,
            child: _uploading ? const Text('Đang tải…') : const Text('Lưu ảnh'),
          ),
        ],
      ),
    );
  }
}
