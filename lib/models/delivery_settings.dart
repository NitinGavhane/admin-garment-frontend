class DeliverySettings {
  final bool enabled;
  final double fee;
  final double? freeAbove;

  const DeliverySettings({
    this.enabled = false,
    this.fee = 0.0,
    this.freeAbove,
  });

  factory DeliverySettings.fromJson(Map<String, dynamic> json) {
    return DeliverySettings(
      enabled: json['enabled'] as bool? ?? false,
      fee: (json['fee'] as num?)?.toDouble() ?? 0.0,
      freeAbove: (json['free_above'] as num?)?.toDouble(),
    );
  }
}
