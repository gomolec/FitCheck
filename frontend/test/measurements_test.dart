import 'package:fitcheck/core/theme/app_theme.dart';
import 'package:fitcheck/features/measurements/application/measurements_controller.dart';
import 'package:fitcheck/features/measurements/domain/body_measurements_profile.dart';
import 'package:fitcheck/features/measurements/presentation/add_measurements_screen.dart';
import 'package:fitcheck/features/measurements/presentation/measurements_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  test('MeasurementsController enforces max 5 profiles in memory', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final controller = container.read(measurementsControllerProvider.notifier);

    for (var i = 1; i <= 5; i++) {
      final added = controller.addProfile(
        name: 'Osoba $i',
        chestCm: 90 + i.toDouble(),
      );
      expect(added, isTrue);
    }

    expect(container.read(measurementsControllerProvider).length, 5);
    expect(controller.canAddMore, isFalse);

    final sixth = controller.addProfile(name: 'Osoba 6', chestCm: 100);
    expect(sixth, isFalse);
    expect(container.read(measurementsControllerProvider).length, 5);

    final firstId = container.read(measurementsControllerProvider).first.id;
    controller.removeProfile(firstId);
    expect(container.read(measurementsControllerProvider).length, 4);
    expect(controller.canAddMore, isTrue);
  });

  testWidgets('MeasurementsScreen shows empty state when no profiles exist', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: AppTheme.light,
          home: const MeasurementsScreen(),
        ),
      ),
    );

    expect(find.text('BRAK WYMIARÓW'), findsOneWidget);
    expect(find.text('0/5'), findsOneWidget);
    expect(find.text('Dodaj wymiary'), findsOneWidget);
  });

  testWidgets('AddMeasurementsScreen validates and saves profile', (
    tester,
  ) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          theme: AppTheme.light,
          home: const AddMeasurementsScreen(),
        ),
      ),
    );

    expect(find.text('TWOJE WYMIARY'), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, 'Anna');
    await tester.enterText(find.byType(TextField).at(1), '92');
    await tester.ensureVisible(find.text('Luźny'));
    await tester.tap(find.text('Luźny'));
    await tester.ensureVisible(find.text('Zapisz wymiary'));
    await tester.tap(find.text('Zapisz wymiary'));
    await tester.pumpAndSettle();

    final saved = container.read(measurementsControllerProvider);
    expect(saved.length, 1);
    expect(saved.first.name, 'Anna');
    expect(saved.first.chestCm, 92);
    expect(saved.first.fitPreference, FitPreference.loose);
  });
}
