import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:trip_mate/config/theme.dart';
import 'package:trip_mate/core/common_custom_widget/custom_button.dart';
import 'package:trip_mate/core/common_custom_widget/custom_input_field.dart';
import 'package:trip_mate/features/auths/controllers/ui_controller.dart';
import 'package:trip_mate/features/auths/controllers/auth_controller.dart';
import 'package:trip_mate/features/auths/services/auth_service.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer3<UIController, AuthController,AuthService>(
      builder: (context, uiController, authController,authService,child) {
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
                      context.tr('forgot_password'),
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontSize: 22.sp,
                        letterSpacing: 0,
                        color: AppColors.textColor1,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    CustomInputField(
                      label: context.tr("enter_valid"),
                      hintText: "example@mail.com",
                      controller: uiController.emailController,
                    ),
                    SizedBox(height: 30.h),
                    
                    // Error Message
                    if (authController.errorMessage != null)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        child: Text(
                          authController.errorMessage!,
                          style: GoogleFonts.inter(
                            color: Colors.red,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    
                    CustomButton(
                      text: authService.isLoading ? "Sending..." : "Continue",
                      onPressed: authService.isLoading
                          ? null
                          : () async {
                              final success = await authService.sendOtp(
                                uiController.emailController.text,
                              );
                              if (success) {
                                context.push('/otp_verification');
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("❌ Failed to send OTP."),
                                  ),
                                );
                              }
                            },
                      backgroundColor: AppColors.primaryColors,
                      textColor: Colors.white,
                    ),
                    SizedBox(height: 20.h),
                    Center(
                      child: Text.rich(
                        TextSpan(
                          text: context.tr("dont_have_account"),
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w400,
                            fontSize: 16.sp,
                            letterSpacing: 1,
                            color: AppColors.textColor1,
                          ),
                          children: [
                            TextSpan(
                              text: context.tr('sign_up'),
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w400,
                                fontSize: 16.sp,
                                letterSpacing: 1,
                                color: AppColors.primaryColors,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  context.push('/sign_up');
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: AppColors.disabled3,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(context.tr("or_continue")),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: AppColors.disabled3,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    CustomButton(
                      text: "Google",
                      onPressed: () {},
                      backgroundColor: AppColors.backgroundColor2,
                      textColor: Colors.black,
                      iconPath: AppAssets.googleIcon,
                      borderColor: Colors.black,
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
