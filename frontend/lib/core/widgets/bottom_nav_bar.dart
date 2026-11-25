import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../theme/theme_context_extension.dart';

/// Descriptor for a single tab in [FitCheckBottomNavBar].
class _NavTab {
  const _NavTab({required this.icon, required this.label});

  final IconData icon;
  final String label;
}

const _tabs = [
  _NavTab(icon: Icons.search, label: 'Sprawdź'),
  _NavTab(icon: Icons.camera_alt_outlined, label: 'Dodaj'),
  _NavTab(icon: Icons.checkroom_outlined, label: 'Ubrania'),
  _NavTab(icon: Icons.person_outline, label: 'Wymiary'),
];

/// Reactive bottom navigation bar shared across the main shell tabs.
class FitCheckBottomNavBar extends StatelessWidget {
  const FitCheckBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.colors.surface,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            for (var i = 0; i < _tabs.length; i++)
              Expanded(
                child: _NavItem(
                  tab: _tabs[i],
                  isActive: i == currentIndex,
                  onTap: () => onTap(i),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.tab,
    required this.isActive,
    required this.onTap,
  });

  final _NavTab tab;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? context.colors.ink : context.colors.ink2;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(tab.icon, color: color),
          const Gap(4),
          Text(
            tab.label,
            style: context.typo.small.copyWith(
              color: color,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
          if (isActive)
            Container(
              margin: const EdgeInsets.only(top: 4),
              height: 2,
              width: 24,
              color: context.colors.ink,
            ),
        ],
      ),
    );
  }
}
