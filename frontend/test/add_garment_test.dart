import 'dart:math';

import 'package:fitcheck/features/add_garment/data/garment_repository.dart';
import 'package:fitcheck/features/add_garment/domain/garment.dart';
import 'package:fitcheck/features/add_garment/presentation/add_garment_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

Future<void> _openMeasurementsStep(WidgetTester tester) async {
  await tester.pumpWidget(
    const ProviderScope(child: MaterialApp(home: AddGarmentScreen())),
  );
  await tester.tap(find.text('Dalej'));
  await tester.pumpAndSettle();
}

void main() {
  test('repository returns codes in FC-0000 format', () async {
    final repo = GarmentRepository(random: Random(1));
    final code = await repo.save(
      const NewGarment(
        category: GarmentCategory.tshirt,
        measurementsCm: {MeasurementType.chestWidth: 52},
      ),
    );
    expect(code, matches(RegExp(r'^FC-\d{4}$')));
  });

  testWidgets('saving without measurements shows an error', (tester) async {
    await _openMeasurementsStep(tester);

    await tester.tap(find.text('Zapisz'));
    await tester.pumpAndSettle();

    expect(find.text('Podaj przynajmniej jeden wymiar.'), findsOneWidget);
  });

  testWidgets('invalid measurement shows an error', (tester) async {
    await _openMeasurementsStep(tester);

    await tester.enterText(
      find.widgetWithText(TextField, MeasurementType.chestWidth.label),
      'abc',
    );
    await tester.tap(find.text('Zapisz'));
    await tester.pumpAndSettle();

    expect(
      find.text('Wymiary muszą być liczbami większymi od 0.'),
      findsOneWidget,
    );
  });

  testWidgets('saving measurements shows the share code', (tester) async {
    await _openMeasurementsStep(tester);

    await tester.enterText(
      find.widgetWithText(TextField, MeasurementType.chestWidth.label),
      '52,5',
    );
    await tester.tap(find.text('Zapisz'));
    await tester.pumpAndSettle();

    expect(find.textContaining(RegExp(r'^FC-\d{4}$')), findsOneWidget);
    expect(find.text('Gotowe'), findsOneWidget);
  });
}
