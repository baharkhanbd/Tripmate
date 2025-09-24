import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trip_mate/config/colors/colors.dart';

class SubscriptionButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isPrimary;
  final IconData? icon;

  const SubscriptionButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isPrimary = true,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 52.h,
      decoration: BoxDecoration(
        color: isPrimary ? AppColors.primaryColor : const Color(0xFFEFEFEF),
        borderRadius: BorderRadius.circular(8.r),
        border: isPrimary 
            ? null 
            : Border.all(
                color: const Color(0xFFBCBCBC),
                width: 1,
              ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(8.r),
          child: Center(
            child: isLoading
                ? SizedBox(
                    width: 20.w,
                    height: 20.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isPrimary ? Colors.white : AppColors.primaryColor,
                      ),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (icon != null) ...[
                        Container(
                          width: 24.w,
                          height: 24.w,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF74747),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Icon(
                            icon,
                            size: 16.sp,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 10.w),
                      ],
                      Text(
                        text,
                        style: GoogleFonts.inter(
                          color: isPrimary 
                              ? Colors.white 
                              : const Color(0xFFF74747),
                          fontSize: 16.sp,
                          fontWeight: isPrimary 
                              ? FontWeight.w700 
                              : FontWeight.w400,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
