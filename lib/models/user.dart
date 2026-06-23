class AdminUser {
  final String id;
  final String fullName;
  final String email;
  final String? phone;
  final String role;
  final String? referralCode;
  final double walletBalance;
  final bool isVerified;
  final DateTime? createdAt;

  AdminUser({
    required this.id,
    required this.fullName,
    required this.email,
    this.phone,
    required this.role,
    this.referralCode,
    required this.walletBalance,
    required this.isVerified,
    this.createdAt,
  });

  factory AdminUser.fromJson(Map<String, dynamic> json) {
    return AdminUser(
      id: json['id'] as String,
      fullName: json['full_name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      role: json['role'] as String,
      referralCode: json['referral_code'] as String?,
      walletBalance: (json['wallet_balance'] as num?)?.toDouble() ?? 0,
      isVerified: json['is_verified'] as bool? ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
    );
  }
}
