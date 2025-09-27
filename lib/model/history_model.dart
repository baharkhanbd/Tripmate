class HistoryModel {
  dynamic message;
  List<Results>? results;

  HistoryModel({this.message, this.results});

  HistoryModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];

    if (json['results'] != null) {
      results = <Results>[];
      if (json['results'] is List) {
        for (var v in json['results']) {
          results!.add(Results.fromJson(v));
        }
      } else {
        print('[HistoryModel] ✕ "results" is not a List: ${json['results']}');
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['message'] = message;
    if (results != null) {
      data['results'] = results!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  static T? safeParse<T>(dynamic value, String fieldName) {
    if (value == null) return null;
    try {
      if (value is T) return value;
      if (T == int) {
        if (value is double) return value.toInt() as T;
        if (value is String) return int.tryParse(value) as T?;
        if (value is num) return value.toInt() as T;
      }
      if (T == double) {
        if (value is String) return double.tryParse(value) as T?;
        if (value is int) return value.toDouble() as T;
        if (value is num) return value.toDouble() as T;
      }
      if (T == bool) {
        final v = value.toString().toLowerCase();
        if (v == 'true') return true as T;
        if (v == 'false') return false as T;
      }
      if (T == String) return value.toString() as T;
    } catch (e) {
      print('[safeParse] ▲ Field "$fieldName": $e');
    }
    print('[safeParse] ✕ Type mismatch in "$fieldName": expected $T, got ${value.runtimeType}');
    return null;
  }
}

class Results {
  Scan? scan;
  Analysis? analysis;

  Results({this.scan, this.analysis});

  Results.fromJson(Map<String, dynamic> json) {
    scan = json['scan'] != null ? Scan.fromJson(json['scan']) : null;
    analysis = json['analysis'] != null ? Analysis.fromJson(json['analysis']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (scan != null) data['scan'] = scan!.toJson();
    if (analysis != null) data['analysis'] = analysis!.toJson();
    return data;
  }
}

class Scan {
  int? id;
  int? user;
  String? userEmail;
  String? imageUrl;
  String? resultText;
  String? createdAt;
  String? latitude;
  String? longitude;
  String? locationName;
  bool? isBoosted;
  String? scanDurationMinutes;
  bool? processed;
  double? engagementScore;
  String? source;
  String? activityType;

  Scan({
    this.id,
    this.user,
    this.userEmail,
    this.imageUrl,
    this.resultText,
    this.createdAt,
    this.latitude,
    this.longitude,
    this.locationName,
    this.isBoosted,
    this.scanDurationMinutes,
    this.processed,
    this.engagementScore,
    this.source,
    this.activityType,
  });

  Scan.fromJson(Map<String, dynamic> json) {
    id = HistoryModel.safeParse<int>(json['id'], 'id');
    user = HistoryModel.safeParse<int>(json['user'], 'user');
    userEmail = HistoryModel.safeParse<String>(json['user_email'], 'user_email');
    imageUrl = HistoryModel.safeParse<String>(json['image_url'], 'image_url');
    resultText = HistoryModel.safeParse<String>(json['result_text'], 'result_text');
    createdAt = HistoryModel.safeParse<String>(json['created_at'], 'created_at');
    latitude = HistoryModel.safeParse<String>(json['latitude'], 'latitude');
    longitude = HistoryModel.safeParse<String>(json['longitude'], 'longitude');
    locationName = HistoryModel.safeParse<String>(json['location_name'], 'location_name');
    isBoosted = HistoryModel.safeParse<bool>(json['is_boosted'], 'is_boosted');
    scanDurationMinutes = HistoryModel.safeParse<String>(json['scan_duration_minutes'], 'scan_duration_minutes');
    processed = HistoryModel.safeParse<bool>(json['processed'], 'processed');
    engagementScore = HistoryModel.safeParse<double>(json['engagement_score'], 'engagement_score');
    source = HistoryModel.safeParse<String>(json['source'], 'source');
    activityType = HistoryModel.safeParse<String>(json['activity_type'], 'activity_type');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['user'] = user;
    data['user_email'] = userEmail;
    data['image_url'] = imageUrl;
    data['result_text'] = resultText;
    data['created_at'] = createdAt;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['location_name'] = locationName;
    data['is_boosted'] = isBoosted;
    data['scan_duration_minutes'] = scanDurationMinutes;
    data['processed'] = processed;
    data['engagement_score'] = engagementScore;
    data['source'] = source;
    data['activity_type'] = activityType;
    return data;
  }
}

class Analysis {
  String? landmarkName;
  String? location;
  String? yearCompleted;
  String? materials;
  String? architecturalStyle;
  String? historicalOverview;
  String? culturalImpact;
  List<String>? famousFor;

  Analysis({
    this.landmarkName,
    this.location,
    this.yearCompleted,
    this.materials,
    this.architecturalStyle,
    this.historicalOverview,
    this.culturalImpact,
    this.famousFor,
  });

  Analysis.fromJson(Map<String, dynamic> json) {
    landmarkName = HistoryModel.safeParse<String>(json['landmark_name'], 'landmark_name');
    location = HistoryModel.safeParse<String>(json['location'], 'location');
    yearCompleted = HistoryModel.safeParse<String>(json['year_completed'], 'year_completed');
    materials = HistoryModel.safeParse<String>(json['materials'], 'materials');
    architecturalStyle = HistoryModel.safeParse<String>(json['architectural_style'], 'architectural_style');
    historicalOverview = HistoryModel.safeParse<String>(json['historical_overview'], 'historical_overview');
    culturalImpact = HistoryModel.safeParse<String>(json['cultural_impact'], 'cultural_impact');

    // Safe famousFor parsing
    if (json['famous_for'] != null) {
      if (json['famous_for'] is List) {
        famousFor = List<String>.from(json['famous_for']);
      } else if (json['famous_for'] is String) {
        famousFor = [json['famous_for']]; // যদি string আসে, list বানাও
      } else {
        famousFor = [];
      }
    } else {
      famousFor = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['landmark_name'] = landmarkName;
    data['location'] = location;
    data['year_completed'] = yearCompleted;
    data['materials'] = materials;
    data['architectural_style'] = architecturalStyle;
    data['historical_overview'] = historicalOverview;
    data['cultural_impact'] = culturalImpact;
    data['famous_for'] = famousFor;
    return data;
  }
}
