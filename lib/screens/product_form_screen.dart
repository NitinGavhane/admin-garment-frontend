import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../config/theme.dart';
import '../models/category.dart';
import '../services/api_service.dart';
import '../services/admin_service.dart';
import '../services/image_upload_service.dart';
import '../widgets.dart';

class ProductFormScreen extends StatefulWidget {
  const ProductFormScreen({super.key});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final AdminService _admin = AdminService(ApiService());
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _skuCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _discountCtrl = TextEditingController();
  final _stockCtrl = TextEditingController(text: '0');
  final _descCtrl = TextEditingController();
  final _brandCtrl = TextEditingController();
  final _urlCtrl = TextEditingController();

  String? _editId;
  bool _loading = false, _saving = false, _featured = false, _active = true, _replaceable = false, _returnable = false, _uploading = false;
  String? _catId;
  String? _gender;
  List<Map<String, dynamic>> _cats = [];
  final List<_V> _variants = [];
  final List<_ImageItem> _images = [];

  @override
  void initState() {
    super.initState();
    // Keep the live price preview in sync while typing.
    void refresh() { if (mounted) setState(() {}); }
    _priceCtrl.addListener(refresh);
    _discountCtrl.addListener(refresh);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_editId == null) {
      _editId = ModalRoute.of(context)?.settings.arguments as String?;
      if (_editId != null) _load();
    }
    _loadCats();
  }

  Future<void> _loadCats() async {
    try {
      final c = await _admin.getCategories();
      if (mounted) setState(() => _cats = c.map((x) => {'id': x.id, 'name': x.name, 'parent_id': x.parentId, 'gender': x.gender}).toList());
    } catch (_) {}
  }

  Future<void> _load() async {
    if (_editId == null) return;
    setState(() => _loading = true);
    try {
      final p = await _admin.getProduct(_editId!);
      _titleCtrl.text = p.title; _skuCtrl.text = p.sku;
      _priceCtrl.text = p.price.toString();
      if (p.discountPrice != null) _discountCtrl.text = (p.price - p.discountPrice!).toStringAsFixed(0);
      _stockCtrl.text = p.stock.toString();
      _descCtrl.text = p.description ?? ''; _brandCtrl.text = p.brand ?? '';
      _featured = p.featured; _active = p.isActive; _replaceable = p.isReplaceable; _returnable = p.isReturnable; _catId = p.categoryId; _gender = p.gender;
      _images.clear();
      for (final img in p.images) {
        _images.add(_ImageItem(url: img.imageUrl, isPrimary: img.isPrimary));
      }
      for (final v in p.variants) {
        _variants.add(_V(
          sc: TextEditingController(text: v.size ?? ''),
          cc: TextEditingController(text: v.color ?? ''),
          stc: TextEditingController(text: v.stock.toString()),
          pc: TextEditingController(text: v.price?.toString() ?? ''),
        ));
      }
    } catch (_) {}
    if (mounted) setState(() => _loading = false);
  }

  /// All categories as dropdown items, grouped under their parent. We never
  /// hide categories based on the selected gender — doing so could leave the
  /// dropdown empty and make it impossible to set a category (so products
  /// could not be created at all).
  List<DropdownMenuItem<String>> _categoryItems() {
    final parents = _cats.where((c) => c['parent_id'] == null).toList();
    final items = <DropdownMenuItem<String>>[];
    for (final p in parents) {
      items.add(DropdownMenuItem<String>(
        value: p['id'] as String?,
        child: Text(p['name'] as String? ?? '', style: TextStyle(color: AppColors.textPrimary)),
      ));
      final subs = _cats.where((c) => c['parent_id'] == p['id']).toList();
      for (final s in subs) {
        items.add(DropdownMenuItem<String>(value: s['id'] as String?, child: Row(children: [
          Icon(Icons.subdirectory_arrow_right, size: 16, color: AppColors.textMuted),
          const SizedBox(width: 4),
          Text(s['name'] as String? ?? '', style: TextStyle(color: AppColors.textSecondary)),
        ])));
      }
    }
    // Include any categories whose parent isn't in the list so a previously
    // saved category is always selectable (avoids a "value not in items" crash).
    final shownIds = items.map((e) => e.value).toSet();
    for (final c in _cats) {
      if (!shownIds.contains(c['id'])) {
        items.add(DropdownMenuItem<String>(
          value: c['id'] as String?,
          child: Text(c['name'] as String? ?? '', style: TextStyle(color: AppColors.textPrimary)),
        ));
      }
    }
    return items;
  }

  void _showError(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: AppColors.error),
    );
  }

  /// Add an image to the list. The first image added becomes the primary one,
  /// so a product always has a primary image to show in listings.
  void _addImage(String url) {
    setState(() => _images.add(_ImageItem(url: url, isPrimary: _images.isEmpty)));
  }

  /// Remove an image, promoting the first remaining one when the primary goes,
  /// so the product never ends up with images but no primary.
  void _removeImage(int i) {
    setState(() {
      _images.removeAt(i);
      if (_images.isNotEmpty && !_images.any((img) => img.isPrimary)) {
        _images.first.isPrimary = true;
      }
    });
  }

  // Pick, validate and upload an image, then append it to the product's image
  // list. Uploading happens immediately; the URL is only persisted on save.
  Future<void> _pickAndUpload() async {
    setState(() => _uploading = true);
    try {
      final url = await pickValidateAndUploadImage(admin: _admin, specs: ImageSpecs.product);
      if (url != null && mounted) _addImage(url);
    } on ImageUploadException catch (e) {
      _showError(e.message);
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  void _addImageUrl() {
    _urlCtrl.clear();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Row(children: [
          Container(width: 28, height: 28, decoration: BoxDecoration(color: AppColors.coral.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)), child: const Icon(Icons.link, color: AppColors.coral, size: 16)),
          const SizedBox(width: 10),
          const Text('ADD IMAGE URL', style: TextStyle(color: AppColors.coral, letterSpacing: 3, fontSize: 14, fontWeight: FontWeight.w800)),
        ]),
        content: TextField(
          controller: _urlCtrl,
          style: TextStyle(color: AppColors.textPrimary, fontSize: 13),
          decoration: InputDecoration(
            hintText: 'https://example.com/image.jpg',
            hintStyle: TextStyle(color: AppColors.textMuted, fontSize: 12),
            filled: true, fillColor: AppColors.bgAlt,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: AppColors.border, width: 1),
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), decoration: BoxDecoration(gradient: LinearGradient(colors: [AppColors.btnColor40, AppColors.surface], begin: Alignment.topLeft, end: Alignment.bottomRight), border: Border.all(color: AppColors.btnBorder, width: 1), borderRadius: BorderRadius.circular(6), boxShadow: AppColors.shadowSm), child: Text('CANCEL', style: TextStyle(color: AppColors.btnColor, letterSpacing: 2, fontSize: 10)))),
          const SizedBox(width: 8),
          TextButton(onPressed: () {
            final url = _urlCtrl.text.trim();
            if (url.isNotEmpty) _addImage(url);
            Navigator.pop(ctx);
          }, child: Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), decoration: AppColors.premiumGoldDeco(radius: 6), child: Text('ADD', style: TextStyle(color: Colors.white, letterSpacing: 2, fontSize: 10)))),
        ],
      ),
    );
  }

  @override void dispose() {
    _titleCtrl.dispose(); _skuCtrl.dispose(); _priceCtrl.dispose();
    _discountCtrl.dispose(); _stockCtrl.dispose();
    _descCtrl.dispose(); _brandCtrl.dispose(); _urlCtrl.dispose();
    for (final v in _variants) { v.sc.dispose(); v.cc.dispose(); v.stc.dispose(); v.pc.dispose(); }
    super.dispose();
  }

  Widget _priceRow(String label, double amount, {bool bold = false, Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: AppColors.textSecondary, fontSize: 13, fontWeight: bold ? FontWeight.w700 : FontWeight.w500)),
        Text('₹${amount.abs().toStringAsFixed(0)}', style: TextStyle(
          color: color ?? (amount < 0 ? AppColors.error : AppColors.textPrimary),
          fontSize: 14,
          fontWeight: bold ? FontWeight.w900 : FontWeight.w600,
        )),
      ],
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_catId == null || _catId!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a category')));
      return;
    }
    setState(() => _saving = true);
    final d = <String, dynamic>{
      'title': _titleCtrl.text.trim(), 'sku': _skuCtrl.text.trim(),
      'price': double.parse(_priceCtrl.text.trim()), 'category_id': _catId,
      'stock': int.tryParse(_stockCtrl.text.trim()) ?? 0,
      'featured': _featured, 'is_active': _active, 'is_replaceable': _replaceable, 'is_returnable': _returnable,
      'variants': _variants.map((v) => {
        'size': v.sc.text.trim().isEmpty ? null : v.sc.text.trim(),
        'color': v.cc.text.trim().isEmpty ? null : v.cc.text.trim(),
        'stock': int.tryParse(v.stc.text.trim()) ?? 0,
        'price': v.pc.text.trim().isEmpty ? null : double.tryParse(v.pc.text.trim()),
      }).toList(),
      'images': _images.map((img) => {
        'image_url': img.url,
        'is_primary': img.isPrimary,
      }).toList(),
    };
    if (_descCtrl.text.trim().isNotEmpty) d['description'] = _descCtrl.text.trim();
    if (_brandCtrl.text.trim().isNotEmpty) d['brand'] = _brandCtrl.text.trim();
    if (_discountCtrl.text.trim().isNotEmpty) {
      final p = double.tryParse(_priceCtrl.text.trim());
      final da = double.tryParse(_discountCtrl.text.trim());
      if (p != null && da != null) d['discount_price'] = p - da;
    }
    if (_gender != null) d['gender'] = _gender;
    try {
      if (_editId != null) { await _admin.updateProduct(_editId!, d); }
      else { await _admin.createProduct(d); }
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString().substring(0, e.toString().length > 80 ? 80 : e.toString().length))));
    }
    if (mounted) setState(() => _saving = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: _loading
          ? const BrandLoader(label: 'Loading')
          : Column(
              children: [
                BrandHeader(title: _editId != null ? 'Edit Product' : 'New Product'),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          FormSection(title: 'Basic Info', children: [
                            StyledInput(controller: _titleCtrl, label: 'Product Title *', validator: (v) => v?.trim().isEmpty == true ? 'Required' : null),
                            StyledInput(controller: _skuCtrl, label: 'SKU *', validator: (v) => v?.trim().isEmpty == true ? 'Required' : null),
                            Row(children: [
                              Expanded(child: StyledInput(controller: _priceCtrl, label: 'Price *', number: true, validator: (v) => v?.trim().isEmpty == true ? 'Required' : null)),
                              const SizedBox(width: 12),
                              Expanded(child: StyledInput(controller: _discountCtrl, label: 'Discount Amount', number: true)),
                            ]),
                            if (_priceCtrl.text.trim().isNotEmpty && _discountCtrl.text.trim().isNotEmpty) ...[
                              const SizedBox(height: 10),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: AppColors.btnColor.withValues(alpha: 0.3), width: 1),
                                  color: AppColors.btnColor.withValues(alpha: 0.05),
                                ),
                                child: Builder(builder: (_) {
                                  final p = double.tryParse(_priceCtrl.text.trim()) ?? 0;
                                  final da = double.tryParse(_discountCtrl.text.trim()) ?? 0;
                                  final fp = p - da;
                                  return Column(
                                    children: [
                                      _priceRow('Original Price', p),
                                      const SizedBox(height: 6),
                                      _priceRow('Discount', -da),
                                      Divider(height: 16, color: AppColors.borderLight),
                                      _priceRow('Final Price', fp, bold: true, color: AppColors.success),
                                    ],
                                  );
                                }),
                              ),
                            ],
                            Row(children: [
                              Expanded(child: StyledInput(controller: _stockCtrl, label: 'Stock', number: true)),
                            ]),
                            const SizedBox(height: 10),
                            // GST is applied automatically at checkout based on the
                            // customer's state — nothing to configure per product.
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppColors.btnColor.withValues(alpha: 0.3), width: 1),
                                color: AppColors.btnColor.withValues(alpha: 0.05),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.info_outline, size: 16, color: AppColors.btnColor),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('GST applied automatically',
                                            style: TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w700)),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Within West Bengal: CGST 9% + SGST 9%.\nOther states: IGST 18%.\nDecided from the customer’s delivery address.',
                                          style: TextStyle(color: AppColors.textSecondary, fontSize: 12, height: 1.4),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                          ]),
                          const SizedBox(height: 16),
                          FormSection(title: 'Images', children: [
                            const ImageSpecsBox(specs: ImageSpecs.product),
                            const SizedBox(height: 12),
                            ImageUploadButton(uploading: _uploading, onPressed: _pickAndUpload),
                            const SizedBox(height: 12),
                            if (_images.isNotEmpty)
                              Wrap(
                                spacing: 8, runSpacing: 8,
                                children: _images.asMap().entries.map((e) {
                                  final i = e.key;
                                  final img = e.value;
                                  return Stack(
                                    children: [
                                      Container(
                                        width: 90, height: 90,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(colors: [AppColors.bgAlt, AppColors.surfaceAlt], begin: Alignment.topLeft, end: Alignment.bottomRight),
                                          border: Border.all(color: img.isPrimary ? AppColors.coral : AppColors.border, width: img.isPrimary ? 2 : 1),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(7),
                                          child: CachedNetworkImage(imageUrl: img.url, fit: BoxFit.cover, width: 90, height: 90, placeholder: (_, __) => Container(color: AppColors.bgAlt), errorWidget: (_, __, ___) => Container(color: AppColors.bgAlt)),
                                        ),
                                      ),
                                      if (img.isPrimary)
                                        Positioned(
                                          top: 4, left: 4,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(colors: AppColors.coralGradient),
                                              borderRadius: BorderRadius.circular(3),
                                              boxShadow: AppColors.shadowSm,
                                            ),
                                            child: const Text('PRIMARY', style: TextStyle(color: Colors.white, fontSize: 7, fontWeight: FontWeight.w800, letterSpacing: 0.5)),
                                          ),
                                        ),
                                      Positioned(
                                        top: 4, right: 4,
                                        child: GestureDetector(
                                          onTap: () => _removeImage(i),
                                            child: Container(
                                              width: 22, height: 22,
                                              decoration: AppColors.premiumGoldDeco(radius: 4),
                                              child: Icon(Icons.close, color: Colors.white, size: 14),
                                            ),
                                        ),
                                      ),
                                      if (!img.isPrimary)
                                        Positioned(
                                          bottom: 4, right: 4,
                                          child: GestureDetector(
                                            onTap: () => setState(() {
                                              for (final x in _images) { x.isPrimary = false; }
                                              _images[i].isPrimary = true;
                                            }),
                                              child: Container(
                                                width: 22, height: 22,
                                                decoration: AppColors.premiumGoldDeco(radius: 4),
                                                child: Icon(Icons.star_border, color: Colors.white, size: 14),
                                              ),
                                          ),
                                        ),
                                    ],
                                  );
                                }).toList(),
                              ),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: double.infinity,
                              child: InkWell(
                                onTap: _addImageUrl,
                                borderRadius: BorderRadius.circular(8),
                                child: Ink(
                                  decoration: AppColors.premiumGoldDeco(radius: 8),
                                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                    Icon(Icons.link, color: Colors.white, size: 18),
                                    const SizedBox(width: 8),
                                    Text('ADD IMAGE URL', style: TextStyle(color: Colors.white, fontSize: 10, letterSpacing: 2, fontWeight: FontWeight.w700)),
                                    ]),
                                  ),
                                ),
                              ),
                          ]),
                          const SizedBox(height: 16),
                          FormSection(title: 'Details', children: [
                            StyledInput(controller: _descCtrl, label: 'Description', maxLines: 3),
                            StyledInput(controller: _brandCtrl, label: 'Brand'),
                            StyledDropdown(
                              label: 'Category *', value: _catId,
                              items: _categoryItems(),
                              onChanged: (v) => setState(() {
                                _catId = v;
                                // Keep the product's gender in sync with the chosen
                                // category so it lands under the right gender tab.
                                final cat = _cats.where((c) => c['id'] == v).firstOrNull;
                                final g = (cat?['gender'] as String?)?.toLowerCase();
                                if (g != null && AdminCategory.genderOptions.contains(g)) _gender = g;
                              }),
                            ),
                            const SizedBox(height: 4),
                            // Gender is inherited from the selected category
                            // (categories are gendered), so there is nothing to
                            // pick here — a men category can never hold a "women"
                            // product. This only shows what will be saved.
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              decoration: BoxDecoration(
                                color: AppColors.bgAlt,
                                border: Border.all(color: AppColors.border, width: 1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(children: [
                                Icon(Icons.wc, size: 16, color: AppColors.textMuted),
                                const SizedBox(width: 10),
                                Text('Gender (from category)', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                                const Spacer(),
                                Text(
                                  (_gender == null || _gender!.isEmpty)
                                      ? 'Select a category'
                                      : _gender![0].toUpperCase() + _gender!.substring(1),
                                  style: TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w700),
                                ),
                              ]),
                            ),
                          ]),
                          const SizedBox(height: 16),
                          FormSection(title: 'Status', children: [
                            Row(children: [
                              Expanded(child: ToggleRow(label: 'Featured', value: _featured, onChanged: (v) => setState(() => _featured = v))),
                              const SizedBox(width: 12),
                              Expanded(child: ToggleRow(label: 'Active', value: _active, onChanged: (v) => setState(() => _active = v))),
                            ]),
                            const SizedBox(height: 12),
                            Row(children: [
                              Expanded(child: ToggleRow(label: 'Replace', value: _replaceable, onChanged: (v) => setState(() => _replaceable = v))),
                              const SizedBox(width: 12),
                              Expanded(child: ToggleRow(label: 'Return', value: _returnable, onChanged: (v) => setState(() => _returnable = v))),
                            ]),
                          ]),
                          const SizedBox(height: 16),
                          FormSection(title: 'Variants', children: [
                            ..._variants.asMap().entries.map((e) {
                              final i = e.key; final v = e.value;
                              return Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: AppColors.bgAlt,
                                  border: Border.all(color: AppColors.border, width: 1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(children: [
                                  Row(children: [
                                    Expanded(child: StyledInput(controller: v.sc, label: 'Size', hint: 'M, L')),
                                    const SizedBox(width: 8),
                                    Expanded(child: StyledInput(controller: v.cc, label: 'Color', hint: 'Red')),
                                  ]),
                                  Row(children: [
                                    Expanded(child: StyledInput(controller: v.stc, label: 'Stock', number: true)),
                                    const SizedBox(width: 8),
                                    Expanded(child: StyledInput(controller: v.pc, label: 'Price', number: true, hint: 'Optional')),
                                    GestureDetector(
                                      onTap: () => setState(() => _variants.removeAt(i)),
                                      child: Container(
                                        width: 36, height: 36,
                                        decoration: AppColors.premiumGoldDeco(radius: 8),
                                        child: Icon(Icons.close, color: Colors.white, size: 16),
                                      ),
                                    ),
                                  ]),
                                ]),
                              );
                            }),
                            Center(
                              child: GestureDetector(
                                onTap: () => setState(() => _variants.add(_V(sc: TextEditingController(), cc: TextEditingController(), stc: TextEditingController(text: '0'), pc: TextEditingController()))),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                  decoration: AppColors.premiumGoldDeco(radius: 8),
                                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                                    Icon(Icons.add, color: Colors.white, size: 16),
                                    const SizedBox(width: 8),
                                    Text('ADD VARIANT', style: TextStyle(color: Colors.white, fontSize: 10, letterSpacing: 2, fontWeight: FontWeight.w700)),
                                  ]),
                                ),
                              ),
                            ),
                          ]),
                          const SizedBox(height: 32),
                          FashionButton(
                            label: _editId != null ? 'Update Product' : 'Create Product',
                            loading: _saving,
                            onPressed: _saving ? null : _save,
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class _V {
  final TextEditingController sc, cc, stc, pc;
  _V({required this.sc, required this.cc, required this.stc, required this.pc});
}

class _ImageItem {
  final String url;
  bool isPrimary;
  _ImageItem({required this.url, this.isPrimary = false});
}
