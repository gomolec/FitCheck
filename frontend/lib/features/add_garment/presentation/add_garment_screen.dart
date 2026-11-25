import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../data/garment_repository.dart';
import '../domain/garment.dart';

/// Unstyled three-step flow: garment › measurements › share code.
class AddGarmentScreen extends ConsumerStatefulWidget {
  const AddGarmentScreen({super.key});

  @override
  ConsumerState<AddGarmentScreen> createState() => _AddGarmentScreenState();
}

class _AddGarmentScreenState extends ConsumerState<AddGarmentScreen> {
  static const _garmentStep = 0;
  static const _measurementsStep = 1;
  static const _codeStep = 2;

  int _step = _garmentStep;
  GarmentCategory _category = GarmentCategory.tshirt;
  final _sizeLabel = TextEditingController();
  final _measurements = {
    for (final type in MeasurementType.values) type: TextEditingController(),
  };
  bool _saving = false;
  String? _error;
  String? _code;

  @override
  void dispose() {
    _sizeLabel.dispose();
    for (final controller in _measurements.values) {
      controller.dispose();
    }
    super.dispose();
  }

  /// Parses filled-in fields; accepts both `52.5` and `52,5`.
  Map<MeasurementType, double>? _parseMeasurements() {
    final result = <MeasurementType, double>{};
    for (final MapEntry(key: type, value: controller)
        in _measurements.entries) {
      final text = controller.text.trim().replaceAll(',', '.');
      if (text.isEmpty) continue;
      final value = double.tryParse(text);
      if (value == null || value <= 0) return null;
      result[type] = value;
    }
    return result;
  }

  Future<void> _save() async {
    final measurements = _parseMeasurements();
    if (measurements == null) {
      setState(() => _error = 'Wymiary muszą być liczbami większymi od 0.');
      return;
    }
    if (measurements.isEmpty) {
      setState(() => _error = 'Podaj przynajmniej jeden wymiar.');
      return;
    }

    setState(() {
      _saving = true;
      _error = null;
    });
    final size = _sizeLabel.text.trim();
    final code = await ref
        .read(garmentRepositoryProvider)
        .save(
          NewGarment(
            category: _category,
            sizeLabel: size.isEmpty ? null : size,
            measurementsCm: measurements,
          ),
        );
    if (!mounted) return;
    setState(() {
      _saving = false;
      _code = code;
      _step = _codeStep;
    });
  }

  void _continue() {
    switch (_step) {
      case _garmentStep:
        setState(() => _step = _measurementsStep);
      case _measurementsStep:
        _save();
      case _codeStep:
        if (context.canPop()) {
          context.pop();
        } else {
          setState(() {
            _step = _garmentStep;
            _code = null;
          });
          StatefulNavigationShell.maybeOf(context)?.goBranch(0);
        }
    }
  }

  void _back() {
    if (_step == _measurementsStep) setState(() => _step = _garmentStep);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dodaj ubranie')),
      body: Stepper(
        currentStep: _step,
        onStepContinue: _saving ? null : _continue,
        onStepCancel: _step == _measurementsStep ? _back : null,
        // Stepper builds controls for collapsed steps too; render them
        // only for the current one.
        controlsBuilder: (context, details) =>
            details.stepIndex != details.currentStep
            ? const SizedBox.shrink()
            : Row(
                children: [
                  ElevatedButton(
                    onPressed: details.onStepContinue,
                    child: Text(switch (details.stepIndex) {
                      _measurementsStep =>
                        _saving ? 'Zapisywanie...' : 'Zapisz',
                      _codeStep => 'Gotowe',
                      _ => 'Dalej',
                    }),
                  ),
                  if (details.onStepCancel != null)
                    TextButton(
                      onPressed: details.onStepCancel,
                      child: const Text('Wstecz'),
                    ),
                ],
              ),
        steps: [
          Step(
            title: const Text('Ubranie'),
            isActive: _step >= _garmentStep,
            content: Column(
              children: [
                DropdownButtonFormField<GarmentCategory>(
                  initialValue: _category,
                  decoration: const InputDecoration(labelText: 'Kategoria'),
                  items: [
                    for (final category in GarmentCategory.values)
                      DropdownMenuItem(
                        value: category,
                        child: Text(category.label),
                      ),
                  ],
                  onChanged: (value) =>
                      setState(() => _category = value ?? _category),
                ),
                TextField(
                  controller: _sizeLabel,
                  decoration: const InputDecoration(
                    labelText: 'Rozmiar z metki (opcjonalnie)',
                  ),
                ),
              ],
            ),
          ),
          Step(
            title: const Text('Wymiary'),
            isActive: _step >= _measurementsStep,
            content: Column(
              children: [
                for (final MapEntry(key: type, value: controller)
                    in _measurements.entries)
                  TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      labelText: type.label,
                      suffixText: 'cm',
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                  ),
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(_error!),
                  ),
              ],
            ),
          ),
          Step(
            title: const Text('Kod'),
            isActive: _step >= _codeStep,
            content: Align(
              alignment: Alignment.centerLeft,
              child: SelectableText(_code ?? ''),
            ),
          ),
        ],
      ),
    );
  }
}
