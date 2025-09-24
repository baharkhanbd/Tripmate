class SubscriptionModel {
  final String planName;
  final String planType;
  final bool isActive;
  final DateTime? expiryDate;
  final int remainingDays;
  final int remainingHours;
  final int remainingMinutes;
  final bool canUpgrade;
  final bool canCancel;

  SubscriptionModel({
    required this.planName,
    required this.planType,
    required this.isActive,
    this.expiryDate,
    required this.remainingDays,
    required this.remainingHours,
    required this.remainingMinutes,
    required this.canUpgrade,
    required this.canCancel,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      planName: json['planName'] ?? '',
      planType: json['planType'] ?? '',
      isActive: json['isActive'] ?? false,
      expiryDate: json['expiryDate'] != null 
          ? DateTime.parse(json['expiryDate']) 
          : null,
      remainingDays: json['remainingDays'] ?? 0,
      remainingHours: json['remainingHours'] ?? 0,
      remainingMinutes: json['remainingMinutes'] ?? 0,
      canUpgrade: json['canUpgrade'] ?? false,
      canCancel: json['canCancel'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'planName': planName,
      'planType': planType,
      'isActive': isActive,
      'expiryDate': expiryDate?.toIso8601String(),
      'remainingDays': remainingDays,
      'remainingHours': remainingHours,
      'remainingMinutes': remainingMinutes,
      'canUpgrade': canUpgrade,
      'canCancel': canCancel,
    };
  }

  SubscriptionModel copyWith({
    String? planName,
    String? planType,
    bool? isActive,
    DateTime? expiryDate,
    int? remainingDays,
    int? remainingHours,
    int? remainingMinutes,
    bool? canUpgrade,
    bool? canCancel,
  }) {
    return SubscriptionModel(
      planName: planName ?? this.planName,
      planType: planType ?? this.planType,
      isActive: isActive ?? this.isActive,
      expiryDate: expiryDate ?? this.expiryDate,
      remainingDays: remainingDays ?? this.remainingDays,
      remainingHours: remainingHours ?? this.remainingHours,
      remainingMinutes: remainingMinutes ?? this.remainingMinutes,
      canUpgrade: canUpgrade ?? this.canUpgrade,
      canCancel: canCancel ?? this.canCancel,
    );
  }
}
