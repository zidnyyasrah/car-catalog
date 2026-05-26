import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class FloatingNavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const FloatingNavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

class FloatingNav extends StatelessWidget {
  final List<FloatingNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onChanged;

  const FloatingNav({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 14),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: AppTheme.border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.6),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Row(
              children: [
                for (int i = 0; i < items.length; i++)
                  Expanded(
                    child: _NavSlot(
                      item: items[i],
                      active: i == currentIndex,
                      onTap: () => onChanged(i),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavSlot extends StatelessWidget {
  final FloatingNavItem item;
  final bool active;
  final VoidCallback onTap;

  const _NavSlot({
    required this.item,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: AnimatedContainer(
          duration: AppTheme.motion,
          curve: Curves.easeOutCubic,
          height: 46,
          decoration: BoxDecoration(
            color: active ? AppTheme.accent : Colors.transparent,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                active ? item.activeIcon : item.icon,
                size: 18,
                color: active ? AppTheme.onAccent : AppTheme.textMuted,
              ),
              AnimatedSize(
                duration: AppTheme.motion,
                curve: Curves.easeOutCubic,
                child: active
                    ? Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          item.label.toUpperCase(),
                          style: const TextStyle(
                            color: AppTheme.onAccent,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.4,
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
