class ProfileModel {
  final String id;
  final String name;
  final String email;
  final String profileImageUrl;
  final bool isBoosted;
  final int remainingDays;
  final int remainingHours;
  final int remainingMinutes;

  ProfileModel({
    required this.id,
    required this.name,
    required this.email,
    required this.profileImageUrl,
    required this.isBoosted,
    required this.remainingDays,
    required this.remainingHours,
    required this.remainingMinutes,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      profileImageUrl: json['profileImageUrl'] ?? '',
      isBoosted: json['isBoosted'] ?? false,
      remainingDays: json['remainingDays'] ?? 0,
      remainingHours: json['remainingHours'] ?? 0,
      remainingMinutes: json['remainingMinutes'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profileImageUrl': profileImageUrl,
      'isBoosted': isBoosted,
      'remainingDays': remainingDays,
      'remainingHours': remainingHours,
      'remainingMinutes': remainingMinutes,
    };
  }
}
