import 'package:flutter/material.dart';

import '../config/theme.dart';
import '../models/referral.dart';
import '../services/api_service.dart';
import '../services/admin_service.dart';
import '../widgets.dart';

/// Refer & earn control room.
///
/// Every purchase made by a customer who arrived on someone's share link lands
/// here as *pending*. Nothing is ever paid automatically: the admin approves a
/// commission (suggested from the store-wide %, editable per sale) and only
/// then does the money reach the referrer's wallet.
class ReferralsScreen extends StatefulWidget {
  const ReferralsScreen({super.key});

  @override
  State<ReferralsScreen> createState() => _ReferralsScreenState();
}

class _ReferralsScreenState extends State<ReferralsScreen> {
  final AdminService _admin = AdminService(ApiService());

  ReferralSettings _settings = const ReferralSettings();
  List<ReferralPurchase> _purchases = [];
  List<ReferralUserReport> _referrers = [];
  bool _loading = true;
  String _filter = 'pending';
  bool _showReferrers = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final settings = await _admin.getReferralSettings();
      final purchases = await _admin.getReferralPurchases(
          status: _filter == 'all' ? null : _filter);
      final referrers = await _admin.getReferralUserReport();
      if (!mounted) return;
      setState(() {
        _settings = settings;
        _purchases = purchases;
        // Only people who actually brought in business are worth listing.
        _referrers = referrers
            .where((r) => r.totalPurchases > 0 || r.totalClicks > 0)
            .toList()
          ..sort((a, b) => b.totalEarnings.compareTo(a.totalEarnings));
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      _toast('Could not load referrals: $e', error: true);
    }
  }

  void _toast(String message, {bool error = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: error ? AppColors.error : null,
    ));
  }

  static String _trim(double v) => v.toStringAsFixed(v % 1 == 0 ? 0 : 2);

  int get _pendingCount => _purchases.where((p) => p.isPending).length;

  Future<void> _openSettings() async {
    final pctCtrl =
        TextEditingController(text: _trim(_settings.commissionPercentage));
    bool enabled = _settings.enabled;

    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => AlertDialog(
          backgroundColor: AppColors.surface,
          title: Text('REFER & EARN',
              style: TextStyle(
                  color: AppColors.coral,
                  letterSpacing: 3,
                  fontSize: 14,
                  fontWeight: FontWeight.w800)),
          content: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              ToggleRow(
                label: 'Programme active',
                value: enabled,
                onChanged: (v) => setLocal(() => enabled = v),
              ),
              const SizedBox(height: 12),
              StyledInput(
                controller: pctCtrl,
                label: 'Default commission (%)',
                number: true,
                hint: 'e.g. 5',
              ),
              const SizedBox(height: 8),
              _note(enabled
                  ? 'New referred sales suggest this % of the product subtotal (before GST and delivery). You can still change the amount on each sale before approving.'
                  : 'Turned off: no new referral earnings are recorded and the app stops advertising a commission. Sales already pending stay approvable.'),
            ]),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text('CANCEL',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 11))),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: AppColors.premiumGoldDeco(radius: 6),
                child: const Text('SAVE',
                    style: TextStyle(
                        color: Colors.white, letterSpacing: 2, fontSize: 10)),
              ),
            ),
          ],
        ),
      ),
    );

    if (saved != true) return;
    try {
      final updated = await _admin.updateReferralSettings({
        'enabled': enabled,
        'commission_percentage': double.tryParse(pctCtrl.text.trim()) ?? 0.0,
      });
      if (!mounted) return;
      setState(() => _settings = updated);
      _toast('Referral settings saved');
    } catch (e) {
      _toast('Save failed: $e', error: true);
    }
  }

  /// Approve dialog: pre-filled with the store default, overridable either as a
  /// percentage or as a flat rupee amount for this one sale.
  Future<void> _approve(ReferralPurchase p) async {
    final pct = p.rewardPercentage > 0
        ? p.rewardPercentage
        : _settings.commissionPercentage;
    final pctCtrl = TextEditingController(text: _trim(pct));
    final amountCtrl = TextEditingController();

    double computed() {
      final fixed = double.tryParse(amountCtrl.text.trim());
      if (fixed != null && fixed > 0) return fixed;
      final percentage = double.tryParse(pctCtrl.text.trim()) ?? 0;
      return p.purchaseAmount * percentage / 100;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) {
          return AlertDialog(
            backgroundColor: AppColors.surface,
            title: Text('PAY COMMISSION',
                style: TextStyle(
                    color: AppColors.coral,
                    letterSpacing: 3,
                    fontSize: 14,
                    fontWeight: FontWeight.w800)),
            content: SingleChildScrollView(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                _dialogRow('Referrer', p.referrerName),
                _dialogRow('Bought by', p.referredUserName ?? '—'),
                if (p.productName != null) _dialogRow('Product', p.productName!),
                _dialogRow('Order', p.orderNumber ?? p.orderId),
                _dialogRow('Order value',
                    '₹${p.purchaseAmount.toStringAsFixed(2)}'),
                const SizedBox(height: 12),
                StyledInput(
                  controller: pctCtrl,
                  label: 'Commission (%)',
                  number: true,
                  onChanged: (_) => setLocal(() {}),
                ),
                StyledInput(
                  controller: amountCtrl,
                  label: 'Or fixed amount (₹)',
                  number: true,
                  hint: 'Optional — overrides the %',
                  onChanged: (_) => setLocal(() {}),
                ),
                const SizedBox(height: 8),
                _note(
                    '₹${computed().toStringAsFixed(2)} will be credited to ${p.referrerName}\'s wallet straight away.'),
              ]),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: Text('CANCEL',
                      style:
                          TextStyle(color: AppColors.textMuted, fontSize: 11))),
              TextButton(
                onPressed: computed() <= 0 ? null : () => Navigator.pop(ctx, true),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: AppColors.premiumGoldDeco(radius: 6),
                  child: const Text('APPROVE & PAY',
                      style: TextStyle(
                          color: Colors.white, letterSpacing: 2, fontSize: 10)),
                ),
              ),
            ],
          );
        },
      ),
    );

    if (confirmed != true) return;
    final fixed = double.tryParse(amountCtrl.text.trim());
    try {
      await _admin.approveReferral(
        p.id,
        rewardPercentage: double.tryParse(pctCtrl.text.trim()) ?? 0,
        rewardAmount: fixed != null && fixed > 0 ? fixed : null,
      );
      _toast('Commission paid to ${p.referrerName}');
      _load();
    } catch (e) {
      _toast('Approval failed: $e', error: true);
    }
  }

  Future<void> _reject(ReferralPurchase p) async {
    final ok = await confirmDeleteDialog(
      context,
      message: 'Reject the commission for ${p.referrerName}? '
          'Nothing will be paid for this order.',
    );
    if (!ok) return;
    try {
      await _admin.rejectReferral(p.id);
      _toast('Referral rejected');
      _load();
    } catch (e) {
      _toast('Reject failed: $e', error: true);
    }
  }

  /// Explanatory box, styled like the one on the Delivery settings screen.
  Widget _note(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
            color: AppColors.btnColor.withValues(alpha: 0.3), width: 1),
        color: AppColors.btnColor.withValues(alpha: 0.05),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(Icons.info_outline, size: 15, color: AppColors.btnColor),
        const SizedBox(width: 10),
        Expanded(
          child: Text(text,
              style: TextStyle(
                  color: AppColors.textSecondary, fontSize: 12, height: 1.4)),
        ),
      ]),
    );
  }

  Widget _dialogRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(children: [
        Text(label,
            style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
        const Spacer(),
        Flexible(
          child: Text(value,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.w700)),
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      currentRoute: '/referrals',
      floatingActionButton: Container(
        width: 52,
        height: 52,
        decoration: AppColors.premiumGoldDeco(radius: 14),
        child: IconButton(
          tooltip: 'Commission settings',
          icon: const Icon(Icons.settings_outlined, color: Colors.white),
          onPressed: _openSettings,
        ),
      ),
      body: Column(children: [
        Builder(
          builder: (ctx) => BrandHeader(
            title: 'Referrals',
            subtitle: _settings.enabled
                ? '$_pendingCount PENDING · ${_trim(_settings.commissionPercentage)}% DEFAULT'
                : 'PROGRAMME OFF',
            onMenuTap: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        Expanded(
          child: _loading
              ? const BrandLoader(label: 'Loading')
              : RefreshIndicator(
                  color: AppColors.coral,
                  backgroundColor: AppColors.surface,
                  onRefresh: _load,
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                    children: [
                      _tabs(),
                      const SizedBox(height: 12),
                      if (_showReferrers)
                        ..._buildReferrers()
                      else
                        ..._buildPurchases(),
                    ],
                  ),
                ),
        ),
      ]),
    );
  }

  Widget _tabs() {
    Widget tab(String label, bool selected, VoidCallback onTap) {
      return Expanded(
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: selected
                  ? LinearGradient(colors: AppColors.coralGradient)
                  : null,
              color: selected ? null : AppColors.surfaceAlt,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  color: selected ? AppColors.coral : AppColors.border,
                  width: 1),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : AppColors.textSecondary,
                fontSize: 10,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      );
    }

    return Row(children: [
      tab('PENDING', !_showReferrers && _filter == 'pending', () {
        setState(() { _showReferrers = false; _filter = 'pending'; _loading = true; });
        _load();
      }),
      const SizedBox(width: 8),
      tab('ALL SALES', !_showReferrers && _filter == 'all', () {
        setState(() { _showReferrers = false; _filter = 'all'; _loading = true; });
        _load();
      }),
      const SizedBox(width: 8),
      tab('REFERRERS', _showReferrers, () => setState(() => _showReferrers = true)),
    ]);
  }

  List<Widget> _buildPurchases() {
    if (_purchases.isEmpty) {
      return [
        const SizedBox(height: 40),
        EmptyBox(
          icon: Icons.people_outline,
          message: _filter == 'pending'
              ? 'No commissions waiting'
              : 'No referred sales yet',
        ),
      ];
    }
    return _purchases.map(_purchaseCard).toList();
  }

  Widget _purchaseCard(ReferralPurchase p) {
    final (statusColor, statusLabel) = switch (p.status) {
      'approved' => (AppColors.success, 'PAID ₹${p.rewardAmount.toStringAsFixed(2)}'),
      'pending' => (AppColors.warning, 'PENDING'),
      _ => (AppColors.error, p.status.toUpperCase()),
    };

    return ListCardShell(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: AppColors.coralGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
                child: Icon(Icons.share_outlined, color: Colors.white, size: 22)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(p.referrerName,
                  style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 14)),
              const SizedBox(height: 2),
              Text(
                '${p.referredUserName ?? 'A customer'} bought'
                '${p.productName != null ? ' ${p.productName}' : ''}',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 11),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                'Order ${p.orderNumber ?? '—'} · ₹${p.purchaseAmount.toStringAsFixed(2)}',
                style: TextStyle(color: AppColors.textMuted, fontSize: 11),
              ),
            ]),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(statusLabel,
                style: TextStyle(
                    color: statusColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w700)),
          ),
        ]),
        if (p.isPending) ...[
          const SizedBox(height: 12),
          Row(children: [
            Expanded(
              child: GestureDetector(
                onTap: () => _approve(p),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  alignment: Alignment.center,
                  decoration: AppColors.premiumGoldDeco(radius: 8),
                  child: const Text('GIVE COMMISSION',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.w700)),
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => _reject(p),
              child: Container(
                width: 44,
                height: 38,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.error, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.close, color: AppColors.error, size: 16),
              ),
            ),
          ]),
        ],
      ]),
    );
  }

  List<Widget> _buildReferrers() {
    if (_referrers.isEmpty) {
      return [
        const SizedBox(height: 40),
        const EmptyBox(
            icon: Icons.emoji_events_outlined, message: 'No one has shared yet'),
      ];
    }
    return _referrers
        .map((r) => ListCardShell(
              child: Row(children: [
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(r.userName,
                            style: TextStyle(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w700,
                                fontSize: 14)),
                        const SizedBox(height: 2),
                        Text(r.userEmail,
                            style: TextStyle(
                                color: AppColors.textMuted, fontSize: 11)),
                        const SizedBox(height: 4),
                        Text(
                          '${r.totalClicks} clicks · ${r.totalPurchases} sales',
                          style: TextStyle(
                              color: AppColors.textSecondary, fontSize: 11),
                        ),
                      ]),
                ),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Text('₹${r.totalEarnings.toStringAsFixed(2)}',
                      style: TextStyle(
                          color: AppColors.success,
                          fontWeight: FontWeight.w800,
                          fontSize: 14)),
                  if (r.pendingRewards > 0)
                    Text('₹${r.pendingRewards.toStringAsFixed(2)} pending',
                        style: TextStyle(
                            color: AppColors.warning, fontSize: 10)),
                ]),
              ]),
            ))
        .toList();
  }
}
