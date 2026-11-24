import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/auth_interceptor.dart';
import '../../../core/network/dio_provider.dart';
import '../../../core/storage/secure_storage.dart';

part 'auth_repository.g.dart';

/// Thrown when an auth request fails; [message] is safe to show to the user.
class AuthException implements Exception {
  const AuthException(this.message);

  final String message;

  @override
  String toString() => 'AuthException: $message';
}

/// Talks to the backend `api/auth` endpoints and persists the session token.
class AuthRepository {
  AuthRepository(this._dio, this._tokens);

  final Dio _dio;
  final TokenStorage _tokens;

  Future<bool> hasSession() async {
    final token = await _tokens.readAccessToken();
    return token != null && token.isNotEmpty;
  }

  /// `POST auth/login` → `{ token }`. Stores the token on success.
  Future<void> login({required String email, required String password}) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        'auth/login',
        data: {'email': email, 'password': password},
        options: Options(extra: {AuthInterceptor.skipAuth: true}),
      );
      final token = response.data?['token'];
      if (token is! String || token.isEmpty) {
        throw const AuthException('Serwer nie zwrócił tokenu.');
      }
      await _tokens.saveTokens(accessToken: token);
    } on DioException catch (e) {
      throw _toAuthException(e);
    }
  }

  Future<void> logout() => _tokens.clear();

  AuthException _toAuthException(DioException e) {
    final data = e.response?.data;
    if (data is Map && data['message'] is String) {
      return AuthException(data['message'] as String);
    }
    return switch (e.type) {
      DioExceptionType.connectionError ||
      DioExceptionType.connectionTimeout ||
      DioExceptionType.receiveTimeout =>
        const AuthException('Brak połączenia z serwerem.'),
      _ => const AuthException('Coś poszło nie tak. Spróbuj ponownie.'),
    };
  }
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) =>
    AuthRepository(ref.watch(dioProvider), ref.watch(tokenStorageProvider));
