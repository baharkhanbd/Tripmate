 
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tripmate/controller/scan/scan_provider.dart';
import 'package:tripmate/core/widgets/custom_loading.dart';
import 'package:tripmate/view/place_details/details.dart';
import 'package:tripmate/view/place_details/place_details.dart';

class ImageViewScreen extends StatefulWidget {
  final String imagePath;
  final String selectedLanguage;
  final String cameraType;

  const ImageViewScreen({
    super.key,
    required this.imagePath,
    required this.selectedLanguage,
    required this.cameraType,
  });

  @override
  State<ImageViewScreen> createState() => _ImageViewScreenState();
}

class _ImageViewScreenState extends State<ImageViewScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Call API after first frame to avoid setState during build error
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _uploadScan();
    });
  }

  Future<void> _uploadScan() async {
    setState(() => _isLoading = true);
    final scanProvider = Provider.of<ScanProvider>(context, listen: false);

    int statusCode = await scanProvider.uploadScan(
      imageFile: File(widget.imagePath),
      language: widget.selectedLanguage,
      cameraType:widget.cameraType
    );

    setState(() => _isLoading = false);

    if (statusCode == 201 && scanProvider.analysis != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => PlaceDetails(capturedImagePath: widget.imagePath),
        ),
      );
    } else if (statusCode == 403) {
      _showLimitReachedDialog();
    } else if (statusCode == 500) {
      _showFailedDialog();
    }  
  }

  // Function to restart the scanning process
  void _restartScan() {
    setState(() {
      _isLoading = true;
    });
    _uploadScan();
  }

  void _showLimitReachedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title with icon
            Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.orange,
                  size: 24,
                ),
                const SizedBox(width: 12),
                const Text(
                  "Daily Limit Reached!",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Center aligned content text
            const Center(
              child: Text(
                "You've used your 3 free analyses for today.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
            ),

            const SizedBox(height: 24),

            // Buttons row
            Row(
              children: [
                // Maybe Later button
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Colors.grey),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      "Maybe Later",
                      style: TextStyle(color: Colors.black87),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Boost Now button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const Details()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF7A00),
                      foregroundColor: const Color(0xFFFF7A00),
                      side: const BorderSide(color: Color(0xFFFF7A00)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Boost Now",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(Icons.flash_on, size: 20, color: Colors.white),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showFailedDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFFFF7A00).withOpacity(0.9),
                const Color(0xFFFF7A00).withOpacity(0.7),
              ],
            ),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Padding(
            padding: EdgeInsets.all(25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline, color: Colors.white, size: 60),
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
                  style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.9)),
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
                            color: const Color(0xFFFF7A00),
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
              Icon(Icons.delete, color: Colors.red.shade600, size: 24.sp),
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
                Navigator.of(context).pop();
                Navigator.pop(context);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Full screen image
          Positioned.fill(
            child: Image.file(
              File(widget.imagePath),
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
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
              ),
            ),
          ),

          // Top back button
          Positioned(
            top: 50.h,
            left: 12.w,
            child: Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: IconButton(
                icon: Icon(Icons.arrow_back, size: 20.sp, color: Colors.white),
                onPressed: () => Navigator.pop(context),
                padding: EdgeInsets.zero,
              ),
            ),
          ),

          // Processing overlay
          if (_isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.3),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
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
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              'Analyzing...',
                              style: GoogleFonts.inter(
                                color: const Color(0xFF6B7280),
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.h),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const Details()),
                          );
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
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Bottom action bar
          Positioned(
            bottom: 50.h,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Refresh/Rescan button
                Container(
                  width: 50.w,
                  height: 50.w,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.refresh, size: 24.sp, color: Colors.white),
                    onPressed: _restartScan, // Changed from Navigator.pop to _restartScan
                    padding: EdgeInsets.zero,
                  ),
                ),
                // Delete button
                Container(
                  width: 50.w,
                  height: 50.w,
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.delete, size: 24.sp, color: Colors.white),
                    onPressed: _showDeleteConfirmation,
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