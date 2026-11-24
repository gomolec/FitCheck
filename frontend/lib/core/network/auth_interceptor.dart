import 'package:dio/dio.dart';

import '../storage/secure_storage.dart';

/// Adds `Authorization: Bearer <token>` to outgoing requests.
///
/// Requests that must be sent without a token pass
/// `Options(extra: {AuthInterceptor.skipAuth: true})`.
///
/// TODO(auth): refresh the token on 401 once the backend exposes a refresh endpoint.
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._tokens);

  static const skipAuth = 'skipAuth';

  final TokenStorage _tokens;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.extra[skipAuth] != true) {
      final token = await _tokens.readAccessToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }
}
