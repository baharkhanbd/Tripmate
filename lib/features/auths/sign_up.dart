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

class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer3<UIController, AuthController, AuthService>(
      builder: (context, uiController, authController, authService, child) {
        return Scaffold(
          backgroundColor: AppColors.backgroundColor2,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsetsGeometry.symmetric(vertical: 65.0.h, horizontal: 13.0.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr('Signup/Sign in with Email\naddress'),
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontSize: 22.sp,
                        letterSpacing: 0,
                        color: AppColors.textColor1,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    CustomInputField(
                      label: context.tr("enter_user_name"),
                      hintText: "Arif Hossain",
                      controller: uiController.nameController,
                    ),
                    SizedBox(height: 10.h),
                    CustomInputField(
                      label: context.tr("enter_user_email"),
                      hintText: "example@mail.com",
                      controller: uiController.emailController,
                    ),
                    SizedBox(height: 10.h),
                    CustomInputField(
                      label: context.tr("create_pass"),
                      hintText: "********",
                      controller: uiController.passwordController,
                      isPassword: true,
                      obscureText: uiController.obscurePassword,
                      onToggleVisibility: () {
                        uiController.togglePasswordVisibility();
                      },
                    ),
                    SizedBox(height: 10.h),
                    CustomInputField(
                      label: context.tr("confirm_pass"),
                      hintText: "********",
                      controller: uiController.confirmPasswordController,
                      isPassword: true,
                      obscureText: uiController.obscureConfirmPassword,
                      onToggleVisibility: () {
                        uiController.toggleConfirmPasswordVisibility();
                      },
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      children: [
                        Transform.scale(
                          scale: 20 / 24,
                          child: Checkbox(
                            value: uiController.isChecked,
                            activeColor: uiController.isChecked
                                ? AppColors.primaryColors
                                : Colors.white,
                            checkColor: Colors.white,
                            onChanged: (val) {
                              uiController.setChecked(val ?? false);
                            },
                          ),
                        ),
                        Expanded(
                          child: RichText(
                            textAlign: TextAlign.left,
                            text: TextSpan(
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w400,
                                fontSize: 12.sp,
                                height: 1.5,
                                letterSpacing: 0,
                                color: Colors.white,
                              ),
                              children: [
                                TextSpan(
                                  text: context.tr('condition'),
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12.sp,
                                    letterSpacing: 0,
                                    color: AppColors.labelTextColor,
                                  ),
                                ),
                                TextSpan(
                                  text: context.tr('condition_h2'),
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12.sp,
                                    letterSpacing: 0,
                                    color: AppColors.primaryColors,
                                  ),
                                ),
                                TextSpan(
                                  text: context.tr(' condition_h3'),
                                  style: TextStyle(color: AppColors.labelTextColor),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    CustomButton(
                      text: context.tr("sign_up"),
                      onPressed: () async {
                        final success = await authService.signUp(
                          uiController.nameController.text,
                          uiController.emailController.text,
                          uiController.passwordController.text,
                        );
                        if (success) {
                          WidgetsBinding.instance.addPostFrameCallback((
                            _,
                          ) async {
                            if (authService.pendingImagePath != null) {
                              final imagePath = authService.pendingImagePath!;
                              await authService.clearPendingImagePath(); // Clear the pending path
                              context.go(
                                '/image_view?imagePath=${Uri.encodeComponent(imagePath)}',
                              );
                            } else {
                              context.go('/camera');
                            }
                          });
                        } else {
                          authController.setErrorMessage(
                            'Sign up failed. Please try again.',
                          );
                        }
                      },
                      backgroundColor: AppColors.primaryColors,
                      textColor: Colors.white,
                      isLoading: authService.isLoading,
                    ),
                    SizedBox(height: 10.h),
                    Center(
                      child: Text.rich(
                        TextSpan(
                          text: context.tr("have_acc"),
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w400,
                            fontSize: 16.sp,
                            letterSpacing: 1,
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(
                              text: context.tr('sign_in'),
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w400,
                                fontSize: 16.sp,
                                letterSpacing: 1,
                                color: AppColors.primaryColors,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  context.push('/login_page');
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        Expanded(child: Divider(thickness: 0.5, color: AppColors.disabled3)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text("or continue with"),
                        ),
                        Expanded(child: Divider(thickness: 0.5, color: AppColors.disabled3)),
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