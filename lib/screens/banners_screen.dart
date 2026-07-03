import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../config/theme.dart';
import '../models/banner.dart';
import '../services/api_service.dart';
import '../services/admin_service.dart';
import '../widgets.dart';

class BannersScreen extends StatefulWidget {
  const BannersScreen({super.key});

  @override
  State<BannersScreen> createState() => _BannersScreenState();
}

class _BannersScreenState extends State<BannersScreen> {
  final AdminService _admin = AdminService(ApiService());
  List<AdminBanner> _banners = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final b = await _admin.getBanners();
      if (mounted) setState(() { _banners = b; _loading = false; });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _navigate(String route, [String? arg]) async {
    await Navigator.pushNamed(context, route, arguments: arg);
    _load();
  }

  Future<void> _delete(AdminBanner banner) async {
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
        content: Text('Remove this banner?', style: TextStyle(color: AppColors.textSecondary)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text('CANCEL', style: TextStyle(color: AppColors.btnColor, letterSpacing: 2, fontSize: 11))),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), decoration: BoxDecoration(gradient: LinearGradient(colors: [AppColors.btnColor, AppColors.btnColor80]), border: Border.all(color: AppColors.btnBorder, width: 1), borderRadius: BorderRadius.circular(6)), child: const Text('DELETE', style: TextStyle(color: Colors.black, letterSpacing: 2, fontSize: 10)))),
        ],
      ),
    );
    if (ok == true) {
      try {
        await _admin.deleteBanner(banner.id);
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
    return Scaffold(
      backgroundColor: AppColors.bg,
      drawer: const FashionNavDrawer(currentRoute: '/banners'),
      floatingActionButton: Container(
        width: 52, height: 52,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [AppColors.btnColor, AppColors.btnColor80]),
          border: Border.all(color: AppColors.btnBorder, width: 1),
          borderRadius: BorderRadius.circular(14),
          boxShadow: AppColors.shadowGlow(AppColors.btnColor),
        ),
        child: IconButton(
          icon: const Icon(Icons.add, color: Colors.black),
          onPressed: () => _navigate('/banner-form'),
        ),
      ),
      body: Column(children: [
        Builder(builder: (ctx) => BrandHeader(
          title: 'Sliding Banners',
          subtitle: '${_banners.length} TOTAL',
          onMenuTap: () => Scaffold.of(ctx).openDrawer(),
        )),
        Expanded(child: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.coral))
          : _banners.isEmpty
            ? const EmptyBox(icon: Icons.view_carousel_outlined, message: 'No banners yet — tap + to add one')
            : RefreshIndicator(
                color: AppColors.coral, backgroundColor: AppColors.surface,
                onRefresh: _load,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
                  children: _banners.map(_buildBannerCard).toList(),
                ),
              ),
        ),
      ]),
    );
  }

  Widget _buildBannerCard(AdminBanner b) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [AppColors.surface, AppColors.surfaceAlt], begin: Alignment.topLeft, end: Alignment.bottomRight),
        border: Border.all(color: b.isActive ? AppColors.coral.withValues(alpha: 0.25) : AppColors.borderLight, width: 1),
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppColors.shadowSm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(11)),
            child: AspectRatio(
              aspectRatio: 3 / 2,
              child: b.imageUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: b.imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => const Center(child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.coral)),
                      errorWidget: (_, __, ___) => Center(child: Icon(Icons.broken_image, color: AppColors.textMuted, size: 36)),
                    )
                  : Center(child: Icon(Icons.image, color: AppColors.textMuted, size: 36)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(b.title?.isNotEmpty == true ? b.title! : 'Untitled banner',
                    style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w700, fontSize: 14)),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: b.isActive ? AppColors.bgAlt : AppColors.error.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'SECTION: ${b.section.toUpperCase()} · ORDER ${b.sortOrder}${!b.isActive ? ' · INACTIVE' : ''}',
                    style: TextStyle(color: b.isActive ? AppColors.textMuted : AppColors.error, fontSize: 10, fontWeight: FontWeight.w700),
                  ),
                ),
              ])),
              GestureDetector(
                onTap: () => _navigate('/banner-form', b.id),
                child: Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [AppColors.btnColor, AppColors.btnColor80], begin: Alignment.topLeft, end: Alignment.bottomRight),
                    border: Border.all(color: AppColors.btnBorder, width: 1),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: AppColors.shadowGlow(AppColors.btnColor),
                  ),
                  child: const Icon(Icons.edit_outlined, color: Colors.black, size: 14),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => _delete(b),
                child: Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [AppColors.btnColor, AppColors.btnColor80], begin: Alignment.topLeft, end: Alignment.bottomRight),
                    border: Border.all(color: AppColors.btnBorder, width: 1),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: AppColors.shadowGlow(AppColors.btnColor),
                  ),
                  child: const Icon(Icons.delete_outlined, color: Colors.black, size: 14),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
