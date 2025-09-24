import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trip_mate/config/colors/colors.dart';
import 'package:trip_mate/features/profile/models/privacy_policy_model.dart';

class PolicySectionWidget extends StatelessWidget {
  final PolicySection section;

  const PolicySectionWidget({
    super.key,
    required this.section,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        Text(
          section.title,
          style: GoogleFonts.inter(
            color: AppColors.textColor1,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            height: 1.57,
          ),
        ),
        
        SizedBox(height: 8.h),
        
        // Section Description
        Text(
          section.description,
          style: GoogleFonts.inter(
            color: AppColors.textColor1,
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            height: 1.57,
          ),
        ),
        
        SizedBox(height: 12.h),
        
        // Bullet Points
        ...section.bulletPoints.map((point) => _buildBulletPoint(point)),
      ],
    );
  }

  Widget _buildBulletPoint(String point) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bullet point
          Container(
            width: 4.w,
            height: 4.w,
            margin: EdgeInsets.only(top: 8.h, right: 8.w),
            decoration: BoxDecoration(
              color: AppColors.textColor1,
              shape: BoxShape.circle,
            ),
          ),
          
          // Text
          Expanded(
            child: Text(
              point,
              style: GoogleFonts.inter(
                color: AppColors.textColor1,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                height: 1.57,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
