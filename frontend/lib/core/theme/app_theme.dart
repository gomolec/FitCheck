import 'package:fitcheck/core/theme/app_typography.dart';
import 'package:material_ui/material_ui.dart';

import 'app_colors.dart';

class AppTheme {
  static ThemeData get light => _buildTheme(Brightness.light, AppColors.light);

  static ThemeData get dark => _buildTheme(Brightness.dark, AppColors.dark);

  static ThemeData _buildTheme(Brightness brightness, AppColors colors) {
    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: colors.ink,
      onPrimary: colors.inkInverse,
      secondary: colors.noteYellow,
      onSecondary: colors.ink,
      error: colors.bad,
      onError: colors.inkInverse,
      surface: colors.surface,
      onSurface: colors.ink,
      onSurfaceVariant: colors.ink2,
      outline: colors.ink2,
      outlineVariant: colors.sunken,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colors.ground,
      fontFamily: 'Rubik',
      iconTheme: IconThemeData(color: colors.ink),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: colors.ink,
        selectionColor: colors.noteYellow.withValues(alpha: 0.45),
        selectionHandleColor: colors.ink,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colors.ground,
        foregroundColor: colors.ink,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: AppTypography.instance.heading.copyWith(
          color: colors.ink,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.ink,
          foregroundColor: colors.inkInverse,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: colors.ink),
      ),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: AppTypography.instance.label.copyWith(color: colors.ink2),
        floatingLabelStyle: AppTypography.instance.small.copyWith(
          color: colors.ink,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: colors.sunken),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: colors.ink, width: 2),
        ),
      ),
      extensions: [colors, AppTypography.instance],
    );
  }
}
