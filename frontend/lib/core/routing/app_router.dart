import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/add_garment/presentation/add_garment_screen.dart';
import '../../features/auth/application/auth_controller.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/check/presentation/check_screen.dart';
import '../../features/measurements/presentation/measurements_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/wardrobe/presentation/wardrobe_screen.dart';
import 'app_routes.dart';
import 'main_shell.dart';

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
    initialLocation: AppRoutes.check,
    refreshListenable: session,
    redirect: (context, state) {
      final loggedIn = session.value.value;
      if (loggedIn == null) return null; // Session still loading.

      final atLogin = state.matchedLocation == AppRoutes.login;
      if (!loggedIn) return atLogin ? null : AppRoutes.login;
      return atLogin ? AppRoutes.check : null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.check,
                builder: (context, state) => const CheckScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.addGarment,
                builder: (context, state) => const AddGarmentScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.wardrobe,
                builder: (context, state) => const WardrobeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.settings,
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.measurements,
        builder: (context, state) => const MeasurementsScreen(),
      ),
    ],
  );
}
