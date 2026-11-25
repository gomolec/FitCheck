import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/theme/theme_context_extension.dart';
import '../../auth/application/auth_controller.dart';
import '../../auth/data/auth_repository.dart';

/// Settings tab structured around the 5 privacy-by-design sections.
/// Only "Zarządzaj wymiarami" and "Wyloguj się" are active for now;
/// remaining items are disabled placeholders for upcoming features.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailAsync = ref.watch(currentUserEmailProvider);
    final userEmail = emailAsync.when(
      data: (email) => email ?? 'Zalogowany użytkownik',
      loading: () => 'Ładowanie...',
      error: (_, _) => 'Zalogowany użytkownik',
    );

    return Scaffold(
      backgroundColor: context.colors.ground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, userEmail),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle(context, '1. Szczegóły profilu'),
                    _SettingsTile(
                      icon: Icons.badge_outlined,
                      title: 'Nazwa wyświetlana / Nick',
                      subtitle: 'Widoczna przy ofertach — wkrótce',
                      enabled: false,
                    ),
                    const Gap(8),
                    _SettingsTile(
                      icon: Icons.tune,
                      title: 'Domyślna preferencja dopasowania',
                      subtitle: 'Regular / Slim / Oversize — wkrótce',
                      enabled: false,
                    ),
                    const Gap(8),
                    _SettingsTile(
                      icon: Icons.straighten,
                      title: 'Zarządzaj wymiarami',
                      subtitle: 'Edytuj swój profil wymiarowy',
                      accentColor: context.colors.noteYellow,
                      onTap: () => context.push(AppRoutes.measurements),
                    ),
                    const Gap(28),
                    _buildSectionTitle(
                      context,
                      '2. Prywatność i bezpieczeństwo wymiarów',
                    ),
                    _SettingsTile(
                      icon: Icons.cloud_outlined,
                      title: 'Model przechowywania: Tryb Chmury',
                      subtitle:
                          'Szyfrowane na serwerze lub tylko lokalnie — wkrótce',
                      enabled: false,
                    ),
                    const Gap(8),
                    _SettingsTile(
                      icon: Icons.sync_lock,
                      title: 'Migracja danych wymiarowych',
                      subtitle: 'Przenoszenie między chmurą a telefonem — wkrótce',
                      enabled: false,
                    ),
                    const Gap(28),
                    _buildSectionTitle(context, '3. Zarządzanie kontem'),
                    _SettingsTile(
                      icon: Icons.mail_outline,
                      title: 'Adres e-mail',
                      subtitle: userEmail,
                      enabled: false,
                    ),
                    const Gap(8),
                    _SettingsTile(
                      icon: Icons.lock_outline,
                      title: 'Zmiana hasła',
                      subtitle: 'Wkrótce',
                      enabled: false,
                    ),
                    const Gap(8),
                    _SettingsTile(
                      icon: Icons.fingerprint,
                      title: 'Logowanie biometryczne (FaceID)',
                      subtitle: 'Dodatkowa blokada dostępu — wkrótce',
                      enabled: false,
                    ),
                    const Gap(8),
                    _SettingsTile(
                      icon: Icons.devices,
                      title: 'Aktywne sesje / Urządzenia',
                      subtitle: 'Wkrótce',
                      enabled: false,
                    ),
                    const Gap(12),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () =>
                            ref.read(authControllerProvider.notifier).logout(),
                        child: Text('Wyloguj się', style: context.typo.label),
                      ),
                    ),
                    const Gap(28),
                    _buildSectionTitle(
                      context,
                      '4. Preferencje aplikacji i zgody',
                    ),
                    _SettingsTile(
                      icon: Icons.notifications_none,
                      title: 'Powiadomienia',
                      subtitle: 'Ankiety i nowe ubrania — wkrótce',
                      enabled: false,
                    ),
                    const Gap(8),
                    _SettingsTile(
                      icon: Icons.square_foot,
                      title: 'Jednostki miary',
                      subtitle: 'Domyślnie centymetry (cm) — wkrótce',
                      enabled: false,
                    ),
                    const Gap(8),
                    _SettingsTile(
                      icon: Icons.gavel_outlined,
                      title: 'Zgody prawne i RODO',
                      subtitle: 'Polityka prywatności, regulamin — wkrótce',
                      enabled: false,
                    ),
                    const Gap(28),
                    _buildSectionTitle(
                      context,
                      '5. Zarządzanie danymi i strefa usuwania',
                    ),
                    _SettingsTile(
                      icon: Icons.download_outlined,
                      title: 'Pobierz kopię swoich danych',
                      subtitle: 'Eksport RODO (JSON) — wkrótce',
                      enabled: false,
                    ),
                    const Gap(8),
                    _SettingsTile(
                      icon: Icons.cleaning_services_outlined,
                      title: 'Wyczyść same dane wymiarowe',
                      subtitle: 'Zachowuje konto i ogłoszenia — wkrótce',
                      enabled: false,
                    ),
                    const Gap(8),
                    _SettingsTile(
                      icon: Icons.delete_forever_outlined,
                      title: 'Usuń konto i wszystkie dane',
                      subtitle: 'Całkowite usunięcie — wkrótce',
                      enabled: false,
                      isDanger: true,
                    ),
                    const Gap(32),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String userEmail) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Transform.rotate(
            angle: -0.04,
            child: Container(
              color: context.colors.noteYellow,
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 4.0,
              ),
              child: Text(
                'Ustawienia',
                style: context.typo.markerM.copyWith(color: context.colors.ink),
              ),
            ),
          ),
          const Gap(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Zalogowano jako',
                  style: context.typo.small.copyWith(
                    color: context.colors.ink2,
                  ),
                ),
                Text(
                  userEmail,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.typo.label.copyWith(color: context.colors.ink),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: context.typo.heading.copyWith(color: context.colors.ink),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.enabled = true,
    this.isDanger = false,
    this.accentColor,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final bool enabled;
  final bool isDanger;
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    final background = isDanger
        ? context.colors.badBg
        : (accentColor ??
              (enabled ? context.colors.surface : context.colors.sunken));
    final titleColor = isDanger
        ? context.colors.bad
        : (enabled ? context.colors.ink : context.colors.ink2);
    final subtitleColor = isDanger
        ? context.colors.bad.withValues(alpha: 0.8)
        : context.colors.ink2;

    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Opacity(
        opacity: enabled ? 1.0 : 0.72,
        child: Container(
          color: background,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(icon, color: titleColor, size: 22),
              const Gap(14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: context.typo.label.copyWith(color: titleColor),
                    ),
                    const Gap(2),
                    Text(
                      subtitle,
                      style: context.typo.small.copyWith(color: subtitleColor),
                    ),
                  ],
                ),
              ),
              if (enabled)
                Icon(Icons.chevron_right, color: titleColor, size: 22),
            ],
          ),
        ),
      ),
    );
  }
}
