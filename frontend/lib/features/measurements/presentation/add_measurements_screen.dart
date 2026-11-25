import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/theme/theme_context_extension.dart';
import '../application/measurements_controller.dart';
import '../domain/body_measurements_profile.dart';

/// Form screen for adding a new body measurements profile in memory.
class AddMeasurementsScreen extends ConsumerStatefulWidget {
  const AddMeasurementsScreen({super.key});

  @override
  ConsumerState<AddMeasurementsScreen> createState() =>
      _AddMeasurementsScreenState();
}

class _AddMeasurementsScreenState extends ConsumerState<AddMeasurementsScreen> {
  final _name = TextEditingController();
  final _chest = TextEditingController();
  final _waist = TextEditingController();
  final _hips = TextEditingController();
  final _shoulder = TextEditingController();
  final _sleeve = TextEditingController();
  final _torso = TextEditingController();

  FitPreference _fitPreference = FitPreference.regular;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    _chest.dispose();
    _waist.dispose();
    _hips.dispose();
    _shoulder.dispose();
    _sleeve.dispose();
    _torso.dispose();
    super.dispose();
  }

  /// Parses an optional measurement field; returns `(value, isValid)`.
  (double?, bool) _parseField(TextEditingController controller) {
    final text = controller.text.trim().replaceAll(',', '.');
    if (text.isEmpty) return (null, true);
    final value = double.tryParse(text);
    if (value == null || value <= 0) return (null, false);
    return (value, true);
  }

  void _save() {
    final name = _name.text.trim();
    if (name.isEmpty) {
      setState(() => _error = 'Podaj nazwę profilu (np. imię osoby).');
      return;
    }

    final (chest, chestOk) = _parseField(_chest);
    final (waist, waistOk) = _parseField(_waist);
    final (hips, hipsOk) = _parseField(_hips);
    final (shoulder, shoulderOk) = _parseField(_shoulder);
    final (sleeve, sleeveOk) = _parseField(_sleeve);
    final (torso, torsoOk) = _parseField(_torso);

    if (!chestOk ||
        !waistOk ||
        !hipsOk ||
        !shoulderOk ||
        !sleeveOk ||
        !torsoOk) {
      setState(() => _error = 'Wymiary muszą być liczbami większymi od 0.');
      return;
    }

    final values = [chest, waist, hips, shoulder, sleeve, torso];
    if (values.every((v) => v == null)) {
      setState(() => _error = 'Podaj przynajmniej jeden wymiar.');
      return;
    }

    final added = ref
        .read(measurementsControllerProvider.notifier)
        .addProfile(
          name: name,
          chestCm: chest,
          waistCm: waist,
          hipsCm: hips,
          shoulderWidthCm: shoulder,
          sleeveLengthCm: sleeve,
          torsoLengthCm: torso,
          fitPreference: _fitPreference,
        );

    if (!added) {
      setState(
        () => _error =
            'Osiągnięto limit ${MeasurementsController.maxProfiles} profili w pamięci.',
      );
      return;
    }

    Navigator.of(context).maybePop();
  }

  void _showMeasureGuide() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: context.colors.surface,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        title: Text(
          'Jak się zmierzyć?',
          style: context.typo.heading.copyWith(color: context.colors.ink),
        ),
        content: Text(
          '• Klatka / Talia / Biodra: mierz obwód poziomo w najszerszym lub najwęższym miejscu.\n'
          '• Szerokość ramion: od końca jednego barku do drugiego.\n'
          '• Długość rękawa: od barku do nadgarstka przy lekko ugiętej ręce.\n'
          '• Długość tułowia: od nasady szyi w dół do linii bioder.',
          style: context.typo.body.copyWith(color: context.colors.ink2),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Rozumiem'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.ground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8, top: 4),
                child: IconButton(
                  onPressed: () => context.pop(),
                  icon: Icon(Icons.arrow_back, color: context.colors.ink),
                  tooltip: 'Wróć',
                ),
              ),
              _buildHeroBanner(context),
              const Gap(20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.lock_outline,
                          size: 20,
                          color: context.colors.ink,
                        ),
                        const Gap(10),
                        Expanded(
                          child: Text(
                            'Widzisz je tylko Ty. Sprzedający nie dostaje żadnych danych.',
                            style: context.typo.small.copyWith(
                              color: context.colors.ink,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Gap(20),
                    _buildNameField(context),
                    const Gap(16),
                    _buildMeasurementRow(
                      context,
                      leftLabel: 'Klatka (obwód)',
                      leftController: _chest,
                      leftHint: '98',
                      rightLabel: 'Talia (obwód)',
                      rightController: _waist,
                      rightHint: '82',
                    ),
                    const Gap(16),
                    _buildMeasurementRow(
                      context,
                      leftLabel: 'Biodra (obwód)',
                      leftController: _hips,
                      leftHint: '96',
                      rightLabel: 'Szerokość ramion',
                      rightController: _shoulder,
                      rightHint: '46',
                    ),
                    const Gap(16),
                    _buildMeasurementRow(
                      context,
                      leftLabel: 'Długość rękawa',
                      leftController: _sleeve,
                      leftHint: '64',
                      rightLabel: 'Długość tułowia',
                      rightController: _torso,
                      rightHint: '68',
                    ),
                    const Gap(20),
                    GestureDetector(
                      onTap: _showMeasureGuide,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 20,
                            color: context.colors.ink,
                          ),
                          const Gap(8),
                          Text(
                            'Jak się zmierzyć?',
                            style: context.typo.label.copyWith(
                              color: context.colors.ink,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Gap(24),
                    Text(
                      'Jak lubisz nosić ubrania?',
                      style: context.typo.label.copyWith(
                        color: context.colors.ink,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Gap(12),
                    _buildFitSelector(context),
                    if (_error != null) ...[
                      const Gap(16),
                      Container(
                        width: double.infinity,
                        color: context.colors.badBg,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        child: Text(
                          _error!,
                          style: context.typo.small.copyWith(
                            color: context.colors.bad,
                          ),
                        ),
                      ),
                    ],
                    const Gap(24),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _save,
                        child: Text(
                          'Zapisz wymiary',
                          style: context.typo.label,
                        ),
                      ),
                    ),
                    const Gap(24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroBanner(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Transform.rotate(
          angle: -0.02,
          child: Container(
            width: double.infinity,
            color: context.colors.noteYellow,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                'TWOJE WYMIARY',
                style: context.typo.markerL.copyWith(color: context.colors.ink),
              ),
            ),
          ),
        ),
        Positioned(
          top: -12,
          right: 12,
          child: Transform.rotate(
            angle: -0.08,
            child: Container(
              width: 110,
              height: 30,
              color: context.colors.tape,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNameField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nazwa profilu (np. imię)',
          style: context.typo.small.copyWith(color: context.colors.ink),
        ),
        const Gap(6),
        Container(
          color: context.colors.surface,
          child: TextField(
            controller: _name,
            textInputAction: TextInputAction.next,
            style: context.typo.body.copyWith(color: context.colors.ink),
            decoration: InputDecoration(
              hintText: 'np. Moje wymiary',
              hintStyle: context.typo.body.copyWith(color: context.colors.ink2),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMeasurementRow(
    BuildContext context, {
    required String leftLabel,
    required TextEditingController leftController,
    required String leftHint,
    required String rightLabel,
    required TextEditingController rightController,
    required String rightHint,
  }) {
    return Row(
      children: [
        Expanded(
          child: _MeasurementInput(
            label: leftLabel,
            controller: leftController,
            hint: leftHint,
          ),
        ),
        const Gap(16),
        Expanded(
          child: _MeasurementInput(
            label: rightLabel,
            controller: rightController,
            hint: rightHint,
          ),
        ),
      ],
    );
  }

  Widget _buildFitSelector(BuildContext context) {
    return Container(
      color: context.colors.sunken,
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          for (final preference in FitPreference.values)
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _fitPreference = preference),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  color: _fitPreference == preference
                      ? context.colors.ink
                      : Colors.transparent,
                  alignment: Alignment.center,
                  child: Text(
                    preference.label,
                    style: context.typo.label.copyWith(
                      color: _fitPreference == preference
                          ? context.colors.inkInverse
                          : context.colors.ink,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _MeasurementInput extends StatelessWidget {
  const _MeasurementInput({
    required this.label,
    required this.controller,
    required this.hint,
  });

  final String label;
  final TextEditingController controller;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.typo.small.copyWith(color: context.colors.ink),
        ),
        const Gap(6),
        Container(
          color: context.colors.surface,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  style: context.typo.figure.copyWith(
                    color: context.colors.ink,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: context.typo.figure.copyWith(
                      color: context.colors.ink2.withValues(alpha: 0.45),
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
              Text(
                'cm',
                style: context.typo.body.copyWith(color: context.colors.ink2),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
