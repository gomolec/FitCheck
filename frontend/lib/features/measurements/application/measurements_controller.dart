import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/body_measurements_profile.dart';

part 'measurements_controller.g.dart';

/// Holds up to [maxProfiles] body measurement profiles in RAM.
@Riverpod(keepAlive: true)
class MeasurementsController extends _$MeasurementsController {
  static const int maxProfiles = 5;

  @override
  List<BodyMeasurementsProfile> build() => const [];

  bool get canAddMore => state.length < maxProfiles;

  /// Adds a profile if the in-memory limit ([maxProfiles]) has not been reached.
  /// Returns `true` when added, `false` when the limit is full.
  bool addProfile({
    required String name,
    double? chestCm,
    double? waistCm,
    double? hipsCm,
    double? shoulderWidthCm,
    double? sleeveLengthCm,
    double? torsoLengthCm,
    FitPreference fitPreference = FitPreference.regular,
  }) {
    if (!canAddMore) return false;

    final profile = BodyMeasurementsProfile(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: name,
      chestCm: chestCm,
      waistCm: waistCm,
      hipsCm: hipsCm,
      shoulderWidthCm: shoulderWidthCm,
      sleeveLengthCm: sleeveLengthCm,
      torsoLengthCm: torsoLengthCm,
      fitPreference: fitPreference,
    );
    state = [...state, profile];
    return true;
  }

  void removeProfile(String id) {
    state = [
      for (final profile in state)
        if (profile.id != id) profile,
    ];
  }
}
