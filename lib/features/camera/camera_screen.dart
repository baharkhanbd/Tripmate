
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:trip_mate/config/theme.dart';
import 'package:trip_mate/config/colors/colors.dart';
import 'package:trip_mate/features/camera/controllers/camera_controller.dart';
import 'package:trip_mate/features/camera/controllers/ui_controller.dart';
import 'package:trip_mate/core/common_custom_widget/custom_language_dropdown.dart';
import 'package:trip_mate/features/auths/services/auth_service.dart';
import 'package:camera/camera.dart' as camera_package;

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Initialize camera when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TripMateCameraController>().initializeCamera();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      // Reset camera state when app becomes active
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.read<TripMateCameraController>().resetCameraState();
        }
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reset camera state when returning to this screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<TripMateCameraController>().resetCameraState();
      }
    });
  }


  void _showLimitPopup(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Limit Reached"),
        content: const Text(
          "You’ve used all 3 free scans.\nUpgrade to premium to continue.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.push("/subscription"); 
            },
            child: const Text("Upgrade"),
          ),
        ],
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return Consumer3<CameraUIController, TripMateCameraController, AuthService>(
      builder: (context, uiController, cameraController, authService, child) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              // Full Screen Camera Preview
              if (cameraController.isInitialized &&
                  cameraController.cameraController != null)
                SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: camera_package.CameraPreview(
                    cameraController.cameraController!,
                  ),
                )
              else
                // Camera preview placeholder
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.black,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.camera_alt,
                          size: 80.sp,
                          color: Colors.white.withOpacity(0.5),
                        ),
                        SizedBox(height: 16.h),
                        if (cameraController.errorMessage != null)
                          Text(
                            cameraController.errorMessage!,
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 14.sp,
                            ),
                            textAlign: TextAlign.center,
                          )
                        else
                          Text(
                            'Initializing camera...',
                            style: GoogleFonts.inter(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

              // Top Controls Overlay
              Positioned(
                top: 50.h,
                left: 0,
                right: 0,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Settings Button
                      Container(
                        width: 24.w,
                        height: 24.w,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.brightness_7,
                            size: 24.sp,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            // Navigate to profile screen
                            context.push('/profile');
                          },
                          padding: EdgeInsets.zero,
                        ),
                      ),

                      // Language Dropdown
                      CustomDropdown(
                        items: ['English', '简体中文', '繁體中文'],
                        selectedValue: uiController.selectedLanguage,
                        hintText: 'Select Language',
                        // onChanged: (value) {
                        //   if (value != null) {
                        //     uiController.setLanguage(value);
                        //   }
                        // },
                        onChanged: (value) {
                          if (value != null) {
                            uiController.setLanguage(value);

                            if (value == 'English') {
                              context.setLocale(const Locale('en', 'US'));
                            } else if (value == '简体中文') {
                              context.setLocale(const Locale('zh', 'CN'));
                            } else if (value == '繁體中文') {
                              context.setLocale(const Locale('zh', 'TW'));
                            }
                          }
                        },
                        buttonWidth: 89.w,
                        buttonHeight: 24.h,
                        itemHeight: 40,
                        fontSize: 12,
                        textColor: AppColors.iconColor,
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        icon: Icon(
                          Icons.arrow_drop_down,
                          size: 24.sp,
                          color: AppColors.iconColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Bottom Controls Overlay
              Positioned(
                bottom: 50.h,
                left: 0,
                right: 0,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: _buildCameraControls(
                    context,
                    cameraController,
                    authService,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCameraControls(BuildContext context,TripMateCameraController cameraController,AuthService authService,) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Gallery Button
        Container(
          width: 30.w,
          height: 30.w,
          decoration: BoxDecoration(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.5),
            borderRadius: BorderRadius.circular(15.r),
          ),
          child: IconButton(
            icon: Icon(Icons.panorama, size: 18.sp, color: Colors.white),
            onPressed: () {
              cameraController.openGallery(context);
            },
            padding: EdgeInsets.zero,
          ),
        ),

        // Camera Shutter Button
        Center(
          child: Stack(
            children: [
              // Outer ring
              Container(
                width: 64.w,
                height: 64.w,
                decoration: ShapeDecoration(
                  shape: OvalBorder(
                    side: BorderSide(width: 2.w, color: Colors.white),
                  ),
                ),
              ),
              // Inner button
              Positioned(
                left: 4.w,
                top: 4.w,
                child: GestureDetector(
                onTap: cameraController.isCapturing
                  ? null
                  : () async {
                    try {
                            // 1️⃣ Check if user is authenticated
                            if (!authService.isAuthenticated()) {
                              // Capture photo first
                              await cameraController.capturePhoto();

                              if (cameraController.lastCapturedImage != null) {
                                // Store the captured image path for after login
                                await authService.setPendingImagePath(
                                  cameraController.lastCapturedImage!,
                                );
                                // Reset camera state
                                cameraController.resetCameraState();
                                // Navigate to login page
                                context.push('/login_page');
                              }
                              return; // Stop further execution until login
                            }

                            // 2️⃣ Check free scan limit for logged-in user
                            if (authService.hasReachedFreeLimit()) {
                              _showLimitPopup(context);
                              return; // Stop capture if limit reached
                            }

                            // 3️⃣ Capture photo normally
                            await cameraController.capturePhoto();

                            if (cameraController.lastCapturedImage != null) {
                              final capturedFile =
                                  cameraController.lastCapturedFile;
                              if (capturedFile != null) {
                                final imagePath = capturedFile.path;
                                // Navigate to image view
                                context.go(
                                  '/image_view?imagePath=${Uri.encodeComponent(imagePath)}',
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "No captured image available",
                                    ),
                                  ),
                                );
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "❌ No captured image available",
                                  ),
                                ),
                              );
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("🚨 Error: ${e.toString()}"),
                              ),
                            );
                            cameraController.resetCameraState();
                          }
                        },

              child: Container(
                width: 56.w,
                height: 56.w,
                decoration: ShapeDecoration(
                  color: cameraController.isCapturing
                  ? Colors.grey
                  : Colors.white,
                  shape: const OvalBorder(),
                ),
                child: cameraController.isCapturing
                  ? Center(
                    child: SizedBox(
                      width: 20.w,
                      height: 20.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.w,
                          valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white,
                                ),
                              ),
                            ),
                          )
                        : null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          // Recent Button
          Container(
          width: 30.w,
          height: 30.w,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            borderRadius: BorderRadius.circular(15.r),
          ),
          child: IconButton(
            icon: Icon(Icons.history, size: 18.sp, color: Colors.white),
            onPressed: () {
              context.push('/history');
            },
            padding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }
}
