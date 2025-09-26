/* 
dependencies:
  flutter_exif_plugin: ^1.0.6

import 'package:flutter_exif_plugin/flutter_exif_plugin.dart';
import 'package:image_picker/image_picker.dart';

Future<void> pickImageAndExtractMeta() async {
  final ImagePicker picker = ImagePicker();
  final XFile? image = await picker.pickImage(source: ImageSource.gallery);

  if (image != null) {
    // ✅ ফাইল পাথ
    final String path = image.path;

    // ✅ Exif থেকে মেটাডাটা বের করা
    final exif = await FlutterExif.fromPath(path);

    String? lat = await exif.getAttribute('GPSLatitude');
    String? long = await exif.getAttribute('GPSLongitude');

    print("📍 Lat: $lat, Long: $long");

    // এখন আপনি চাইলে FormData তে ব্যবহার করতে পারবেন
    final formData = FormData.fromMap({
      "image": await MultipartFile.fromFile(path),
      "latitude": lat,
      "longitude": long,
      "source": "gallery",
      "language": "English",
    });

    // তারপর Dio দিয়ে API call করবেন
  }
}

lib/
├─ main.dart
├─ core/                       # অ্যাপ-ওয়াইড সেটিংস, থিম, constants, utils
│  ├─ app_theme.dart
│  ├─ constants.dart
│  └─ widgets/                  # পুনঃব্যবহারযোগ্য UI কম্পোনেন্ট
│     ├─ rounded_button.dart
│     ├─ icon_button_circle.dart
│     ├─ loading_overlay.dart
│     └─ offline_banner.dart
├─ models/                     # শুধুমাত্র ডাটা মডেল (Model in MVC)
│  ├─ user_model.dart
│  ├─ history_item_model.dart
│  └─ place_info_model.dart
├─ controllers/                # Controller (ব্যবসায়িক লজিক আপনার দেয়া হবে)
│  ├─ auth_controller.dart
│  ├─ camera_controller.dart
│  ├─ history_controller.dart
│  └─ profile_controller.dart
├─ views/                      # Views (UI) — এখানে পুরো UI থাকবে
│  ├─ auth/
│  │  ├─ login_page.dart
│  │  └─ signup_page.dart
│  ├─ camera/
│  │  ├─ camera_page.dart
│  │  └─ image_preview_page.dart
│  ├─ history/
│  │  └─ history_page.dart
│  ├─ place_details/
│  │  └─ place_details_page.dart
│  ├─ profile/
│  │  └─ profile_page.dart
│  └─ widgets/                  # view-specific small widgets
│     ├─ bottom_actions.dart
│     └─ analysis_card.dart
├─ services/                   # API service (you will provide implementations)
│  └─ tripmate_api.dart
├─ routes/
│  └─ app_routes.dart
└─ resources/
   ├─ assets/
   │  ├─ icons/
   │  └─ images/
   └─ translations/             # যদি localization চান


*/