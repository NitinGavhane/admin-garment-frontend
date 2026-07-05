import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../models/dashboard.dart';
import '../services/api_service.dart';
import '../services/admin_service.dart';
import '../widgets.dart';

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color accent;
  final IconData icon;
  final VoidCallback? onTap;

  const _StatCard({
    required this.label,
    required this.value,
    required this.accent,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.gold.withValues(alpha: 0.45), width: 1),
          boxShadow: [
            ...AppColors.shadowMd,
            BoxShadow(color: AppColors.coral.withValues(alpha: 0.22), blurRadius: 20, offset: const Offset(0, 8)),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Stack(
            children: [
              Positioned.fill(
                child: DecoratedBox(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      // Royal blue from the logo, gold accents.
                      colors: AppColors.royalMetallic,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),
              // Subtle diagonal sheen across the plate
              Positioned(
                top: -20, right: -10, width: 90, height: 90,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [AppColors.gold.withValues(alpha: 0.16), Colors.transparent],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 38, height: 38,
                          decoration: AppColors.premiumGoldDeco(radius: 10),
                          child: Icon(icon, color: AppColors.coralDark, size: 18),
                        ),
                        const Spacer(),
                        Icon(Icons.north_east_rounded, color: AppColors.gold.withValues(alpha: 0.55), size: 15),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      value,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 27,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Container(width: 14, height: 2, decoration: BoxDecoration(
                          gradient: LinearGradient(colors: AppColors.goldMetallic),
                          borderRadius: BorderRadius.circular(1),
                        )),
                        const SizedBox(width: 7),
                        Text(
                          label.toUpperCase(),
                          style: TextStyle(
                            color: AppColors.gold40,
                            fontSize: 9,
                            letterSpacing: 1.8,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final AdminService _admin = AdminService(ApiService());
  DashboardStats? _stats;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      _stats = await _admin.getDashboard();
    } catch (_) {}
    if (mounted) setState(() => _loading = false);
  }

  Widget _buildStatGrid(BuildContext context) {
    final stats = [
      _StatCard(label: 'Total Users', value: '${_stats?.totalUsers ?? 0}', accent: AppColors.purple, icon: Icons.people_outline, onTap: () => Navigator.pushNamed(context, '/users')),
      _StatCard(label: 'Total Products', value: '${_stats?.totalProducts ?? 0}', accent: AppColors.purple, icon: Icons.inventory_2_outlined, onTap: () => Navigator.pushNamed(context, '/products')),
      _StatCard(label: 'Total Orders', value: '${_stats?.totalOrders ?? 0}', accent: AppColors.purple, icon: Icons.receipt_long_outlined, onTap: () => Navigator.pushNamed(context, '/orders')),
      _StatCard(label: 'Revenue', value: '₹${(_stats?.totalRevenue ?? 0).toStringAsFixed(0)}', accent: AppColors.purple, icon: Icons.trending_up, onTap: () => Navigator.pushNamed(context, '/orders')),
      _StatCard(label: 'Pending Orders', value: '${_stats?.pendingOrders ?? 0}', accent: AppColors.purple, icon: Icons.schedule, onTap: () => Navigator.pushNamed(context, '/orders')),
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          const gap = 12.0;
          final cols = Responsive.compactColumns(constraints.maxWidth);
          final tileW = (constraints.maxWidth - gap * (cols - 1)) / cols;
          return Wrap(
            spacing: gap,
            runSpacing: gap,
            children: stats.map((s) => SizedBox(width: tileW, child: s)).toList(),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      drawer: const FashionNavDrawer(currentRoute: '/dashboard'),
      body: _loading
          ? const BrandLoader(label: 'Loading')
          : RefreshIndicator(
              color: AppColors.coral,
              backgroundColor: AppColors.surface,
              onRefresh: _load,
              child: ListView(
                children: [
                  Builder(builder: (ctx) => BrandHeader(
                    title: 'Dashboard',
                    subtitle: 'STORE OVERVIEW',
                    onMenuTap: () => Scaffold.of(ctx).openDrawer(),
                    trailing: Container(
                      width: 38, height: 38,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.surfaceRaised, AppColors.surfaceAlt],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.gold.withValues(alpha: 0.4), width: 1),
                      ),
                      child: Icon(Icons.refresh, color: AppColors.gold, size: 16),
                    ),
                  )),
                  const SizedBox(height: 20),
                  _buildStatGrid(context),
                  const SizedBox(height: 28),
                  const SectionLabel(title: 'Quick Actions'),
                  const SizedBox(height: 12),
                  ActionGrid(items: [
                    ActionItem(label: 'Add Product', icon: Icons.add_box_outlined, color: AppColors.btnColor, gradient: [AppColors.btnColor, AppColors.btnColor80], onTap: () => Navigator.pushNamed(context, '/product-form')),
                    ActionItem(label: 'View Orders', icon: Icons.receipt_long_outlined, color: AppColors.btnColor, gradient: [AppColors.btnColor, AppColors.btnColor80], onTap: () => Navigator.pushNamed(context, '/orders')),
                  ]),
                  const SizedBox(height: 48),
                ],
              ),
            ),
    );
  }
}
