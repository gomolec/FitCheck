import 'package:material_ui/material_ui.dart';

import 'app_colors.dart';
import 'app_typography.dart';

extension ThemeContextExtension on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;

  AppTypography get typo => Theme.of(this).extension<AppTypography>()!;
}
