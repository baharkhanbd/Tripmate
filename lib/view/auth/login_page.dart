import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tripmate/controller/auth/login_proivder.dart';
import 'package:tripmate/core/constants/app_colors.dart';
import 'package:tripmate/core/constants/assets_manager.dart';
import 'package:tripmate/core/widgets/custom_buttom.dart';
import 'package:tripmate/core/widgets/custom_input_field.dart';
import 'package:tripmate/core/widgets/custom_language.dart' show CustomDropdown;
import 'package:tripmate/view/camera/camera_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  String? _errorMessage;
  bool _showError = false;
  String? _errorType; // 'email' or 'general'

  void _showValidationMessage(String message, {String? errorType}) {
    setState(() {
      _errorMessage = message;
      _errorType = errorType;
      _showError = true;
    });

    Future.delayed(const Duration(seconds:2), () {
      if (mounted) {
        setState(() {
          _showError = false;
        });
      }
    });
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white, size: 20.w),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                message,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.all(16.w),
      ),
    );
  }

  void _clearErrors() {
    if (_showError) {
      setState(() {
        _showError = false;
        _errorMessage = null;
        _errorType = null;
      });
    }
  }

  bool _validateEmail(String email) {
    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    return emailRegex.hasMatch(email);
  }

  String _parseApiError(dynamic error) {
    if (error is String) return error;
    if (error is Map<String, dynamic>) {
      if (error.containsKey('email')) {
        return error['email'] is List
            ? error['email'][0]
            : error['email'].toString();
      } else if (error.containsKey('non_field_errors')) {
        return error['non_field_errors'] is List
            ? error['non_field_errors'][0]
            : error['non_field_errors'].toString();
      } else if (error.containsKey('detail')) {
        return error['detail'].toString();
      } else {
        final firstError = error.values.first;
        return firstError is List ? firstError[0] : firstError.toString();
      }
    }
    return "Please provide valid email and password";
  }

  Widget _buildValidationMessage() {
    if (!_showError || _errorMessage == null) return SizedBox.shrink();

    Color primaryColor = _errorType == 'Auth Error'
        ? Colors.orange
        : Colors.red;

    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: EdgeInsets.only(bottom: 16.h),
      child: Material(
        elevation: 6,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: primaryColor.withOpacity(0.3), width: 1),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withOpacity(0.1),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _errorType == 'email'
                      ? Icons.email_outlined
                      : Icons.error_outline,
                  color: primaryColor,
                  size: 20.w,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _errorType == 'email'
                          ? "Email Error"
                          : "Authentication Error",
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp,
                        color: primaryColor,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      _errorMessage!,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w400,
                        fontSize: 12.sp,
                        color: primaryColor.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: _clearErrors,
                icon: Icon(Icons.close, size: 18.w, color: primaryColor),
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor2,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        toolbarHeight: 40.h,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Align(
          alignment: Alignment.topRight,
          child: CustomDropdown(
            items: ['English', '简体中文', '繁體中文'],
            selectedValue: 'English',
            hintText: 'Select Language',
            onChanged: (value) {},
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
                _buildValidationMessage(),
                Text(
                  "Sign In",
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 22.sp,
                    color: AppColors.textColor1,
                  ),
                ),
                SizedBox(height: 16.h),
                CustomInputField(
                  label: "Email",
                  hintText: "example@mail.com",
                  controller: _emailController,
                  onChanged: (value) {
                    _clearErrors();
                  },
                ),
                SizedBox(height: 12.h),
                CustomInputField(
                  label: "Password",
                  hintText: "********",
                  controller: _passwordController,
                  isPassword: true,
                  obscureText: _obscurePassword,
                  onToggleVisibility: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                  onChanged: (value) {
                    _clearErrors();
                  },
                ),
                SizedBox(height: 16.h),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Forgot Password?",
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w400,
                      fontSize: 14.sp,
                      color: AppColors.primaryColors,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                ValueListenableBuilder<bool>(
                  valueListenable: LoginProvider.isLoading,
                  builder: (context, isLoading, _) {
                    return CustomButton(
                      text: isLoading ? "Logging in..." : "Log In",
                      onPressed: isLoading
                          ? null
                          : () async {
                              String email = _emailController.text.trim();
                              String password = _passwordController.text.trim();
                              _clearErrors();

                              // Email validation
                              if (email.isEmpty) {
                                _showValidationMessage(
                                  "Please enter your email address",
                                  errorType: 'email',
                                );
                                return;
                              }
                              if (!_validateEmail(email)) {
                                _showValidationMessage(
                                  "Please enter a valid email address",
                                  errorType: 'email',
                                );
                                return;
                              }

                              // Password validation
                              if (password.isEmpty) {
                                _showValidationMessage(
                                  "Please enter your password",
                                );
                                return;
                              }
                              if (password.length < 6) {
                                _showValidationMessage(
                                  "Password must be at least 6 characters",
                                  errorType:
                                      'general', // or 'password' if you want separate type
                                );
                                return;
                              }

                              // API login
                              try {
                                final response = await LoginProvider.login(
                                  email,
                                  password,
                                  context,
                                );

                                _showSuccessMessage(
                                  "Login Successful! Welcome ${response['user']['username'] ?? ''}",
                                );
                                // 3 সেকেন্ড delay দিয়ে navigation
                                Future.delayed(const Duration(seconds: 3), () {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const CameraPage(),
                                    ),
                                    (route) =>
                                        false, // সব previous routes remove হবে
                                  );
                                });
                              } catch (e) {
                                String errorMessage =
                                    "Please provide valid email and password";
                                String? errorType = 'general';

                                if (e is Map<String, dynamic>) {
                                  errorMessage = _parseApiError(e);
                                  if (e.containsKey('email')) {
                                    errorType = 'email';
                                  }
                                }

                                _showValidationMessage(
                                  errorMessage,
                                  errorType: errorType,
                                );
                              }
                            },

                      backgroundColor: AppColors.primaryColors,
                      textColor: Colors.white,
                    );
                  },
                ),
                SizedBox(height: 20.h),
                Center(
                  child: Text.rich(
                    TextSpan(
                      text: "Don't have an account? ",
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w400,
                        fontSize: 14.sp,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: "Sign Up",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 14.sp,
                            color: AppColors.primaryColors,
                          ),
                          recognizer: TapGestureRecognizer()..onTap = () {},
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Row(
                  children: [
                    Expanded(child: Divider(color: AppColors.disabled3)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        "or continue",
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: AppColors.disabled3)),
                  ],
                ),
                SizedBox(height: 20.h),
                CustomButton(
                  text: "Google",
                  onPressed: () {},
                  backgroundColor: AppColors.backgroundColor2,
                  textColor: Colors.black,
                  borderColor: Colors.black,
                  iconPath: IconAssets.google,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
