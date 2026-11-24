import 'package:fitcheck/features/auth/data/auth_repository.dart';
import 'package:fitcheck/features/auth/presentation/login_screen.dart';
import 'package:fitcheck/features/home/presentation/home_screen.dart';
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
      child: MaterialApp(home: home),
    );

void main() {
  testWidgets('home screen renders', (tester) async {
    await tester.pumpWidget(_app(const HomeScreen(), _FakeAuthRepository()));

    expect(find.text('FitCheck'), findsOneWidget);
    expect(find.text('Wyloguj'), findsOneWidget);
  });

  testWidgets('login screen shows backend error message', (tester) async {
    final repo = _FakeAuthRepository(
      loginError: const AuthException('Błędny email lub hasło'),
    );
    await tester.pumpWidget(_app(const LoginScreen(), repo));

    await tester.enterText(find.byType(TextField).first, 'a@b.pl');
    await tester.enterText(find.byType(TextField).last, 'zle');
    await tester.tap(find.text('Zaloguj'));
    await tester.pumpAndSettle();

    expect(find.text('Błędny email lub hasło'), findsOneWidget);
    expect(repo.loggedIn, isFalse);
  });

  testWidgets('successful login stores the session', (tester) async {
    final repo = _FakeAuthRepository();
    await tester.pumpWidget(_app(const LoginScreen(), repo));

    await tester.tap(find.text('Zaloguj'));
    await tester.pumpAndSettle();

    expect(repo.loggedIn, isTrue);
  });
}
