import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import '../config/theme.dart';
import '../services/api_service.dart';
import '../services/admin_service.dart';
import '../widgets.dart';

// Banner image requirements — shown to the admin and enforced before upload.
// The backend re-validates the same rules on the server.
const int _kMaxBytes = 5 * 1024 * 1024; // 5 MB
const Set<String> _kAllowedExts = {'jpg', 'jpeg', 'png', 'webp'};
const int _kMinWidth = 600;
const int _kMinHeight = 400;
const int _kRecWidth = 1536;
const int _kRecHeight = 1024;

class BannerFormScreen extends StatefulWidget {
  const BannerFormScreen({super.key});

  @override
  State<BannerFormScreen> createState() => _BannerFormScreenState();
}

class _BannerFormScreenState extends State<BannerFormScreen> {
  final AdminService _admin = AdminService(ApiService());
  final _fk = GlobalKey<FormState>();
  final _imageC = TextEditingController();
  final _titleC = TextEditingController();
  final _subtitleC = TextEditingController();
  final _linkUrlC = TextEditingController();
  final _linkTextC = TextEditingController();
  final _sectionC = TextEditingController(text: 'hero');
  final _sortC = TextEditingController(text: '0');

  String? _editId;
  bool _loading = false, _saving = false, _active = true, _uploading = false;
  String _imageUrl = '';

  @override
  void initState() {
    super.initState();
    _imageC.addListener(() {
      final trimmed = _imageC.text.trim();
      if (trimmed != _imageUrl) setState(() => _imageUrl = trimmed);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_editId == null) {
      _editId = ModalRoute.of(context)?.settings.arguments as String?;
      if (_editId != null) _load();
    }
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final b = await _admin.getBanner(_editId!);
      if (mounted) {
        _imageC.text = b.imageUrl;
        _titleC.text = b.title ?? '';
        _subtitleC.text = b.subtitle ?? '';
        _linkUrlC.text = b.linkUrl ?? '';
        _linkTextC.text = b.linkText ?? '';
        _sectionC.text = b.section;
        _sortC.text = b.sortOrder.toString();
        _active = b.isActive;
      }
    } catch (_) {}
    if (mounted) setState(() => _loading = false);
  }

  @override
  void dispose() {
    _imageC.dispose();
    _titleC.dispose();
    _subtitleC.dispose();
    _linkUrlC.dispose();
    _linkTextC.dispose();
    _sectionC.dispose();
    _sortC.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_fk.currentState!.validate()) return;
    setState(() => _saving = true);
    final data = <String, dynamic>{
      'image_url': _imageC.text.trim(),
      if (_titleC.text.trim().isNotEmpty) 'title': _titleC.text.trim(),
      if (_subtitleC.text.trim().isNotEmpty) 'subtitle': _subtitleC.text.trim(),
      if (_linkUrlC.text.trim().isNotEmpty) 'link_url': _linkUrlC.text.trim(),
      if (_linkTextC.text.trim().isNotEmpty) 'link_text': _linkTextC.text.trim(),
      'section': _sectionC.text.trim().isEmpty ? 'hero' : _sectionC.text.trim(),
      'sort_order': int.tryParse(_sortC.text.trim()) ?? 0,
      'is_active': _active,
    };
    try {
      if (_editId != null) {
        await _admin.updateBanner(_editId!, data);
      } else {
        await _admin.createBanner(data);
      }
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.toString().length > 100 ? e.toString().substring(0, 100) : e.toString()),
          backgroundColor: AppColors.error,
        ));
      }
    }
    if (mounted) setState(() => _saving = false);
  }

  void _showError(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: AppColors.error),
    );
  }

  // Pick an image, validate format/size/dimensions, then upload it and put the
  // returned URL into the image field. Validation mirrors the backend rules.
  Future<void> _pickAndUpload() async {
    try {
      final XFile? file =
          await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 100);
      if (file == null) return;

      final name = file.name;
      final ext = name.contains('.') ? name.split('.').last.toLowerCase() : '';
      if (!_kAllowedExts.contains(ext)) {
        _showError('Unsupported format. Allowed: JPG, PNG, WebP.');
        return;
      }

      final bytes = await file.readAsBytes();
      if (bytes.lengthInBytes > _kMaxBytes) {
        final mb = (bytes.lengthInBytes / (1024 * 1024)).toStringAsFixed(1);
        _showError('Image is too large ($mb MB). Maximum size is 5 MB.');
        return;
      }

      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      final w = frame.image.width, h = frame.image.height;
      frame.image.dispose();
      if (w < _kMinWidth || h < _kMinHeight) {
        _showError('Image too small ($w×$h). Minimum is $_kMinWidth×$_kMinHeight px.');
        return;
      }

      setState(() => _uploading = true);
      final url = await _admin.uploadImageBytes(bytes, name);
      if (mounted) _imageC.text = url;
    } catch (e) {
      _showError('Upload failed: $e');
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: _loading
          ? const BrandLoader(label: 'Loading')
          : Column(children: [
              BrandHeader(title: _editId != null ? 'Edit Banner' : 'New Banner'),
              Expanded(child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(key: _fk, child: Column(children: [
                  FormSection(title: 'Banner Image', children: [
                    _SpecsBox(),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _uploading ? null : _pickAndUpload,
                        icon: _uploading
                            ? const SizedBox(
                                width: 16, height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.coral))
                            : const Icon(Icons.upload_file, size: 18),
                        label: Text(_uploading ? 'Uploading…' : 'Upload Image'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.coral,
                          side: const BorderSide(color: AppColors.coral),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    StyledInput(
                      controller: _imageC,
                      label: 'Image URL *',
                      hint: 'Upload above, or paste a URL',
                      validator: (v) => v?.trim().isEmpty == true ? 'Upload an image or provide a URL' : null,
                    ),
                    if (_imageUrl.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: Stack(children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: AspectRatio(
                              aspectRatio: 3 / 2,
                              child: CachedNetworkImage(
                                imageUrl: _imageUrl,
                                fit: BoxFit.cover,
                                placeholder: (_, __) => const Center(child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.coral)),
                                errorWidget: (_, __, ___) => Center(child: Icon(Icons.broken_image, color: AppColors.textMuted, size: 36)),
                              ),
                            ),
                          ),
                          Positioned(top: 6, right: 6, child: GestureDetector(
                            onTap: () => _imageC.clear(),
                            child: Container(
                              width: 28, height: 28,
                              decoration: AppColors.premiumGoldDeco(radius: 6),
                              child: Icon(Icons.close, color: Colors.white, size: 16),
                            ),
                          )),
                        ]),
                      ),
                  ]),
                  const SizedBox(height: 16),
                  FormSection(title: 'Details (optional)', children: [
                    StyledInput(controller: _titleC, label: 'Title', hint: 'Shown for accessibility / future overlays'),
                    StyledInput(controller: _subtitleC, label: 'Subtitle', hint: 'Optional'),
                    StyledInput(controller: _linkUrlC, label: 'Link URL', hint: 'Where the banner points (optional)'),
                    StyledInput(controller: _linkTextC, label: 'Link Text', hint: 'e.g. Shop Now (optional)'),
                  ]),
                  const SizedBox(height: 16),
                  FormSection(title: 'Placement', children: [
                    StyledInput(controller: _sectionC, label: 'Section', hint: 'hero'),
                    StyledInput(controller: _sortC, label: 'Sort Order', hint: '0 = first', number: true),
                    ToggleRow(label: 'Active', value: _active, onChanged: (v) => setState(() => _active = v)),
                  ]),
                  const SizedBox(height: 32),
                  FashionButton(
                    label: _editId != null ? 'Update Banner' : 'Create Banner',
                    loading: _saving,
                    onPressed: _saving ? null : _save,
                  ),
                  const SizedBox(height: 40),
                ])),
              )),
            ]),
    );
  }
}

class _SpecsBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget row(IconData icon, String text) => Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(children: [
            Icon(icon, size: 15, color: AppColors.textMuted),
            const SizedBox(width: 8),
            Expanded(child: Text(text, style: TextStyle(fontSize: 12.5, color: AppColors.textMuted))),
          ]),
        );
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.coral.withOpacity(0.06),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.coral.withOpacity(0.25)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Image requirements',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        const SizedBox(height: 8),
        row(Icons.aspect_ratio, 'Recommended: $_kRecWidth × $_kRecHeight px (3:2)'),
        row(Icons.photo_size_select_large, 'Minimum: $_kMinWidth × $_kMinHeight px'),
        row(Icons.sd_storage_outlined, 'Max file size: 5 MB'),
        row(Icons.image_outlined, 'Formats: JPG, PNG, WebP'),
      ]),
    );
  }
}
