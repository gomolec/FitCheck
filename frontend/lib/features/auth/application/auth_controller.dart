import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/auth_repository.dart';

part 'auth_controller.g.dart';

/// Session state: `true` when a token is stored. Drives the router redirect.
@Riverpod(keepAlive: true)
class AuthController extends _$AuthController {
  @override
  Future<bool> build() => ref.watch(authRepositoryProvider).hasSession();

  Future<void> login({required String email, required String password}) async {
    await ref
        .read(authRepositoryProvider)
        .login(email: email, password: password);
    state = const AsyncData(true);
  }

  Future<void> logout() async {
    await ref.read(authRepositoryProvider).logout();
    state = const AsyncData(false);
  }
}
