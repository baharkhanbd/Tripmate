import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trip_mate/config/colors/colors.dart';
import 'package:trip_mate/features/booster/models/booster_model.dart';

class BoosterCard extends StatelessWidget {
  final BoosterModel booster;
  final bool isSelected;
  final VoidCallback? onTap;

  const BoosterCard({
    super.key,
    required this.booster,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 351.w,
        height: 52.h,
        //margin: EdgeInsets.only(bottom: 8.h),
        margin: EdgeInsets.only(bottom: 15.h),
        decoration: ShapeDecoration(
          color: AppColors.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Row(
            children: [
              // Icon
              Container(
                width: 24.w,
                height: 24.w,
                decoration: BoxDecoration(
                  //color: const Color(0xFFD9D9D9),
                  color:Colors.transparent,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: _buildIcon(),
              ),
              
              SizedBox(width: 20.w),
              
              // Duration Text
              Expanded(
                child: Text(
                  booster.duration,
                  style: GoogleFonts.inter(
                    color: AppColors.textColor1,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w500,
                    height: 1,
                    letterSpacing: 1.32,
                  ),
                ),
              ),
              
              // Price Text
              Text(
                booster.price,
                style: GoogleFonts.inter(
                  color: AppColors.textColor1,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w500,
                  height: 1,
                  letterSpacing: 1.32,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    switch (booster.icon) {
      case 'infinity':
        return Icon(
          Icons.all_inclusive,
          size: 16.sp,
          color: AppColors.textColor1,
        );
      case 'clock':
        return Icon(
          Icons.access_time,
          size: 16.sp,
          color: AppColors.textColor1,
        );
      case 'calendar':
        return Icon(
          // Icons.calendar_today,
          Icons.access_time,
          size: 16.sp,
          color: AppColors.textColor1,
        );
      default:
        return Icon(
          Icons.star,
          size: 16.sp,
          color: AppColors.textColor1,
        );
    }
  }
}
