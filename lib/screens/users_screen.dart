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
    return Scaffold(
      backgroundColor: AppColors.bg,
      drawer: const FashionNavDrawer(currentRoute: '/users'),
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
                ? const Center(child: CircularProgressIndicator(color: AppColors.coral))
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
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: AppColors.shadowSm,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  gradient: LinearGradient(colors: [Colors.white.withValues(alpha: 0.03), Colors.transparent], begin: Alignment.topLeft, end: Alignment.bottomRight),
                                ),
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 46, height: 46,
                                      decoration: BoxDecoration(
                                        color: u.role == 'admin' ? AppColors.gold.withValues(alpha: 0.15) : AppColors.coral.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: u.role == 'admin' ? AppColors.gold.withValues(alpha: 0.3) : AppColors.coral.withValues(alpha: 0.2),
                                          width: 1,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(u.fullName[0].toUpperCase(),
                                            style: const TextStyle(
                                              color: Colors.black,
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
                                          Text(u.fullName, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 14), overflow: TextOverflow.ellipsis),
                                          const SizedBox(height: 2),
                                          Text(u.email, style: const TextStyle(color: Colors.black, fontSize: 12)),
                                          const SizedBox(height: 2),
                                          Text('P-${u.id.length > 6 ? u.id.substring(u.id.length - 6).toUpperCase() : u.id.toUpperCase()}', style: const TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.w600)),
                                          const SizedBox(height: 8),
                                          Wrap(spacing: 6, children: [
                                            Tag(text: u.role, color: Colors.black),
                                            Tag(text: u.isVerified ? 'Verified' : 'Unverified', color: Colors.black),
                                            Tag(text: '₹${u.walletBalance.toStringAsFixed(0)}', color: Colors.black),
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
