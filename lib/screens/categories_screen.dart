import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../config/api_config.dart';
import '../config/theme.dart';
import '../models/category.dart';
import '../services/api_service.dart';
import '../services/admin_service.dart';
import '../widgets.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final AdminService _admin = AdminService(ApiService());
  List<AdminCategory> _categories = [];
  bool _loading = true;
  String _genderFilter = '';

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    try {
      final c = await _admin.getCategories(
        gender: _genderFilter.isNotEmpty ? _genderFilter : null,
      );
      if (mounted) setState(() { _categories = c; _loading = false; });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  List<AdminCategory> get _parents => _categories.where((c) => c.isParent).toList();

  List<AdminCategory> _childrenOf(String parentId) =>
      _categories.where((c) => c.parentId == parentId).toList();

  List<AdminCategory> get _genderParents =>
      _parents.where((c) => AdminCategory.mainCategoryNames.any((n) => n.toLowerCase() == c.name.toLowerCase())).toList();

  List<AdminCategory> get _otherParents =>
      _parents.where((c) => !AdminCategory.mainCategoryNames.any((n) => n.toLowerCase() == c.name.toLowerCase()) && _genderFor(c).isEmpty).toList();

  String _genderFor(AdminCategory cat) {
    if (cat.gender != null) return cat.gender!.toLowerCase();
    if (cat.parentId != null) {
      final parent = _categories.where((c) => c.id == cat.parentId).firstOrNull;
      if (parent != null) {
        if (parent.gender != null) return parent.gender!.toLowerCase();
        if (AdminCategory.mainCategoryNames.any((n) => n.toLowerCase() == parent.name.toLowerCase())) {
          return parent.name.toLowerCase();
        }
      }
    }
    return '';
  }

  List<AdminCategory> _categoriesForGender(String gender) {
    return _categories.where((c) {
      final cg = _genderFor(c);
      return cg == gender && !AdminCategory.mainCategoryNames.any((n) => n.toLowerCase() == c.name.toLowerCase());
    }).toList();
  }

  List<AdminCategory> get _orphans =>
      _categories.where((c) => _genderFor(c).isEmpty && !AdminCategory.mainCategoryNames.any((n) => n.toLowerCase() == c.name.toLowerCase())).toList();

  Future<void> _navigate(String route, [String? arg]) async {
    try {
      await Navigator.pushNamed(context, route, arguments: arg);
      _load();
    } catch (_) {}
  }

  Future<void> _delete(AdminCategory cat) async {
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
        content: Text('Remove "${cat.name}"?${_childrenOf(cat.id).isNotEmpty ? '\nSubcategories will also be removed.' : ''}', style: TextStyle(color: AppColors.textSecondary)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), decoration: BoxDecoration(gradient: LinearGradient(colors: [AppColors.btnColor40, AppColors.surface], begin: Alignment.topLeft, end: Alignment.bottomRight), border: Border.all(color: AppColors.btnBorder, width: 1), borderRadius: BorderRadius.circular(6), boxShadow: AppColors.shadowSm), child: Text('CANCEL', style: TextStyle(color: AppColors.btnColor, letterSpacing: 2, fontSize: 10)))),
          const SizedBox(width: 8),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), decoration: BoxDecoration(gradient: LinearGradient(colors: [AppColors.btnColor, AppColors.btnColor80]), border: Border.all(color: AppColors.btnBorder, width: 1), borderRadius: BorderRadius.circular(6)), child: const Text('DELETE', style: TextStyle(color: Colors.black, letterSpacing: 2, fontSize: 10)))),
        ],
      ),
    );
    if (ok == true) {
      try {
        await _admin.deleteCategory(cat.id);
        _load();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Delete failed: ${e.toString().length > 100 ? e.toString().substring(0, 100) : e.toString()}'),
            backgroundColor: AppColors.error,
          ));
        }
      }
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
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            gradient: active
                ? LinearGradient(colors: [AppColors.btnColor, AppColors.btnColor80], begin: Alignment.topLeft, end: Alignment.bottomRight)
                : null,
            color: active ? null : AppColors.surfaceAlt,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: active ? AppColors.btnBorder : AppColors.borderLight,
              width: 1,
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: active ? Colors.black : AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w700,
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
      drawer: const FashionNavDrawer(currentRoute: '/categories'),
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
          onPressed: () => _navigate('/category-form'),
        ),
      ),
      body: Column(children: [
        Builder(builder: (ctx) => BrandHeader(
          title: 'Categories',
          subtitle: '${_categories.length} TOTAL',
          onMenuTap: () => Scaffold.of(ctx).openDrawer(),
        )),
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
        Expanded(child: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.coral))
          : _categories.isEmpty
            ? const EmptyBox(icon: Icons.category_outlined, message: 'No categories')
            : RefreshIndicator(
                color: AppColors.coral, backgroundColor: AppColors.surface,
                onRefresh: _load,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                    children: _genderFilter.isEmpty
                      ? [
                          for (final gender in AdminCategory.mainCategoryNames) ...[
                            ..._genderParents.where((p) => p.name.toLowerCase() == gender.toLowerCase()).map((p) => _buildCategoryCard(p, isParent: true)),
                          for (final cat in _categoriesForGender(gender.toLowerCase()))
                            _buildCategoryCard(cat, isParent: cat.isParent),
                        ],
                        if (_otherParents.isNotEmpty || _categoriesForGender('unisex').isNotEmpty) ...[
                          Padding(
                            padding: const EdgeInsets.only(top: 12, bottom: 10),
                            child: Row(children: [
                              Container(width: 16, height: 2, decoration: BoxDecoration(gradient: LinearGradient(colors: AppColors.coralGradient), borderRadius: BorderRadius.circular(1))),
                              const SizedBox(width: 8),
                              Text('OTHER', style: TextStyle(color: AppColors.textMuted, fontSize: 10, letterSpacing: 3, fontWeight: FontWeight.w800)),
                            ]),
                          ),
                          for (final parent in _otherParents)
                            _buildCategoryCard(parent, isParent: true),
                          for (final cat in _categoriesForGender('unisex'))
                            _buildCategoryCard(cat, isParent: cat.isParent),
                        ],
                        if (_orphans.isNotEmpty) ...[
                          Padding(
                            padding: const EdgeInsets.only(top: 12, bottom: 10),
                            child: Row(children: [
                              Container(width: 16, height: 2, decoration: BoxDecoration(gradient: LinearGradient(colors: AppColors.coralGradient), borderRadius: BorderRadius.circular(1))),
                              const SizedBox(width: 8),
                              Text('UNGROUPED', style: TextStyle(color: AppColors.textMuted, fontSize: 10, letterSpacing: 3, fontWeight: FontWeight.w800)),
                            ]),
                          ),
                          for (final cat in _orphans)
                            _buildCategoryCard(cat, isParent: cat.isParent),
                        ],
                      ]
                    : _categories.where((c) {
                        final g = _genderFor(c);
                        return g == _genderFilter && !AdminCategory.mainCategoryNames.any((n) => n.toLowerCase() == c.name.toLowerCase());
                      }).map((c) => _buildCategoryCard(c, isParent: c.isParent)).toList(),
                ),
              ),
        ),
      ]),
    );
  }

  Widget _buildCategoryCard(AdminCategory cat, {required bool isParent}) {
    final hasChildren = isParent && _childrenOf(cat.id).isNotEmpty;
    final accent = cat.isActive ? AppColors.coral : AppColors.textMuted;
    return Container(
      margin: EdgeInsets.only(bottom: 8, left: isParent ? 0 : 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [AppColors.surface, AppColors.surfaceAlt], begin: Alignment.topLeft, end: Alignment.bottomRight),
        border: Border.all(color: isParent ? AppColors.coral.withValues(alpha: 0.25) : AppColors.borderLight, width: 1),
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppColors.shadowSm,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(colors: [Colors.white.withValues(alpha: 0.03), Colors.transparent], begin: Alignment.topLeft, end: Alignment.bottomRight),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(children: [
          if (!isParent) Container(
            margin: const EdgeInsets.only(right: 8),
            width: 24, height: 24,
            decoration: BoxDecoration(color: AppColors.textMuted.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
            child: Icon(Icons.subdirectory_arrow_right, size: 14, color: AppColors.textMuted),
          ),
          Container(
            width: 46, height: 46,
            decoration: BoxDecoration(
              color: cat.isActive ? accent.withValues(alpha: 0.1) : AppColors.bgAlt,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: cat.isActive ? accent.withValues(alpha: 0.2) : AppColors.border, width: 1),
            ),
            child: cat.imageUrl != null && cat.imageUrl!.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(9),
                    child: CachedNetworkImage(
                      imageUrl: cat.imageUrl!.startsWith('http') ? cat.imageUrl! : '${ApiConfig.baseUrl}${cat.imageUrl!}',
                      fit: BoxFit.cover,
                      width: 46, height: 46,
                      placeholder: (_, __) => Center(child: Text(cat.name.isNotEmpty ? cat.name[0].toUpperCase() : '?', style: TextStyle(color: cat.isActive ? accent : AppColors.textMuted, fontWeight: FontWeight.w900, fontSize: 20))),
                      errorWidget: (_, __, ___) => Center(child: Text(cat.name.isNotEmpty ? cat.name[0].toUpperCase() : '?', style: TextStyle(color: cat.isActive ? accent : AppColors.textMuted, fontWeight: FontWeight.w900, fontSize: 20))),
                    ),
                  )
                : Center(
                    child: Text(
                      cat.name.isNotEmpty ? cat.name[0].toUpperCase() : '?',
                      style: TextStyle(
                        color: cat.isActive ? accent : AppColors.textMuted,
                        fontWeight: FontWeight.w900, fontSize: 20,
                      ),
                    ),
                  ),
          ),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(cat.name, style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w700, fontSize: 14, letterSpacing: 0.5)),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: cat.isActive ? AppColors.bgAlt : AppColors.error.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '${cat.isParent ? 'PARENT' : 'SUBCATEGORY'}${cat.gender != null ? ' · ${cat.gender![0].toUpperCase()}${cat.gender!.substring(1)}' : ''}${hasChildren ? ' · ${_childrenOf(cat.id).length} SUBCATEGORIES' : ''}${!cat.isActive ? ' · INACTIVE' : ''}',
                style: TextStyle(color: cat.isActive ? AppColors.textMuted : AppColors.error, fontSize: 10, fontWeight: FontWeight.w700),
              ),
            ),
          ])),
          Column(children: [
            GestureDetector(
              onTap: () => _navigate('/category-form', cat.id),
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
            const SizedBox(height: 6),
            GestureDetector(
              onTap: () => _delete(cat),
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
        ]),
      ),
    );
  }
}
