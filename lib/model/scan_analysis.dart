class ScanAnalysis {
  final String landmarkName;
  final String location;
  final String yearCompleted;
  final String materials;
  final String architecturalStyle;
  final String historicalOverview;
  final String culturalImpact;
  final List<String> famousFor;

  ScanAnalysis({
    required this.landmarkName,
    required this.location,
    required this.yearCompleted,
    required this.materials,
    required this.architecturalStyle,
    required this.historicalOverview,
    required this.culturalImpact,
    required this.famousFor,
  });

  factory ScanAnalysis.fromJson(Map<String, dynamic> json) {
    return ScanAnalysis(
      landmarkName: json['landmark_name'] ?? '',
      location: json['location'] ?? '',
      yearCompleted: json['year_completed'] ?? '',
      materials: json['materials'] ?? '',
      architecturalStyle: json['architectural_style'] ?? '',
      historicalOverview: json['historical_overview'] ?? '',
      culturalImpact: json['cultural_impact'] ?? '',
      famousFor: List<String>.from(json['famous_for'] ?? []),
    );
  }
}
