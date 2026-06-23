class AdminCategory {
  final String id;
  final String name;
  final String slug;
  final String? description;
  final String? imageUrl;
  final bool isActive;
  final String? parentId;
  final String? gender;
  final DateTime? createdAt;

  AdminCategory({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    this.imageUrl,
    required this.isActive,
    this.parentId,
    this.gender,
    this.createdAt,
  });

  factory AdminCategory.fromJson(Map<String, dynamic> json) {
    return AdminCategory(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
      description: json['description'] as String?,
      imageUrl: json['image_url'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      parentId: json['parent_id'] as String?,
      gender: json['gender'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
    );
  }

  bool get isParent => parentId == null;

  static const List<String> mainCategoryNames = ['Men', 'Women', 'Kids'];
  static const List<String> genderOptions = ['men', 'women', 'kids', 'unisex'];

  bool get isMainCategory => isParent && mainCategoryNames.contains(name);
}
