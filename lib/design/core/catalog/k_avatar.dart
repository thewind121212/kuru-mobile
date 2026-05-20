import 'package:flutter/material.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
import 'package:kuru_mobile/core/env/env.dart';

class KAvatar extends StatelessWidget {
  const KAvatar({
    required this.name,
    super.key,
    this.size = 40,
    this.avatarStyle,
    this.avatarSeed,
    this.avatarUrl,
  });

  final String name;
  final double size;
  final String? avatarStyle;
  final String? avatarSeed;
  final String? avatarUrl;

  static String _initialsFor(String raw) {
    final parts = raw.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) {
      return parts.first
          .substring(0, parts.first.length >= 2 ? 2 : 1)
          .toUpperCase();
    }
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }

  String? _dicebearUrl() {
    if (avatarStyle == null || avatarStyle!.isEmpty) return null;
    if (avatarStyle == 'upload') return null;
    final seed = Uri.encodeComponent(avatarSeed ?? name);
    return 'https://api.dicebear.com/9.x/$avatarStyle/png?seed=$seed';
  }

  /// Build the full S3/MinIO URL for an uploaded avatar.
  ///
  /// BE persists the S3 key (`<userId>/<userId>.<ext>`) in `avatar_url`,
  /// NOT a fully-qualified URL. Mirror the web's helper
  /// (`getUploadedAvatarUrl` in fe/src/core-design/utils/avatar.ts):
  /// `${IMAGE_BASE_URL}/user-avatar/${key}`. If the BE ever returns an
  /// absolute URL (http(s)://…) we pass it through unchanged.
  String? _uploadedUrl() {
    final key = avatarUrl;
    if (key == null || key.isEmpty) return null;
    if (key.startsWith('http://') || key.startsWith('https://')) return key;
    return '${Env.imageBaseUrl}/user-avatar/$key';
  }

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final url = avatarStyle == 'upload' ? _uploadedUrl() : _dicebearUrl();
    final initials = _initialsFor(name);

    return ClipOval(
      child: Container(
        width: size,
        height: size,
        color: c.primary.withValues(alpha: 0.15),
        alignment: Alignment.center,
        child: url != null
            ? Image.network(
                url,
                width: size,
                height: size,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => _initialsLabel(initials, c),
                loadingBuilder: (_, child, progress) {
                  if (progress == null) return child;
                  return _initialsLabel(initials, c);
                },
              )
            : _initialsLabel(initials, c),
      ),
    );
  }

  Widget _initialsLabel(String s, KuruColors c) => Text(
    s,
    style: TextStyle(
      color: c.primary,
      fontWeight: FontWeight.w700,
      fontSize: size * 0.38,
    ),
  );
}
