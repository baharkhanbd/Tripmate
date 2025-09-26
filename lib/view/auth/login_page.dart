import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tripmate/controller/auth/login_proivder.dart';

import 'package:tripmate/core/constants/app_colors.dart';
import 'package:tripmate/core/widgets/custom_buttom.dart';
import 'package:tripmate/core/widgets/custom_input_field.dart';
import 'package:tripmate/core/widgets/custom_language.dart';
import 'package:tripmate/view/camera/camera_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // ✅ Controllers (UI layer)
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool obscurePassword = true;
  bool emailError = false;
  bool passwordError = false;

  String selectedLanguage = "English";

  @override
  void dispose() {
    // ✅ Dispose controllers
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void togglePasswordVisibility() {
    setState(() {
      obscurePassword = !obscurePassword;
    });
  }

  void validateFields() {
    setState(() {
      emailError = emailController.text.trim().isEmpty;
      passwordError = passwordController.text.trim().isEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ✅ Language Dropdown
              Align(
                alignment: Alignment.topRight,
                child: CustomDropdown(
                  items: ['English', 'বাংলা', 'हिन्दी'],
                  selectedValue: selectedLanguage,
                  hintText: 'Select Language',
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => selectedLanguage = value);
                      // Locale change logic (optional)
                    }
                  },
                  buttonWidth: 120.w,
                  buttonHeight: 28.h,
                  fontSize: 12,
                  textColor: Colors.brown,
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.brown),
                  buttonColor: Colors.transparent,
                ),
              ),

              SizedBox(height: 20.h),

              // ✅ Title
              Text(
                "Sign In",
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 22.sp,
                  color: AppColors.greyOpacity4D,
                ),
              ),
              SizedBox(height: 16.h),

              // ✅ Email Field
              CustomInputField(
                label: "Email",
                hintText: "example@mail.com",
                controller: emailController,
                isError: emailError,
                onChanged: (value) {
                  if (emailError && value.isNotEmpty) {
                    setState(() => emailError = false);
                  }
                },
              ),
              SizedBox(height: 12.h),

              // ✅ Password Field
              CustomInputField(
                label: "Password",
                hintText: "********",
                controller: passwordController,
                isPassword: true,
                obscureText: obscurePassword,
                isError: passwordError,
                onToggleVisibility: togglePasswordVisibility,
                onChanged: (value) {
                  if (passwordError && value.isNotEmpty) {
                    setState(() => passwordError = false);
                  }
                },
              ),
              SizedBox(height: 20.h),

              // ✅ Forgot Password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    "Forgot Password?",
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      color: AppColors.greyOpacity4D,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20.h),

              // ✅ Login Button
              CustomButton(
                text: "Log In",
                onPressed: () async {
                  // UI Validation
                  validateFields();
                  if (emailController.text.isEmpty ||
                      passwordController.text.isEmpty)
                    return;

                  try {
                    final response = await LoginProvider.login(
                      emailController.text.trim(),
                      passwordController.text.trim(),
                      context,
                    );

                    // Success - navigate or show next screen
                    print(
                      "Login Successful! User: ${response['user']['username']}",
                    );

                    // Clear fields
                    emailController.clear();
                    passwordController.clear();
                    if (!mounted) return;
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const CameraPage()),
                    );
                  } catch (e) {
                    // Show error snackbar
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Login Failed! ${e.toString()}")),
                    );
                  }
                },
                backgroundColor: AppColors.dark1F2937,
                textColor: Colors.white,
              ),

              SizedBox(height: 16.h),

              // ✅ Or Continue Divider
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey.shade400)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text("Or Continue"),
                  ),
                  Expanded(child: Divider(color: Colors.grey.shade400)),
                ],
              ),

              SizedBox(height: 16.h),

              // ✅ Google Button
              CustomButton(
                text: "Google",
                onPressed: () {
                  validateFields(); // UI-only validation function
                  // এখানে চাইলে আরো logic যোগ করতে পারেন
                },
                backgroundColor: AppColors.dark1F2937,
                textColor: Colors.white,
              ),
              SizedBox(height: 20.h),

              // ✅ Sign Up Link
              Center(
                child: Text.rich(
                  TextSpan(
                    text: "Don't have an account? ",
                    style: GoogleFonts.inter(fontSize: 14.sp),
                    children: [
                      TextSpan(
                        text: "Sign Up",
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          color: AppColors.darkOpacityCC,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
