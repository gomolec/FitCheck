import 'package:freezed_annotation/freezed_annotation.dart';

part 'garment.freezed.dart';

/// Garment categories (mirrors the `CATEGORIES` table).
enum GarmentCategory {
  tshirt('Koszulka'),
  hoodie('Bluza'),
  jacket('Kurtka'),
  trousers('Spodnie');

  const GarmentCategory(this.label);

  final String label;
}

/// Flat garment measurements in cm (mirrors `MEASUREMENT_TYPES`).
enum MeasurementType {
  chestWidth('Szerokość w klatce'),
  shoulderWidth('Szerokość ramion'),
  sleeveLength('Długość rękawa'),
  bodyLength('Długość'),
  waistWidth('Szerokość w pasie');

  const MeasurementType(this.label);

  final String label;
}

/// A garment to be saved; only measurements that were filled in are present.
@freezed
abstract class NewGarment with _$NewGarment {
  const factory NewGarment({
    required GarmentCategory category,
    String? sizeLabel,
    required Map<MeasurementType, double> measurementsCm,
  }) = _NewGarment;
}
