class HistoryDetailsModel {
  final String id;
  final String title;
  final String imageUrl;
  final String location;
  final String year;
  final String description;
  final String construction;
  final String unfinishedStructure;
  final String visitingHours;
  final String additionalInfo;

  HistoryDetailsModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.location,
    required this.year,
    required this.description,
    required this.construction,
    required this.unfinishedStructure,
    required this.visitingHours,
    required this.additionalInfo,
  });

  factory HistoryDetailsModel.fromJson(Map<String, dynamic> json) {
    return HistoryDetailsModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      location: json['location'] ?? '',
      year: json['year'] ?? '',
      description: json['description'] ?? '',
      construction: json['construction'] ?? '',
      unfinishedStructure: json['unfinishedStructure'] ?? '',
      visitingHours: json['visitingHours'] ?? '',
      additionalInfo: json['additionalInfo'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'imageUrl': imageUrl,
      'location': location,
      'year': year,
      'description': description,
      'construction': construction,
      'unfinishedStructure': unfinishedStructure,
      'visitingHours': visitingHours,
      'additionalInfo': additionalInfo,
    };
  }
}
