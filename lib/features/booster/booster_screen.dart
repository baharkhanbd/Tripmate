import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:trip_mate/config/colors/colors.dart';
import 'package:trip_mate/features/booster/controllers/booster_controller.dart';
import 'package:trip_mate/features/booster/widgets/booster_card.dart';

class BoosterScreen extends StatelessWidget {
  const BoosterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BoosterController(),
      child: Consumer<BoosterController>(
        builder: (context, controller, child) {
          return Scaffold(
            backgroundColor: AppColors.backgroundColor2,
            body: SafeArea(
              child: Column(
                children: [
                  _buildAppBar(context),
                  Expanded(
                    child: _buildContent(context, controller),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      child: Row(
        children: [
          // Back Button
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 26.w,
              height: 26.w,
              decoration: BoxDecoration(
                //color: const Color(0xFFD9D9D9),
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
          
          SizedBox(width: 20.w),
          
          // Title
          Expanded(
            child: Text(
              'Booster',
              style: GoogleFonts.inter(
                color: AppColors.textColor1,
                fontSize: 22.sp,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          
          // Spacer to balance the layout
          SizedBox(width: 46.w),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, BoosterController controller) {
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
            Text(
              'Error',
              style: GoogleFonts.inter(
                color: AppColors.textColor1,
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              controller.errorMessage!,
              style: GoogleFonts.inter(
                color: AppColors.labelTextColor,
                fontSize: 14.sp,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: controller.refreshBoosters,
              child: Text('Retry'),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: ListView.builder(
        padding: EdgeInsets.only(top: 20.h),
        itemCount: controller.boosters.length,
        itemBuilder: (context, index) {
        final booster = controller.boosters[index];
          return Column(
            children: [
              if (index == 1) SizedBox(height: 25.h),
              BoosterCard(
                booster: booster,
                isSelected: controller.selectedBoosterId == booster.id,
                onTap: () => _handleBoosterTap(context, controller, booster),
              ),
            ],
          );
        },
      ),
    );
  }

  void _handleBoosterTap(BuildContext context, BoosterController controller, booster) async {
  controller.selectBooster(booster.id);
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text('Purchase Booster'),
      content: Text('Do you want to purchase ${booster.duration} for ${booster.price}?'),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('Cancel')),
        ElevatedButton(
          onPressed: () async {
            Navigator.of(context).pop(); // close dialog

            final success = await controller.purchaseBooster(booster.duration);

            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(success
                      ? 'Booster purchased successfully!'
                      : 'Failed to purchase booster. Please try again.'),
                  backgroundColor: success ? Colors.green : Colors.red,
                  duration: Duration(seconds: 3),
                ),
              );
            }
          },
          child: Text('Purchase'),
        ),
      ],
    ),
  );
}

}
