/// Store-wide refer-and-earn settings. `commissionPercentage` is only the
/// suggested payout — every sale is still approved by hand.
class ReferralSettings {
  final bool enabled;
  final double commissionPercentage;

  const ReferralSettings({
    this.enabled = true,
    this.commissionPercentage = 5.0,
  });

  factory ReferralSettings.fromJson(Map<String, dynamic> json) {
    return ReferralSettings(
      enabled: json['enabled'] as bool? ?? true,
      commissionPercentage:
          (json['commission_percentage'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

/// One referred purchase awaiting (or having had) a commission decision.
class ReferralPurchase {
  final String id;
  final String referrerName;
  final String referrerEmail;
  final String? referrerCode;
  final String? referredUserName;
  final String? referredUserEmail;
  final String? productName;
  final String orderId;
  final String? orderNumber;
  final double purchaseAmount;
  final double rewardAmount;
  final double rewardPercentage;
  final String status;
  final DateTime? createdAt;

  const ReferralPurchase({
    required this.id,
    required this.referrerName,
    required this.referrerEmail,
    this.referrerCode,
    this.referredUserName,
    this.referredUserEmail,
    this.productName,
    required this.orderId,
    this.orderNumber,
    this.purchaseAmount = 0,
    this.rewardAmount = 0,
    this.rewardPercentage = 0,
    this.status = 'pending',
    this.createdAt,
  });

  bool get isPending => status == 'pending';

  factory ReferralPurchase.fromJson(Map<String, dynamic> json) {
    return ReferralPurchase(
      id: json['id'] as String,
      referrerName: json['referrer_name'] as String? ?? 'Unknown',
      referrerEmail: json['referrer_email'] as String? ?? '',
      referrerCode: json['referrer_code'] as String?,
      referredUserName: json['referred_user_name'] as String?,
      referredUserEmail: json['referred_user_email'] as String?,
      productName: json['product_name'] as String?,
      orderId: json['order_id'] as String? ?? '',
      orderNumber: json['order_number'] as String?,
      purchaseAmount: (json['purchase_amount'] as num?)?.toDouble() ?? 0,
      rewardAmount: (json['reward_amount'] as num?)?.toDouble() ?? 0,
      rewardPercentage: (json['reward_percentage'] as num?)?.toDouble() ?? 0,
      status: json['status'] as String? ?? 'pending',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
    );
  }
}

/// Per-referrer totals, for the "Top referrers" view.
class ReferralUserReport {
  final String userId;
  final String userName;
  final String userEmail;
  final int totalClicks;
  final int totalPurchases;
  final double totalEarnings;
  final double pendingRewards;

  const ReferralUserReport({
    required this.userId,
    required this.userName,
    required this.userEmail,
    this.totalClicks = 0,
    this.totalPurchases = 0,
    this.totalEarnings = 0,
    this.pendingRewards = 0,
  });

  factory ReferralUserReport.fromJson(Map<String, dynamic> json) {
    return ReferralUserReport(
      userId: json['user_id'] as String? ?? '',
      userName: json['user_name'] as String? ?? '',
      userEmail: json['user_email'] as String? ?? '',
      totalClicks: json['total_clicks'] as int? ?? 0,
      totalPurchases: json['total_purchases'] as int? ?? 0,
      totalEarnings: (json['total_earnings'] as num?)?.toDouble() ?? 0,
      pendingRewards: (json['pending_rewards'] as num?)?.toDouble() ?? 0,
    );
  }
}
