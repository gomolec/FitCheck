import 'package:fitcheck/core/theme/app_typography.dart';
import 'package:material_ui/material_ui.dart';

import 'app_colors.dart';

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.light.ground,
      brightness: Brightness.light,
      extensions: const [AppColors.light, AppTypography.instance],
    );
  }

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.dark.ground,
      brightness: Brightness.dark,
      extensions: const [AppColors.dark, AppTypography.instance],
    );
  }
}
