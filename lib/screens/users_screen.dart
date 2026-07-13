import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import '../services/admin_service.dart';
import '../widgets.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final AdminService _admin = AdminService(ApiService());
  List<AdminUser> _users = [];
  bool _loading = true;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final u = await _admin.getUsers();
      if (mounted) setState(() { _users = u; _loading = false; });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  List<AdminUser> get _filtered => _query.isEmpty ? _users : _users.where((u) =>
    u.fullName.toLowerCase().contains(_query.toLowerCase()) ||
    u.email.toLowerCase().contains(_query.toLowerCase())
  ).toList();

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      currentRoute: '/users',
      body: Column(
        children: [
          Builder(builder: (ctx) => BrandHeader(
            title: 'Users',
            subtitle: '${_users.length} REGISTERED',
            onMenuTap: () => Scaffold.of(ctx).openDrawer(),
          )),
          const SizedBox(height: 16),
          SearchInput(hint: 'SEARCH USERS', onChanged: (v) => setState(() => _query = v)),
          const SizedBox(height: 12),
          Expanded(
            child: _loading
                ? const BrandLoader(label: 'Loading')
                : _filtered.isEmpty
                    ? const EmptyBox(icon: Icons.people_outline, message: 'No users found')
                    : RefreshIndicator(
                        color: AppColors.coral,
                        backgroundColor: AppColors.surface,
                        onRefresh: _load,
                        child: ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
                          itemCount: _filtered.length,
                          itemBuilder: (_, i) {
                            final u = _filtered[i];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [AppColors.surface, AppColors.surfaceAlt], begin: Alignment.topLeft, end: Alignment.bottomRight),
                                border: Border.all(color: AppColors.borderLight, width: 1),
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: AppColors.shadowMd,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  gradient: LinearGradient(colors: [Colors.white.withValues(alpha: 0.03), Colors.transparent], begin: Alignment.topLeft, end: Alignment.bottomRight),
                                ),
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 48, height: 48,
                                      decoration: u.role == 'admin'
                                          ? AppColors.premiumGoldDeco(radius: 12)
                                          : BoxDecoration(
                                              gradient: LinearGradient(colors: AppColors.royalMetallic, begin: Alignment.topLeft, end: Alignment.bottomRight),
                                              borderRadius: BorderRadius.circular(12),
                                              border: Border.all(color: AppColors.coral.withValues(alpha: 0.4), width: 1),
                                              boxShadow: AppColors.shadowSm,
                                            ),
                                      child: Center(
                                        child: Text(u.fullName.isNotEmpty ? u.fullName[0].toUpperCase() : '?',
                                            style: TextStyle(
                                              color: u.role == 'admin' ? AppColors.coralDark : Colors.white,
                                              fontWeight: FontWeight.w900,
                                              fontSize: 18,
                                            )),
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(u.fullName, style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w700, fontSize: 14), overflow: TextOverflow.ellipsis),
                                          const SizedBox(height: 2),
                                          Text(u.email, style: TextStyle(color: AppColors.textSecondary, fontSize: 12), overflow: TextOverflow.ellipsis),
                                          const SizedBox(height: 3),
                                          Text('P-${u.id.length > 6 ? u.id.substring(u.id.length - 6).toUpperCase() : u.id.toUpperCase()}', style: TextStyle(color: AppColors.textMuted, fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
                                          const SizedBox(height: 8),
                                          Wrap(spacing: 6, runSpacing: 6, children: [
                                            Tag(text: u.role, color: u.role == 'admin' ? AppColors.gold : AppColors.coral, filled: true),
                                            Tag(text: u.isVerified ? 'Verified' : 'Unverified', color: u.isVerified ? AppColors.success : AppColors.warning),
                                            Tag(text: '₹${u.walletBalance.toStringAsFixed(0)}', color: AppColors.teal),
                                          ]),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
