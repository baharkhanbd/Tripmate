import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:tripmate/controller/scan/scan_provider.dart';
import 'package:tripmate/view/place_details/place_details.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController? _cameraController;
  bool _isInitialized = false;
  bool _isCapturing = false;
  XFile? _capturedFile;
  String selectedLanguage = "English";

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
    if (_cameraController == null || !_cameraController!.value.isInitialized)
      return;

    setState(() => _isCapturing = true);

    try {
      final file = await _cameraController!.takePicture();
      setState(() => _capturedFile = file);
    } catch (e) {
      debugPrint("Capture Error: $e");
    }

    setState(() => _isCapturing = false);
  }

  // Future<void> _submitScan() async {
  //   if (_capturedFile == null) return;
  //   final scanProvider = Provider.of<ScanProvider>(context, listen: false);
  //   await scanProvider.uploadScan(
  //     imageFile: File(_capturedFile!.path),
  //     language: selectedLanguage,
  //   );
     
  // }


//   Future<void> _submitScan() async {
//   if (_capturedFile == null) return;

//   final scanProvider = Provider.of<ScanProvider>(context, listen: false);
//   int statusCode = await scanProvider.uploadScan(
//     imageFile: File(_capturedFile!.path),
//     language: selectedLanguage,
//   );

//   // যদি 201 হয়, নেভিগেট করুন PlaceDetails পেজে
//   if (statusCode == 201 && scanProvider.analysis != null) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => PlaceDetails(
//           capturedImagePath: _capturedFile!.path,
//         ),
//       ),
//     );
//   } else {
//     debugPrint("Scan failed or status code != 201");
//   }
// }
Future<void> _submitScan() async {
  if (_capturedFile == null) return;

  final scanProvider = Provider.of<ScanProvider>(context, listen: false);
  int statusCode = await scanProvider.uploadScan(
    imageFile: File(_capturedFile!.path),
    language: selectedLanguage,
  );

  // যদি 201 হয়, নেভিগেট করুন PlaceDetails পেজে
  if (statusCode == 201 && scanProvider.analysis != null) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlaceDetails(
          capturedImagePath: _capturedFile!.path,
        ),
      ),
    );
  } 
  // যদি 500 আসে বা AI processing failed
  else if (statusCode == 500) {
     showDialog(
  context: context,
  builder: (context) => Dialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(25),
    ),
    child: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.red[400]!, Colors.purple[400]!],
        ),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Padding(
        padding: EdgeInsets.all(25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.white,
              size: 60,
            ),
            SizedBox(height: 16),
            Text(
              "Upload Failed",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "AI processing failed. Please try again.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      "OK",
                      style: TextStyle(
                        color: Colors.red[400],
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  ),
);
  } 
  else {
    // অন্য কোনো error বা unexpected status
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error"),
        content: Text("Scan failed with status code $statusCode"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    final scanProvider = Provider.of<ScanProvider>(context);

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
                  items: ['English', '简体中文', '繁體中文']
                      .map(
                        (lang) => DropdownMenuItem(
                          value: lang,
                          child: Text(
                            lang,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => selectedLanguage = value);
                      if (value == "English") {
                        context.setLocale(const Locale('en', 'US'));
                      }
                      if (value == "简体中文") {
                        context.setLocale(
                          const Locale('zh', 'CN'),
                        ); // Simplified Chinese
                      }
                      if (value == "繁體中文") {
                        context.setLocale(
                          const Locale('zh', 'TW'),
                        ); // Traditional Chinese
                      }
                    }
                  },
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 40.h,
            left: 20.w,
            right: 20.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
                          ? CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            )
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
                GestureDetector(
                  onTap: _initCamera,
                  child: Container(
                    width: 50.w,
                    height: 50.w,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.refresh, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          // Submit button
          if (_capturedFile != null)
            Positioned(
              bottom: 140.h,
              left: 50.w,
              right: 50.w,
              child: ElevatedButton(
                onPressed: scanProvider.isLoading ? null : _submitScan,
                child: scanProvider.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Submit"),
              ),
            ),
        ],
      ),
    );
  }
}



// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';

// import 'package:provider/provider.dart';
// import 'package:easy_localization/easy_localization.dart';

// import 'package:tripmate/controller/scan/scan_provider.dart';
// import 'package:tripmate/core/constants/app_colors.dart';
// import 'package:tripmate/core/widgets/custom_language.dart';

// class CameraPage extends StatefulWidget {
//   const CameraPage({super.key});

//   @override
//   State<CameraPage> createState() => _CameraPageState();
// }

// class _CameraPageState extends State<CameraPage> {
//   CameraController? _cameraController;
//   bool _isInitialized = false;
//   bool _isCapturing = false;
//   XFile? _capturedFile;
//   String _selectedLanguage = "English";
//   String? _errorMessage;

//   @override
//   void initState() {
//     super.initState();
//     _requestPermissionsAndInit();
//   }

//   Future<void> _requestPermissionsAndInit() async {
//     final scanProvider = Provider.of<ScanProvider>(context, listen: false);
//     await scanProvider.fetchLocation(context);
//     await _initCamera();
//   }

//   Future<void> _initCamera() async {
//     try {
//       final cameras = await availableCameras();
//       final firstCamera = cameras.first;
//       _cameraController = CameraController(
//         firstCamera,
//         ResolutionPreset.medium,
//       );
//       await _cameraController!.initialize();
//       if (mounted) {
//         setState(() {
//           _isInitialized = true;
//           _errorMessage = null;
//         });
//       }
//     } catch (e) {
//       if (mounted) {
//         setState(() {
//           _errorMessage = "Camera initialization failed: $e";
//         });
//       }
//       debugPrint("Camera Init Error: $e");
//     }
//   }

//   @override
//   void dispose() {
//     _cameraController?.dispose();
//     super.dispose();
//   }

//   Future<void> _capturePhoto() async {
//     if (_cameraController == null ||
//         !_cameraController!.value.isInitialized ||
//         _isCapturing)
//       return;

//     setState(() => _isCapturing = true);

//     try {
//       final file = await _cameraController!.takePicture();
//       setState(() => _capturedFile = file);
//     } catch (e) {
//       debugPrint("Capture Error: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('capture_failed'.tr()),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }

//     setState(() => _isCapturing = false);
//   }

//   Future<void> _submitScan() async {
//     if (_capturedFile == null) return;

//     final scanProvider = Provider.of<ScanProvider>(context, listen: false);
//     await scanProvider.uploadScan(
//       imageFile: File(_capturedFile!.path),
//       language: _selectedLanguage,
//     );

//     // Navigate to results page if analysis is successful
//     if (scanProvider.analysis != null && mounted) {}
//   }

//   void _retryCamera() {
//     setState(() {
//       _isInitialized = false;
//       _errorMessage = null;
//       _capturedFile = null;
//     });
//     _initCamera();
//   }

//   void _onLanguageChanged(String? value) {
//     if (value != null) {
//       setState(() => _selectedLanguage = value);

//       // Update app locale
//       switch (value) {
//         case "English":
//           context.setLocale(const Locale('en', 'US'));
//           break;
//         case "简体中文":
//           context.setLocale(const Locale('zh', 'CN'));
//           break;
//         case "繁體中文":
//           context.setLocale(const Locale('zh', 'TW'));
//           break;
//       }
//     }
//   }

//   Widget _buildCameraPreview() {
//     if (!_isInitialized || _cameraController == null) {
//       return Container(
//         width: double.infinity,
//         height: double.infinity,
//         color: Colors.black,
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(
//                 Icons.camera_alt,
//                 size: 80.sp,
//                 color: Colors.white.withOpacity(0.5),
//               ),
//               SizedBox(height: 16.h),
//               Text(
//                 _errorMessage ?? 'initializing_camera'.tr(),
//                 style: GoogleFonts.inter(
//                   color: Colors.white.withOpacity(0.7),
//                   fontSize: 14.sp,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               if (_errorMessage != null) ...[
//                 SizedBox(height: 16.h),
//                 ElevatedButton(
//                   onPressed: _retryCamera,
//                   child: Text('retry'.tr()),
//                 ),
//               ],
//             ],
//           ),
//         ),
//       );
//     }

//     return CameraPreview(_cameraController!);
//   }

//   Widget _buildCaptureButton() {
//     return GestureDetector(
//       onTap: _isCapturing ? null : _capturePhoto,
//       child: Container(
//         width: 64.w,
//         height: 64.w,
//         decoration: ShapeDecoration(
//           shape: OvalBorder(
//             side: BorderSide(
//               width: 2.w,
//               color: _isCapturing ? Colors.grey : Colors.white,
//             ),
//           ),
//         ),
//         child: Center(
//           child: _isCapturing
//               ? SizedBox(
//                   width: 20.w,
//                   height: 20.w,
//                   child: CircularProgressIndicator(
//                     strokeWidth: 2,
//                     color: Colors.white,
//                   ),
//                 )
//               : Container(
//                   width: 56.w,
//                   height: 56.w,
//                   decoration: const ShapeDecoration(
//                     color: Colors.white,
//                     shape: OvalBorder(),
//                   ),
//                 ),
//         ),
//       ),
//     );
//   }

//   Widget _buildBottomControls(ScanProvider scanProvider) {
//     return Positioned(
//       bottom: 50.h,
//       left: 0,
//       right: 0,
//       child: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 12.w),
//         child: Column(
//           children: [
//             // Submit button (shown only when image is captured)
//             if (_capturedFile != null) ...[
//               Container(
//                 width: 200.w,
//                 height: 44.h,
//                 margin: EdgeInsets.only(bottom: 20.h),
//                 child: ElevatedButton(
//                   onPressed: scanProvider.isLoading ? null : _submitScan,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColors.primaryColor,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(22.r),
//                     ),
//                   ),
//                   child: scanProvider.isLoading
//                       ? SizedBox(
//                           width: 20.w,
//                           height: 20.w,
//                           child: CircularProgressIndicator(
//                             strokeWidth: 2,
//                             color: Colors.white,
//                           ),
//                         )
//                       : Text(
//                           'submit'.tr(),
//                           style: GoogleFonts.inter(
//                             color: Colors.white,
//                             fontSize: 16.sp,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                 ),
//               ),
//             ],

//             // Camera controls
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 // Gallery Button
//                 _circleButton(Icons.photo_library, () {}),

//                 // Camera Shutter
//                 _buildCaptureButton(),

//                 // Retry/History Button
//                 _capturedFile != null
//                     ? _circleButton(Icons.refresh, () {
//                         setState(() => _capturedFile = null);
//                       })
//                     : _circleButton(Icons.history, () {}),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _circleButton(IconData icon, VoidCallback onTap) {
//     return Container(
//       width: 40.w,
//       height: 40.w,
//       decoration: BoxDecoration(
//         color: Colors.black.withOpacity(0.5),
//         borderRadius: BorderRadius.circular(20.r),
//       ),
//       child: IconButton(
//         icon: Icon(icon, size: 20.sp, color: Colors.white),
//         onPressed: onTap,
//         padding: EdgeInsets.zero,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final scanProvider = Provider.of<ScanProvider>(context);

//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Stack(
//         children: [
//           // Camera Preview
//           Positioned.fill(child: _buildCameraPreview()),

//           // Top Controls
//           Positioned(
//             top: 50.h,
//             left: 0,
//             right: 0,
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 12.w),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   // Profile button
//                   IconButton(
//                     icon: Icon(Icons.person, size: 28.sp, color: Colors.white),
//                     onPressed: () {},
//                   ),

//                   // Language Dropdown
//                   CustomDropdown(
//                     items: ['English', '简体中文', '繁體中文'],
//                     selectedValue: _selectedLanguage,
//                     hintText: 'select_language'.tr(),
//                     onChanged: _onLanguageChanged,
//                     buttonWidth: 100.w,
//                     buttonHeight: 28.h,
//                     fontSize: 12,
//                     textColor: AppColors.iconColor,
//                     padding: EdgeInsets.symmetric(horizontal: 10.w),
//                     icon: Icon(
//                       Icons.arrow_drop_down,
//                       size: 22.sp,
//                       color: AppColors.iconColor,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),

//           // Bottom Controls
//           _buildBottomControls(scanProvider),

//           // Loading overlay
//           if (scanProvider.isLoading)
//             Positioned.fill(
//               child: Container(
//                 color: Colors.black.withOpacity(0.7),
//                 child: Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       CircularProgressIndicator(
//                         valueColor: AlwaysStoppedAnimation<Color>(
//                           AppColors.primaryColor,
//                         ),
//                       ),
//                       SizedBox(height: 16.h),
//                       Text(
//                         'analyzing_image'.tr(),
//                         style: GoogleFonts.inter(
//                           color: Colors.white,
//                           fontSize: 16.sp,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }


// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:tripmate/controller/scan/scan_provider.dart';
// import 'package:tripmate/core/constants/app_colors.dart';
// import 'package:tripmate/core/widgets/custom_language.dart';
// import 'package:tripmate/view/place_details/place_details.dart';

// class CameraPage extends StatefulWidget {
//   const CameraPage({super.key});

//   @override
//   State<CameraPage> createState() => _CameraPageState();
// }

// class _CameraPageState extends State<CameraPage> with WidgetsBindingObserver {
//   CameraController? _cameraController;
//   bool _isInitialized = false;
//   bool _isCapturing = false;
//   XFile? _capturedFile;
//   String _selectedLanguage = "English";
//   String? _errorMessage;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//     _requestPermissionsAndInit();
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     _cameraController?.dispose();
//     super.dispose();
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.resumed) {
//       _resetCameraState();
//     }
//   }

//   void _resetCameraState() {
//     if (mounted) {
//       setState(() {
//         _capturedFile = null;
//         _isCapturing = false;
//       });
//     }
//   }

//   Future<void> _requestPermissionsAndInit() async {
//     final scanProvider = Provider.of<ScanProvider>(context, listen: false);
//     await scanProvider.fetchLocation(context);
//     await _initCamera();
//   }

//   Future<void> _initCamera() async {
//     try {
//       final cameras = await availableCameras();
//       final firstCamera = cameras.first;
//       _cameraController = CameraController(
//         firstCamera,
//         ResolutionPreset.medium,
//       );
//       await _cameraController!.initialize();
//       if (mounted) {
//         setState(() {
//           _isInitialized = true;
//           _errorMessage = null;
//         });
//       }
//     } catch (e) {
//       if (mounted) {
//         setState(() {
//           _errorMessage = "Camera initialization failed: $e";
//         });
//       }
//       debugPrint("Camera Init Error: $e");
//     }
//   }

//   Future<void> _capturePhoto() async {
//     if (_cameraController == null ||
//         !_cameraController!.value.isInitialized ||
//         _isCapturing) return;

//     setState(() => _isCapturing = true);

//     try {
//       final file = await _cameraController!.takePicture();
//       setState(() => _capturedFile = file);
      
//       // Automatically submit scan after capture
//       await _submitScan();
//     } catch (e) {
//       debugPrint("Capture Error: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('capture_failed'.tr()),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }

//     setState(() => _isCapturing = false);
//   }

//   Future<void> _submitScan() async {
//     if (_capturedFile == null) return;

//     final scanProvider = Provider.of<ScanProvider>(context, listen: false);
//     await scanProvider.uploadScan(
//       imageFile: File(_capturedFile!.path),
//       language: _selectedLanguage,
//     );

//     // Navigate to PlaceDetails page if analysis is successful
//     if (scanProvider.analysis != null && mounted) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => PlaceDetails(
//             capturedImagePath: _capturedFile!.path,
//           ),
//         ),
//       );
//     }
//   }

//   void _onLanguageChanged(String? value) {
//     if (value != null) {
//       setState(() => _selectedLanguage = value);

//       switch (value) {
//         case "English":
//           context.setLocale(const Locale('en', 'US'));
//           break;
//         case "简体中文":
//           context.setLocale(const Locale('zh', 'CN'));
//           break;
//         case "繁體中文":
//           context.setLocale(const Locale('zh', 'TW'));
//           break;
//       }
//     }
//   }

//   Widget _buildCameraControls(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         // Gallery Button
//         Container(
//           width: 30.w,
//           height: 30.w,
//           decoration: BoxDecoration(
//             color: Colors.black.withOpacity(0.5),
//             borderRadius: BorderRadius.circular(15.r),
//           ),
//           child: IconButton(
//             icon: Icon(Icons.photo_library, size: 18.sp, color: Colors.white),
//             onPressed: () {
//               // Add gallery functionality
//             },
//             padding: EdgeInsets.zero,
//           ),
//         ),

//         // Camera Shutter Button
//         Center(
//           child: Stack(
//             children: [
//               // Outer ring
//               Container(
//                 width: 64.w,
//                 height: 64.w,
//                 decoration: ShapeDecoration(
//                   shape: OvalBorder(
//                     side: BorderSide(width: 2.w, color: Colors.white),
//                   ),
//                 ),
//               ),
//               // Inner button
//               Positioned(
//                 left: 4.w,
//                 top: 4.w,
//                 child: GestureDetector(
//                   onTap: _isCapturing ? null : _capturePhoto,
//                   child: Container(
//                     width: 56.w,
//                     height: 56.w,
//                     decoration: ShapeDecoration(
//                       color: _isCapturing ? Colors.grey : Colors.white,
//                       shape: const OvalBorder(),
//                     ),
//                     child: _isCapturing
//                         ? Center(
//                             child: SizedBox(
//                               width: 20.w,
//                               height: 20.w,
//                               child: CircularProgressIndicator(
//                                 strokeWidth: 2.w,
//                                 valueColor: AlwaysStoppedAnimation<Color>(
//                                   Colors.white,
//                                 ),
//                               ),
//                             ),
//                           )
//                         : null,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),

//         // History Button
//         Container(
//           width: 30.w,
//           height: 30.w,
//           decoration: BoxDecoration(
//             color: Colors.black.withOpacity(0.5),
//             borderRadius: BorderRadius.circular(15.r),
//           ),
//           child: IconButton(
//             icon: Icon(Icons.history, size: 18.sp, color: Colors.white),
//             onPressed: () {
//               // Navigate to history
//             },
//             padding: EdgeInsets.zero,
//           ),
//         ),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final scanProvider = Provider.of<ScanProvider>(context);

//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Stack(
//         children: [
//           // Full Screen Camera Preview
//           if (_isInitialized && _cameraController != null)
//             SizedBox(
//               width: double.infinity,
//               height: double.infinity,
//               child: CameraPreview(_cameraController!),
//             )
//           else
//             // Camera preview placeholder
//             Container(
//               width: double.infinity,
//               height: double.infinity,
//               color: Colors.black,
//               child: Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(
//                       Icons.camera_alt,
//                       size: 80.sp,
//                       color: Colors.white.withOpacity(0.5),
//                     ),
//                     SizedBox(height: 16.h),
//                     if (_errorMessage != null)
//                       Text(
//                         _errorMessage!,
//                         style: GoogleFonts.inter(
//                           color: Colors.white,
//                           fontSize: 14.sp,
//                         ),
//                         textAlign: TextAlign.center,
//                       )
//                     else
//                       Text(
//                         'initializing_camera'.tr(),
//                         style: GoogleFonts.inter(
//                           color: Colors.white.withOpacity(0.7),
//                           fontSize: 14.sp,
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//             ),

//           // Top Controls Overlay
//           Positioned(
//             top: 50.h,
//             left: 0,
//             right: 0,
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 12.w),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   // Profile Button
//                   Container(
//                     width: 24.w,
//                     height: 24.w,
//                     decoration: BoxDecoration(
//                       color: Colors.transparent,
//                       borderRadius: BorderRadius.circular(12.r),
//                     ),
//                     child: IconButton(
//                       icon: Icon(
//                         Icons.person,
//                         size: 24.sp,
//                         color: Colors.white,
//                       ),
//                       onPressed: () {
//                         // Navigate to profile screen
//                       },
//                       padding: EdgeInsets.zero,
//                     ),
//                   ),

//                   // Language Dropdown
//                   CustomDropdown(
//                     items: ['English', '简体中文', '繁體中文'],
//                     selectedValue: _selectedLanguage,
//                     hintText: 'select_language'.tr(),
//                     onChanged: _onLanguageChanged,
//                     buttonWidth: 89.w,
//                     buttonHeight: 24.h,
//                     itemHeight: 40,
//                     fontSize: 12,
//                     textColor: AppColors.iconColor,
//                     padding: EdgeInsets.symmetric(horizontal: 10.w),
//                     icon: Icon(
//                       Icons.arrow_drop_down,
//                       size: 24.sp,
//                       color: AppColors.iconColor,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),

//           // Bottom Controls Overlay
//           Positioned(
//             bottom: 50.h,
//             left: 0,
//             right: 0,
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 12.w),
//               child: _buildCameraControls(context),
//             ),
//           ),

//           // Loading Overlay
//           if (scanProvider.isLoading)
//             Positioned.fill(
//               child: Container(
//                 color: Colors.black.withOpacity(0.7),
//                 child: Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       CircularProgressIndicator(
//                         valueColor: AlwaysStoppedAnimation<Color>(
//                           AppColors.primaryColor,
//                         ),
//                       ),
//                       SizedBox(height: 16.h),
//                       Text(
//                         'analyzing_image'.tr(),
//                         style: GoogleFonts.inter(
//                           color: Colors.white,
//                           fontSize: 16.sp,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }