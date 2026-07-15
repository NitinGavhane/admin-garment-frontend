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

  // Lexron-inspired light palette: soft lavender canvas, pure-white cards,
  // gentle violet-tinted hairlines, and a calm neutral text ramp.
  static const Color _lightBg = Color(0xFFF3F0FC);         // airy lavender canvas
  static const Color _lightBgAlt = Color(0xFFECE8F9);      // input fills / gutters (lilac)
  static const Color _lightSurface = Color(0xFFFFFFFF);    // cards
  static const Color _lightSurfaceAlt = Color(0xFFFBFAFE); // near-white lilac (flatter gradients)
  static const Color _lightSurfaceRaised = Color(0xFFFFFFFF);
  static const Color _lightBorder = Color(0xFFE5DFF6);     // visible lavender hairline
  static const Color _lightBorderLight = Color(0xFFEFEBFA);// subtle lavender hairline
  static const Color _lightTextPrimary = Color(0xFF1E1B33);// deep ink (violet-tinted)
  static const Color _lightTextSecondary = Color(0xFF544F6B);// muted violet-grey
  static const Color _lightTextMuted = Color(0xFF9B93B5);  // soft lilac-grey
  static const Color _lightOverlay = Color(0x26000000);
  static const Color _lightShimmer = Color(0xFFEDEAF8);

  static const Color _darkBg = Color(0xFF17132A);          // deep indigo-violet
  static const Color _darkBgAlt = Color(0xFF221B3D);
  static const Color _darkSurface = Color(0xFF221B3D);
  static const Color _darkSurfaceAlt = Color(0xFF2E2650);
  static const Color _darkSurfaceRaised = Color(0xFF3A3060);
  static const Color _darkBorder = Color(0xFF3A3060);
  static const Color _darkBorderLight = Color(0xFF2E2650);
  static const Color _darkTextPrimary = Color(0xFFF3F0FC);
  static const Color _darkTextSecondary = Color(0xFFB4A9D6);
  static const Color _darkTextMuted = Color(0xFF7C709F);
  static const Color _darkOverlay = Color(0x40FFFFFF);
  static const Color _darkShimmer = Color(0xFF2E2650);

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

  // ── Lexron violet brand palette ───────────────────────────────────────────
  // `coral` is the primary brand accent (branding, active states, labels).
  // (Token names kept for a drop-in reskin; the values are now the violet set.)
  static const Color coral = Color(0xFF8B5CF6);   // violet-500 (primary)
  static const Color coral80 = Color(0xFFA78BFA); // violet-400
  static const Color coral40 = Color(0xFFDDD6FE); // violet-200
  static const Color coralDark = Color(0xFF6D28D9); // violet-700 (deep text / icons on light plates)
  // `gold` is the secondary accent — recolored to a rich violet. Standalone
  // uses (icons/labels on light surfaces) read as violet-600.
  static const Color gold = Color(0xFF7C3AED);   // violet-600
  static const Color gold80 = Color(0xFF8B5CF6); // violet-500
  static const Color gold40 = Color(0xFFC4B5FD); // violet-300
  // Soft lilac "plate" stops — used for premium button/pill surfaces. Kept
  // light end-to-end so deep-violet `coralDark` text stays legible on them.
  static const Color goldHighlight = Color(0xFFF5F3FF); // lilac sheen
  static const Color goldLight = Color(0xFFEDE9FE);
  static const Color goldDeep = Color(0xFFC4B5FD);
  static const Color goldShadow = Color(0xFFA78BFA);
  static const Color success = Color(0xFF16A34A);
  static const Color success80 = Color(0xFF45B56E);
  static const Color success40 = Color(0xFFA2DAB7);
  static const Color error = Color(0xFFE11D48);
  static const Color error80 = Color(0xFFEB5678);
  static const Color error40 = Color(0xFFF5A3B6);
  static const Color info = Color(0xFF6366F1);
  static const Color info80 = Color(0xFF868BF5);
  static const Color info40 = Color(0xFFC1C3FA);
  // `purple` — secondary accent (stat tiles), the core Lexron violet.
  static const Color purple = Color(0xFF8B5CF6);
  static const Color purple80 = Color(0xFFA78BFA);
  static const Color purple40 = Color(0xFFDDD6FE);
  static const Color teal = Color(0xFF0D9488);
  static const Color teal80 = Color(0xFF3DA9A0);
  static const Color teal40 = Color(0xFF9ED4CF);
  static const Color warning = Color(0xFFF59E0B);
  // `btnColor` — saturated violet action gradient with light lilac border.
  static const Color btnColor = Color(0xFF8B5CF6);
  static const Color btnColor80 = Color(0xFF7C3AED);
  static const Color btnColor40 = Color(0xFFC4B5FD);
  static const Color btnBorder = Color(0xFFD8CEF8);

  static List<Color> get coralGradient => [coral, coral80];
  static List<Color> get goldGradient => [gold, gold80];
  // Soft lilac plate — top-lit, for premium buttons and pills (violet-100→300).
  static const List<Color> goldMetallic = [Color(0xFFEDE9FE), Color(0xFFDDD6FE), Color(0xFFC4B5FD)];
  // Saturated violet gradient for premium/hero surfaces (stat cards) — white text.
  static const List<Color> royalMetallic = [Color(0xFF8B5CF6), Color(0xFF7C3AED), Color(0xFF6D28D9)];
  static List<Color> get successGradient => [success, success80];
  static List<Color> get errorGradient => [error, error80];
  static List<Color> get bluePurpleGradient => [const Color(0xFF8B5CF6), const Color(0xFFA78BFA)];
  static List<Color> get darkGradient => [surface, surfaceAlt];
  static List<Color> get bgGradient => _isDark
      ? [bg, const Color(0xFF0F0B1E)]
      : [bg, const Color(0xFFE7E0F8)];
  static List<Color> get cardGradient => [surface, surfaceRaised];
  static List<Color> get navGradient => _isDark
      ? [const Color(0xFF221B3D), const Color(0xFF17132A)]
      : [const Color(0xFFFFFFFF), const Color(0xFFF6F3FD)];

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
    borderRadius: BorderRadius.circular(16),
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
    gradient: const LinearGradient(colors: [Color(0xFF8B5CF6), Color(0xFFA78BFA)], begin: Alignment.topLeft, end: Alignment.bottomRight),
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
