import 'dart:math';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/garment.dart';

part 'garment_repository.g.dart';

/// Saves garments and returns their share code.
///
/// TODO(api): replace with a Dio implementation once the backend exposes
/// a garments endpoint. This in-memory version only backs the prototype.
class GarmentRepository {
  GarmentRepository({Random? random}) : _random = random ?? Random();

  final Random _random;
  final Map<String, NewGarment> _saved = {};

  /// Returns a share code in the `FC-1234` format.
  Future<String> save(NewGarment garment) async {
    String code;
    do {
      code = 'FC-${_random.nextInt(10000).toString().padLeft(4, '0')}';
    } while (_saved.containsKey(code));
    _saved[code] = garment;
    return code;
  }
}

@Riverpod(keepAlive: true)
GarmentRepository garmentRepository(Ref ref) => GarmentRepository();
