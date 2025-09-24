class PrivacyPolicyModel {
  final String title;
  final String introduction;
  final List<PolicySection> sections;

  PrivacyPolicyModel({
    required this.title,
    required this.introduction,
    required this.sections,
  });

  factory PrivacyPolicyModel.fromJson(Map<String, dynamic> json) {
    return PrivacyPolicyModel(
      title: json['title'] ?? '',
      introduction: json['introduction'] ?? '',
      sections: (json['sections'] as List<dynamic>?)
          ?.map((section) => PolicySection.fromJson(section))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'introduction': introduction,
      'sections': sections.map((section) => section.toJson()).toList(),
    };
  }
}

class PolicySection {
  final String title;
  final String description;
  final List<String> bulletPoints;

  PolicySection({
    required this.title,
    required this.description,
    required this.bulletPoints,
  });

  factory PolicySection.fromJson(Map<String, dynamic> json) {
    return PolicySection(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      bulletPoints: (json['bulletPoints'] as List<dynamic>?)
          ?.map((point) => point.toString())
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'bulletPoints': bulletPoints,
    };
  }
}
