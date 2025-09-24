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
import 'package:trip_mate/core/common_custom_widget/custom_language_dropdown.dart';
import 'package:trip_mate/features/auths/controllers/ui_controller.dart';
import 'package:trip_mate/features/auths/controllers/auth_controller.dart';
import 'package:trip_mate/features/auths/services/auth_service.dart';
import 'package:trip_mate/features/auths/services/google_auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _emailError = false;
  bool _passwordError = false;

  @override
  void initState() {
    super.initState();
    // Clear any existing error states when the page is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _emailError = false;
          _passwordError = false;
        });
      }
    });
  }

  void _validateFields() {
    setState(() {
      _emailError = false;
      _passwordError = false;
    });
  }

  bool _validateForm() {
    bool isValid = true;
    
    setState(() {
      _emailError = false;
      _passwordError = false;
    });

    // Check if email is empty
    if (context.read<UIController>().emailController.text.trim().isEmpty) {
      setState(() {
        _emailError = true;
      });
      isValid = false;
    }

    // Check if password is empty
    if (context.read<UIController>().passwordController.text.trim().isEmpty) {
      setState(() {
        _passwordError = true;
      });
      isValid = false;
    }

    return isValid;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<UIController, AuthController, AuthService>(
      builder: (context, uiController, authController, authService, child) {
        return Scaffold(
          backgroundColor: AppColors.backgroundColor2,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            toolbarHeight: 40.h,
            automaticallyImplyLeading: false,
            elevation: 0,
            // Language Dropdown
            title: Align(
              alignment: Alignment.topRight,
              child: CustomDropdown(
                items: ['English', '简体中文', '繁體中文'],
                selectedValue: uiController.selectedValue,
                hintText: 'Select Language',
                // onChanged: (value) {
                //   uiController.setSelectedValue(value);
                // },
                onChanged: (value) {
                  if (value != null) {
                    uiController.setLanguage(value);
                  if (value == 'English') {
                    context.setLocale(const Locale('en', 'US'));
                  } else if (value == '简体中文') {
                    context.setLocale(const Locale('zh', 'CN'));
                  } else if (value == '繁體中文') {
                    context.setLocale(const Locale('zh', 'TW'));
                  }
                  }
                },
                buttonWidth: 120.w,
                buttonHeight: 24.h,
                itemHeight: 40,
                fontSize: 12,
                textColor: Colors.brown,
                icon: const Icon(Icons.arrow_drop_down, color: Colors.brown),
                buttonColor: Colors.transparent,
              ),
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
                      context.tr('sign_in'),
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontSize: 22.sp,
                        letterSpacing: 0,
                        color: AppColors.textColor1,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    CustomInputField(
                      label: context.tr("enter_email"),
                      hintText: "example@mail.com",
                      controller: uiController.emailController,
                      isError: _emailError,
                      onChanged: (value) {
                        if (authController.errorMessage != null) {
                          authController.setErrorMessage(null);
                        }
                        if (_emailError) {
                          setState(() {
                            _emailError = false;
                          });
                        }
                      },
                    ),
                    SizedBox(height: 10.h),
                    CustomInputField(
                      label: context.tr("enter_pass"),
                      hintText: "********",
                      controller: uiController.passwordController,
                      isPassword: true,
                      obscureText: uiController.obscurePassword,
                      isError: _passwordError,
                      onToggleVisibility: () {
                        uiController.togglePasswordVisibility();
                      },
                      onChanged: (value) {
                        if (authController.errorMessage != null) {
                          authController.setErrorMessage(null);
                        }
                        if (_passwordError) {
                          setState(() {
                            _passwordError = false;
                          });
                        }
                      },
                    ),
                    if (authController.errorMessage != null) ...[
                      SizedBox(height: 10.h),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: Colors.red.shade600,
                              size: 16.sp,
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Text(
                                authController.errorMessage!,
                                style: GoogleFonts.inter(
                                  fontSize: 14.sp,
                                  color: Colors.red.shade600,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    SizedBox(height: 20.h),
                    Padding(
                      padding: const EdgeInsets.only(left: 208),
                      child: Text.rich(
                        TextSpan(
                          text: context.tr('forgot_password'),
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w400,
                            fontSize: 16.sp,
                            // letterSpacing: 2,
                            color: AppColors.primaryColors,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              context.push('/forgot_password');
                            },
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    CustomButton(
                      text: context.tr("log_in"),
                      onPressed: () async {
                        // Validate form fields first
                        if (!_validateForm()) {
                          return;
                        }
                        
                        final success = await authService.login(
                          uiController.emailController.text,
                          uiController.passwordController.text,
                        );
                        if (success) {
                          // Clear the form fields after successful login
                          uiController.emailController.clear();
                          uiController.passwordController.clear();
                          
                          // Check if there's a pending image path
                          if (authService.pendingImagePath != null) {
                            // Navigate to image view screen with the pending image
                            final imagePath = authService.pendingImagePath!;
                            await authService.clearPendingImagePath(); // Clear the pending path
                            context.go('/image_view?imagePath=${Uri.encodeComponent(imagePath)}');
                          } else {
                            // Navigate to camera screen if no pending image
                            context.go('/camera');
                          }
                        } else {
                          // Show error message
                          authController.setErrorMessage('Invalid email or password');
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
                          text: context.tr("dont_have_account"),
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
                                  context.push('/sign_up');
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
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
                      onPressed: () async{
                        try {
                          final userCredential = await GoogleSignInService.signInWithGoogle();
                            if (userCredential != null) {
                              print("Signed in as: ${userCredential.user?.displayName}",);
                                if (context.mounted) {
                                  //context.push('/sign_up',); 
                                  if (authService.pendingImagePath != null) {
                                  // Navigate to image view screen with the pending image
                                  final imagePath = authService.pendingImagePath!;
                                  await authService.clearPendingImagePath(); // Clear the pending path
                                  context.go('/image_view?imagePath=${Uri.encodeComponent(imagePath)}');
                                } else {
                                  // Navigate to camera screen if no pending image
                                  context.go('/camera');
                                }
                              }
                            }
                          } catch (e) {
                          print("Google Sign-In failed: $e");
                        }
                      },
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