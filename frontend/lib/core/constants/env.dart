import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Environment configuration loaded from the git-ignored `env/app.env` asset.
///
/// The file is optional; see `env/app.env.example` for available keys.
abstract final class Env {
  static const _file = 'env/app.env';

  static Future<void> load() => dotenv.load(fileName: _file, isOptional: true);

  /// Backend REST API base URL. Falls back to the local backend
  /// as seen from the Android emulator.
  static String get apiBaseUrl => withTrailingSlash(
        dotenv.maybeGet('API_BASE_URL') ?? 'http://10.0.2.2:5232/api',
      );

  /// Dio joins `baseUrl` and a relative path verbatim, so `.../api` +
  /// `auth/login` would become `.../apiauth/login` without the slash.
  static String withTrailingSlash(String url) =>
      url.endsWith('/') ? url : '$url/';
}
