class AdminBanner {
  final String id;
  final String? title;
  final String? subtitle;
  final String imageUrl;
  final String? linkUrl;
  final String? linkText;
  final String section;
  final int sortOrder;
  final bool isActive;

  const AdminBanner({
    required this.id,
    this.title,
    this.subtitle,
    required this.imageUrl,
    this.linkUrl,
    this.linkText,
    this.section = 'hero',
    this.sortOrder = 0,
    this.isActive = true,
  });

  factory AdminBanner.fromJson(Map<String, dynamic> json) {
    return AdminBanner(
      id: json['id'] as String,
      title: json['title'] as String?,
      subtitle: json['subtitle'] as String?,
      imageUrl: (json['image_url'] as String?) ?? '',
      linkUrl: json['link_url'] as String?,
      linkText: json['link_text'] as String?,
      section: (json['section'] as String?) ?? 'hero',
      sortOrder: (json['sort_order'] as int?) ?? 0,
      isActive: (json['is_active'] as bool?) ?? true,
    );
  }
}
