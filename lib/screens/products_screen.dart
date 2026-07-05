import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../config/api_config.dart';
import '../config/theme.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import '../services/admin_service.dart';
import '../widgets.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final AdminService _admin = AdminService(ApiService());
  List<AdminProduct> _products = [];
  bool _loading = true;
  String _query = '';
  String _genderFilter = '';
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final p = await _admin.getProducts(
        gender: _genderFilter.isNotEmpty ? _genderFilter : null,
      );
      if (mounted) setState(() { _products = p; _loading = false; });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  List<AdminProduct> get _filtered => _products.where((p) {
    if (_query.isNotEmpty && !p.title.toLowerCase().contains(_query.toLowerCase()) && !p.sku.toLowerCase().contains(_query.toLowerCase())) return false;
    if (_genderFilter.isNotEmpty && (p.gender == null || p.gender!.toLowerCase() != _genderFilter)) return false;
    return true;
  }).toList();

  Future<void> _delete(String id, String title) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Row(children: [
          Container(width: 28, height: 28, decoration: BoxDecoration(color: AppColors.error.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)), child: const Icon(Icons.delete_outlined, color: AppColors.error, size: 16)),
          const SizedBox(width: 10),
          const Text('DELETE', style: TextStyle(color: AppColors.coral, letterSpacing: 3, fontSize: 14, fontWeight: FontWeight.w800)),
        ]),
        content: Text('Remove "$title"?', style: TextStyle(color: AppColors.textSecondary)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Container(padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9), decoration: BoxDecoration(color: AppColors.surfaceAlt, border: Border.all(color: AppColors.borderLight, width: 1), borderRadius: BorderRadius.circular(7)), child: Text('CANCEL', style: TextStyle(color: AppColors.textSecondary, letterSpacing: 2, fontSize: 10, fontWeight: FontWeight.w800)))),
          const SizedBox(width: 8),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: Container(padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9), decoration: BoxDecoration(gradient: LinearGradient(colors: [AppColors.error, AppColors.error80], begin: Alignment.topCenter, end: Alignment.bottomCenter), border: Border.all(color: AppColors.error, width: 1), borderRadius: BorderRadius.circular(7), boxShadow: AppColors.shadowGlow(AppColors.error)), child: const Text('DELETE', style: TextStyle(color: Colors.white, letterSpacing: 2, fontSize: 10, fontWeight: FontWeight.w800)))),
        ],
      ),
    );
    if (ok == true) {
      try { await _admin.deleteProduct(id); _load(); } catch (_) {}
    }
  }

  Widget _genderChip(String label, String value) {
    final active = _genderFilter == value;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => _genderFilter = value);
          _load();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: active
              ? AppColors.premiumGoldDeco(radius: 9)
              : BoxDecoration(
                  color: AppColors.surfaceAlt,
                  borderRadius: BorderRadius.circular(9),
                  border: Border.all(color: AppColors.borderLight, width: 1),
                ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: active ? AppColors.coralDark : AppColors.textSecondary,
              fontSize: 12,
              fontWeight: active ? FontWeight.w800 : FontWeight.w700,
              letterSpacing: 1,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      drawer: const FashionNavDrawer(currentRoute: '/products'),
      floatingActionButton: Container(
        width: 56, height: 56,
          decoration: AppColors.premiumGoldDeco(radius: 16),
          child: IconButton(icon: Icon(Icons.add, color: AppColors.coralDark, size: 26), onPressed: () => Navigator.pushNamed(context, '/product-form').then((_) => _load())),
      ),
      body: Column(
        children: [
          Builder(builder: (ctx) => BrandHeader(
            title: 'Products',
            subtitle: '${_products.length} ITEMS',
            onMenuTap: () => Scaffold.of(ctx).openDrawer(),
          )),
          const SizedBox(height: 16),
          SearchInput(hint: 'SEARCH PRODUCTS', onChanged: (v) {
            _debounce?.cancel();
            _debounce = Timer(const Duration(milliseconds: 250), () {
              if (mounted) setState(() => _query = v);
            });
          }),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(children: [
              _genderChip('All', ''),
              const SizedBox(width: 8),
              _genderChip('Men', 'men'),
              const SizedBox(width: 8),
              _genderChip('Women', 'women'),
              const SizedBox(width: 8),
              _genderChip('Kids', 'kids'),
            ]),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: _loading
                ? const BrandLoader(label: 'Loading')
                : _filtered.isEmpty
                    ? const EmptyBox(icon: Icons.inventory_2_outlined, message: 'No products yet')
                    : RefreshIndicator(
                        color: AppColors.coral,
                        backgroundColor: AppColors.surface,
                        onRefresh: _load,
                        child: ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                          itemCount: _filtered.length,
                          itemBuilder: (_, i) {
                            final p = _filtered[i];
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
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 60, height: 60,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(colors: [AppColors.bgAlt, AppColors.surfaceAlt], begin: Alignment.topLeft, end: Alignment.bottomRight),
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: AppColors.border, width: 1),
                                      ),
                                      child: p.primaryImage != null
                                          ? ClipRRect(
                                              borderRadius: BorderRadius.circular(9),
                                              child: CachedNetworkImage(
                                                imageUrl: p.primaryImage!.startsWith('http') ? p.primaryImage! : '${ApiConfig.baseUrl}${p.primaryImage!}',
                                                fit: BoxFit.cover,
                                                placeholder: (_, __) => Container(color: AppColors.bgAlt, child: Icon(Icons.inventory_2_outlined, color: AppColors.textMuted, size: 24)),
                                                errorWidget: (_, __, ___) => Container(color: AppColors.bgAlt, child: Icon(Icons.broken_image, color: AppColors.textMuted, size: 24)),
                                              ),
                                            )
                                          : Icon(Icons.inventory_2_outlined, color: AppColors.textMuted, size: 24),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(p.title, style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w700, fontSize: 14), overflow: TextOverflow.ellipsis),
                                          const SizedBox(height: 4),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(color: AppColors.bgAlt, borderRadius: BorderRadius.circular(4), border: Border.all(color: AppColors.border)),
                                            child: Text('SKU: ${p.sku}', style: TextStyle(color: AppColors.textMuted, fontSize: 9, letterSpacing: 0.8, fontWeight: FontWeight.w600)),
                                          ),
                                          const SizedBox(height: 8),
                                          Row(children: [
                                            if (p.discountPrice != null) ...[
                                              ShaderMask(shaderCallback: (b) => LinearGradient(colors: [AppColors.coral, AppColors.coral80]).createShader(b),
                                                child: Text('₹${p.discountPrice!.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16)),
                                              ),
                                              const SizedBox(width: 8),
                                              Text('₹${p.price.toStringAsFixed(2)}', style: TextStyle(color: AppColors.textMuted, fontSize: 12, decoration: TextDecoration.lineThrough)),
                                            ] else
                                              ShaderMask(shaderCallback: (b) => LinearGradient(colors: [AppColors.coral, AppColors.coral80]).createShader(b),
                                                child: Text('₹${p.price.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16)),
                                              ),
                                          ]),
                                          const SizedBox(height: 8),
                                          Wrap(spacing: 4, runSpacing: 4, children: [
                                            if (p.featured) Tag(text: 'Featured', color: AppColors.gold, filled: true),
                                            if (p.gender != null) Tag(text: p.gender![0].toUpperCase() + p.gender!.substring(1), color: AppColors.coral),
                                            if (p.isReplaceable) const Tag(text: 'Replace', color: AppColors.coral),
                                            if (p.isReturnable) const Tag(text: 'Return', color: AppColors.coral),
                                            if (!p.isActive) const Tag(text: 'Inactive', color: AppColors.error, filled: true),
                                            if (p.categoryName != null) Tag(text: p.categoryName!, color: AppColors.textMuted),
                                            Tag(text: 'Stock: ${p.stock}', color: p.stock > 5 ? AppColors.success : AppColors.error),
                                          ]),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () => Navigator.pushNamed(context, '/product-form', arguments: p.id).then((_) => _load()),
                                          child: Container(
                                            width: 38, height: 38,
                                            decoration: AppColors.premiumGoldDeco(radius: 8),
                                            child: Icon(Icons.edit_outlined, color: AppColors.coralDark, size: 16),
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        GestureDetector(
                                          onTap: () => _delete(p.id, p.title),
                                          child: Container(
                                            width: 38, height: 38,
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(colors: [AppColors.error, AppColors.error80], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                                              border: Border.all(color: AppColors.error, width: 1),
                                              borderRadius: BorderRadius.circular(8),
                                              boxShadow: AppColors.shadowGlow(AppColors.error),
                                            ),
                                            child: const Icon(Icons.delete_outline, color: Colors.white, size: 16),
                                          ),
                                        ),
                                      ],
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
