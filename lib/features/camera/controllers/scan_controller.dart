import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:trip_mate/config/baseurl/baseurl.dart';
import 'package:trip_mate/features/auths/services/auth_service.dart';

class ScanController extends ChangeNotifier {
  final Dio _dio = Dio(BaseOptions(baseUrl: Baseurl.baseUrl));

  bool isLoading = false;
  Map<String, dynamic>? lastScanResult;
  String? _token;

  // ✅ Get current location (no permission request here)
  Future<Position> _getCurrentLocation() async {
    return await Geolocator.getCurrentPosition(
      // ignore: deprecated_member_use
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  // ✅ Called once at app start (e.g., in main.dart before runApp)
  static Future<bool> requestLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      debugPrint("❌ Location services are disabled.");
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        debugPrint("❌ Location permissions are denied.");
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      debugPrint("❌ Location permissions are permanently denied.");
      return false;
    }

    return true;
  }

  Future<void> uploadScan(String imagePath, {String? language}) async {
    try {
      isLoading = true;
      notifyListeners();

      final file = await MultipartFile.fromFile(
        imagePath,
        filename: imagePath.split('/').last,
      );

      // ✅ Only fetch location (permission already handled on app start)
      final position = await _getCurrentLocation();
      final latitude = position.latitude.toString();
      final longitude = position.longitude.toString();

      // ✅ Get token
      final authService = AuthService();
      await authService.loadAuthState();
      _token = authService.token;

      // ✅ Form data
      final formData = FormData.fromMap({
        "image": file,
        "latitude": latitude,
        "longitude": longitude,
        "source": "gallery", // or "camera"
        "language": language ?? "English",
      });

      final response = await _dio.post(
        "/api/scans/scan/",
        data: formData,
        options: Options(headers: {"Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzU4Njk5NDAyLCJpYXQiOjE3NTg2ODE0MDIsImp0aSI6ImRlZTU3Y2VjN2UzNDQ2MWE4NGQ5ZWE1NzY3ZDAxYTNjIiwidXNlcl9pZCI6IjE3In0.Ys4tKLEP-jSFyWix5BdXHq-31VMLtUVAAjE9AVKBCrc"}),
      );

      if (response.data is Map) {
        lastScanResult = Map<String, dynamic>.from(response.data as Map);
        print("✅ Scan uploaded successfully: $lastScanResult");
      } else {
        print("❌ Unexpected response format: ${response.data}");
        lastScanResult = _defaultFallback();
      }
    } catch (e) {
      if (e is DioException) {
        print("❌ Upload failed: ${e.response?.statusCode} -> ${e.response?.data}");
      } else {
        print("❌ Unexpected error: $e");
      }
      lastScanResult = _defaultFallback();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Map<String, dynamic> _defaultFallback() {
    return {
      "scan": {
        "id": 0,
        "user": 0,
        "user_email": "unknown@example.com",
      },
      "analysis": {
        "landmark_name": "Unknown",
        "location": "Unknown",
        "year_completed": 0,
        "historical_overview": "No analysis available.",
        "materials": "N/A",
        "architectural_style": "N/A",
      },
    };
  }
}
