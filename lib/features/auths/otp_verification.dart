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

class OTPVerificationPage extends StatelessWidget {
  const OTPVerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<UIController, AuthController>(
      builder: (context, uiController, authController, child) {
        return Scaffold(
          backgroundColor: AppColors.backgroundColor2,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            toolbarHeight: 40.h,
            automaticallyImplyLeading: false,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: AppColors.textColor1,
                size: 24.sp,
              ),
              onPressed: () {
                context.pop();
              },
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0.h, horizontal: 13.0.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr('otp_auth'),
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontSize: 22.sp,
                        letterSpacing: 0,
                        color: AppColors.textColor1,
                      ),
                    ),
                    SizedBox(height: 40.h),
                    
                    // OTP Illustration
                    Center(
                      child: SizedBox(
                        width: 140.w,
                        height: 93.w,
                        child: Stack(
                          children: [
                            // Main phone icon
                            Positioned(
                              left: 0,
                              top: 0,
                              child: Container(
                                width: 93.w,
                                height: 93.w,
                                decoration: BoxDecoration(
                                  color: AppColors.disabled2,
                                  borderRadius: BorderRadius.circular(46.5.r),
                                ),
                                child: Image.asset(
                                  AppAssets.otpImage,
                                  width: 60.w,
                                  height: 60.w,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            // Yellow message bubble
                            Positioned(
                              right: 0,
                              top: -10.h,
                              child: Container(
                                width: 46.w,
                                height: 46.w,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColors,
                                  borderRadius: BorderRadius.circular(23.r),
                                ),
                                child: Icon(
                                  Icons.more_horiz,
                                  size: 24.sp,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 40.h),
                    
                    // Instructions
                    Center(
                      child: Text(
                        context.tr('four_digit'),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          color: AppColors.disabled3,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          height: 1.38,
                        ),
                      ),
                    ),
                    SizedBox(height: 40.h),
                    
                    // OTP Input Fields
                     Center(
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: List.generate(4, (index) {
                           return Container(
                             margin: EdgeInsets.symmetric(horizontal: 10.w),
                             width: 53.w,
                             height: 70.h,
                             decoration: ShapeDecoration(
                               color: Colors.white,
                               shape: RoundedRectangleBorder(
                                 borderRadius: BorderRadius.circular(8.r),
                               ),
                             ),
                             child: TextField(
                               controller: uiController.otpControllers[index],
                               textAlign: TextAlign.center,
                               keyboardType: TextInputType.number,
                               maxLength: 1,
                               style: GoogleFonts.inter(
                                 fontSize: 24.sp,
                                 fontWeight: FontWeight.w600,
                                 color: AppColors.textColor1,
                               ),
                               decoration: InputDecoration(
                                 counterText: "",
                                 border: InputBorder.none,
                                 focusedBorder: OutlineInputBorder(
                                   borderRadius: BorderRadius.circular(8.r),
                                   borderSide: BorderSide(
                                     color: AppColors.primaryColors,
                                     width: 2.w,
                                   ),
                                 ),
                                 enabledBorder: OutlineInputBorder(
                                   borderRadius: BorderRadius.circular(8.r),
                                   borderSide: BorderSide.none,
                                 ),
                               ),
                               onChanged: (value) {
                                 if (value.isNotEmpty && index < 3) {
                                   FocusScope.of(context).nextFocus();
                                 }
                               },
                             ),
                           );
                         }),
                       ),
                     ),
                    SizedBox(height: 30.h),
                    
                    // Resend Code
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          authController.resendOTP();
                        },
                        child: Text(
                          context.tr('resend_otp (${authController.resendTimer})'),
                          style: GoogleFonts.inter(
                            color: AppColors.disabled3,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            height: 1.38,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 40.h),
                    // Error Message
                     if (authController.errorMessage != null)
                       Center(
                         child: Padding(
                           padding: EdgeInsets.symmetric(vertical: 10.h),
                           child: Text(
                             authController.errorMessage!,
                             style: GoogleFonts.inter(
                               color: Colors.red,
                               fontSize: 14.sp,
                               fontWeight: FontWeight.w500,
                             ),
                             textAlign: TextAlign.center,
                           ),
                         ),
                       ),
                      // Continue Button
                      CustomButton(
                        text: authController.isLoading ? "Verifying..." : "Continue",
                        onPressed: authController.isLoading
                          ? null
                          : () async {
                            final otp = uiController.otpControllers.map((controller) => controller.text).join();
                            final otp_token = authController.otpToken;
                              final success = await authController.verifyOTP(otp, "14");
                                if (success) {
                                  // Navigate to reset password screen
                                context.push('/reset_password');
                                debugPrint(otp_token);
                            }
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
