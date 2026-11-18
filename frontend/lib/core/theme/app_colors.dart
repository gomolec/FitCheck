import 'package:material_ui/material_ui.dart';

class AppColors extends ThemeExtension<AppColors> {
  final Color ground;
  final Color surface;
  final Color sunken;
  final Color ink;
  final Color ink2;
  final Color inkInverse;

  // Post-it notes
  final Color noteYellow;
  final Color noteOrange;
  final Color noteGreen;
  final Color notePink;
  final Color tape;

  // Statuses
  final Color ok;
  final Color okBg;
  final Color warn;
  final Color warnBg;
  final Color bad;
  final Color badBg;

  const AppColors({
    required this.ground,
    required this.surface,
    required this.sunken,
    required this.ink,
    required this.ink2,
    required this.inkInverse,
    required this.noteYellow,
    required this.noteOrange,
    required this.noteGreen,
    required this.notePink,
    required this.tape,
    required this.ok,
    required this.okBg,
    required this.warn,
    required this.warnBg,
    required this.bad,
    required this.badBg,
  });

  // Wartości dla trybu jasnego (z Twojej Figmy)
  static const light = AppColors(
    ground: Color(0xFFF1F1EE),
    surface: Color(0xFFFFFFFF),
    sunken: Color(0xFFE4E4E0),
    ink: Color(0xFF111111),
    ink2: Color(0xFF555550),
    inkInverse: Color(0xFFFFFFFF),
    noteYellow: Color(0xFFF5FF65),
    noteOrange: Color(0xFFF0903E),
    noteGreen: Color(0xFF7AED87),
    notePink: Color(0xFFED6AA6),
    tape: Color(0x8CCFCFC5), // 55% opacity dla #cfcfc5
    ok: Color(0xFF336A47),
    okBg: Color(0xFFE1F0E5),
    warn: Color(0xFF90501F),
    warnBg: Color(0xFFF8E9D6),
    bad: Color(0xFFA53428),
    badBg: Color(0xFFF9E2E2),
  );

  // Generowane wartości dla trybu ciemnego (odwrócone jasności)
  static const dark = AppColors(
    ground: Color(0xFF111111),
    surface: Color(0xFF1C1C1C),
    sunken: Color(0xFF2A2A28),
    ink: Color(0xFFF1F1EE),
    ink2: Color(0xFFA0A09C),
    inkInverse: Color(0xFF111111),
    noteYellow: Color(0xFFD4DD4A),
    noteOrange: Color(0xFFD4792E),
    noteGreen: Color(0xFF62C96C),
    notePink: Color(0xFFD2528C),
    tape: Color(0x8C4A4A45),
    ok: Color(0xFF66B981),
    okBg: Color(0xFF21442E),
    warn: Color(0xFFD8894F),
    warnBg: Color(0xFF583113),
    bad: Color(0xFFE56A5D),
    badBg: Color(0xFF672018),
  );

  @override
  AppColors copyWith() {
    return this;
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      ground: Color.lerp(ground, other.ground, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      sunken: Color.lerp(sunken, other.sunken, t)!,
      ink: Color.lerp(ink, other.ink, t)!,
      ink2: Color.lerp(ink2, other.ink2, t)!,
      inkInverse: Color.lerp(inkInverse, other.inkInverse, t)!,
      noteYellow: Color.lerp(noteYellow, other.noteYellow, t)!,
      noteOrange: Color.lerp(noteOrange, other.noteOrange, t)!,
      noteGreen: Color.lerp(noteGreen, other.noteGreen, t)!,
      notePink: Color.lerp(notePink, other.notePink, t)!,
      tape: Color.lerp(tape, other.tape, t)!,
      ok: Color.lerp(ok, other.ok, t)!,
      okBg: Color.lerp(okBg, other.okBg, t)!,
      warn: Color.lerp(warn, other.warn, t)!,
      warnBg: Color.lerp(warnBg, other.warnBg, t)!,
      bad: Color.lerp(bad, other.bad, t)!,
      badBg: Color.lerp(badBg, other.badBg, t)!,
    );
  }
}
