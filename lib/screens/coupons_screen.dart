import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../models/coupon.dart';
import '../services/api_service.dart';
import '../services/admin_service.dart';
import '../widgets.dart';

class CouponsScreen extends StatefulWidget {
  const CouponsScreen({super.key});

  @override
  State<CouponsScreen> createState() => _CouponsScreenState();
}

class _CouponsScreenState extends State<CouponsScreen> {
  final AdminService _admin = AdminService(ApiService());
  List<AdminCoupon> _coupons = [];
  bool _loading = true;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    try { final c = await _admin.getCoupons(); if (mounted) setState(() { _coupons = c; _loading = false; }); } catch (_) { if (mounted) setState(() => _loading = false); }
  }

  Future<void> _delete(String id, String code) async {
    final ok = await confirmDeleteDialog(context, message: 'Remove "$code"?');
    if (ok) { await _admin.deleteCoupon(id); _load(); }
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      currentRoute: '/coupons',
      floatingActionButton: Container(
        width: 52, height: 52,
        decoration: AppColors.premiumGoldDeco(radius: 14),
        child: IconButton(icon: Icon(Icons.add, color: Colors.white), onPressed: () => Navigator.pushNamed(context, '/coupon-form').then((_) => _load())),
      ),
      body: Column(children: [
        Builder(builder: (ctx) => BrandHeader(title: 'Coupons', subtitle: '${_coupons.length} ACTIVE', onMenuTap: () => Scaffold.of(ctx).openDrawer())),
        Expanded(child: _loading
          ? const BrandLoader(label: 'Loading')
          : _coupons.isEmpty
            ? const EmptyBox(icon: Icons.card_giftcard_outlined, message: 'No coupons')
            : RefreshIndicator(color: AppColors.coral, backgroundColor: AppColors.surface, onRefresh: _load, child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                itemCount: _coupons.length,
                itemBuilder: (_, i) {
                  final c = _coupons[i];
                  return ListCardShell(
                      child: Row(children: [
                        Container(
                          width: 52, height: 52,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: c.isActive ? AppColors.coralGradient : [AppColors.textMuted, AppColors.borderLight],
                              begin: Alignment.topLeft, end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: c.isActive ? AppColors.shadowGlow(AppColors.coral) : null,
                          ),
                          child: Center(child: Text(c.code.substring(0, c.code.length > 3 ? 3 : c.code.length), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: 1))),
                        ),
                        const SizedBox(width: 14),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(c.code, style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w700, fontSize: 14, letterSpacing: 1)),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.coral.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text('${c.type.toUpperCase()} · ${c.type == 'percentage' ? '${c.value.toStringAsFixed(0)}%' : '₹${c.value.toStringAsFixed(2)}'} OFF',
                              style: TextStyle(color: AppColors.coral, fontWeight: FontWeight.w600, fontSize: 11),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text('Used ${c.usedCount}/${c.usageLimit}${!c.isActive ? ' · INACTIVE' : ''}', style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
                        ])),
                        Column(children: [
                          GestureDetector(onTap: () => Navigator.pushNamed(context, '/coupon-form', arguments: c.id).then((_) => _load()), child: Container(width: 36, height: 36, decoration: AppColors.premiumGoldDeco(radius: 8), child: Icon(Icons.edit_outlined, color: Colors.white, size: 14))),
                          const SizedBox(height: 6),
                          GestureDetector(onTap: () => _delete(c.id, c.code), child: Container(width: 36, height: 36, decoration: BoxDecoration(gradient: LinearGradient(colors: [AppColors.error, AppColors.error80], begin: Alignment.topCenter, end: Alignment.bottomCenter), border: Border.all(color: AppColors.error, width: 1), borderRadius: BorderRadius.circular(8), boxShadow: AppColors.shadowGlow(AppColors.error)), child: const Icon(Icons.delete_outlined, color: Colors.white, size: 14))),
                        ]),
                      ]),
                  );
                },
              )),
        ),
      ]),
    );
  }
}
