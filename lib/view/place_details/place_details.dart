import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tripmate/controller/scan/scan_provider.dart';
import 'package:tripmate/model/scan_analysis.dart';

class PlaceDetails extends StatelessWidget {
  final String? capturedImagePath;

  const PlaceDetails({super.key, this.capturedImagePath});

  @override
  Widget build(BuildContext context) {
    final scanProvider = Provider.of<ScanProvider>(context);
    final analysis = scanProvider.analysis;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: CustomScrollView(
        slivers: [
          // 🔝 AppBar with Image
          SliverAppBar(
            expandedHeight: 280.h,
            floating: false,
            pinned: true,
            leading: GestureDetector(
              onTap: ()  {
                Navigator.pop(context);
                scanProvider.clearAnalysis();
              },
              child: Container(
                margin: EdgeInsets.all(8.w),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.arrow_back, size: 22.sp, color: Colors.black87),
              ),
            ),
            actions: [
              GestureDetector(
                onTap: () {
                  // Delete functionality
                  scanProvider.clearAnalysis();
                  Navigator.of(context).pop();
                },
                child: Container(
                  margin: EdgeInsets.all(8.w),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.delete_outline, size: 22.sp, color: Colors.red),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: capturedImagePath != null
                        ? FileImage(File(capturedImagePath!))
                        : const NetworkImage(
                            "https://upload.wikimedia.org/wikipedia/commons/d/da/Taj-Mahal.jpg",
                          ) as ImageProvider,
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

          // 🔻 Content
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: analysis == null 
                  ? _buildLoadingState()
                  : _buildAnalysisContent(analysis),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 50.h),
        CircularProgressIndicator(),
        SizedBox(height: 20.h),
        Text(
          "Loading analysis...",
          style: GoogleFonts.inter(
            fontSize: 16.sp,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildAnalysisContent(ScanAnalysis analysis) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          analysis.landmarkName.isNotEmpty 
              ? analysis.landmarkName 
              : "Historical Landmark",
          style: GoogleFonts.inter(
            fontSize: 24.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 12.h),

        // Metadata Row
        Row(
          children: [
            Icon(Icons.location_on, size: 18.sp, color: Colors.grey),
            SizedBox(width: 6.w),
            Expanded(
              child: Text(
                analysis.location.isNotEmpty ? analysis.location : "Location not specified",
                style: GoogleFonts.inter(fontSize: 14.sp, color: Colors.grey),
              ),
            ),
            if (analysis.yearCompleted.isNotEmpty) ...[
              SizedBox(width: 20.w),
              Icon(Icons.calendar_today, size: 18.sp, color: Colors.grey),
              SizedBox(width: 6.w),
              Text(
                analysis.yearCompleted,
                style: GoogleFonts.inter(fontSize: 14.sp, color: Colors.grey),
              ),
            ],
          ],
        ),
        Divider(height: 32.h, color: Colors.grey.shade300),

        // Historical Overview
        if (analysis.historicalOverview.isNotEmpty) ...[
          _buildSection(
            "Historical Overview",
            analysis.historicalOverview,
            Icons.history,
          ),
          SizedBox(height: 16.h),
        ],

        // Location
        if (analysis.location.isNotEmpty) ...[
          _buildSection(
            "Location",
            analysis.location,
            Icons.location_on,
          ),
          SizedBox(height: 16.h),
        ],

        // Architectural Style
        if (analysis.architecturalStyle.isNotEmpty) ...[
          _buildSection(
            "Architecture",
            analysis.architecturalStyle,
            Icons.architecture,
          ),
          SizedBox(height: 16.h),
        ],

        // Materials
        if (analysis.materials.isNotEmpty) ...[
          _buildSection(
            "Materials",
            analysis.materials,
            Icons.construction,
          ),
          SizedBox(height: 16.h),
        ],

        // Cultural Impact
        if (analysis.culturalImpact.isNotEmpty) ...[
          _buildSection(
            "Cultural Impact",
            analysis.culturalImpact,
            Icons.people,
          ),
          SizedBox(height: 16.h),
        ],

        // Famous For
        if (analysis.famousFor.isNotEmpty) ...[
          Row(
            children: [
              Icon(Icons.star, size: 18.sp, color: Colors.blue),
              SizedBox(width: 8.w),
              Text(
                "Famous For:",
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 4.h,
            children: analysis.famousFor.map((item) {
              return Chip(
                label: Text(
                  item,
                  style: GoogleFonts.inter(fontSize: 12.sp),
                ),
                backgroundColor: Colors.blue.shade50,
              );
            }).toList(),
          ),
          SizedBox(height: 24.h),
        ],

        // Additional Info
        Row(
          children: [
            Icon(Icons.info, size: 18.sp, color: Colors.blue),
            SizedBox(width: 8.w),
            Text(
              "Additional Information:",
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.blue,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Text(
          "This analysis was generated using advanced image recognition technology.",
          style: GoogleFonts.inter(fontSize: 14.sp, color: Colors.black87),
        ),
        SizedBox(height: 32.h),
      ],
    );
  }

  Widget _buildSection(String title, String content, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18.sp, color: Colors.blue),
            SizedBox(width: 8.w),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.blue,
              ),
            ),
          ],
        ),
        SizedBox(height: 6.h),
        Text(
          content,
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            color: Colors.black87,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}