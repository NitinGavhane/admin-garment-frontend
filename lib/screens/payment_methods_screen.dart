import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../models/payment_method.dart';
import '../services/api_service.dart';
import '../services/admin_service.dart';
import '../widgets.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  final AdminService _admin = AdminService(ApiService());
  List<AdminPaymentMethod> _methods = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final m = await _admin.getPaymentMethods();
      if (mounted) setState(() { _methods = m; _loading = false; });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _navigate(String route, [String? arg]) async {
    await Navigator.pushNamed(context, route, arguments: arg);
    _load();
  }

  Future<void> _delete(AdminPaymentMethod method) async {
    final ok = await confirmDeleteDialog(
      context,
      message: 'Remove "${method.name}" from checkout? '
          'To hide it temporarily, switch it to inactive instead.',
    );
    if (ok) {
      try {
        await _admin.deletePaymentMethod(method.id);
        _load();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Delete failed: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      currentRoute: '/payment-methods',
      floatingActionButton: Container(
        width: 52, height: 52,
        decoration: AppColors.premiumGoldDeco(radius: 14),
        child: IconButton(
          icon: Icon(Icons.add, color: Colors.white),
          onPressed: () => _navigate('/payment-method-form'),
        ),
      ),
      body: Column(children: [
        Builder(builder: (ctx) => BrandHeader(
          title: 'Payment Methods',
          subtitle: '${_methods.where((m) => m.isActive).length} ACTIVE · ${_methods.length} TOTAL',
          onMenuTap: () => Scaffold.of(ctx).openDrawer(),
        )),
        Expanded(child: _loading
          ? const BrandLoader(label: 'Loading')
          : _methods.isEmpty
            ? const EmptyBox(icon: Icons.account_balance_wallet_outlined, message: 'No payment methods yet — tap + to add one')
            : RefreshIndicator(
                color: AppColors.coral, backgroundColor: AppColors.surface,
                onRefresh: _load,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
                  children: _methods.map(_buildCard).toList(),
                ),
              ),
        ),
      ]),
    );
  }

  Widget _buildCard(AdminPaymentMethod m) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.surface, AppColors.surfaceAlt],
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: m.isActive ? AppColors.coral.withValues(alpha: 0.25) : AppColors.borderLight,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: AppColors.shadowMd,
      ),
      child: Row(children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Flexible(child: Text(
              m.name,
              style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w700, fontSize: 14),
            )),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.bgAlt,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                m.code.toUpperCase(),
                style: TextStyle(color: AppColors.textMuted, fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 1),
              ),
            ),
          ]),
          if (m.description?.isNotEmpty == true) ...[
            const SizedBox(height: 4),
            Text(m.description!, style: TextStyle(color: AppColors.textSecondary, fontSize: 11)),
          ],
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: m.isActive ? AppColors.bgAlt : AppColors.error.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '${m.regionsLabel} · VIA ${m.gateway.toUpperCase()} · ORDER ${m.sortOrder}${!m.isActive ? ' · INACTIVE' : ''}',
              style: TextStyle(
                color: m.isActive ? AppColors.textMuted : AppColors.error,
                fontSize: 10, fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ])),
        GestureDetector(
          onTap: () => _navigate('/payment-method-form', m.id),
          child: Container(
            width: 36, height: 36,
            decoration: AppColors.premiumGoldDeco(radius: 8),
            child: Icon(Icons.edit_outlined, color: Colors.white, size: 14),
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () => _delete(m),
          child: Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [AppColors.error, AppColors.error80], begin: Alignment.topCenter, end: Alignment.bottomCenter),
              border: Border.all(color: AppColors.error, width: 1),
              borderRadius: BorderRadius.circular(8),
              boxShadow: AppColors.shadowGlow(AppColors.error),
            ),
            child: const Icon(Icons.delete_outlined, color: Colors.white, size: 14),
          ),
        ),
      ]),
    );
  }
}
