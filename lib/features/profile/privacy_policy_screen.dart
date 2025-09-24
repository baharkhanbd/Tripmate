import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:trip_mate/config/colors/colors.dart';
import 'package:trip_mate/features/profile/controllers/privacy_policy_controller.dart';
import 'package:trip_mate/features/profile/widgets/policy_section_widget.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PrivacyPolicyController>(
      builder: (context, controller, child) {
        return Scaffold(
          backgroundColor: AppColors.backgroundColor2,
          body: _buildBody(context, controller),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, PrivacyPolicyController controller) {
    if (controller.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (controller.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48.sp,
              color: AppColors.disabled1,
            ),
            SizedBox(height: 16.h),
            Text(
              controller.errorMessage!,
              style: GoogleFonts.inter(
                color: AppColors.disabled1,
                fontSize: 16.sp,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: controller.refreshPrivacyPolicy,
              child: Text('Retry'),
            ),
          ],
        ),
      );
    }

    final privacyPolicy = controller.privacyPolicy;
    if (privacyPolicy == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return SafeArea(
      child: Column(
        children: [
          // App Bar
          _buildAppBar(context),
          
          // Content
          Expanded(
            child: _buildContent(privacyPolicy),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
      child: Row(
        children: [
          // Back Button
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 26.w,
              height: 26.w,
              decoration: BoxDecoration(
                // color: AppColors.disabled1,
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Icon(
                Icons.arrow_back,
                size: 18.sp,
                color: AppColors.iconColor,
              ),
            ),
          ),
          
          SizedBox(width: 16.w),
          
          // Title
          Expanded(
            child: Text(
              'Privacy & Policy',
              style: GoogleFonts.inter(
                color: AppColors.textColor1,
                fontSize: 22.sp,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          
          SizedBox(width: 42.w), // Balance the back button
        ],
      ),
    );
  }

  Widget _buildContent(privacyPolicy) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20.h),
          
          // Introduction
          Text(
            privacyPolicy.introduction,
            style: GoogleFonts.inter(
              color: AppColors.textColor1,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              height: 1.57,
            ),
          ),
          
          SizedBox(height: 24.h),
          
          // Policy Sections
          ...privacyPolicy.sections.map((section) => Column(
            children: [
              PolicySectionWidget(section: section),
              SizedBox(height: 24.h),
            ],
          )),
          
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
