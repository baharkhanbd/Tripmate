import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:trip_mate/features/auths/controllers/ui_controller.dart';
import 'package:trip_mate/features/camera/controllers/scan_controller.dart';
import 'package:trip_mate/features/camera/custom_widget/custome_circle_indigator_widget.dart';

class ImageViewScreen extends StatefulWidget {
  final String imagePath;
  
  const ImageViewScreen({
    super.key,
    required this.imagePath,
  });

  @override
  State<ImageViewScreen> createState() => _ImageViewScreenState();
}

class _ImageViewScreenState extends State<ImageViewScreen> {
  Timer? _analyzingTimer;
  int _analyzingTime = 25;
  bool _isAnalyzing = false;

  @override
  void initState() {
    super.initState();
    // Start analyzing automatically when screen loads
    _startAnalyzing();
  }

  @override
  void dispose() {
    _analyzingTimer?.cancel();
    super.dispose();
  }

  void _startAnalyzing() {
    setState(() {
      _isAnalyzing = true;
      _analyzingTime = 25;
    });
    
    _analyzingTimer?.cancel();
    _analyzingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_analyzingTime > 0) {
            _analyzingTime--;
          } else {
            timer.cancel();
            _isAnalyzing = false;
            // Navigate to history details screen after analysis completes
            _navigateToHistoryDetails();
          }
        });
      }
    });
  }

  // void _navigateToHistoryDetails() {
  //   // Navigate to history details screen with the captured image
  //   context.push('/history_details?imagePath=${Uri.encodeComponent(widget.imagePath)}');
  // }
  void _navigateToHistoryDetails() async {
  final scanController = context.read<ScanController>();
  final uiController = context.read<UIController>();
  try {
    await scanController.uploadScan(widget.imagePath, language:uiController.selectedLang);

    if (scanController.lastScanResult != null) {
      final scanId = scanController.lastScanResult!['id'].toString();

      context.push(
        '/history_details',
        extra: {
          'historyId': scanId,
          'capturedImagePath': widget.imagePath,
        },
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Failed to analyze image")),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Full screen image
          Container(
            width: double.infinity,
            height: double.infinity,
            child: Image.file(
              File(widget.imagePath),
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.black,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 80.sp,
                          color: Colors.white.withOpacity(0.5),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'Failed to load image',
                          style: GoogleFonts.inter(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 16.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Top controls overlay
          Positioned(
            top: 50.h,
            left: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back button
                  Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        size: 20.sp,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        // Navigate back to camera screen
                        context.go('/camera');
                      },
                      padding: EdgeInsets.zero,
                    ),
                  ),
                  
                                     // Title
                  //  Container(
                  //    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  //    decoration: BoxDecoration(
                  //      color: Colors.black.withOpacity(0.5),
                  //      borderRadius: BorderRadius.circular(20.r),
                  //    ),
                  //    child: Text(
                  //      'Captured Image',
                  //      style: GoogleFonts.inter(
                  //        color: Colors.white,
                  //        fontSize: 14.sp,
                  //        fontWeight: FontWeight.w500,
                  //      ),
                  //    ),
                  //  ),
                 ],
              ),
            ),
          ),
          
          // Center processing UI overlay - only show during analysis
          if (_isAnalyzing)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.3),
                child: Center(
                  child: _buildProcessingUI(),
                ),
              ),
            ),
          
          // Bottom action bar
          Positioned(
            bottom: 50.h,
            left: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: _buildBottomActionBar(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProcessingUI() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Analyzing Button
        Container(
          width: 200.w,
          height: 48.h,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.r),
              side: BorderSide(
                color: const Color(0xFF6B7280),
                width: 1,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 20.w,
                height: 20.w,
                child: SegmentedSpinner(
                  size: 40.w,
                  color: const Color(0xFF6B7280),
                ),
                // CircularProgressIndicator(
                //   strokeWidth: 2.w,
                //   valueColor: AlwaysStoppedAnimation<Color>(
                //     const Color(0xFF6B7280),
                //   ),
                // ),
              ),
              SizedBox(width: 8.w),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Analyzing ',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF6B7280), // Gray color
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextSpan(
                      text: '${_analyzingTime}s',
                      style: GoogleFonts.inter(
                        color: const Color(0xFFFF7A00), // Orange color
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              // Text(
              //   'Analyzing ${_analyzingTime}s',
              //   style: GoogleFonts.inter(
              //     color: const Color(0xFF6B7280),
              //     fontSize: 16.sp,
              //     fontWeight: FontWeight.w500,
              //   ),
              // ),
            ],
          ),
        ),
        
        SizedBox(height: 16.h),
        
        // Boost Button
        GestureDetector(
          onTap: () {
            context.push('/booster');
          },
          child: Container(
            width: 200.w,
            height: 48.h,
            decoration: ShapeDecoration(
              color: Color(0xFFFF7A00),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.r),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Boost',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 8.w),
                Container(
                  width: 32.sp,
                  height: 32.sp,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.flash_on,
                      size: 20.sp,
                      color: Color(0xFFFF7A00),
                    ),
                  ),
                ),
                // Icon(
                //   Icons.flash_on,
                //   size: 20.sp,
                //   color: Colors.white,
                // ),
              ],
            ),
          ),
        ),
      ],
    );
  }



  Widget _buildBottomActionBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Retake button
        Container(
          width: 50.w,
          height: 50.w,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            borderRadius: BorderRadius.circular(25.r),
          ),
          child: IconButton(
            icon: Icon(
              Icons.refresh,
              size: 24.sp,
              color: Colors.white,
            ),
            onPressed: () {
              // Navigate back to camera screen
              context.go('/camera');
            },
            padding: EdgeInsets.zero,
          ),
        ),
        
        // // Save button
        // Container(
        //   width: 50.w,
        //   height: 50.w,
        //   decoration: BoxDecoration(
        //     color: Colors.black.withOpacity(0.5),
        //     borderRadius: BorderRadius.circular(25.r),
        //   ),
        //   child: IconButton(
        //     icon: Icon(
        //       Icons.save,
        //       size: 24.sp,
        //       color: Colors.white,
        //     ),
        //     onPressed: () {
        //       // TODO: Implement save functionality
        //     },
        //     padding: EdgeInsets.zero,
        //   ),
        // ),
        
        // // Edit button
        // Container(
        //   width: 50.w,
        //   height: 50.w,
        //   decoration: BoxDecoration(
        //     color: Colors.black.withOpacity(0.5),
        //     borderRadius: BorderRadius.circular(25.r),
        //   ),
        //   child: IconButton(
        //     icon: Icon(
        //       Icons.edit,
        //       size: 24.sp,
        //       color: Colors.white,
        //     ),
        //     onPressed: () {
        //       // TODO: Implement edit functionality
        //     },
        //     padding: EdgeInsets.zero,
        //   ),
        // ),
        
        // Delete button
        Container(
          width: 50.w,
          height: 50.w,
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.8),
            borderRadius: BorderRadius.circular(25.r),
          ),
          child: IconButton(
            icon: Icon(
              Icons.delete,
              size: 24.sp,
              color: Colors.white,
            ),
            onPressed: () {
              _showDeleteConfirmation();
            },
            padding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: Row(
            children: [
              Icon(
                Icons.delete,
                color: Colors.red.shade600,
                size: 24.sp,
              ),
              SizedBox(width: 12.w),
              Text(
                'Delete Image',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 18.sp,
                ),
              ),
            ],
          ),
          content: Text(
            'Are you sure you want to delete this image?',
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              color: Colors.grey.shade700,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                context.go('/camera'); // Go back to camera
              },
              child: Text(
                'Delete',
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.red.shade600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
