import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Compact "Edit / Hapus" action sheet shown when admin long-presses an
/// entity card (brand / model / generation / variant).
class AdminActionSheet extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const AdminActionSheet({
    super.key,
    required this.title,
    this.subtitle,
    required this.onEdit,
    required this.onDelete,
  });

  static Future<void> show(
    BuildContext context, {
    required String title,
    String? subtitle,
    required VoidCallback onEdit,
    required VoidCallback onDelete,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => AdminActionSheet(
        title: title,
        subtitle: subtitle,
        onEdit: onEdit,
        onDelete: onDelete,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(AppTheme.lg, 0, AppTheme.lg, AppTheme.lg),
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(AppTheme.radiusCard),
            border: Border.all(color: AppTheme.hairline),
          ),
          padding: const EdgeInsets.all(AppTheme.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(title.toUpperCase(),
                  style: AppTheme.eyebrow(color: AppTheme.textPrimary)),
              if (subtitle != null) ...[
                const SizedBox(height: AppTheme.sm),
                Text(
                  subtitle!,
                  style: const TextStyle(
                      color: AppTheme.textSecondary, fontSize: 13),
                ),
              ],
              const SizedBox(height: AppTheme.lg),
              _Btn(
                label: 'EDIT',
                icon: Icons.edit_outlined,
                onTap: () {
                  Navigator.pop(context);
                  onEdit();
                },
              ),
              const SizedBox(height: AppTheme.sm),
              _Btn(
                label: 'HAPUS',
                icon: Icons.delete_outline_rounded,
                destructive: true,
                onTap: () {
                  Navigator.pop(context);
                  onDelete();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Btn extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool destructive;

  const _Btn({
    required this.label,
    required this.icon,
    required this.onTap,
    this.destructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final fg =
        destructive ? const Color(0xFFFF8585) : AppTheme.textPrimary;
    return Material(
      color: AppTheme.surfaceElevated,
      borderRadius: BorderRadius.circular(AppTheme.radiusLg),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.lg, vertical: AppTheme.md),
          child: Row(
            children: [
              Icon(icon, size: 18, color: fg),
              const SizedBox(width: AppTheme.md),
              Text(label,
                  style: TextStyle(
                    color: fg,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.4,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

/// Confirmation dialog for destructive operations.
Future<bool> confirmDelete(
  BuildContext context, {
  required String title,
  required String message,
}) async {
  final ok = await showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: AppTheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
      ),
      title: Text(title, style: AppTheme.display(size: 18)),
      content: Text(
        message,
        style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text('BATAL', style: AppTheme.eyebrow()),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text('HAPUS',
              style: AppTheme.eyebrow(color: const Color(0xFFFF8585))),
        ),
      ],
    ),
  );
  return ok ?? false;
}
