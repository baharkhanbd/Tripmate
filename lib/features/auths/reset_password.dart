import 'package:easy_localization/easy_localization.dart';
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

class ResetPasswordPage extends StatelessWidget {
  const ResetPasswordPage({super.key});

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
                      context.tr('reset_pass_header'),
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontSize: 22.sp,
                        letterSpacing: 0,
                        color: AppColors.textColor1,
                      ),
                    ),
                    SizedBox(height: 40.h),
                    
                    // New Password Field
                    CustomInputField(
                      label: context.tr("enter_new_pass"),
                      hintText: "Enter your new password",
                      controller: uiController.newPasswordController,
                      isPassword: true,
                      obscureText: uiController.obscureNewPassword,
                      onToggleVisibility: () {
                        uiController.toggleNewPasswordVisibility();
                      },
                    ),
                    SizedBox(height: 20.h),
                    
                    // Confirm Password Field
                    CustomInputField(
                      label: context.tr("confirm_pass"),
                      hintText: "Confirm your new password",
                      controller: uiController.confirmNewPasswordController,
                      isPassword: true,
                      obscureText: uiController.obscureConfirmNewPassword,
                      onToggleVisibility: () {
                        uiController.toggleConfirmNewPasswordVisibility();
                      },
                    ),
                    SizedBox(height: 40.h),
                    
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
                    
                    // Continue Button
                    CustomButton(
                      text: authController.isLoading ? "Resetting..." : "Continue",
                      onPressed: authController.isLoading
                          ? null
                          : () async {
                              final success = await authController.resetPassword(
                                uiController.newPasswordController.text,
                                uiController.confirmNewPasswordController.text,
                                authController.otpToken??"14"
                              );
                              if (success) {
                                // Navigate to success screen after successful reset
                                context.push('/reset_password_success');
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
