class AdminCoupon {
  final String id;
  final String code;
  final String type;
  final double value;
  final double? minOrderAmount;
  final double? maxDiscount;
  final String? expiryDate;
  final int usageLimit;
  final int usedCount;
  final bool isActive;
  final DateTime? createdAt;

  AdminCoupon({
    required this.id,
    required this.code,
    required this.type,
    required this.value,
    this.minOrderAmount,
    this.maxDiscount,
    this.expiryDate,
    required this.usageLimit,
    required this.usedCount,
    required this.isActive,
    this.createdAt,
  });

  factory AdminCoupon.fromJson(Map<String, dynamic> json) {
    return AdminCoupon(
      id: json['id'] as String,
      code: json['code'] as String,
      type: json['type'] as String? ?? 'percentage',
      value: (json['value'] as num).toDouble(),
      minOrderAmount: (json['min_order_amount'] as num?)?.toDouble(),
      maxDiscount: (json['max_discount'] as num?)?.toDouble(),
      expiryDate: json['expiry_date'] as String?,
      usageLimit: json['usage_limit'] as int? ?? 100,
      usedCount: json['used_count'] as int? ?? 0,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
    );
  }
}
