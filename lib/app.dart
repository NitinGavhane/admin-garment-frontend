import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/theme.dart';
import 'providers/auth_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/users_screen.dart';
import 'screens/products_screen.dart';
import 'screens/product_form_screen.dart';
import 'screens/orders_screen.dart';
import 'screens/order_detail_screen.dart';
import 'screens/categories_screen.dart';
import 'screens/category_form_screen.dart';
import 'screens/coupons_screen.dart';
import 'screens/coupon_form_screen.dart';

class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (_, theme, __) {
        final isDark = theme.isDark;
        return MaterialApp(
          title: 'Admin Panel',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            brightness: Brightness.light,
            scaffoldBackgroundColor: AppColors.bg,
            colorScheme: ColorScheme.light(
              primary: AppColors.coral,
              secondary: AppColors.gold,
              surface: AppColors.surface,
              error: AppColors.error,
            ),
            snackBarTheme: SnackBarThemeData(
              backgroundColor: AppColors.surfaceAlt,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            dialogTheme: DialogThemeData(
              backgroundColor: AppColors.surface,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            pageTransitionsTheme: PageTransitionsTheme(
              builders: {
                TargetPlatform.android: const FadeUpwardsPageTransitionsBuilder(),
                TargetPlatform.iOS: const FadeUpwardsPageTransitionsBuilder(),
              },
            ),
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: AppColors.bg,
            colorScheme: ColorScheme.dark(
              primary: AppColors.coral,
              secondary: AppColors.gold,
              surface: AppColors.surface,
              error: AppColors.error,
            ),
            snackBarTheme: SnackBarThemeData(
              backgroundColor: AppColors.surfaceAlt,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            dialogTheme: DialogThemeData(
              backgroundColor: AppColors.surface,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            pageTransitionsTheme: PageTransitionsTheme(
              builders: {
                TargetPlatform.android: const FadeUpwardsPageTransitionsBuilder(),
                TargetPlatform.iOS: const FadeUpwardsPageTransitionsBuilder(),
              },
            ),
          ),
          themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
          home: const _SplashGate(),
          routes: {
            '/login': (_) => const LoginScreen(),
            '/dashboard': (_) => const DashboardScreen(),
            '/users': (_) => const UsersScreen(),
            '/products': (_) => const ProductsScreen(),
            '/product-form': (_) => const ProductFormScreen(),
            '/orders': (_) => const OrdersScreen(),
            '/order-detail': (_) => const OrderDetailScreen(),
            '/categories': (_) => const CategoriesScreen(),
            '/category-form': (_) => const CategoryFormScreen(),
            '/coupons': (_) => const CouponsScreen(),
            '/coupon-form': (_) => const CouponFormScreen(),
          },
        );
      },
    );
  }
}

class _SplashGate extends StatefulWidget {
  const _SplashGate();

  @override
  State<_SplashGate> createState() => _SplashGateState();
}

class _SplashGateState extends State<_SplashGate>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;
  bool _started = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack));
    _ctrl.forward();
    _init();
  }

  Future<void> _init() async {
    final auth = context.read<AdminAuthProvider>();
    await Future.wait([
      auth.checkAuth(),
      Future.delayed(const Duration(milliseconds: 1200)),
    ]);
    if (mounted) {
      await _ctrl.reverse();
      setState(() => _started = true);
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_started) {
      final auth = context.watch<AdminAuthProvider>();
      Widget dest = const LoginScreen();
      if (auth.isAuthenticated) {
        dest = const DashboardScreen();
      }
      return dest;
    }
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: FadeTransition(
        opacity: _fade,
        child: SlideTransition(
          position: _slide,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: AppColors.coralGradient),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: AppColors.shadowGlow(AppColors.coral),
                  ),
                  child: const Center(
                    child: Text('A', style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.w900)),
                  ),
                ),
                const SizedBox(height: 24),
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [AppColors.textPrimary, AppColors.coral],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ).createShader(bounds),
                  child: const Text('ADMIN', style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.w900, letterSpacing: 12)),
                ),
                const SizedBox(height: 8),
                Text('GARMENT STORE', style: TextStyle(color: AppColors.textMuted, fontSize: 11, letterSpacing: 8, fontWeight: FontWeight.w600)),
                const SizedBox(height: 48),
                SizedBox(
                  width: 24, height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.coral.withValues(alpha: 0.6),
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
