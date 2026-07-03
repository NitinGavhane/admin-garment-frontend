import 'package:flutter/material.dart';

class AppColors {
  static bool _isDark = false;
  static bool get isDark => _isDark;
  static void setDark(bool v) { _isDark = v; }

  static const Color _lightBg = Color(0xFFF0F4F8);
  static const Color _lightBgAlt = Color(0xFFE2E8F0);
  static const Color _lightSurface = Color(0xFFFFFFFF);
  static const Color _lightSurfaceAlt = Color(0xFFF8FAFC);
  static const Color _lightSurfaceRaised = Color(0xFFFFFFFF);
  static const Color _lightBorder = Color(0xFFCBD5E1);
  static const Color _lightBorderLight = Color(0xFFE2E8F0);
  static const Color _lightTextPrimary = Color(0xFF0F172A);
  static const Color _lightTextSecondary = Color(0xFF475569);
  static const Color _lightTextMuted = Color(0xFF94A3B8);
  static const Color _lightOverlay = Color(0x30000000);
  static const Color _lightShimmer = Color(0xFFE2E8F0);

  static const Color _darkBg = Color(0xFF0F172A);
  static const Color _darkBgAlt = Color(0xFF1E293B);
  static const Color _darkSurface = Color(0xFF1E293B);
  static const Color _darkSurfaceAlt = Color(0xFF334155);
  static const Color _darkSurfaceRaised = Color(0xFF475569);
  static const Color _darkBorder = Color(0xFF475569);
  static const Color _darkBorderLight = Color(0xFF334155);
  static const Color _darkTextPrimary = Color(0xFFF1F5F9);
  static const Color _darkTextSecondary = Color(0xFF94A3B8);
  static const Color _darkTextMuted = Color(0xFF64748B);
  static const Color _darkOverlay = Color(0x40FFFFFF);
  static const Color _darkShimmer = Color(0xFF334155);

  static Color get bg => _isDark ? _darkBg : _lightBg;
  static Color get bgAlt => _isDark ? _darkBgAlt : _lightBgAlt;
  static Color get surface => _isDark ? _darkSurface : _lightSurface;
  static Color get surfaceAlt => _isDark ? _darkSurfaceAlt : _lightSurfaceAlt;
  static Color get surfaceRaised => _isDark ? _darkSurfaceRaised : _lightSurfaceRaised;
  static Color get border => _isDark ? _darkBorder : _lightBorder;
  static Color get borderLight => _isDark ? _darkBorderLight : _lightBorderLight;
  static Color get textPrimary => _isDark ? _darkTextPrimary : _lightTextPrimary;
  static Color get textSecondary => _isDark ? _darkTextSecondary : _lightTextSecondary;
  static Color get textMuted => _isDark ? _darkTextMuted : _lightTextMuted;
  static Color get overlay => _isDark ? _darkOverlay : _lightOverlay;
  static Color get shimmer => _isDark ? _darkShimmer : _lightShimmer;

  // ── Dristi Fashions brand (royal blue + gold, from the logo) ──────────────
  // `coral` is the primary brand accent (branding, active states, labels).
  static const Color coral = Color(0xFF1A2A80);   // royal blue
  static const Color coral80 = Color(0xFF243AA0); // brighter royal
  static const Color coral40 = Color(0xFFB9C0E0); // light royal
  static const Color gold = Color(0xFFC9A227);
  static const Color gold80 = Color(0xFFD9AF4E);
  static const Color gold40 = Color(0xFFEAD9A0);
  static const Color success = Color(0xFF16A34A);
  static const Color success80 = Color(0xFF45B56E);
  static const Color success40 = Color(0xFFA2DAB7);
  static const Color error = Color(0xFFDC2626);
  static const Color error80 = Color(0xFFE35151);
  static const Color error40 = Color(0xFFF1A8A8);
  static const Color info = Color(0xFF0EA5E9);
  static const Color info80 = Color(0xFF3EB7ED);
  static const Color info40 = Color(0xFF9FDBF6);
  // `purple` was a secondary accent (stat cards) — remapped to royal blue.
  static const Color purple = Color(0xFF243AA0);
  static const Color purple80 = Color(0xFF3A4FB0);
  static const Color purple40 = Color(0xFFA6AED6);
  static const Color teal = Color(0xFF0D9488);
  static const Color teal80 = Color(0xFF3DA9A0);
  static const Color teal40 = Color(0xFF9ED4CF);
  static const Color warning = Color(0xFFF59E0B);
  // `btnColor` is the primary action (buttons) — gold, with dark text/icons.
  static const Color btnColor = Color(0xFFC9A227);
  static const Color btnColor80 = Color(0xFFD9AF4E);
  static const Color btnColor40 = Color(0xFFEAD9A0);
  static const Color btnBorder = Color(0xFFA8841C);

  static List<Color> get coralGradient => [coral, coral80];
  static List<Color> get goldGradient => [gold, gold80];
  static List<Color> get successGradient => [success, success80];
  static List<Color> get errorGradient => [error, error80];
  static List<Color> get bluePurpleGradient => [const Color(0xFF1A2A80), const Color(0xFF243AA0)];
  static List<Color> get darkGradient => [surface, surfaceAlt];
  static List<Color> get bgGradient => _isDark
      ? [bg, const Color(0xFF0A1120)]
      : [bg, const Color(0xFFE2E8F0)];
  static List<Color> get cardGradient => [surface, surfaceRaised];
  static List<Color> get navGradient => _isDark
      ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
      : [const Color(0xFFDBE4F0), const Color(0xFFC8D4E4)];

  static List<BoxShadow> get shadowSm => [
    BoxShadow(color: (_isDark ? Colors.white : Colors.black).withValues(alpha: _isDark ? 0.06 : 0.08), blurRadius: 4, offset: const Offset(0, 2)),
  ];
  static List<BoxShadow> get shadowMd => [
    BoxShadow(color: (_isDark ? Colors.white : Colors.black).withValues(alpha: _isDark ? 0.08 : 0.1), blurRadius: 8, offset: const Offset(0, 4)),
    BoxShadow(color: (_isDark ? Colors.white : Colors.black).withValues(alpha: _isDark ? 0.04 : 0.06), blurRadius: 16, offset: const Offset(0, 2)),
  ];
  static List<BoxShadow> get shadowLg => [
    BoxShadow(color: (_isDark ? Colors.white : Colors.black).withValues(alpha: _isDark ? 0.1 : 0.12), blurRadius: 16, offset: const Offset(0, 6)),
    BoxShadow(color: (_isDark ? Colors.white : Colors.black).withValues(alpha: _isDark ? 0.04 : 0.06), blurRadius: 32, offset: const Offset(0, 4)),
  ];
  static List<BoxShadow> shadowGlow(Color c) => [
    BoxShadow(color: c.withValues(alpha: 0.2), blurRadius: 12, offset: const Offset(0, 4)),
    BoxShadow(color: c.withValues(alpha: 0.1), blurRadius: 28, offset: const Offset(0, 8)),
  ];
  static List<BoxShadow> get shadowInset => [
    BoxShadow(color: (_isDark ? Colors.white : Colors.black).withValues(alpha: _isDark ? 0.04 : 0.06), blurRadius: 2, offset: const Offset(0, 1)),
  ];

  static BoxDecoration get cardDeco => BoxDecoration(
    gradient: LinearGradient(colors: cardGradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
    borderRadius: BorderRadius.circular(10),
    border: Border.all(color: borderLight, width: 1),
    boxShadow: shadowMd,
  );

  static BoxDecoration cardDecoGlow(Color accent) => BoxDecoration(
    gradient: LinearGradient(colors: cardGradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
    borderRadius: BorderRadius.circular(10),
    border: Border.all(color: accent.withValues(alpha: 0.3), width: 1),
    boxShadow: shadowGlow(accent),
  );

  static BoxDecoration get glassDeco => BoxDecoration(
    gradient: LinearGradient(
      colors: _isDark
          ? [const Color(0xCC1E293B), const Color(0x660F172A)]
          : [Colors.white.withValues(alpha: 0.8), Colors.white.withValues(alpha: 0.4)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(10),
    border: Border.all(color: _isDark ? const Color(0x33FFFFFF) : Colors.white.withValues(alpha: 0.9), width: 1),
    boxShadow: [
      BoxShadow(color: (_isDark ? Colors.white : Colors.black).withValues(alpha: 0.08), blurRadius: 8, offset: const Offset(0, 4)),
      BoxShadow(color: (_isDark ? Colors.white : Colors.black).withValues(alpha: 0.04), blurRadius: 1, offset: const Offset(0, 1)),
    ],
  );

  static BoxDecoration get inputDeco => BoxDecoration(
    color: bgAlt,
    borderRadius: BorderRadius.circular(6),
    border: Border.all(color: border, width: 1),
  );

  static BoxDecoration get inputDecoFocused => BoxDecoration(
    color: bgAlt,
    borderRadius: BorderRadius.circular(6),
    border: Border.all(color: btnColor.withValues(alpha: 0.6), width: 1.5),
    boxShadow: [
      BoxShadow(color: btnColor.withValues(alpha: 0.08), blurRadius: 6, offset: const Offset(0, 0)),
    ],
  );

  static Decoration get cornerAccent => BoxDecoration(
    gradient: const LinearGradient(colors: [Color(0xFF1A2A80), Color(0xFF243AA0)], begin: Alignment.topLeft, end: Alignment.bottomRight),
    borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
  );

  static BoxDecoration get headerDeco => BoxDecoration(
    gradient: LinearGradient(
      colors: [surface, surfaceAlt],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
    border: Border(
      bottom: BorderSide(color: borderLight, width: 1),
    ),
    boxShadow: shadowSm,
  );
}
