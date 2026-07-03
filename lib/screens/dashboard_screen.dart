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
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.gold.withValues(alpha: 0.4), width: 1),
          boxShadow: AppColors.shadowMd,
        ),
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            gradient: LinearGradient(
              // Royal blue from the logo, gold accents.
              colors: [Color(0xFF243AA0), Color(0xFF1A2A80), Color(0xFF10195E)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.gold, AppColors.gold80],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      border: Border.all(color: AppColors.btnBorder, width: 1),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: AppColors.shadowGlow(AppColors.gold),
                    ),
                    child: Icon(icon, color: const Color(0xFF10195E), size: 18),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label.toUpperCase(),
                style: TextStyle(
                  color: AppColors.gold80,
                  fontSize: 9,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w700,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      drawer: const FashionNavDrawer(currentRoute: '/dashboard'),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.coral))
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
                        border: Border.all(color: AppColors.borderLight, width: 1),
                      ),
                      child: const Icon(Icons.refresh, color: Colors.black, size: 16),
                    ),
                  )),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(child: _StatCard(label: 'Total Users', value: '${_stats?.totalUsers ?? 0}', accent: AppColors.purple, icon: Icons.people_outline, onTap: () => Navigator.pushNamed(context, '/users'))),
                        const SizedBox(width: 10),
                        Expanded(child: _StatCard(label: 'Total Products', value: '${_stats?.totalProducts ?? 0}', accent: AppColors.purple, icon: Icons.inventory_2_outlined, onTap: () => Navigator.pushNamed(context, '/products'))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(child: _StatCard(label: 'Total Orders', value: '${_stats?.totalOrders ?? 0}', accent: AppColors.purple, icon: Icons.receipt_long_outlined, onTap: () => Navigator.pushNamed(context, '/orders'))),
                        const SizedBox(width: 10),
                        Expanded(child: _StatCard(label: 'Revenue', value: '₹${(_stats?.totalRevenue ?? 0).toStringAsFixed(0)}', accent: AppColors.purple, icon: Icons.trending_up, onTap: () => Navigator.pushNamed(context, '/orders'))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(child: _StatCard(label: 'Pending Orders', value: '${_stats?.pendingOrders ?? 0}', accent: AppColors.purple, icon: Icons.schedule, onTap: () => Navigator.pushNamed(context, '/orders'))),
                        const Expanded(child: SizedBox.shrink()),
                      ],
                    ),
                  ),
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
