import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/theme/theme_context_extension.dart';
import '../application/auth_controller.dart';
import '../data/auth_repository.dart';

/// Login screen styled with the FitCheck post-it design system.
/// Navigation after success is handled by the router redirect.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await ref
          .read(authControllerProvider.notifier)
          .login(email: _email.text.trim(), password: _password.text);
    } on AuthException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.ground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLogoHeader(context),
              _buildHeroPostIt(context),
              const Gap(24),
              _buildForm(context),
              const Gap(24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Transform.rotate(
        angle: -0.04,
        child: Container(
          color: context.colors.noteYellow,
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Text(
            'FitCheck',
            style: context.typo.markerLogo.copyWith(color: context.colors.ink),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroPostIt(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Transform.rotate(
          angle: -0.05,
          child: Container(
            width: double.infinity,
            color: context.colors.notePink,
            padding: const EdgeInsets.only(
              top: 32,
              bottom: 40,
              left: 24,
              right: 24,
            ),
            margin: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ZALOGUJ\nSIĘ!',
                  style: context.typo.markerXl.copyWith(
                    color: context.colors.ink,
                  ),
                ),
                const Gap(16),
                Text(
                  'wejdź do swojej szafy',
                  style: context.typo.markerM.copyWith(
                    color: context.colors.ink,
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 8,
          left: -10,
          child: Transform.rotate(
            angle: -0.3,
            child: Container(
              width: 100,
              height: 32,
              color: context.colors.tape,
            ),
          ),
        ),
        Positioned(
          top: -5,
          right: -10,
          child: Transform.rotate(
            angle: -0.15,
            child: Container(
              width: 120,
              height: 32,
              color: context.colors.tape,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInputField(
            context,
            label: 'Email',
            controller: _email,
            hintText: 'admin@fitcheck.pl',
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.email],
            textInputAction: TextInputAction.next,
          ),
          const Gap(16),
          _buildInputField(
            context,
            label: 'Hasło',
            controller: _password,
            hintText: '••••••••',
            obscureText: true,
            autofillHints: const [AutofillHints.password],
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _submit(),
          ),
          if (_error != null) ...[
            const Gap(16),
            Container(
              width: double.infinity,
              color: context.colors.badBg,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Text(
                _error!,
                style: context.typo.small.copyWith(color: context.colors.bad),
              ),
            ),
          ],
          const Gap(24),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colors.ink,
                foregroundColor: context.colors.inkInverse,
                disabledBackgroundColor: context.colors.sunken,
                disabledForegroundColor: context.colors.ink2,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
              onPressed: _loading ? null : _submit,
              child: Text(
                _loading ? 'Logowanie...' : 'Zaloguj',
                style: context.typo.label,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(
    BuildContext context, {
    required String label,
    required TextEditingController controller,
    required String hintText,
    bool obscureText = false,
    TextInputType? keyboardType,
    Iterable<String>? autofillHints,
    TextInputAction? textInputAction,
    ValueChanged<String>? onSubmitted,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.typo.label.copyWith(color: context.colors.ink),
        ),
        const Gap(8),
        Container(
          color: context.colors.surface,
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            autofillHints: autofillHints,
            textInputAction: textInputAction,
            onSubmitted: onSubmitted,
            style: context.typo.body.copyWith(color: context.colors.ink),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: context.typo.body.copyWith(color: context.colors.ink2),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
