import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/theme/theme_context_extension.dart';
import '../application/measurements_controller.dart';
import '../domain/body_measurements_profile.dart';

/// Displays in-memory body measurement profiles (up to 5) with an empty state
/// and navigation to [AddMeasurementsScreen].
class MeasurementsScreen extends ConsumerWidget {
  const MeasurementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profiles = ref.watch(measurementsControllerProvider);
    final canAddMore = profiles.length < MeasurementsController.maxProfiles;

    return Scaffold(
      backgroundColor: context.colors.ground,
      appBar: AppBar(
        title: const Text('Wymiary'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Container(
                color: context.colors.sunken,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                child: Text(
                  '${profiles.length}/${MeasurementsController.maxProfiles}',
                  style: context.typo.code.copyWith(color: context.colors.ink),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: profiles.isEmpty
                  ? _EmptyState(
                      onAdd: () => context.push(AppRoutes.addMeasurements),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                      itemCount: profiles.length,
                      separatorBuilder: (_, _) => const Gap(12),
                      itemBuilder: (context, index) {
                        final profile = profiles[index];
                        return _ProfileCard(
                          profile: profile,
                          onDelete: () => ref
                              .read(measurementsControllerProvider.notifier)
                              .removeProfile(profile.id),
                        );
                      },
                    ),
            ),
            if (profiles.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
                child: Column(
                  children: [
                    if (!canAddMore) ...[
                      Text(
                        'Osiągnięto limit ${MeasurementsController.maxProfiles} profili w pamięci.',
                        style: context.typo.small.copyWith(
                          color: context.colors.warn,
                        ),
                      ),
                      const Gap(8),
                    ],
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: canAddMore
                            ? () => context.push(AppRoutes.addMeasurements)
                            : null,
                        child: Text(
                          'Dodaj wymiary',
                          style: context.typo.label,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Transform.rotate(
              angle: -0.03,
              child: Container(
                color: context.colors.noteYellow,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Text(
                  'BRAK WYMIARÓW',
                  style: context.typo.markerM.copyWith(
                    color: context.colors.ink,
                  ),
                ),
              ),
            ),
            const Gap(16),
            Text(
              'Dodaj swoje wymiary lub wymiary bliskich osób (maks. ${MeasurementsController.maxProfiles} w pamięci), aby sprawdzać dopasowanie ubrań.',
              textAlign: TextAlign.center,
              style: context.typo.body.copyWith(color: context.colors.ink2),
            ),
            const Gap(24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: onAdd,
                child: Text('Dodaj wymiary', style: context.typo.label),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.profile, required this.onDelete});

  final BodyMeasurementsProfile profile;
  final VoidCallback onDelete;

  String _formatCm(double value) =>
      value % 1 == 0 ? value.toInt().toString() : value.toString();

  List<String> _measurementParts() {
    final entries = <(String, double?)>[
      ('Klatka', profile.chestCm),
      ('Talia', profile.waistCm),
      ('Biodra', profile.hipsCm),
      ('Ramiona', profile.shoulderWidthCm),
      ('Rękaw', profile.sleeveLengthCm),
      ('Tułów', profile.torsoLengthCm),
    ];
    return [
      for (final (label, value) in entries)
        if (value != null) '$label: ${_formatCm(value)} cm',
    ];
  }

  @override
  Widget build(BuildContext context) {
    final summary = _measurementParts().join(' • ');

    return Container(
      color: context.colors.surface,
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        profile.name,
                        style: context.typo.heading.copyWith(
                          color: context.colors.ink,
                        ),
                      ),
                    ),
                    const Gap(10),
                    Transform.rotate(
                      angle: -0.02,
                      child: Container(
                        color: context.colors.noteYellow,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        child: Text(
                          profile.fitPreference.label,
                          style: context.typo.small.copyWith(
                            color: context.colors.ink,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                if (summary.isNotEmpty) ...[
                  const Gap(8),
                  Text(
                    summary,
                    style: context.typo.small.copyWith(
                      color: context.colors.ink2,
                    ),
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            onPressed: onDelete,
            icon: Icon(Icons.delete_outline, color: context.colors.ink2),
            tooltip: 'Usuń profil',
          ),
        ],
      ),
    );
  }
}
