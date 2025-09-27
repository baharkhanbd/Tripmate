 

// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:tripmate/controller/scan/scan_provider.dart';
// import 'package:tripmate/view/image/image_view_screen.dart';

// class CameraPage extends StatefulWidget {
//   const CameraPage({super.key});

//   @override
//   State<CameraPage> createState() => _CameraPageState();
// }

// class _CameraPageState extends State<CameraPage> {
//   CameraController? _cameraController;
//   bool _isInitialized = false;
//   bool _isCapturing = false;
//   String selectedLanguage = "English";

//   @override
//   void initState() {
//     super.initState();
//     _requestPermissionsAndInit();
//   }

//   Future<void> _requestPermissionsAndInit() async {
//     final scanProvider = Provider.of<ScanProvider>(context, listen: false);
//     await scanProvider.fetchLocation(context); // Location fetch
//     await _initCamera(); // Camera init
//   }

//   Future<void> _initCamera() async {
//     final cameras = await availableCameras();
//     final firstCamera = cameras.first;
//     _cameraController = CameraController(firstCamera, ResolutionPreset.medium);
//     await _cameraController!.initialize();
//     if (mounted) setState(() => _isInitialized = true);
//     final scanProvider = Provider.of<ScanProvider>(context, listen: false);
//     scanProvider.clearAnalysis();
//   }

//   @override
//   void dispose() {
//     _cameraController?.dispose();
//     super.dispose();
//   }

//   Future<void> _capturePhoto() async {
//     if (_cameraController == null || !_cameraController!.value.isInitialized) return;

//     setState(() => _isCapturing = true);

//     try {
//       final file = await _cameraController!.takePicture();

//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (_) => ImageViewScreen(
//             imagePath: file.path,
//             selectedLanguage: selectedLanguage,
//             cameraType: "camera",
//           ),
//         ),
//       );
//     } catch (e) {
//       debugPrint("Capture Error: $e");
//     }

//     setState(() => _isCapturing = false);
//   }

//   Future<void> _pickFromGallery() async {
//     final status = await Permission.photos.request();
//     if (!status.isGranted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Gallery permission denied")));
//       return;
//     }

//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (_) => ImageViewScreen(
//             imagePath: pickedFile.path,
//             selectedLanguage: selectedLanguage,
//             cameraType: "gallery",
//           ),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Stack(
//         children: [
//           Positioned.fill(
//             child: _isInitialized && _cameraController != null
//                 ? CameraPreview(_cameraController!)
//                 : const Center(child: CircularProgressIndicator()),
//           ),
//           Positioned(
//             top: 40.h,
//             left: 20.w,
//             right: 20.w,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Icon(Icons.person, color: Colors.white, size: 28.sp),
//                 DropdownButton<String>(
//                   value: selectedLanguage,
//                   dropdownColor: Colors.black87,
//                   icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
//                   underline: const SizedBox(),
//                   items: ['English', '简体中文', '繁體中文']
//                       .map(
//                         (lang) => DropdownMenuItem(
//                           value: lang,
//                           child: Text(lang, style: const TextStyle(color: Colors.white)),
//                         ),
//                       )
//                       .toList(),
//                   onChanged: (value) {
//                     if (value != null) {
//                       setState(() => selectedLanguage = value);
//                       if (value == "English") context.setLocale(const Locale('en', 'US'));
//                       if (value == "简体中文") context.setLocale(const Locale('zh', 'CN'));
//                       if (value == "繁體中文") context.setLocale(const Locale('zh', 'TW'));
//                     }
//                   },
//                 ),
//               ],
//             ),
//           ),
//           Positioned(
//             bottom: 40.h,
//             left: 40.w,
//             right: 40.w,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 // Left Gallery Button
//                 Container(
//                   width: 40.w,
//                   height: 40.w,
//                   decoration: BoxDecoration(
//                     color: Colors.black.withOpacity(0.5),
//                     borderRadius: BorderRadius.circular(20.r),
//                   ),
//                   child: IconButton(
//                     icon: Icon(Icons.photo, size: 20.sp, color: Colors.white),
//                     onPressed: _pickFromGallery,
//                     padding: EdgeInsets.zero,
//                   ),
//                 ),
//                 // Capture Button
//                 GestureDetector(
//                   onTap: _isCapturing ? null : _capturePhoto,
//                   child: Container(
//                     width: 70.w,
//                     height: 70.w,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       border: Border.all(color: Colors.white, width: 3),
//                     ),
//                     child: Center(
//                       child: _isCapturing
//                           ? CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
//                           : Container(
//                               width: 50.w,
//                               height: 50.w,
//                               decoration: const BoxDecoration(
//                                 color: Colors.white,
//                                 shape: BoxShape.circle,
//                               ),
//                             ),
//                     ),
//                   ),
//                 ),
//                 // Right Gallery Button
//                 Container(
//                   width: 40.w,
//                   height: 40.w,
//                   decoration: BoxDecoration(
//                     color: Colors.black.withOpacity(0.5),
//                     borderRadius: BorderRadius.circular(20.r),
//                   ),
//                   child: IconButton(
//                     icon: Icon(Icons.history, size: 20.sp, color: Colors.white),
//                     onPressed: () {
//                       // Implement history or other functionality
//                     },
//                     padding: EdgeInsets.zero,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tripmate/controller/scan/scan_provider.dart';
import 'package:tripmate/view/history/history_card.dart';
import 'package:tripmate/view/history/history_list.dart';
import 'package:tripmate/view/history/history_page.dart';
import 'package:tripmate/view/image/image_view_screen.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController? _cameraController;
  bool _isInitialized = false;
  bool _isCapturing = false;
  String selectedLanguage = "English";

  /// UI এর ভাষা → API ভাষা mapping
  final Map<String, String> languageMap = {
    "English": "English",
    "简体中文": "Chinese",
    "繁體中文": "Traditional Chinese",
  };

  @override
  void initState() {
    super.initState();
    _requestPermissionsAndInit();
  }

  Future<void> _requestPermissionsAndInit() async {
    final scanProvider = Provider.of<ScanProvider>(context, listen: false);
    await scanProvider.fetchLocation(context); // Location fetch
    await _initCamera(); // Camera init
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    _cameraController = CameraController(firstCamera, ResolutionPreset.medium);
    await _cameraController!.initialize();
    if (mounted) setState(() => _isInitialized = true);
    final scanProvider = Provider.of<ScanProvider>(context, listen: false);
    scanProvider.clearAnalysis();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _capturePhoto() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) return;

    setState(() => _isCapturing = true);

    try {
      final file = await _cameraController!.takePicture();

      // API এর জন্য map করা language পাঠানো
      final apiLanguage = languageMap[selectedLanguage]!;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ImageViewScreen(
            imagePath: file.path,
            selectedLanguage: apiLanguage, // API এর জন্য
            cameraType: "camera",
          ),
        ),
      );
    } catch (e) {
      debugPrint("Capture Error: $e");
    }

    setState(() => _isCapturing = false);
  }

  Future<void> _pickFromGallery() async {
    final status = await Permission.photos.request();
    if (!status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Gallery permission denied")));
      return;
    }

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final apiLanguage = languageMap[selectedLanguage]!; // API language
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ImageViewScreen(
            imagePath: pickedFile.path,
            selectedLanguage: apiLanguage,
            cameraType: "gallery",
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: _isInitialized && _cameraController != null
                ? CameraPreview(_cameraController!)
                : const Center(child: CircularProgressIndicator()),
          ),
          Positioned(
            top: 40.h,
            left: 20.w,
            right: 20.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.person, color: Colors.white, size: 28.sp),
                DropdownButton<String>(
                  value: selectedLanguage,
                  dropdownColor: Colors.black87,
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                  underline: const SizedBox(),
                  items: languageMap.keys
                      .map(
                        (lang) => DropdownMenuItem(
                          value: lang,
                          child: Text(lang, style: const TextStyle(color: Colors.white)),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => selectedLanguage = value);
                      if (value == "English") context.setLocale(const Locale('en', 'US'));
                      if (value == "简体中文") context.setLocale(const Locale('zh', 'CN'));
                      if (value == "繁體中文") context.setLocale(const Locale('zh', 'TW'));
                    }
                  },
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 40.h,
            left: 40.w,
            right: 40.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.photo, size: 20.sp, color: Colors.white),
                    onPressed: _pickFromGallery,
                    padding: EdgeInsets.zero,
                  ),
                ),
                GestureDetector(
                  onTap: _isCapturing ? null : _capturePhoto,
                  child: Container(
                    width: 70.w,
                    height: 70.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                    child: Center(
                      child: _isCapturing
                          ? CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                          : Container(
                              width: 50.w,
                              height: 50.w,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                    ),
                  ),
                ),
                Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.history, size: 20.sp, color: Colors.white),
                    onPressed: () {
                      Navigator.push(context, 
                      MaterialPageRoute(builder: (context)=>HistoryListScreen())
                      );
                    },
                    padding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
