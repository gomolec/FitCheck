import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/application/auth_controller.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import 'app_routes.dart';

part 'app_router.g.dart';

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  // Re-runs `redirect` whenever the session state changes.
  final session = ValueNotifier<AsyncValue<bool>>(const AsyncLoading());
  ref.onDispose(session.dispose);
  ref.listen(
    authControllerProvider,
    (_, next) => session.value = next,
    fireImmediately: true,
  );

  return GoRouter(
    initialLocation: AppRoutes.home,
    refreshListenable: session,
    redirect: (context, state) {
      final loggedIn = session.value.value;
      if (loggedIn == null) return null; // Session still loading.

      final atLogin = state.matchedLocation == AppRoutes.login;
      if (!loggedIn) return atLogin ? null : AppRoutes.login;
      return atLogin ? AppRoutes.home : null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
    ],
  );
}
