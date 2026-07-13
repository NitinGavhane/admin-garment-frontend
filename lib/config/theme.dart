import 'package:flutter/material.dart';

/// Central responsive helper — breakpoints and derived layout values so every
/// screen sizes consistently from phones up to large desktops.
class Responsive {
  // Breakpoints (logical px). The desktop breakpoint is 900 (not 1024) so the
  // full desktop layout also engages for desktop browsers and mobile "Desktop
  // site" mode (~980px), instead of falling back to the compact layout.
  static const double phone = 600;
  static const double tablet = 900;

  // Max width the app is allowed to occupy on very wide screens; keeps the
  // admin panel readable instead of stretching edge-to-edge on a monitor.
  // Sized for the desktop shell: 280px sidebar + ~1100px content.
  static const double maxContentWidth = 1400;

  static bool isPhone(BuildContext c) => MediaQuery.of(c).size.width < phone;
  static bool isTablet(BuildContext c) {
    final w = MediaQuery.of(c).size.width;
    return w >= phone && w < tablet;
  }
  static bool isDesktop(BuildContext c) => MediaQuery.of(c).size.width >= tablet;

  /// Number of columns for card grids given an available width.
  static int gridColumns(double w) {
    if (w >= 1240) return 5;
    if (w >= tablet) return 4;
    if (w >= phone) return 3;
    if (w >= 420) return 2;
    return 1;
  }

  /// Column count tuned for compact stat/quick-action tiles.
  static int compactColumns(double w) {
    if (w >= tablet) return 4;
    if (w >= phone) return 3;
    return 2;
  }

  /// Horizontal page padding that grows a little on larger canvases.
  static double pagePadding(double w) => w >= phone ? 24 : 16;
}

class AppColors {
  static bool _isDark = false;
  static bool get isDark => _isDark;
  static void setDark(bool v) { _isDark = v; }

  // Haze-inspired clean light palette: neutral near-white canvas, pure-white
  // cards, soft hairline borders, and a calm neutral text ramp.
  static const Color _lightBg = Color(0xFFF6F7F9);         // airy neutral canvas
  static const Color _lightBgAlt = Color(0xFFF1F3F6);      // input fills / gutters
  static const Color _lightSurface = Color(0xFFFFFFFF);    // cards
  static const Color _lightSurfaceAlt = Color(0xFFFBFCFD); // near-white (flatter gradients)
  static const Color _lightSurfaceRaised = Color(0xFFFFFFFF);
  static const Color _lightBorder = Color(0xFFE2E5EA);     // visible hairline
  static const Color _lightBorderLight = Color(0xFFEDEFF2);// subtle hairline
  static const Color _lightTextPrimary = Color(0xFF111827);// neutral-900
  static const Color _lightTextSecondary = Color(0xFF4B5563);// neutral-600
  static const Color _lightTextMuted = Color(0xFF9CA3AF);  // neutral-400
  static const Color _lightOverlay = Color(0x26000000);
  static const Color _lightShimmer = Color(0xFFEDEFF2);

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
  static const Color coralDark = Color(0xFF10195E); // deep royal (gradient tail / icons)
  static const Color gold = Color(0xFFC9A227);
  static const Color gold80 = Color(0xFFD9AF4E);
  static const Color gold40 = Color(0xFFEAD9A0);
  // Metallic gold stops — used to simulate brushed/polished gold on premium
  // surfaces (buttons, accents). Ordered light → deep for top-lit gradients.
  static const Color goldHighlight = Color(0xFFF7E9B0); // champagne sheen
  static const Color goldLight = Color(0xFFE4C86A);
  static const Color goldDeep = Color(0xFFA07A17);
  static const Color goldShadow = Color(0xFF7C5E12);
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
  // Polished metallic gold — top-lit, for premium buttons and highlights.
  static const List<Color> goldMetallic = [goldLight, gold, goldDeep];
  // Deep royal-blue metallic gradient for premium dark surfaces.
  static const List<Color> royalMetallic = [Color(0xFF2A3C9E), Color(0xFF1A2A80), Color(0xFF0E1656)];
  static List<Color> get successGradient => [success, success80];
  static List<Color> get errorGradient => [error, error80];
  static List<Color> get bluePurpleGradient => [const Color(0xFF1A2A80), const Color(0xFF243AA0)];
  static List<Color> get darkGradient => [surface, surfaceAlt];
  static List<Color> get bgGradient => _isDark
      ? [bg, const Color(0xFF0A1120)]
      : [bg, const Color(0xFFEDEFF3)];
  static List<Color> get cardGradient => [surface, surfaceRaised];
  static List<Color> get navGradient => _isDark
      ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
      : [const Color(0xFFFFFFFF), const Color(0xFFF4F5F8)];

  // Soft, minimal elevation (Haze/shadcn-style) — barely-there in light mode.
  static List<BoxShadow> get shadowSm => [
    BoxShadow(color: (_isDark ? Colors.white : Colors.black).withValues(alpha: _isDark ? 0.05 : 0.04), blurRadius: 3, offset: const Offset(0, 1)),
  ];
  static List<BoxShadow> get shadowMd => [
    BoxShadow(color: (_isDark ? Colors.white : Colors.black).withValues(alpha: _isDark ? 0.07 : 0.06), blurRadius: 8, offset: const Offset(0, 3)),
    BoxShadow(color: (_isDark ? Colors.white : Colors.black).withValues(alpha: _isDark ? 0.03 : 0.035), blurRadius: 16, offset: const Offset(0, 1)),
  ];
  static List<BoxShadow> get shadowLg => [
    BoxShadow(color: (_isDark ? Colors.white : Colors.black).withValues(alpha: _isDark ? 0.09 : 0.08), blurRadius: 16, offset: const Offset(0, 6)),
    BoxShadow(color: (_isDark ? Colors.white : Colors.black).withValues(alpha: _isDark ? 0.04 : 0.05), blurRadius: 32, offset: const Offset(0, 4)),
  ];
  static List<BoxShadow> shadowGlow(Color c) => [
    BoxShadow(color: c.withValues(alpha: 0.2), blurRadius: 12, offset: const Offset(0, 4)),
    BoxShadow(color: c.withValues(alpha: 0.1), blurRadius: 28, offset: const Offset(0, 8)),
  ];
  // Warm, layered glow for gold surfaces — richer and softer than shadowGlow.
  static List<BoxShadow> get shadowGold => [
    BoxShadow(color: gold.withValues(alpha: 0.35), blurRadius: 14, offset: const Offset(0, 5)),
    BoxShadow(color: goldDeep.withValues(alpha: 0.18), blurRadius: 30, offset: const Offset(0, 12)),
    BoxShadow(color: (_isDark ? Colors.black : goldShadow).withValues(alpha: 0.12), blurRadius: 2, offset: const Offset(0, 1)),
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

  // ── Premium building blocks ───────────────────────────────────────────────
  // Polished metallic-gold surface for primary actions. `radius` lets callers
  // match pills, buttons, and chips. Top-lit gradient + warm glow read as a
  // solid, expensive gold plate rather than a flat fill.
  static BoxDecoration premiumGoldDeco({double radius = 10}) => BoxDecoration(
    gradient: const LinearGradient(
      colors: goldMetallic,
      stops: [0.0, 0.55, 1.0],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
    borderRadius: BorderRadius.circular(radius),
    border: Border.all(color: goldDeep, width: 1),
    boxShadow: shadowGold,
  );

  // Thin top sheen — a highlight line where light catches the metal edge.
  // Layer this above a gold surface with a Positioned/DecoratedBox.
  static BoxDecoration goldSheen({double radius = 10}) => BoxDecoration(
    borderRadius: BorderRadius.circular(radius),
    gradient: LinearGradient(
      colors: [goldHighlight.withValues(alpha: 0.9), Colors.white.withValues(alpha: 0.0)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: const [0.0, 0.5],
    ),
  );

  // Premium card: soft surface gradient with a hairline gold-tinted border and
  // a whisper of gold glow. Used for luxury content containers.
  static BoxDecoration premiumCardDeco({double radius = 14}) => BoxDecoration(
    gradient: LinearGradient(colors: cardGradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
    borderRadius: BorderRadius.circular(radius),
    border: Border.all(color: gold.withValues(alpha: _isDark ? 0.28 : 0.35), width: 1),
    boxShadow: [
      ...shadowMd,
      BoxShadow(color: gold.withValues(alpha: 0.06), blurRadius: 24, offset: const Offset(0, 8)),
    ],
  );

  // A 1px horizontal gold rule that fades at both ends — a refined divider.
  static BoxDecoration get goldHairline => BoxDecoration(
    gradient: LinearGradient(
      colors: [
        gold.withValues(alpha: 0.0),
        gold.withValues(alpha: 0.6),
        goldHighlight.withValues(alpha: 0.9),
        gold.withValues(alpha: 0.6),
        gold.withValues(alpha: 0.0),
      ],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ),
  );
}
