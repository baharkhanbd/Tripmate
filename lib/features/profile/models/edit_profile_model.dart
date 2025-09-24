class EditProfileModel {
  final String fullName;
  final String email;
  final String oldPassword;
  final String newPassword;

  EditProfileModel({
    required this.fullName,
    required this.email,
    required this.oldPassword,
    required this.newPassword,
  });

  factory EditProfileModel.fromJson(Map<String, dynamic> json) {
    return EditProfileModel(
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      oldPassword: json['oldPassword'] ?? '',
      newPassword: json['newPassword'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'oldPassword': oldPassword,
      'newPassword': newPassword,
    };
  }

  EditProfileModel copyWith({
    String? fullName,
    String? email,
    String? oldPassword,
    String? newPassword,
  }) {
    return EditProfileModel(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      oldPassword: oldPassword ?? this.oldPassword,
      newPassword: newPassword ?? this.newPassword,
    );
  }
}
