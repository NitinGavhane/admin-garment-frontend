import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/theme.dart';
import 'providers/theme_provider.dart';
import 'services/api_service.dart';

class BrandHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onMenuTap;

  const BrandHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 12,
        left: 0, right: 0, bottom: 0,
      ),
      decoration: AppColors.headerDeco,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Row(
              children: [
                GestureDetector(
                  onTap: onMenuTap,
                  child: Container(
                    width: 42, height: 42,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.surfaceRaised, AppColors.surfaceAlt],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      border: Border.all(color: AppColors.borderLight, width: 1),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: AppColors.shadowSm,
                    ),
                    child: Icon(Icons.menu, color: AppColors.textSecondary, size: 18),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: [AppColors.textPrimary, AppColors.coral],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ).createShader(bounds),
                        child: Text(
                          title.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 6,
                            height: 1,
                          ),
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(width: 16, height: 2, decoration: BoxDecoration(
                              gradient: LinearGradient(colors: AppColors.coralGradient),
                              borderRadius: BorderRadius.circular(1),
                            )),
                            const SizedBox(width: 8),
                            Text(
                              subtitle!,
                                  style: TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 10,
                                letterSpacing: 3,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                if (trailing != null) ...[
                  const SizedBox(width: 12),
                  trailing!,
                ],
              ],
            ),
          ),
          Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.coral.withValues(alpha: 0.4),
                  AppColors.borderLight,
                  AppColors.coral.withValues(alpha: 0.1),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FashionCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? color;
  final double? height;
  final Color? accentColor;

  const FashionCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.color,
    this.height,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color ?? AppColors.surface,
            AppColors.surfaceAlt,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.borderLight, width: 1),
        boxShadow: AppColors.shadowMd,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            colors: [
              Colors.white.withValues(alpha: 0.03),
              Colors.transparent,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (accentColor != null)
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  width: 32, height: 3,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [accentColor!, accentColor!.withValues(alpha: 0.3)],
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

class StatTile extends StatelessWidget {
  final String label;
  final String value;
  final Color accent;
  final VoidCallback? onTap;

  const StatTile({
    super.key,
    required this.label,
    required this.value,
    required this.accent,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.surface, AppColors.surfaceAlt],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.borderLight, width: 1),
          boxShadow: AppColors.shadowSm,
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              colors: [Colors.white.withValues(alpha: 0.03), Colors.transparent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: Row(
              children: [
                Container(
                  width: 6,
                  height: 72,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [accent, accent.withValues(alpha: 0.3)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ShaderMask(
                              shaderCallback: (bounds) => LinearGradient(
                                colors: [accent, accent.withValues(alpha: 0.7)],
                              ).createShader(bounds),
                              child: Text(
                                value,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              label.toUpperCase(),
                                  style: TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 10,
                                letterSpacing: 2.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: 40, height: 40,
                          decoration: BoxDecoration(
                            color: accent.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: accent.withValues(alpha: 0.2), width: 1),
                          ),
                          child: Icon(Icons.arrow_forward_ios, color: accent.withValues(alpha: 0.5), size: 14),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Tag extends StatelessWidget {
  final String text;
  final Color color;
  final bool filled;

  const Tag({
    super.key,
    required this.text,
    required this.color,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: filled ? color.withValues(alpha: 0.2) : Colors.transparent,
        border: Border.all(
          color: filled ? Colors.transparent : color.withValues(alpha: 0.5),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(4),
        boxShadow: filled ? [
          BoxShadow(color: color.withValues(alpha: 0.15), blurRadius: 4, offset: const Offset(0, 1)),
        ] : null,
      ),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          color: filled ? color : color,
          fontSize: 9,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}

class ActionGrid extends StatelessWidget {
  final List<ActionItem> items;

  const ActionGrid({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 10, runSpacing: 10,
        children: items.map((item) {
          return GestureDetector(
            onTap: item.onTap,
            child: Container(
              width: (MediaQuery.of(context).size.width - 42) / 2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.surface, AppColors.surfaceAlt],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.btnBorder, width: 1),
                boxShadow: AppColors.shadowSm,
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    colors: [Colors.white.withValues(alpha: 0.03), Colors.transparent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.btnColor, AppColors.btnColor80],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: AppColors.shadowGlow(AppColors.btnColor),
                      ),
                      child: Icon(item.icon, color: Colors.black, size: 20),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      item.label.toUpperCase(),
                      style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                    ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class ActionItem {
  final String label;
  final IconData icon;
  final Color color;
  final List<Color>? gradient;
  final VoidCallback onTap;
  ActionItem({required this.label, required this.icon, required this.color, this.gradient, required this.onTap});
}

class FashionNavDrawer extends StatelessWidget {
  final String currentRoute;

  const FashionNavDrawer({super.key, required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.bg,
      width: 300,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.navGradient,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 40,
                left: 24, right: 24, bottom: 32,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.surface, AppColors.surfaceAlt],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border(
                  bottom: BorderSide(color: AppColors.borderLight, width: 1),
                ),
                boxShadow: AppColors.shadowSm,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 56, height: 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.gold.withValues(alpha: 0.5), width: 1.2),
                      boxShadow: AppColors.shadowGlow(AppColors.coral),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(11),
                      child: Image.asset('assets/logo.jpg', fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text('DRISTI FASHIONS', style: TextStyle(color: AppColors.textPrimary, fontSize: 17, fontWeight: FontWeight.w900, letterSpacing: 2)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(width: 20, height: 2, decoration: BoxDecoration(
                        gradient: LinearGradient(colors: AppColors.goldGradient),
                        borderRadius: BorderRadius.circular(1),
                      )),
                      const SizedBox(width: 8),
                      Text('ADMIN PANEL', style: TextStyle(color: AppColors.gold, fontSize: 9, letterSpacing: 4, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 12),
                children: [
                  _navItem(Icons.dashboard, 'Dashboard', '/dashboard', context),
                  _navItem(Icons.people, 'Users', '/users', context),
                  _navItem(Icons.inventory_2, 'Products', '/products', context),
                  _navItem(Icons.receipt_long, 'Orders', '/orders', context),
                  _navItem(Icons.category, 'Categories', '/categories', context),
                  _navItem(Icons.view_carousel, 'Banners', '/banners', context),
                  _navItem(Icons.card_giftcard, 'Coupons', '/coupons', context),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: AppColors.borderLight, width: 1)),
              ),
              child: Consumer<ThemeProvider>(
                builder: (_, tp, __) {
                  final dark = tp.isDark;
                  return GestureDetector(
                    onTap: () => tp.toggle(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: dark
                              ? [AppColors.btnColor, AppColors.btnColor80]
                              : [AppColors.purple40, AppColors.surfaceAlt],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        border: Border.all(color: AppColors.btnBorder, width: 1),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: dark ? AppColors.shadowGlow(AppColors.btnColor) : AppColors.shadowSm,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 32, height: 32,
                            decoration: BoxDecoration(
                              color: (dark ? AppColors.btnColor : AppColors.purple).withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Icon(
                              dark ? Icons.dark_mode : Icons.light_mode,
                              color: Colors.black,
                              size: 16,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            dark ? 'DARK MODE' : 'LIGHT MODE',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: GestureDetector(
                onTap: () => _logout(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.btnColor, AppColors.btnColor80],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    border: Border.all(color: AppColors.btnBorder, width: 1),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: AppColors.shadowGlow(AppColors.btnColor),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 32, height: 32,
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(Icons.logout, color: Colors.black, size: 16),
                      ),
                      const SizedBox(width: 12),
                      const Text('SIGN OUT', style: TextStyle(color: Colors.black, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 2)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Row(
          children: [
            Container(
              width: 32, height: 32,
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(Icons.logout, color: AppColors.error, size: 16),
            ),
            const SizedBox(width: 12),
            Text('Sign Out', style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w700)),
          ],
        ),
        content: Text('Are you sure you want to sign out?', style: TextStyle(color: AppColors.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [AppColors.surface, AppColors.surfaceAlt], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  border: Border.all(color: AppColors.borderLight, width: 1),
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: AppColors.shadowSm,
                ),
                child: Text('CANCEL', style: TextStyle(color: AppColors.textSecondary, letterSpacing: 1, fontSize: 10, fontWeight: FontWeight.w700)),
              ),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: () async {
              final api = ApiService();
              await api.clearTokens();
              if (ctx.mounted) Navigator.pop(ctx);
              if (context.mounted) Navigator.pushReplacementNamed(context, '/login');
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [AppColors.btnColor, AppColors.btnColor80]),
                border: Border.all(color: AppColors.btnBorder, width: 1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text('SIGN OUT', style: TextStyle(color: Colors.black, letterSpacing: 1, fontSize: 10, fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, String label, String route, BuildContext ctx) {
    final active = currentRoute == route;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
      decoration: BoxDecoration(
        gradient: active
            ? LinearGradient(colors: [AppColors.btnColor40, Colors.white], begin: Alignment.topLeft, end: Alignment.bottomRight)
            : null,
        borderRadius: BorderRadius.circular(8),
        border: active
            ? Border.all(color: AppColors.btnBorder, width: 1)
            : null,
      ),
      child: ListTile(
        dense: true,
        leading: Container(
          width: 36, height: 36,
          decoration: BoxDecoration(
            gradient: active
            ? LinearGradient(colors: [AppColors.btnColor, AppColors.btnColor80], begin: Alignment.topLeft, end: Alignment.bottomRight)
            : LinearGradient(colors: AppColors.cardGradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(8),
        boxShadow: active ? AppColors.shadowGlow(AppColors.btnColor) : null,
          ),
          child: Icon(icon, color: active ? Colors.black : AppColors.textMuted, size: 18),
        ),
        title: Text(
          label.toUpperCase(),
          style: TextStyle(
            color: active ? AppColors.btnColor : AppColors.textSecondary,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 2.5,
          ),
        ),
        onTap: () {
          Navigator.pop(ctx);
          if (route != currentRoute) Navigator.pushReplacementNamed(ctx, route);
        },
      ),
    );
  }
}

class EmptyBox extends StatelessWidget {
  final IconData icon;
  final String message;

  const EmptyBox({super.key, required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(48),
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.surface, AppColors.surfaceAlt],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.borderLight, width: 1),
            boxShadow: AppColors.shadowSm,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64, height: 64,
                decoration: BoxDecoration(
                  color: AppColors.textMuted.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppColors.textMuted, size: 28),
              ),
              const SizedBox(height: 16),
              Text(
                message.toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary, fontSize: 11, letterSpacing: 2.5, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DividerLine extends StatelessWidget {
  const DividerLine({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.border.withValues(alpha: 0.3),
            AppColors.borderLight,
            AppColors.border.withValues(alpha: 0.3),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
    );
  }
}

class SectionLabel extends StatelessWidget {
  final String title;

  const SectionLabel({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 28, 16, 12),
      child: Row(
        children: [
          Container(
            width: 24, height: 3,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: AppColors.coralGradient),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            title.toUpperCase(),
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11,
              letterSpacing: 4,
              fontWeight: FontWeight.w800,
            ),
          ),
          const Spacer(),
          Container(
            height: 1,
            width: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.borderLight, AppColors.border.withValues(alpha: 0.3)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SearchInput extends StatelessWidget {
  final String hint;
  final ValueChanged<String> onChanged;

  const SearchInput({super.key, required this.hint, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        onChanged: onChanged,
        style: TextStyle(color: AppColors.textPrimary, fontSize: 13),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: AppColors.textMuted, fontSize: 11, letterSpacing: 2),
          prefixIcon: Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.coral.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(Icons.search, color: AppColors.coral, size: 16),
          ),
          filled: true,
          fillColor: AppColors.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: AppColors.borderLight, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: AppColors.borderLight, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: AppColors.coral, width: 1),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}

enum ButtonVariant { primary }

extension ButtonVariantColors on ButtonVariant {
  List<Color> get gradient {
    switch (this) {
      case ButtonVariant.primary: return [AppColors.btnColor, AppColors.btnColor80];
    }
  }
  Color get base {
    switch (this) {
      case ButtonVariant.primary: return AppColors.btnColor;
    }
  }
}

class FashionButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final ButtonVariant variant;
  final Color? color;

  const FashionButton({
    super.key,
    required this.label,
    this.onPressed,
    this.loading = false,
    this.variant = ButtonVariant.primary,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colors = color != null
        ? [color!, Color.lerp(color!, Colors.white, 0.2)!]
        : variant.gradient;
    final base = color ?? variant.base;
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0,
        ).copyWith(
          backgroundColor: WidgetStateProperty.resolveWith((states) => Colors.transparent),
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: colors, begin: Alignment.topLeft, end: Alignment.bottomRight),
            border: Border.all(color: AppColors.btnBorder, width: 1),
            borderRadius: BorderRadius.circular(8),
            boxShadow: AppColors.shadowGlow(base),
          ),
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: loading
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black))
                : Text(label.toUpperCase(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: 3.5)),
          ),
        ),
      ),
    );
  }
}

class InfoBlock extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const InfoBlock({super.key, required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 90,
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Text(label.toUpperCase(),
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 9,
                letterSpacing: 2,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.bgAlt,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AppColors.border, width: 1),
              ),
              child: Text(value,
                style: TextStyle(
                  color: valueColor ?? AppColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FormSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const FormSection({super.key, required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 14),
          child: Row(
            children: [
              Container(
                width: 20, height: 3,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: AppColors.coralGradient),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Text(title.toUpperCase(),
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                  letterSpacing: 3.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.surface, AppColors.surfaceAlt],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: AppColors.borderLight, width: 1),
            borderRadius: BorderRadius.circular(10),
            boxShadow: AppColors.shadowMd,
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class StyledInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool number;
  final int? maxLines;
  final String? hint;
  final String? Function(String?)? validator;

  const StyledInput({
    super.key,
    required this.controller,
    required this.label,
    this.number = false,
    this.maxLines,
    this.hint,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines ?? 1,
        keyboardType: number ? TextInputType.number : TextInputType.text,
        validator: validator,
        style: TextStyle(color: AppColors.textPrimary, fontSize: 13),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          labelStyle: TextStyle(color: AppColors.textMuted, fontSize: 11, letterSpacing: 1),
          hintStyle: TextStyle(color: AppColors.textMuted, fontSize: 11),
          filled: true,
          fillColor: AppColors.bgAlt,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(color: AppColors.border, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(color: AppColors.border, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(color: AppColors.coral, width: 1),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}

class StyledDropdown extends StatelessWidget {
  final String? value;
  final List<DropdownMenuItem<String>> items;
  final ValueChanged<String?> onChanged;
  final String label;

  const StyledDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: value,
        items: items,
        onChanged: onChanged,
        dropdownColor: AppColors.surfaceAlt,
        style: TextStyle(color: AppColors.textPrimary, fontSize: 13),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: AppColors.textMuted, fontSize: 11, letterSpacing: 1),
          filled: true,
          fillColor: AppColors.bgAlt,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(color: AppColors.border, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(color: AppColors.border, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(color: AppColors.coral, width: 1),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}

class ToggleRow extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const ToggleRow({super.key, required this.label, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: value ? AppColors.coral.withValues(alpha: 0.06) : AppColors.bgAlt,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: value ? AppColors.coral.withValues(alpha: 0.2) : AppColors.border, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 28, width: 48,
            child: Switch(
        value: value,
              onChanged: onChanged,
              activeTrackColor: AppColors.coral.withValues(alpha: 0.5),
              inactiveTrackColor: AppColors.textMuted.withValues(alpha: 0.2),
              activeThumbColor: AppColors.coral,
            ),
          ),
          const SizedBox(width: 8),
          Text(label.toUpperCase(),
            style: TextStyle(
              color: value ? AppColors.coral : AppColors.textMuted,
              fontSize: 9,
              letterSpacing: 1.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
