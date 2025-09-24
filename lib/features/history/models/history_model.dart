class HistoryModel {
  final String id;
  final String imageUrl;
  final String date;
  final String? location;
  final String? description;
  final DateTime createdAt;

  HistoryModel({
    required this.id,
    required this.imageUrl,
    required this.date,
    this.location,
    this.description,
    required this.createdAt,
  });

  factory HistoryModel.fromJson(Map<String, dynamic> json) {
    return HistoryModel(
      id: json['id'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      date: json['date'] ?? '',
      location: json['location'],
      description: json['description'],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'date': date,
      'location': location,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
