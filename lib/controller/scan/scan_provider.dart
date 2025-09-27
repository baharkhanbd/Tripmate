// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:http/http.dart' as http;
// import 'package:http_parser/http_parser.dart';
// import 'package:mime/mime.dart';
// import 'package:flutter_debug_logger/flutter_debug_logger.dart';
// import 'package:tripmate/config/shared_pref_helper.dart';
// import 'package:tripmate/model/scan_analysis.dart';

// class ScanProvider extends ChangeNotifier {
//   bool isLoading = false;
//   ScanAnalysis? analysis;

//   double? latitude;
//   double? longitude;

//   /// Fetch live location
//   Future<void> fetchLocation(BuildContext context) async {
//     try {
//       bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//       if (!serviceEnabled) {
//         bool opened = await _showLocationDialog(context);
//         if (!opened) return;
//       }

//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//         if (permission == LocationPermission.denied) {
//           await _showLocationDialog(context);
//           return;
//         }
//       }

//       if (permission == LocationPermission.deniedForever) {
//         await _showLocationDialog(context);
//         return;
//       }

//       Position pos = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );

//       latitude = pos.latitude;
//       longitude = pos.longitude;
//       notifyListeners();
//       debugPrint("✅ Location fetched: $latitude, $longitude");
//     } catch (e) {
//       debugPrint("Location Error: $e");
//     }
//   }

//   Future<bool> _showLocationDialog(BuildContext context) async {
//     return showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text("Location Required"),
//         content: const Text(
//           "Please enable location services and grant permission to use this feature.",
//         ),
//         actions: [
//           TextButton(
//             onPressed: () async {
//               await Geolocator.openLocationSettings();
//             },
//             child: const Text("Open Location Settings"),
//           ),
//           TextButton(
//             onPressed: () async {
//               await Geolocator.openAppSettings();
//             },
//             child: const Text("Open App Settings"),
//           ),
//           TextButton(
//             onPressed: () => Navigator.pop(context, false),
//             child: const Text("Cancel"),
//           ),
//         ],
//       ),
//     ).then((value) => value ?? false);
//   }

//   /// Upload scan image
//   Future<int> uploadScan({
//     required File imageFile,
//     required String language,
//     required String cameraType,
//   }) async {
//     isLoading = true;
//     notifyListeners();

//     int statusCode = 0;

//     try {
//       String? token = SharedPrefHelper.getToken();
//       String lat = latitude?.toString() ?? '0.0';
//       String long = longitude?.toString() ?? '0.0';

//       String url = "https://ppp7rljm-8000.inc1.devtunnels.ms/api/scans/scan/";
//       final mimeType = lookupMimeType(imageFile.path) ?? 'image/jpeg';
//       final mimeSplit = mimeType.split('/');

//       var request = http.MultipartRequest('POST', Uri.parse(url));
//       request.headers['Authorization'] = 'Bearer $token';
//       request.fields['latitude'] = lat;
//       request.fields['longitude'] = long;
//       request.fields['source'] = cameraType;
//       request.fields['language'] = language;

//       request.files.add(
//         await http.MultipartFile.fromPath(
//           'image',
//           imageFile.path,
//           contentType: MediaType(mimeSplit[0], mimeSplit[1]),
//         ),
//       );

//       //       // Debug print request
//       debugPrint("📌 Request Fields:");
//       request.fields.forEach((key, value) => debugPrint("$key: $value"));

//       debugPrint("📌 Request Files:");
//       for (var file in request.files) {
//         debugPrint(
//           "${file.field}: ${file.filename}, contentType: ${file.contentType}",
//         );
//       }

//       var response = await request.send();
//       statusCode = response.statusCode;
//       final respStr = await response.stream.bytesToString();
//       FlutterDebugLogger.printJsonResponse(
//         url: url,
//         method: Method.POST,
//         tag: "Upload Scan Request",
//         statusCode: response.statusCode,
//         responseBody: respStr,
//       );

//       if (respStr.isNotEmpty) {
//         try {
//           final Map<String, dynamic> resData = Map<String, dynamic>.from(
//             jsonDecode(respStr),
//           );

//           if (resData.containsKey('analysis')) {
//             analysis = ScanAnalysis.fromJson(resData['analysis']);
//             notifyListeners();
//           }
//         } catch (e) {
//           debugPrint("JSON Parse Error: $e");
//         }
//       }
//     } catch (e) {
//       debugPrint("Upload Scan Error: $e");
//     } finally {
//       isLoading = false;
//       notifyListeners();
//     }

//     return statusCode;
//   }

//   /// Clear last scan analysis
//   void clearAnalysis() {
//     analysis = null;
//     notifyListeners();
//   }
// }

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:flutter_debug_logger/flutter_debug_logger.dart';
import 'package:tripmate/config/shared_pref_helper.dart';
import 'package:tripmate/model/scan_analysis.dart';

class ScanProvider extends ChangeNotifier {
  bool isLoading = false;
  ScanAnalysis? analysis;

  double? latitude;
  double? longitude;

  /// Fetch live location
  Future<void> fetchLocation(BuildContext context) async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        bool opened = await _showLocationDialog(context);
        if (!opened) return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          await _showLocationDialog(context);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        await _showLocationDialog(context);
        return;
      }

      Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      latitude = pos.latitude;
      longitude = pos.longitude;
      notifyListeners();
      debugPrint("✅ Location fetched: $latitude, $longitude");
    } catch (e) {
      debugPrint("Location Error: $e");
    }
  }

  Future<bool> _showLocationDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Location Required"),
        content: const Text(
          "Please enable location services and grant permission to use this feature.",
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await Geolocator.openLocationSettings();
            },
            child: const Text("Open Location Settings"),
          ),
          TextButton(
            onPressed: () async {
              await Geolocator.openAppSettings();
            },
            child: const Text("Open App Settings"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
        ],
      ),
    ).then((value) => value ?? false);
  }

  Future<int> uploadScan({
    required File imageFile,
    required String language,
    required String cameraType,
  }) async {
    isLoading = true;
    notifyListeners();

    int statusCode = 0;

    try {
      String? token = SharedPrefHelper.getToken();

      // যদি gallery থেকে আসে তাহলে lat, long null পাঠানো হবে
      String? lat = (cameraType.toLowerCase() == 'gallery')
          ? null
          : latitude?.toString() ?? '0.0';
      String? long = (cameraType.toLowerCase() == 'gallery')
          ? null
          : longitude?.toString() ?? '0.0';
      // Console-এ print করা
      debugPrint("📍 Camera Type: $cameraType");
      debugPrint("📍 Latitude: ${lat ?? 'null'}");
      debugPrint("📍 Longitude: ${long ?? 'null'}");
      String url = "https://ppp7rljm-8000.inc1.devtunnels.ms/api/scans/scan/";
      final mimeType = lookupMimeType(imageFile.path) ?? 'image/jpeg';
      final mimeSplit = mimeType.split('/');

      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.headers['Authorization'] = 'Bearer $token';

      if (lat != null) request.fields['latitude'] = lat;
      if (long != null) request.fields['longitude'] = long;

      request.fields['source'] = cameraType;
      request.fields['language'] = language;

      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
          contentType: MediaType(mimeSplit[0], mimeSplit[1]),
        ),
      );

      debugPrint("📌 Request Fields:");
      request.fields.forEach((key, value) => debugPrint("$key: $value"));

      debugPrint("📌 Request Files:");
      for (var file in request.files) {
        debugPrint(
          "${file.field}: ${file.filename}, contentType: ${file.contentType}",
        );
      }

      var response = await request.send();
      statusCode = response.statusCode;
      final respStr = await response.stream.bytesToString();
      FlutterDebugLogger.printJsonResponse(
        url: url,
        method: Method.POST,
        tag: "Upload Scan Request",
        statusCode: response.statusCode,
        responseBody: respStr,
      );

      if (respStr.isNotEmpty) {
        try {
          final Map<String, dynamic> resData = Map<String, dynamic>.from(
            jsonDecode(respStr),
          );

          if (resData.containsKey('analysis')) {
            analysis = ScanAnalysis.fromJson(resData['analysis']);
            notifyListeners();
          }
        } catch (e) {
          debugPrint("JSON Parse Error: $e");
        }
      }
    } catch (e) {
      debugPrint("Upload Scan Error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }

    return statusCode;
  }

  /// Clear last scan analysis
  void clearAnalysis() {
    analysis = null;
    notifyListeners();
  }
}
