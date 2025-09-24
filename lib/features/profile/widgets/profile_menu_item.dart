import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trip_mate/config/colors/colors.dart';

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  final bool showDivider;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Row(
              children: [
                // Icon
                Container(
                  width: 20.w,
                  height: 20.w,
                  decoration: BoxDecoration(
                     color: AppColors.disabled1,
                    //color: Colors.transparent,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Icon(
                    icon,
                    size: 14.sp,
                    color: AppColors.iconColor,
                  ),
                ),
                
                SizedBox(width: 16.w),
                
                // Title
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.inter(
                      color: AppColors.textColor1,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                
                // Arrow icon
                Container(
                  width: 24.w,
                  height: 24.w,
                  decoration: BoxDecoration(
                    color: AppColors.disabled1,
                    //color: Colors.transparent,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 14.sp,
                    color: AppColors.iconColor,
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // Divider
        if (showDivider)
          Container(
            width: double.infinity,
            height: 0.5,
            color: AppColors.disabled2,
            margin: EdgeInsets.symmetric(horizontal: 16.w),
          ),
      ],
    );
  }
}
