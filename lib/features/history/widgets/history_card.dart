import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trip_mate/config/colors/colors.dart';
import 'package:trip_mate/features/history/models/history_model.dart';

class HistoryCard extends StatelessWidget {
  final HistoryModel history;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;

  const HistoryCard({
    super.key,
    required this.history,
    this.onDelete,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // margin: EdgeInsets.only(bottom: 16.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.r),
          child: Stack(
            children: [
              // Background Image
              Container(
                width: double.infinity,
                height: 149.h,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(history.imageUrl),
                    fit: BoxFit.cover,
                    onError: (exception, stackTrace) {
                      // Handle image loading error
                    },
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.3),
                      ],
                    ),
                  ),
                ),
              ),

              // Date Badge (Top Left)
              Positioned(
                top: 12.h,
                left: 12.w,
                child: Container(
                  padding: EdgeInsets.all(4.w,), 
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r,), 
                    ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_month_outlined,
                        size: 12.sp,
                        color: AppColors.iconColor,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        history.date,
                        style: GoogleFonts.inter(
                          color: AppColors.iconColor,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Location Badge (if available)
              if (history.location != null)
                Positioned(
                  top: 12.h,
                  left: 130.w,
                  child:Container(
                    padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                     child: Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 12.sp,
                          color: AppColors.iconColor,
                        ),
                      SizedBox(width: 4.w),
                      SizedBox(
                        width: 50,
                        child: Text(
                          history.location!,
                          maxLines: 1, 
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            color: AppColors.iconColor,
                            //color: Colors.white,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),

                      ],
                    ),
                  ),
                ),

              // Delete Button (Top Right)
              Positioned(
                top: 12.h,
                right: 12.w,
                child: GestureDetector(
                  onTap: onDelete,
                  child: Container(
                    width: 20.w,
                    height: 20.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.delete_outline,
                      size: 14.sp,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),

              // Description (Bottom)
              if (history.description != null)
                Positioned(
                  bottom: 12.h,
                  left: 12.w,
                  right: 12.w,
                  child: Text(
                    history.description!,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      shadows: [
                        Shadow(
                          offset: const Offset(0, 1),
                          blurRadius: 2,
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
