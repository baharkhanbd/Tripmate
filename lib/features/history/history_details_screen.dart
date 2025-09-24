import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:trip_mate/config/colors/colors.dart';
import 'package:trip_mate/features/camera/controllers/camera_controller.dart';
import 'package:trip_mate/features/camera/controllers/scan_controller.dart';
import 'package:trip_mate/features/history/controllers/history_details_controller.dart';
import 'package:trip_mate/features/history/widgets/rich_text_widget.dart';

class HistoryDetailsScreen extends StatelessWidget {
  final String historyId;
  final String? capturedImagePath;

  const HistoryDetailsScreen({
    super.key,
    required this.historyId,
    this.capturedImagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<HistoryDetailsController>(
      builder: (context, controller, child) {
        // Load details when screen is first built
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (controller.historyDetails?.id != historyId) {
            controller.loadHistoryDetails(historyId);
          }
        });
        return Scaffold(
          backgroundColor: AppColors.backgroundColor1,
          body: _buildBody(context, controller),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, HistoryDetailsController controller) {
    // If we have a captured image, show it directly without loading history details
    if (capturedImagePath != null) {
      return CustomScrollView(
        slivers: [
          // App Bar with Captured Image
          SliverAppBar(
            expandedHeight: 300.h,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.backgroundColor2,
            leading: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                margin: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_back,
                  color: AppColors.iconColor,
                  size: 20.sp,
                ),
              ),
            ),
            // No delete action for captured images
            flexibleSpace: FlexibleSpaceBar(
              background: Consumer<TripMateCameraController>(
                builder: (context, cameraController, child) {
                  final capturedImagePath = cameraController.lastCapturedFile?.path;
                  return Container(
                    decoration: BoxDecoration(
                      image: capturedImagePath != null
                        ? DecorationImage(
                          image: FileImage(File(capturedImagePath)),
                          fit: BoxFit.cover,
                        )
                          : null,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.3),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Content for captured image
          // SliverToBoxAdapter(
          //   child: Padding(
          //     padding: EdgeInsets.all(16.w),
          //     child: _buildCapturedImageContent(),
          //   ),
          // ),

          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Consumer<ScanController>(
                builder: (context, controller, child) {
                  final analysis = controller.lastScanResult?["analysis"] ?? {};
                  final scan = controller.lastScanResult?["scan"] ?? {};
                  return _buildCapturedImageContent(analysis, scan, isLoading: controller.isLoading);
                },
              ),
            ),
          ),
        ],
      );
    }

    // For history items, load details from controller
    if (controller.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (controller.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48.sp,
              color: AppColors.disabled1,
            ),
            SizedBox(height: 16.h),
            Text(
              controller.errorMessage!,
              style: GoogleFonts.inter(
                color: AppColors.disabled1,
                fontSize: 16.sp,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: () => controller.loadHistoryDetails(historyId),
              child: Text('Retry'),
            ),
          ],
        ),
      );
    }

    final details = controller.historyDetails;
if (details == null) {
  return const Center(
    child: CircularProgressIndicator(),
  );
}

return CustomScrollView(
  slivers: [
    // App Bar with Image
    SliverAppBar(
      expandedHeight: 300.h,
      floating: false,
      pinned: true,
      backgroundColor: AppColors.backgroundColor2,
      leading: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          margin: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.arrow_back,
            color: AppColors.iconColor,
            size: 22.sp,
          ),
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () {
            // Handle delete action
            _showDeleteDialog(context);
          },
          child: Container(
            margin: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.delete_outline,
              color: Colors.red,
              size: 20.sp,
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(details.imageUrl), // <-- this shows the image
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.3),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
        // Content for history items
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: _buildHistoryContent(details),
          ),
        ),
      ],
    );
  }

  Widget _buildSection(String title, String content, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 18.sp,
              color: AppColors.highlight,
            ),
            SizedBox(width: 8.w),
            Text(
              title,
              style: GoogleFonts.inter(
                color: AppColors.highlight,
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        RichTextWidget(
          text: content,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ],
    );
  }

  Widget _buildVisitingHoursSection(String visitingHours) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.access_time,
              size: 18.sp,
              color: AppColors.highlight,
            ),
            SizedBox(width: 8.w),
            Text(
              'Visiting Hours',
              style: GoogleFonts.inter(
                color: AppColors.highlight,
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              ' (approx.):',
              style: GoogleFonts.inter(
                color: AppColors.textColor1,
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        RichTextWidget(
          text: visitingHours,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ],
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Delete History',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            'Are you sure you want to delete this history item?',
            style: GoogleFonts.inter(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Go back to history list
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('History item deleted'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              child: Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  // Widget _buildCapturedImageContent() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       //!-----tollbar on scroll-------------!
  //       Column(
  //         children: [
  //           SizedBox(height: 8.h),
  //           Center(
  //             child: Column(
  //               children: [
  //                 Container(
  //                   width: 40.w,
  //                   height: 2.h,
  //                   decoration: BoxDecoration(
  //                     color: AppColors.iconColor,
  //                     borderRadius: BorderRadius.circular(2.r),
  //                   ),
  //                 ),
  //                 SizedBox(height: 4.h),
  //                 Container(
  //                   width: 40.w,
  //                   height: 2.h,
  //                   decoration: BoxDecoration(
  //                     color: AppColors.iconColor,
  //                     borderRadius: BorderRadius.circular(2.r),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //           SizedBox(height: 16.h),
  //         ],
  //       ),
  //       //!-----------------------------------!
  //       // Title
  //       Text(
  //         'Red Fort - Historical Monument',
  //         style: GoogleFonts.inter(
  //           color: AppColors.textColor1,
  //           fontSize: 24.sp,
  //           fontWeight: FontWeight.w600,
  //         ),
  //       ),
        
  //       SizedBox(height: 16.h),
        
  //       // Metadata Row
  //       Row(
  //         children: [
  //           // Location
  //           Row(
  //             children: [
  //               Icon(
  //                 Icons.location_on,
  //                 size: 16.sp,
  //                 color: AppColors.iconColor,
  //               ),
  //               SizedBox(width: 4.w),
  //               Text(
  //                 'Delhi, India',
  //                 style: GoogleFonts.inter(
  //                   color: AppColors.iconColor,
  //                   fontSize: 14.sp,
  //                   fontWeight: FontWeight.w400,
  //                 ),
  //               ),
  //             ],
  //           ),
            
  //           SizedBox(width: 24.w),
            
  //           // Year
  //           Row(
  //             children: [
  //               Icon(
  //                 Icons.business,
  //                 size: 16.sp,
  //                 color: AppColors.iconColor,
  //               ),
  //               SizedBox(width: 4.w),
  //               Text(
  //                 '1648',
  //                 style: GoogleFonts.inter(
  //                   color: AppColors.iconColor,
  //                   fontSize: 14.sp,
  //                   fontWeight: FontWeight.w400,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ],
  //       ),
  //       SizedBox(width: double.infinity,child: Divider(color: AppColors.disabled1, height: 32.h),),
  //       SizedBox(height: 5.h),
        
  //       // Description
  //       Text(
  //         'The Red Fort is a historic fort in the city of Delhi in India. It was the main residence of the emperors of the Mughal dynasty for nearly 200 years, until 1857. The fort represents the peak in Mughal architecture under Shah Jahan.',
  //         style: GoogleFonts.inter(
  //           color: AppColors.textColor1,
  //           fontSize: 16.sp,
  //           fontWeight: FontWeight.w400,
  //           height: 1.5,
  //         ),
  //       ),
        
  //       SizedBox(height: 24.h),
        
  //       // Location Section
  //       _buildSection(
  //         'Location',
  //         'Located in Old Delhi, the fort was built by the Mughal emperor Shah Jahan as the palace fort of his capital Shahjahanabad.',
  //         Icons.location_on,
  //       ),
        
  //       SizedBox(height: 16.h),
        
  //       // Construction Section
  //       _buildSection(
  //         'Construction',
  //         'Construction began in 1638 and was completed in 1648. The fort was designed by architect Ustad Ahmad Lahori, who also designed the Taj Mahal.',
  //         Icons.construction,
  //       ),
        
  //       SizedBox(height: 16.h),
        
  //       // Architecture Section
  //       _buildSection(
  //         'Architecture',
  //         'The Red Fort showcases the peak of Mughal architecture with its red sandstone walls, white marble inlays, and intricate carvings.',
  //         Icons.architecture,
  //       ),
        
  //       SizedBox(height: 24.h),
  //     ],
  //   );
  // }

  Widget _buildCapturedImageContent(Map<String, dynamic> analysis, Map<String, dynamic> scan, {required bool isLoading}) {
  return Stack(
    children: [
      // Main content
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //!-----toolbar on scroll-------------!
          Column(
            children: [
              SizedBox(height: 8.h),
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 40.w,
                      height: 2.h,
                      decoration: BoxDecoration(
                        color: AppColors.iconColor,
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Container(
                      width: 40.w,
                      height: 2.h,
                      decoration: BoxDecoration(
                        color: AppColors.iconColor,
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
            ],
          ),

          //!-----------------------------------!
          // Title
          Text(
            analysis["landmark_name"] ?? "Unknown Landmark",
            style: GoogleFonts.inter(
              color: AppColors.textColor1,
              fontSize: 24.sp,
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: 16.h),

          // Metadata Row
          Row(
            children: [
              // Location
              Row(
                children: [
                  Icon(Icons.location_on, size: 16.sp, color: AppColors.iconColor),
                  SizedBox(width: 4.w),
                  Text(
                    analysis["location"] ?? "Unknown Location",
                    style: GoogleFonts.inter(
                      color: AppColors.iconColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),

              SizedBox(width: 24.w),

              // Year
              Row(
                children: [
                  Icon(Icons.business, size: 16.sp, color: AppColors.iconColor),
                  SizedBox(width: 4.w),
                  Text(
                    analysis["year_completed"]?.toString() ?? "N/A",
                    style: GoogleFonts.inter(
                      color: AppColors.iconColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(width: double.infinity, child: Divider(color: AppColors.disabled1, height: 32.h)),
          SizedBox(height: 5.h),

          // Description
          Text(
            analysis["historical_overview"] ?? "No description available.",
            style: GoogleFonts.inter(
              color: AppColors.textColor1,
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              height: 1.5,
            ),
          ),

          SizedBox(height: 24.h),

          // Location Section
          _buildSection(
            "Location",
            analysis["location"] ?? "Unknown location details.",
            Icons.location_on,
          ),

          SizedBox(height: 16.h),

          // Construction Section
          _buildSection(
              "Construction",
              analysis["materials"] ?? "No construction details available.",
              Icons.construction,
            ),

          SizedBox(height: 16.h),
          // Architecture Section
          _buildSection(
              "Architecture",
              analysis["architectural_style"] ?? "No architecture details available.",
              Icons.architecture,
            ),

          SizedBox(height: 24.h),
        ],
      ),

      // Loader overlay
      if (isLoading)
        Container(
          color: Colors.black.withOpacity(0.4),
          alignment: Alignment.center,
          child: const CircularProgressIndicator(
            color: Colors.white,
          ),
        ),
    ],
  );
}


  Widget _buildHistoryContent(dynamic details) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          details.title,
          style: GoogleFonts.inter(
            color: AppColors.textColor1,
            fontSize: 24.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 16.h),
        // Metadata Row
        (details.location.length > 30)
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 16.sp,
                        color: AppColors.iconColor,
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        // prevent overflow
                        child: Text(
                          details.location,
                          style: GoogleFonts.inter(
                            color: AppColors.textColor1,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                          softWrap: true,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Icon(
                        Icons.business,
                        size: 16.sp,
                        color: AppColors.iconColor,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        details.year,
                        style: GoogleFonts.inter(
                          color: AppColors.textColor1,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              )
            : Row(
                children: [
                  // Location
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 16.sp,
                        color: AppColors.iconColor,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        details.location,
                        style: GoogleFonts.inter(
                          color: AppColors.textColor1,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 24.w),
                  // Year
                  Row(
                    children: [
                      Icon(
                        Icons.business,
                        size: 16.sp,
                        color: AppColors.iconColor,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        details.year,
                        style: GoogleFonts.inter(
                          color: AppColors.textColor1,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

        SizedBox(width: double.infinity,child: Divider(color: AppColors.disabled1, height: 24.h),),
        // SizedBox(height: 24.h),
        SizedBox(height: 10.h,),
        // Description
        RichTextWidget(
          text: details.description,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        
        SizedBox(height: 24.h),
        
        // Location Section
        _buildSection(
          'Location',
          details.location,
          Icons.location_on,
        ),
        
        SizedBox(height: 16.h),
        
        // Construction Section
        _buildSection(
          'Construction',
          details.construction,
          Icons.construction,
        ),
        
        SizedBox(height: 16.h),
        
        // Unfinished Structure Section
        _buildSection(
          'Unfinished Structure',
          details.unfinishedStructure,
          Icons.architecture,
        ),
        
        SizedBox(height: 24.h),
        
        // Visiting Hours Section
        _buildVisitingHoursSection(details.visitingHours),
        
        SizedBox(height: 24.h),
        
        // Additional Info Section
        if (details.additionalInfo.isNotEmpty) ...[
          RichTextWidget(
            text: details.additionalInfo,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          
          SizedBox(height: 24.h),
        ],
      ],
    );
  }
}
