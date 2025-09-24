import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:trip_mate/config/theme.dart';
import 'package:trip_mate/core/common_custom_widget/custom_button.dart';
import 'package:trip_mate/features/auths/controllers/ui_controller.dart';
import 'package:trip_mate/features/auths/controllers/auth_controller.dart';

class ResetPasswordSuccessPage extends StatelessWidget {
  const ResetPasswordSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<UIController, AuthController>(
      builder: (context, uiController, authController, child) {
        return Scaffold(
          backgroundColor: AppColors.backgroundColor2,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0.h, horizontal: 13.0.w),
                child: Column(
                  children: [
                    SizedBox(height: 100.h),
                    
                    // Success Icon
                    Center(
                      child: SizedBox(
                        width: 82.w,
                        height: 82.w,
                        child: Stack(
                          children: [
                            // Outer circle
                            Container(
                              width: 82.w,
                              height: 82.w,
                              decoration: ShapeDecoration(
                                color: AppColors.primaryColors,
                                shape: const OvalBorder(),
                              ),
                            ),
                            // Inner icon container
                            Positioned(
                              left: 11.w,
                              top: 11.w,
                              child: Container(
                                width: 60.w,
                                height: 60.w,
                                decoration: BoxDecoration(
                                  color: AppColors.disabled2,
                                  borderRadius: BorderRadius.circular(30.r),
                                ),
                                child: Icon(
                                  Icons.check,
                                  size: 40.sp,
                                  color: AppColors.primaryColors,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 40.h),
                    
                    // Success Title
                    Center(
                      child: Text(
                        context.tr('password_reset'),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          color: AppColors.textColor1,
                          fontSize: 30.sp,
                          fontWeight: FontWeight.w600,
                          height: 1.43,
                          letterSpacing: 3,
                        ),
                      ),
                    ),
                    SizedBox(height: 40.h),
                    
                    // Success Message
                    Center(
                      child: Text(
                        context.tr('successful_login'),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          color: AppColors.labelTextColor,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          height: 1.25,
                          letterSpacing: 0.48,
                        ),
                      ),
                    ),
                    SizedBox(height: 60.h),
                    
                    // Go to Login Button
                    CustomButton(
                      text: context.tr("new_pass"),
                      onPressed: () {
                        // Navigate to login screen
                        context.go('/login_page');
                      },
                      backgroundColor: AppColors.primaryColors,
                      textColor: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
