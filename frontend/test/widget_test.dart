import 'package:fitcheck/core/theme/app_theme.dart';
import 'package:fitcheck/core/widgets/bottom_nav_bar.dart';
import 'package:fitcheck/features/auth/data/auth_repository.dart';
import 'package:fitcheck/features/auth/presentation/login_screen.dart';
import 'package:fitcheck/features/check/presentation/check_screen.dart';
import 'package:fitcheck/features/measurements/presentation/measurements_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

/// Repository stub that never touches the network or secure storage.
class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository({this.loginError});

  final AuthException? loginError;
  bool loggedIn = false;

  @override
  Future<bool> hasSession() async => loggedIn;

  @override
  Future<void> login({required String email, required String password}) async {
    if (loginError != null) throw loginError!;
    loggedIn = true;
  }

  @override
  Future<void> logout() async => loggedIn = false;
}

Widget _app(Widget home, _FakeAuthRepository repo) => ProviderScope(
  overrides: [authRepositoryProvider.overrideWithValue(repo)],
  child: MaterialApp(theme: AppTheme.light, home: home),
);

void main() {
  testWidgets('check screen renders FitCheck hero', (tester) async {
    await tester.pumpWidget(_app(const CheckScreen(), _FakeAuthRepository()));

    expect(find.text('FitCheck'), findsOneWidget);
    expect(find.text('Sprawdź'), findsOneWidget);
  });

  testWidgets('measurements screen renders logout action', (tester) async {
    await tester.pumpWidget(
      _app(const MeasurementsScreen(), _FakeAuthRepository()),
    );

    expect(find.text('Wymiary'), findsOneWidget);
    expect(find.text('Wyloguj'), findsOneWidget);
  });

  testWidgets('bottom nav bar notifies on tab tap', (tester) async {
    var tappedIndex = -1;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          bottomNavigationBar: FitCheckBottomNavBar(
            currentIndex: 0,
            onTap: (index) => tappedIndex = index,
          ),
        ),
      ),
    );

    await tester.tap(find.text('Dodaj'));
    expect(tappedIndex, 1);

    await tester.tap(find.text('Ubrania'));
    expect(tappedIndex, 2);

    await tester.tap(find.text('Wymiary'));
    expect(tappedIndex, 3);
  });

  testWidgets('login screen shows backend error message', (tester) async {
    final repo = _FakeAuthRepository(
      loginError: const AuthException('Błędny email lub hasło'),
    );
    await tester.pumpWidget(_app(const LoginScreen(), repo));

    await tester.enterText(find.byType(TextField).first, 'a@b.pl');
    await tester.enterText(find.byType(TextField).last, 'zle');
    await tester.ensureVisible(find.text('Zaloguj'));
    await tester.tap(find.text('Zaloguj'));
    await tester.pumpAndSettle();

    expect(find.text('Błędny email lub hasło'), findsOneWidget);
    expect(repo.loggedIn, isFalse);
  });

  testWidgets('successful login stores the session', (tester) async {
    final repo = _FakeAuthRepository();
    await tester.pumpWidget(_app(const LoginScreen(), repo));

    await tester.ensureVisible(find.text('Zaloguj'));
    await tester.tap(find.text('Zaloguj'));
    await tester.pumpAndSettle();

    expect(repo.loggedIn, isTrue);
  });
}
