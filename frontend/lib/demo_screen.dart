import 'package:fitcheck/core/theme/theme_context_extension.dart';
import 'package:material_ui/material_ui.dart';
import 'package:gap/gap.dart';

class DemoScreen extends StatelessWidget {
  const DemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.ground,
      bottomNavigationBar: _buildBottomNav(context),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAppBar(context),
              _buildHeroPostIt(context),
              const Gap(24),
              _buildInputSection(context),
              const Gap(32),
              _buildRecentSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Transform.rotate(
        angle: -0.04, // Lekkie przechylenie logo
        child: Container(
          color: context.colors.noteYellow,
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Text(
            'FitCheck',
            style: context.typo.markerLogo.copyWith(color: context.colors.ink),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroPostIt(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Główne żółte tło (karteczka)
        Transform.rotate(
          angle: -0.05,
          child: Container(
            width: double.infinity,
            color: context.colors.noteYellow,
            padding: const EdgeInsets.only(
              top: 40,
              bottom: 30,
              left: 24,
              right: 24,
            ),
            margin: const EdgeInsets.only(top: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'BĘDZIE\nPASOWAĆ?',
                  style: context.typo.markerXl.copyWith(
                    color: context.colors.ink,
                  ),
                ),
                const Gap(8),
                Text(
                  'wpisz kod z ogłoszenia',
                  style: context.typo.markerM.copyWith(
                    color: context.colors.ink,
                  ),
                ),
              ],
            ),
          ),
        ),
        // Taśma lewa
        Positioned(
          top: 8,
          left: -10,
          child: Transform.rotate(
            angle: -0.3,
            child: Container(
              width: 100,
              height: 32,
              color: context.colors.tape,
            ),
          ),
        ),
        // Taśma prawa
        Positioned(
          top: -5,
          right: -10,
          child: Transform.rotate(
            angle: -0.15,
            child: Container(
              width: 120,
              height: 32,
              color: context.colors.tape,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInputSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Kod z ogłoszenia',
            style: context.typo.label.copyWith(color: context.colors.ink),
          ),
          const Gap(8),
          Container(
            color: context.colors.surface,
            child: TextField(
              style: context.typo.title.copyWith(color: context.colors.ink),
              decoration: InputDecoration(
                prefix: Text(
                  '#FC-',
                  style: context.typo.title.copyWith(
                    color: context.colors.ink2,
                  ),
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
            ),
          ),
          const Gap(12),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colors.ink,
                foregroundColor: context.colors.inkInverse,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
              onPressed: () {},
              child: Text('Sprawdź', style: context.typo.label),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ostatnio sprawdzane',
            style: context.typo.heading.copyWith(color: context.colors.ink),
          ),
          const Gap(16),
          _buildRecentItem(
            context,
            title: 'Bluza z kapturem',
            subtitle: 'Rękawy o 2 cm za krótkie',
            badgeText: 'PRAWIE',
            badgeColor: context.colors.noteOrange,
            icon: Icons.dry_cleaning,
          ),
          _buildRecentItem(
            context,
            title: 'Kurtka jeansowa',
            subtitle: 'Wszystkie wymiary w porządku',
            badgeText: 'PASUJE',
            badgeColor: context.colors.noteGreen,
            icon: Icons.checkroom,
          ),
          _buildRecentItem(
            context,
            title: 'Koszula lniana',
            subtitle: 'W klatce brakuje 6 cm',
            badgeText: 'ZA CIASNA',
            badgeColor: context.colors.notePink,
            icon: Icons.accessibility_new,
          ),
          const Gap(32), // Miejsce na padding na dole
        ],
      ),
    );
  }

  Widget _buildRecentItem(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String badgeText,
    required Color badgeColor,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            color: context.colors.sunken,
            child: Icon(icon, color: context.colors.ink2, size: 32),
          ),
          const Gap(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: context.typo.label.copyWith(color: context.colors.ink),
                ),
                const Gap(4),
                Text(
                  subtitle,
                  style: context.typo.small.copyWith(
                    color: context.colors.ink2,
                  ),
                ),
              ],
            ),
          ),
          // Rotowany badge statusu
          Transform.rotate(
            angle: -0.03, // Delikatne odchylenie
            child: Container(
              color: badgeColor,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              child: Text(
                badgeText,
                style: context.typo.markerS.copyWith(color: context.colors.ink),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      color: context.colors.surface,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              context,
              icon: Icons.search,
              label: 'Sprawdź',
              isActive: true,
            ),
            _buildNavItem(
              context,
              icon: Icons.camera_alt_outlined,
              label: 'Dodaj',
            ),
            _buildNavItem(
              context,
              icon: Icons.checkroom_outlined,
              label: 'Ubrania',
            ),
            _buildNavItem(
              context,
              icon: Icons.person_outline,
              label: 'Wymiary',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    bool isActive = false,
  }) {
    final color = isActive ? context.colors.ink : context.colors.ink2;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color),
        const Gap(4),
        Text(
          label,
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
    );
  }
}
