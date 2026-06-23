class AdminProduct {
  final String id;
  final String title;
  final String sku;
  final double price;
  final double? discountPrice;
  final int stock;
  final bool featured;
  final bool isActive;
  final bool isReplaceable;
  final bool isReturnable;
  final String? categoryName;
  final String? primaryImage;
  final String? categoryId;
  final String? description;
  final String? brand;
  final String? gender;
  final double gstPercentage;
  final String? updatedBy;
  final DateTime? updatedAt;
  final List<AdminVariant> variants;
  final List<AdminImage> images;

  AdminProduct({
    required this.id,
    required this.title,
    required this.sku,
    required this.price,
    this.discountPrice,
    required this.stock,
    required this.featured,
    required this.isActive,
    this.isReplaceable = false,
    this.isReturnable = false,
    this.categoryName,
    this.primaryImage,
    this.categoryId,
    this.description,
    this.brand,
    this.gender,
    this.gstPercentage = 18,
    this.updatedBy,
    this.updatedAt,
    this.variants = const [],
    this.images = const [],
  });

  factory AdminProduct.fromJson(Map<String, dynamic> json) {
    return AdminProduct(
      id: json['id'] as String,
      title: json['title'] as String,
      sku: json['sku'] as String,
      price: (json['price'] as num).toDouble(),
      discountPrice: (json['discount_price'] as num?)?.toDouble(),
      stock: json['stock'] as int? ?? 0,
      featured: json['featured'] as bool? ?? false,
      isActive: json['is_active'] as bool? ?? true,
      isReplaceable: json['is_replaceable'] as bool? ?? false,
      isReturnable: json['is_returnable'] as bool? ?? false,
      categoryName: json['category_name'] as String?,
      primaryImage: json['primary_image'] as String?,
      categoryId: json['category_id'] as String?,
      description: json['description'] as String?,
      brand: json['brand'] as String?,
      gender: json['gender'] as String?,
      gstPercentage: (json['gst_percentage'] as num?)?.toDouble() ?? 18,
      updatedBy: json['updated_by'] as String?,
      updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at'] as String) : null,
      variants: (json['variants'] as List<dynamic>?)
              ?.map((e) => AdminVariant.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => AdminImage.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toUpdateJson() {
    return {
      'title': title,
      'category_id': categoryId,
      'description': description,
      'brand': brand,
      'sku': sku,
      'price': price,
      'discount_price': discountPrice,
      'gst_percentage': gstPercentage,
      'stock': stock,
      'featured': featured,
      'is_active': isActive,
      'is_replaceable': isReplaceable,
      'is_returnable': isReturnable,
      'gender': gender,
    };
  }
}

class AdminVariant {
  final String? id;
  String? size;
  String? color;
  int stock;
  double? price;

  AdminVariant({
    this.id,
    this.size,
    this.color,
    this.stock = 0,
    this.price,
  });

  factory AdminVariant.fromJson(Map<String, dynamic> json) {
    return AdminVariant(
      id: json['id'] as String?,
      size: json['size'] as String?,
      color: json['color'] as String?,
      stock: json['stock'] as int? ?? 0,
      price: (json['price'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'size': size,
      'color': color,
      'stock': stock,
      'price': price,
    };
  }
}

class AdminImage {
  final String? id;
  final String imageUrl;
  final bool isPrimary;

  AdminImage({
    this.id,
    required this.imageUrl,
    this.isPrimary = false,
  });

  factory AdminImage.fromJson(Map<String, dynamic> json) {
    return AdminImage(
      id: json['id'] as String?,
      imageUrl: json['image_url'] as String,
      isPrimary: json['is_primary'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'image_url': imageUrl,
      'is_primary': isPrimary,
    };
  }
}
