import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'preferences.g.dart';

/// SharedPreferences instance.
///
/// Created asynchronously in `main()` and injected via
/// `ProviderScope(overrides: [...])`.
@Riverpod(keepAlive: true)
SharedPreferences sharedPreferences(Ref ref) => throw UnimplementedError(
      'sharedPreferencesProvider must be overridden in main()',
    );
