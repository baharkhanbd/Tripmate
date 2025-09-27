import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tripmate/core/constants/app_colors.dart';
 

class CustomInputField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final bool isPassword;
  final bool obscureText; 
  final VoidCallback? onToggleVisibility;
  final ValueChanged<String>? onChanged;
  final bool isError;

  const CustomInputField({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.isPassword = false,
    this.obscureText = false,
    this.onToggleVisibility,
    this.onChanged,
    this.isError = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w400,
            fontSize: 18.sp,
            letterSpacing: 0,
            color:  Colors.red.shade600  ,
          ),
        ),
        SizedBox(height: 8.h),
        SizedBox(
          height: 41.h,   
          width: 351.w, 
          child: TextFormField(
            controller: controller,
            obscureText: isPassword ? obscureText : false,
            onChanged: onChanged,
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              hintText: hintText,
              labelStyle: GoogleFonts.inter(
                fontWeight: FontWeight.w400,
                fontSize: 16.sp,
                letterSpacing: 0,
                color: AppColors.highlight,
              ),
              contentPadding: const EdgeInsets.all(10.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4.0),
                borderSide: BorderSide(
                  color: isError ? Colors.red.shade400 : Colors.transparent,
                  width: isError ? 1.5 : 0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4.0),
                borderSide: BorderSide(
                  color: isError ? Colors.red.shade400 : Colors.transparent,
                  width: isError ? 1.5 : 0,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4.0),
                borderSide: BorderSide(
                  color: isError ? Colors.red.shade400 : Colors.transparent,
                  width: isError ? 1.5 : 0,
                ),
              ),
              suffixIcon: isPassword
                  ? IconButton(
                      onPressed: onToggleVisibility,
                      icon: Icon(
                        obscureText
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}
