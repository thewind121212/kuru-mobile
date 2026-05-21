import 'package:flutter/material.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
import 'package:kuru_mobile/core/auth/org_info.dart';

class OrgCard extends StatelessWidget {
  const OrgCard({
    required this.org,
    required this.active,
    required this.onTap,
    super.key,
  });

  final OrgInfo org;
  final bool active;
  final VoidCallback onTap;

  // Derive a stable hue from the org name hash for the avatar tint.
  int get _hue => (org.name.hashCode & 0xFFFF) % 360;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final initials = org.name
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .take(2)
        .map((w) => w[0])
        .join()
        .toUpperCase();
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: c.surfaceElev,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: active ? c.primary : c.borderSoft,
            width: active ? 2 : 1,
          ),
          boxShadow: active ? c.shadowMd : c.shadowSm,
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    HSLColor.fromAHSL(1, _hue.toDouble(), 0.6, 0.55).toColor(),
                    HSLColor.fromAHSL(
                      1,
                      (_hue + 30) % 360,
                      0.7,
                      0.45,
                    ).toColor(),
                  ],
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                initials,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  letterSpacing: -0.4,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    org.name,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: c.textPrimary,
                      letterSpacing: -0.14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  _RolePill(role: org.role, active: active),
                ],
              ),
            ),
            if (active) Icon(Icons.check, size: 20, color: c.primary),
          ],
        ),
      ),
    );
  }
}

class _RolePill extends StatelessWidget {
  const _RolePill({required this.role, required this.active});
  final String role;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final bg = active ? c.primarySoft : c.borderSoft;
    final fg = active ? c.primary : c.textSecondary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        role,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: fg),
      ),
    );
  }
}
