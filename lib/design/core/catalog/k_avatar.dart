import 'package:flutter/material.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';

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

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final url = avatarStyle == 'upload' ? avatarUrl : _dicebearUrl();
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
