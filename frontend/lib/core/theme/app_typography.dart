import 'package:material_ui/material_ui.dart';

class AppTypography extends ThemeExtension<AppTypography> {
  final TextStyle markerHero;
  final TextStyle markerDisplay;
  final TextStyle markerXxl;
  final TextStyle markerXl;
  final TextStyle markerL;
  final TextStyle markerM;
  final TextStyle markerS;
  final TextStyle markerLogo;

  final TextStyle title;
  final TextStyle heading;
  final TextStyle body;
  final TextStyle label;
  final TextStyle small;
  final TextStyle figure;
  final TextStyle code;

  const AppTypography({
    required this.markerHero,
    required this.markerDisplay,
    required this.markerXxl,
    required this.markerXl,
    required this.markerL,
    required this.markerM,
    required this.markerS,
    required this.markerLogo,
    required this.title,
    required this.heading,
    required this.body,
    required this.label,
    required this.small,
    required this.figure,
    required this.code,
  });

  static const instance = AppTypography(
    markerHero: TextStyle(
      fontFamily: 'CaveatBrush',
      fontWeight: FontWeight.w400,
      fontSize: 190,
      height: 160 / 190,
    ),
    markerDisplay: TextStyle(
      fontFamily: 'CaveatBrush',
      fontWeight: FontWeight.w400,
      fontSize: 150,
      height: 128 / 150,
    ),
    markerXxl: TextStyle(
      fontFamily: 'CaveatBrush',
      fontWeight: FontWeight.w400,
      fontSize: 112,
      height: 98 / 112,
    ),
    markerXl: TextStyle(
      fontFamily: 'CaveatBrush',
      fontWeight: FontWeight.w400,
      fontSize: 84,
      height: 76 / 84,
    ),
    markerL: TextStyle(
      fontFamily: 'CaveatBrush',
      fontWeight: FontWeight.w400,
      fontSize: 56,
      height: 52 / 56,
    ),
    markerM: TextStyle(
      fontFamily: 'CaveatBrush',
      fontWeight: FontWeight.w400,
      fontSize: 36,
      height: 34 / 36,
    ),
    markerS: TextStyle(
      fontFamily: 'CaveatBrush',
      fontWeight: FontWeight.w400,
      fontSize: 22,
      height: 22 / 22,
    ),
    markerLogo: TextStyle(
      fontFamily: 'CaveatBrush',
      fontWeight: FontWeight.w400,
      fontSize: 28,
      height: 28 / 28,
    ),

    title: TextStyle(
      fontFamily: 'Rubik',
      fontWeight: FontWeight.w700,
      fontSize: 28,
      height: 34 / 28,
      letterSpacing: -0.28,
    ),
    heading: TextStyle(
      fontFamily: 'Rubik',
      fontWeight: FontWeight.w600,
      fontSize: 20,
      height: 26 / 20,
    ),
    body: TextStyle(
      fontFamily: 'Rubik',
      fontWeight: FontWeight.w400,
      fontSize: 16,
      height: 24 / 16,
    ),
    label: TextStyle(
      fontFamily: 'Rubik',
      fontWeight: FontWeight.w500,
      fontSize: 15,
      height: 20 / 15,
    ),
    small: TextStyle(
      fontFamily: 'Rubik',
      fontWeight: FontWeight.w400,
      fontSize: 13,
      height: 18 / 13,
    ),
    figure: TextStyle(
      fontFamily: 'Rubik',
      fontWeight: FontWeight.w500,
      fontSize: 22,
      height: 28 / 22,
    ),
    code: TextStyle(
      fontFamily: 'Rubik',
      fontWeight: FontWeight.w700,
      fontSize: 14,
      height: 18 / 14,
    ),
  );

  @override
  AppTypography copyWith() => this;

  @override
  AppTypography lerp(ThemeExtension<AppTypography>? other, double t) {
    if (other is! AppTypography) return this;
    return this;
  }
}
