import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:trip_mate/config/colors/colors.dart';
import 'package:trip_mate/features/profile/controllers/profile_controller.dart';
import 'package:trip_mate/features/profile/widgets/profile_menu_item.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileController>(
      builder: (context, profileController, child) {
        return Scaffold(
          backgroundColor: AppColors.backgroundColor2,
          body: _buildBody(context, profileController),
        );
      },
    );
  }

  // Widget _buildBody(BuildContext context, ProfileController controller) {
  //   if (controller.isLoading) {
  //     return const Center(
  //       child: CircularProgressIndicator(),
  //     );
  //   }

  //   if (controller.errorMessage != null) {
  //     return Center(
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           Icon(
  //             Icons.error_outline,
  //             size: 48.sp,
  //             color: AppColors.disabled1,
  //           ),
  //           SizedBox(height: 16.h),
  //           Text(
  //             controller.errorMessage!,
  //             style: GoogleFonts.inter(
  //               color: AppColors.disabled1,
  //               fontSize: 16.sp,
  //             ),
  //             textAlign: TextAlign.center,
  //           ),
  //           SizedBox(height: 16.h),
  //           ElevatedButton(
  //             onPressed: controller.refreshProfile,
  //             child: Text('Retry'),
  //           ),
  //         ],
  //       ),
  //     );
  //   }

  //   final profile = controller.profile;
  //   if (profile == null) {
  //     return const Center(
  //       child: CircularProgressIndicator(),
  //     );
  //   }

  //   return SafeArea(
  //     child: SingleChildScrollView(
  //       child: Padding(
  //         padding: EdgeInsets.symmetric(horizontal: 12.w),
  //         child: Column(
  //           children: [
  //             // App Bar
  //             _buildAppBar(context),
              
  //             SizedBox(height: 40.h),
              
  //             // Profile Image Section
  //             _buildProfileImageSection(profile),
              
  //             SizedBox(height: 8.h),
              
  //             // Boosted Badge
  //             if (profile.isBoosted) _buildBoostedBadge(),
              
  //             SizedBox(height: 10.h),
              
  //             // User Info
  //             _buildUserInfo(profile),
              
  //             SizedBox(height: 10.h),
              
  //             // Separator
  //             _buildSeparator(),
              
  //             SizedBox(height: 10.h),
              
  //             // Time Remaining Section
  //             _buildTimeRemainingSection(profile),
              
  //             SizedBox(height: 20.h),
              
  //             // Separator
  //             _buildSeparator(),
              
  //             SizedBox(height: 20.h),
              
  //             // Settings Menu
  //             _buildSettingsMenu(context, controller),
              
  //             SizedBox(height: 20.h),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildBody(BuildContext context, ProfileController controller) {
  if (controller.isLoading) {
    return const Center(child: CircularProgressIndicator());
  }

  final profile = controller.profile;
  if (profile == null) {
    // This should never happen, but fallback
    return const Center(child: Text("No profile available"));
  }

  return SafeArea(
    child: SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Column(
          children: [
            _buildAppBar(context),
            SizedBox(height: 40.h),
            _buildProfileImageSection(profile),
            SizedBox(height: 8.h),
            if (profile.isBoosted) _buildBoostedBadge(),
            SizedBox(height: 10.h),
            _buildUserInfo(profile),
            SizedBox(height: 10.h),
            _buildSeparator(),
            SizedBox(height: 10.h),
            _buildTimeRemainingSection(context,profile),
            SizedBox(height: 20.h),
            _buildSeparator(),
            SizedBox(height: 20.h),
            _buildSettingsMenu(context, controller),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    ),
  );
}


  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h),
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
              context.tr('profile_text'),
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

  Widget _buildProfileImageSection(profile) {
    return Center(
      child: Container(
        width: 94.w,
        height: 94.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.primaryColor,
            width: 3.w,
          ),
        ),
        child: ClipOval(
          child: Image.network(
            profile.profileImageUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: AppColors.disabled1,
                child: Icon(
                  Icons.person,
                  size: 40.sp,
                  color: AppColors.iconColor,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBoostedBadge() {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: AppColors.highlight,
          borderRadius: BorderRadius.circular(100.r),
        ),
        child: Text(
          'Boosted',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 8.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfo(profile) {
    return Column(
      children: [
        Text(
          profile.name,
          style: GoogleFonts.inter(
            color: AppColors.textColor1,
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          profile.email,
          style: GoogleFonts.inter(
            color: AppColors.textColor1.withOpacity(0.8),
            fontSize: 10.sp,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }

  Widget _buildSeparator() {
    return Container(
      width: double.infinity,
      height: 1,
      color: AppColors.disabled2,
    );
  }

  Widget _buildTimeRemainingSection(BuildContext context,profile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.tr('time_remaining'),
          style: GoogleFonts.inter(
            color: AppColors.textColor1,
            fontSize: 22.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 16.h),
        Container(
          width: double.infinity,
          height: 98.h,
          decoration: BoxDecoration(
            color: const Color(0xFF4D4D4D),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildTimeItem('Day', profile.remainingDays.toString()),
              _buildTimeItem('Hour', profile.remainingHours.toString()),
              _buildTimeItem('Minute', profile.remainingMinutes.toString()),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimeItem(String label, String value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          value,
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 22.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsMenu(BuildContext context, ProfileController controller) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.backgroundColor2,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: AppColors.disabled2,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          ProfileMenuItem(
            icon: Icons.border_color,
            title: context.tr('edit_profile'),
            onTap: () {
              // Navigate to edit profile screen
              context.push('/edit_profile');
            },
          ),
          ProfileMenuItem(
            icon: Icons.card_membership,
            title: context.tr('subscription'),
            onTap: () {
              // Navigate to subscription screen
              context.push('/subscription');
            },
          ),
          ProfileMenuItem(
            icon: Icons.security,
            title: context.tr('privacy_policy'),
            onTap: () {
              // Navigate to privacy policy screen
              context.push('/privacy_policy');
            },
          ),
          ProfileMenuItem(
            icon: Icons.logout,
            title: context.tr('logout'),
            showDivider: false,
            onTap: () {
              _showLogoutDialog(context, controller);
            },
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, ProfileController controller) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              title: Row(
                children: [
                  Icon(
                    Icons.logout,
                    color: Colors.red.shade600,
                    size: 24.sp,
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    'Logout',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      fontSize: 18.sp,
                    ),
                  ),
                ],
              ),
              content: Text(
                'Are you sure you want to logout from your account?',
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  color: Colors.grey.shade700,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: controller.isLoading ? null : () => Navigator.of(context).pop(),
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                TextButton(
                   onPressed: controller.isLoading ? null : () async {
                     setState(() {
                       // Show loading state in dialog
                     });
                     await controller.logout(context);
                     Navigator.of(context).pop();
                     // Navigate to login screen using go_router
                     context.go('/login_page');
                   },
                  child: controller.isLoading
                      ? SizedBox(
                          width: 16.w,
                          height: 16.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.red.shade600),
                          ),
                        )
                      : Text(
                          'Logout',
                          style: GoogleFonts.inter(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.red.shade600,
                          ),
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
