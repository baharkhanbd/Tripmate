import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tripmate/controller/scan/scan_provider.dart';
import 'package:tripmate/model/scan_analysis.dart';
import 'package:tripmate/core/constants/app_colors.dart';

class PlaceDetails extends StatelessWidget {
  final String? capturedImagePath;

  const PlaceDetails({super.key, this.capturedImagePath});

  @override
  Widget build(BuildContext context) {
    final scanProvider = Provider.of<ScanProvider>(context);
    final analysis = scanProvider.analysis;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor1,
      body: CustomScrollView(
        slivers: [
          // AppBar with Image
          SliverAppBar(
            expandedHeight: 300.h,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.backgroundColor2,
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
                scanProvider.clearAnalysis();
              },
              child: Container(
                margin: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: AppColors.backgroundColor1,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_back,
                  color: AppColors.iconColor,
                  size: 22.sp,
                ),
              ),
            ),
             
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: capturedImagePath != null
                        ? FileImage(File(capturedImagePath!))
                        : const NetworkImage(
                            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRlqK1n6Xe3Budimutwt4yZ2YCXmNCCa66QLA&s",
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

          // Content
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
            color: AppColors.textColor1,
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
            fontSize: 22.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textColor1,
          ),
        ),
        SizedBox(height: 12.h),

        // Meta info row
        Row(
          children: [
            Row(
              children: [
                Icon(Icons.location_on, size: 16.sp, color: AppColors.iconColor),
                SizedBox(width: 4.w),
                Text(
                  analysis.location.isNotEmpty ? analysis.location : "Location not specified",
                  style: GoogleFonts.inter(fontSize: 14.sp, color: AppColors.textColor1),
                ),
              ],
            ),
            if (analysis.yearCompleted.isNotEmpty) ...[
              SizedBox(width: 24.w),
              Row(
                children: [
                  Icon(Icons.business, size: 16.sp, color: AppColors.iconColor),
                  SizedBox(width: 4.w),
                  Text(
                    analysis.yearCompleted,
                    style: GoogleFonts.inter(fontSize: 14.sp, color: AppColors.textColor1),
                  ),
                ],
              ),
            ],
          ],
        ),

        SizedBox(height: 16.h),
        Divider(color: AppColors.disabled1),
        SizedBox(height: 16.h),

        // Description / Overview
        if (analysis.historicalOverview.isNotEmpty)
          Text(
            analysis.historicalOverview,
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              height: 1.5,
              color: AppColors.textColor1,
            ),
          ),
        SizedBox(height: 24.h),

        // Sections
        if (analysis.location.isNotEmpty)
          _buildSection("Location", analysis.location, Icons.location_on),
        if (analysis.architecturalStyle.isNotEmpty)
          _buildSection("Architecture", analysis.architecturalStyle, Icons.architecture),
        if (analysis.materials.isNotEmpty)
          _buildSection("Construction", analysis.materials, Icons.construction),
        if (analysis.culturalImpact.isNotEmpty)
          _buildSection("Cultural Impact", analysis.culturalImpact, Icons.people),
        if (analysis.famousFor.isNotEmpty) ...[
          Row(
            children: [
              Icon(Icons.star, size: 18.sp, color: AppColors.highlight),
              SizedBox(width: 8.w),
              Text(
                "Famous For:",
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.highlight,
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
                backgroundColor: AppColors.highlight.withOpacity(0.2),
              );
            }).toList(),
          ),
          SizedBox(height: 24.h),
        ],

         
         
      ],
    );
  }

  Widget _buildSection(String title, String content, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18.sp, color: AppColors.highlight),
            SizedBox(width: 8.w),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.highlight,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Text(
          content,
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.textColor1,
          ),
        ),
        SizedBox(height: 16.h),
      ],
    );
  }
 
}
