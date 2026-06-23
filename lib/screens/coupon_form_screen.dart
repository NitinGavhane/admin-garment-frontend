import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../services/api_service.dart';
import '../services/admin_service.dart';
import '../widgets.dart';

class CouponFormScreen extends StatefulWidget {
  const CouponFormScreen({super.key});

  @override
  State<CouponFormScreen> createState() => _CouponFormScreenState();
}

class _CouponFormScreenState extends State<CouponFormScreen> {
  final AdminService _admin = AdminService(ApiService());
  final _fk = GlobalKey<FormState>();
  final _cc = TextEditingController(), _vc = TextEditingController();
  final _mc = TextEditingController(), _xc = TextEditingController();
  final _ec = TextEditingController(), _lc = TextEditingController(text: '100');

  String? _editId;
  bool _loading = false, _saving = false, _active = true;
  String _type = 'percentage';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_editId == null) {
      _editId = ModalRoute.of(context)?.settings.arguments as String?;
      if (_editId != null) _load();
    }
  }

  Future<void> _load() async {
    if (_editId == null) return;
    setState(() => _loading = true);
    try {
      final c = await _admin.getCoupon(_editId!);
      _cc.text = c.code; _vc.text = c.value.toString();
      if (c.minOrderAmount != null) _mc.text = c.minOrderAmount.toString();
      if (c.maxDiscount != null) _xc.text = c.maxDiscount.toString();
      _ec.text = c.expiryDate ?? ''; _lc.text = c.usageLimit.toString();
      _type = c.type; _active = c.isActive;
    } catch (_) {}
    if (mounted) setState(() => _loading = false);
  }

  @override void dispose() { _cc.dispose(); _vc.dispose(); _mc.dispose(); _xc.dispose(); _ec.dispose(); _lc.dispose(); super.dispose(); }

  Future<void> _save() async {
    if (!_fk.currentState!.validate()) return;
    setState(() => _saving = true);
    final d = <String, dynamic>{
      'code': _cc.text.trim().toUpperCase(), 'type': _type,
      'value': double.parse(_vc.text.trim()),
      'usage_limit': int.tryParse(_lc.text.trim()) ?? 100, 'is_active': _active,
    };
    if (_mc.text.trim().isNotEmpty) d['min_order_amount'] = double.tryParse(_mc.text.trim()) ?? 0;
    if (_xc.text.trim().isNotEmpty) d['max_discount'] = double.tryParse(_xc.text.trim()) ?? 0;
    if (_ec.text.trim().isNotEmpty) d['expiry_date'] = _ec.text.trim();
    try {
      if (_editId != null) { await _admin.updateCoupon(_editId!, d); }
      else { await _admin.createCoupon(d); }
      if (mounted) Navigator.pop(context);
    } catch (e) { if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString().substring(0, e.toString().length > 80 ? 80 : e.toString().length)))); }
    if (mounted) setState(() => _saving = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: _loading
        ? const Center(child: CircularProgressIndicator(color: AppColors.coral))
        : Column(children: [
            BrandHeader(title: _editId != null ? 'Edit Coupon' : 'New Coupon'),
            Expanded(child: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Form(key: _fk, child: Column(children: [
              FormSection(title: 'Coupon Details', children: [
                StyledInput(controller: _cc, label: 'Coupon Code *', validator: (v) => v?.trim().isEmpty == true ? 'Required' : null),
                StyledDropdown(label: 'Type', value: _type, items: ['percentage', 'fixed'].map((e) => DropdownMenuItem<String>(value: e, child: Text(e[0].toUpperCase() + e.substring(1), style: TextStyle(color: AppColors.textPrimary)))).toList(), onChanged: (v) => setState(() => _type = v ?? 'percentage')),
                StyledInput(controller: _vc, label: 'Value *', number: true, hint: _type == 'percentage' ? 'e.g. 10' : 'e.g. 50', validator: (v) => v?.trim().isEmpty == true ? 'Required' : null),
                Row(children: [
                  Expanded(child: StyledInput(controller: _mc, label: 'Min Order', number: true)),
                  const SizedBox(width: 12),
                  Expanded(child: StyledInput(controller: _xc, label: 'Max Discount', number: true)),
                ]),
              ]),
              const SizedBox(height: 16),
              FormSection(title: 'Limits', children: [
                StyledInput(controller: _ec, label: 'Expiry', hint: '2026-12-31T23:59:59'),
                StyledInput(controller: _lc, label: 'Usage Limit', number: true),
                ToggleRow(label: 'Active', value: _active, onChanged: (v) => setState(() => _active = v)),
              ]),
              const SizedBox(height: 32),
              FashionButton(label: _editId != null ? 'Update Coupon' : 'Create Coupon', loading: _saving, onPressed: _saving ? null : _save),
              const SizedBox(height: 40),
            ])))),
          ]),
    );
  }
}
