import 'package:freezed_annotation/freezed_annotation.dart';

part 'body_measurements_profile.freezed.dart';

/// Preferred garment fit influencing ease recommendations.
enum FitPreference {
  fitted('Dopasowany'),
  regular('Regularny'),
  loose('Luźny');

  const FitPreference(this.label);
  final String label;
}

/// In-memory body measurements profile for a person.
@freezed
abstract class BodyMeasurementsProfile with _$BodyMeasurementsProfile {
  const factory BodyMeasurementsProfile({
    required String id,
    required String name,
    double? chestCm,
    double? waistCm,
    double? hipsCm,
    double? shoulderWidthCm,
    double? sleeveLengthCm,
    double? torsoLengthCm,
    @Default(FitPreference.regular) FitPreference fitPreference,
  }) = _BodyMeasurementsProfile;
}
