class BoosterModel {
  final String id;
  final String duration;
  final String price;
  final String icon;
  final bool isPopular;

  BoosterModel({
    required this.id,
    required this.duration,
    required this.price,
    required this.icon,
    this.isPopular = false,
  });

  factory BoosterModel.fromJson(Map<String, dynamic> json) {
    return BoosterModel(
      id: json['id'] ?? '',
      duration: json['duration'] ?? '',
      price: json['price'] ?? '',
      icon: json['icon'] ?? '',
      isPopular: json['isPopular'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'duration': duration,
      'price': price,
      'icon': icon,
      'isPopular': isPopular,
    };
  }

  BoosterModel copyWith({
    String? id,
    String? duration,
    String? price,
    String? icon,
    bool? isPopular,
  }) {
    return BoosterModel(
      id: id ?? this.id,
      duration: duration ?? this.duration,
      price: price ?? this.price,
      icon: icon ?? this.icon,
      isPopular: isPopular ?? this.isPopular,
    );
  }
}
