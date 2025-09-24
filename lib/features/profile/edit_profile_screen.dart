import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:trip_mate/config/colors/colors.dart';
import 'package:trip_mate/features/profile/controllers/edit_profile_controller.dart';
import 'package:trip_mate/features/profile/widgets/custom_text_field.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<EditProfileController>(
      builder: (context, controller, child) {
        return Scaffold(
          backgroundColor: AppColors.backgroundColor2,
          body: _buildBody(context, controller),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, EditProfileController controller) {
    if (controller.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Form(
            key: controller.formKey,
            child: Column(
              children: [
                // App Bar
                _buildAppBar(context),
                SizedBox(height: 32.h),
                
                // Profile Image Section
                _buildProfileImageSection(context, controller),
                SizedBox(height: 40.h),
                
                // Form Fields
                _buildFormFields(context,controller),
                
                SizedBox(height: 40.h),
                
                // Save Button
                _buildSaveButton(context, controller),
                
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        children: [
          // Back Button
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                // color: Colors.white,
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                // Icons.arrow_back_ios_new,
                Icons.arrow_back,
                size: 20.sp,
                color: AppColors.iconColor,
              ),
            ),
          ),
          SizedBox(width: 20.w),
          // Title
          Expanded(
            child: Text(
              context.tr('edit_profiledata'),
              style: GoogleFonts.inter(
                color: AppColors.textColor1,
                fontSize: 24.sp,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          
          SizedBox(width: 60.w), // Balance the back button
        ],
      ),
    );
  }

  Widget _buildProfileImageSection(BuildContext context, EditProfileController controller) {
  return Column(
    children: [
      Center(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 120.w,
              height: 120.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primaryColor, width: 4.w),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryColor.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipOval(
                child: controller.selectedImage != null
                    ? Image.file(
                        controller.selectedImage!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _buildDefaultProfileImage();
                        },
                      )
                    : (controller.currentImageUrl.isNotEmpty
                        ? Image.network(
                            controller.currentImageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return _buildDefaultProfileImage();
                            },
                          )
                        : _buildDefaultProfileImage()),
              ),
            ),

            Positioned(
              bottom: 45,
              right: 45,
              child: GestureDetector(
                onTap: () => controller.showImagePickerOptions(context),
                child: Container(
                  width: 36.w,
                  height: 36.w,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryColor.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.camera_alt_outlined,
                    size: 20.sp,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      SizedBox(height: 16.h),

      Text(
        context.tr('tap_to_change'),
        style: GoogleFonts.inter(
          color: Colors.grey.shade600,
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
        ),
        textAlign: TextAlign.center,
      ),
    ],
  );
}

Widget _buildDefaultProfileImage() {
  return Container(
    color: AppColors.disabled1,
    child: Icon(
      Icons.person,
      size: 50.sp,
      color: AppColors.iconColor,
    ),
  );
}


  Widget _buildFormFields(BuildContext context,EditProfileController controller) {
    return Column(
      children: [
        // Full Name Field
        CustomTextField(
          label: context.tr('full_name'),
          controller: controller.fullNameController,
          isRequired: true,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your full name';
            }
            return null;
          },
          keyboardType: TextInputType.name,
        ),
        
        SizedBox(height: 15.h),
        
        // Email Field
        CustomTextField(
          label: context.tr('email_address'),
          controller: controller.emailController,
          isRequired: true,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your email address';
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return 'Please enter a valid email address';
            }
            return null;
          },
          keyboardType: TextInputType.emailAddress,
        ),
        
        // SizedBox(height: 24.h),
        SizedBox(height: 15.h),
        
        // Old Password Field
        CustomTextField(
          label: context.tr('current_password'),
          controller: controller.oldPasswordController,
          isPassword: true,
          isVisible: controller.isOldPasswordVisible,
          onToggleVisibility: controller.toggleOldPasswordVisibility,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your current password';
            }
            return null;
          },
        ),
        
        // SizedBox(height: 24.h),
        SizedBox(height: 15.h),
        
        // New Password Field
        CustomTextField(
          label: context.tr('new_passowrd'),
          controller: controller.newPasswordController,
          isPassword: true,
          isVisible: controller.isNewPasswordVisible,
          onToggleVisibility: controller.toggleNewPasswordVisibility,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your new password';
            }
            if (value.length < 6) {
              return 'Password must be at least 6 characters';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildSaveButton(BuildContext context, EditProfileController controller) {
    return Container(
      width: double.infinity,
      height: 56.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryColor,
            // ignore: deprecated_member_use
            AppColors.primaryColor.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: controller.isSaving ? null : () => _handleSave(context, controller),
          child: Center(
            child: controller.isSaving
                ? SizedBox(
                    width: 24.w,
                    height: 24.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5.w,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.save,
                        color: Colors.white,
                        size: 20.sp,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        context.tr('save_changes'),
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          height: 1.20,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleSave(BuildContext context, EditProfileController controller) async {
    final success = await controller.saveProfile();
    
    if (success) {
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white, size: 20.sp),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  controller.successMessage!,
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.green.shade600,
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
      );
      
      // Navigate back after a short delay
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.of(context).pop();
      });
    } else {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white, size: 20.sp),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  controller.errorMessage!,
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.red.shade600,
          duration: const Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
      );
    }
  }
}
