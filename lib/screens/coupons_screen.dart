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

  void _delete(String id, String code) => showDialog(context: context, builder: (ctx) => AlertDialog(
    backgroundColor: AppColors.surface,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    title: Row(children: [
      Container(width: 28, height: 28, decoration: BoxDecoration(color: AppColors.error.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)), child: const Icon(Icons.delete_outlined, color: AppColors.error, size: 16)),
      const SizedBox(width: 10),
      const Text('DELETE', style: TextStyle(color: AppColors.coral, letterSpacing: 3, fontSize: 14, fontWeight: FontWeight.w800)),
    ]),
    content: Text('Remove "$code"?', style: TextStyle(color: AppColors.textSecondary)),
    actions: [
      TextButton(onPressed: () => Navigator.pop(ctx, false), child: Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), decoration: BoxDecoration(gradient: LinearGradient(colors: [AppColors.btnColor40, AppColors.surface], begin: Alignment.topLeft, end: Alignment.bottomRight), border: Border.all(color: AppColors.btnBorder, width: 1), borderRadius: BorderRadius.circular(6), boxShadow: AppColors.shadowSm), child: Text('CANCEL', style: TextStyle(color: AppColors.btnColor, letterSpacing: 2, fontSize: 10)))),
      const SizedBox(width: 8),
      TextButton(onPressed: () { Navigator.pop(ctx, true); _admin.deleteCoupon(id); _load(); }, child: Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), decoration: BoxDecoration(gradient: LinearGradient(colors: [AppColors.error, AppColors.error80], begin: Alignment.topCenter, end: Alignment.bottomCenter), border: Border.all(color: AppColors.error, width: 1), borderRadius: BorderRadius.circular(6), boxShadow: AppColors.shadowGlow(AppColors.error)), child: const Text('DELETE', style: TextStyle(color: Colors.white, letterSpacing: 2, fontSize: 10)))),
    ],
  ));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      drawer: const FashionNavDrawer(currentRoute: '/coupons'),
      floatingActionButton: Container(
        width: 52, height: 52,
        decoration: AppColors.premiumGoldDeco(radius: 14),
        child: IconButton(icon: Icon(Icons.add, color: AppColors.coralDark), onPressed: () => Navigator.pushNamed(context, '/coupon-form').then((_) => _load())),
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
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
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
                          GestureDetector(onTap: () => Navigator.pushNamed(context, '/coupon-form', arguments: c.id).then((_) => _load()), child: Container(width: 36, height: 36, decoration: AppColors.premiumGoldDeco(radius: 8), child: Icon(Icons.edit_outlined, color: AppColors.coralDark, size: 14))),
                          const SizedBox(height: 6),
                          GestureDetector(onTap: () => _delete(c.id, c.code), child: Container(width: 36, height: 36, decoration: BoxDecoration(gradient: LinearGradient(colors: [AppColors.error, AppColors.error80], begin: Alignment.topCenter, end: Alignment.bottomCenter), border: Border.all(color: AppColors.error, width: 1), borderRadius: BorderRadius.circular(8), boxShadow: AppColors.shadowGlow(AppColors.error)), child: const Icon(Icons.delete_outlined, color: Colors.white, size: 14))),
                        ]),
                      ]),
                    ),
                  );
                },
              )),
        ),
      ]),
    );
  }
}
