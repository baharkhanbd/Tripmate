import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';

class FontManager {
  // Font Families
  static const String poppins = "Poppins";
  static const String inter = "Inter";

  // Font Weights
  static const FontWeight w400 = FontWeight.w400;
  static const FontWeight w700 = FontWeight.w700;

  // Default Text Colors
  static const Color mainTextColor = AppColors.dark1F2937;
  static const Color subtitleColor = AppColors.dark1F2937;
  static const Color subSubtitleColor = AppColors.teal9FC2CC;

  // ================== Text Styles ==================

  // Title Text
  static TextStyle titleText() => TextStyle(
        fontFamily: inter,
        fontSize: 22.sp,
        fontWeight: w700,
        color: mainTextColor,
        height: 1.0,
        letterSpacing: 0.0,
      );

  // Subtitle Text
  static TextStyle subtitleText() => TextStyle(
        fontFamily: inter,
        fontSize: 16.sp,
        fontWeight: w400,
        color: subtitleColor,
        height: 1.0,
        letterSpacing: 0.0,
      );

  // Sub-subtitle Text
  static TextStyle subSubtitleText() => TextStyle(
        fontFamily: inter,
        fontSize: 18.sp,
        fontWeight: w700,
        color: subSubtitleColor,
        height: 1.0,
        letterSpacing: 0.0,
      );

  // Header Subtitle
  static TextStyle headerSubtitleText() => TextStyle(
        fontFamily: inter,
        fontSize: 14.sp,
        fontWeight: w400,
        color: subtitleColor,
        height: 1.0,
        letterSpacing: 0.0,
      );

  // Body / Caption Text (default)
  static TextStyle bodyText() => TextStyle(
        fontFamily: inter,
        fontSize: 14.sp,
        fontWeight: w400,
        color: mainTextColor,
        height: 1.0,
        letterSpacing: 0.0,
      );

  // Button Text
  static TextStyle buttonText() => TextStyle(
        fontFamily: inter,
        fontSize: 16.sp,
        fontWeight: w700,
        color: mainTextColor,
        height: 1.0,
        letterSpacing: 0.0,
      );

  // AppBar Text
  static TextStyle appBarText() => TextStyle(
        fontFamily: inter,
        fontSize: 16.sp,
        fontWeight: w700,
        color: mainTextColor,
        height: 1.0,
        letterSpacing: 0.0,
      );
      // Button Text (Regular, White)
static TextStyle buttonTextRegular() => TextStyle(
      fontFamily: inter,
      fontSize: 16.sp,
      fontWeight: FontWeight.w400,
      color: AppColors.white,
      height: 1.0,
      letterSpacing: 0.0,
    );// White Button Text (Regular, 16px)
static TextStyle whiteButtonText() => TextStyle(
      fontFamily: inter,
      fontSize: 16.sp,
      fontWeight: FontWeight.w400,
      color: AppColors.white,       // text color
      height: 1.0,
      letterSpacing: 0.0,
    );


}
