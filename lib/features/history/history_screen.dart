import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:trip_mate/config/assets/assets.dart';
import 'package:trip_mate/config/colors/colors.dart';
import 'package:trip_mate/features/history/controllers/history_controller.dart';
import 'package:trip_mate/features/history/widgets/history_card.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearchFocused = false;
  bool _isSearchOverlayVisible = false;
  final TextEditingController _searchOverlayController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
     _searchOverlayController.dispose();
    super.dispose();
  }

  @override
   Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor2,
      body: Stack(
        children: [
          Consumer<HistoryController>(
            builder: (context, historyController, child) {
              return SafeArea(
                child: Column(
                  children: [
                    _buildAppBar(context, historyController),
                    _buildSearchBar(context, historyController),
                    Expanded(child: _buildContent(context, historyController)),
                  ],
                ),
              );
            },
          ),
          
          // Tap outside to unfocus search
          if (_isSearchFocused)
            GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
                setState(() => _isSearchFocused = false);
              },
              // ignore: deprecated_member_use
              child: Container(color: Colors.black.withOpacity(0.7)),
            ),

          // ✅ Fullscreen search overlay
          if (_isSearchOverlayVisible)
            Positioned.fill(
              child: Container(
                // ignore: deprecated_member_use
                color: Colors.black.withOpacity(0.9),
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Search input (left)
                          Expanded(
                            child: TextField(
                              controller: _searchOverlayController,
                              autofocus: true,
                              onSubmitted: (query) {
                                context.read<HistoryController>().searchHistory(
                                  query,
                                );
                                setState(() {
                                  _isSearchOverlayVisible = false;
                                });
                              },
                              textInputAction: TextInputAction.search,
                              textAlign:TextAlign.left, // Left aligned input text
                              style: GoogleFonts.inter(
                                fontSize: 16.sp,
                                color: Colors.white,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Search',
                                hintStyle: GoogleFonts.inter(
                                  fontSize: 16.sp,
                                  color: Colors.white54,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(width: 16.w),

                          // Cancel (right)
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isSearchOverlayVisible = false;
                                _searchOverlayController.clear();
                              });
                            },
                            child: Text(
                              'Cancel',
                            style: GoogleFonts.inter(
                              fontSize: 16.sp,
                              color: Colors.amberAccent,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, HistoryController controller) {
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
                // color: AppColors.disabled2,
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
              context.tr('history'),
              style: GoogleFonts.inter(
                color: AppColors.textColor1,
                fontSize: 22.sp,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(width: 16.w),
          // Profile Button
          // Container(
          //   width: 24.w,
          //   height: 24.w,
          //   decoration: BoxDecoration(
          //     color: AppColors.disabled2,
          //     borderRadius: BorderRadius.circular(4.r),
          //   ),
          //   child: Icon(
          //     Icons.person,
          //     size: 16.sp,
          //     color: AppColors.iconColor,
          //   ),
          // ),
          GestureDetector(
            onTap: () {
              context.push('/profile');
            },
            child: Container(
              width: 24.w,
              height: 24.w,
              decoration: BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.iconColor, width: 2),
              ),
              child: Center(
                child: Icon(
                  Icons.person,
                  size: 16.sp,
                  color: AppColors.iconColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context, HistoryController controller) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      child: Row(
        children: [
          Spacer(),
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: controller.searchHistory,
              onTap: () {
                setState(() => _isSearchFocused = true);
              },
              onEditingComplete: () {
                setState(() => _isSearchFocused = false);
              },
              decoration: InputDecoration(
                hintText: '',
                hintStyle: GoogleFonts.inter(
                  color: AppColors.labelTextColor,
                  fontSize: 14.sp,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 8.h),
              ),
              style: GoogleFonts.inter(
                color: AppColors.textColor1,
                fontSize: 14.sp,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          GestureDetector(
            onTap: () {
              setState(() {
                _isSearchOverlayVisible = true;
              });
            },
            child: Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Icon(Icons.search, size: 15.sp, color: AppColors.iconColor),
            ),
          ),
          SizedBox(width: 8.w),
          PopupMenuButton<String>(
            icon: Container(
              width: 20.w,
              height: 18.w,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Image.asset(
                AppAssets.sort_icon,
                width: 20.w,
                height: 18.h,
              ),
            ),
            onSelected: (value) => _applyFilter(controller, value),
            itemBuilder: (BuildContext context) => [
              // Filter items
              PopupMenuItem<String>(
                value: 'week',
                child: Row(
                  children: [
                    Icon(Icons.calendar_today, size: 18.sp, color: AppColors.iconColor),
                    SizedBox(width: 12.w),
                    Text('Last week', style: GoogleFonts.inter(fontSize: 14.sp, color: AppColors.textColor1)),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'month',
                child: Row(
                  children: [
                    Icon(Icons.calendar_month, size: 18.sp, color: AppColors.iconColor),
                    SizedBox(width: 12.w),
                    Text('Last month', style: GoogleFonts.inter(fontSize: 14.sp, color: AppColors.textColor1)),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'year',
                child: Row(
                  children: [
                    Icon(Icons.calendar_view_month, size: 18.sp, color: AppColors.iconColor),
                    SizedBox(width: 12.w),
                    Text('Last year', style: GoogleFonts.inter(fontSize: 14.sp, color: AppColors.textColor1)),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'clear',
                child: Row(
                  children: [
                    Icon(Icons.clear, size: 18.sp, color: Colors.red),
                    SizedBox(width: 12.w),
                    Text('Clear filter', style: GoogleFonts.inter(fontSize: 14.sp, color: Colors.red)),
                  ],
                ),
              ),
            ],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
            elevation: 8,
            offset: Offset(0, 8.h),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, HistoryController controller) {
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
              onPressed: controller.refreshHistory,
              child: Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (controller.filteredList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history,
              size: 48.sp,
              color: AppColors.disabled1,
            ),
            SizedBox(height: 16.h),
            Text(
              controller.searchQuery.isEmpty 
                ? 'No history found'
                : 'No results found for "${controller.searchQuery}"',
              style: GoogleFonts.inter(
                color: AppColors.disabled1,
                fontSize: 16.sp,
              ),
              textAlign: TextAlign.center,
            ),
            if (controller.searchQuery.isNotEmpty) ...[
              SizedBox(height: 16.h),
              TextButton(
                onPressed: controller.clearSearch,
                child: Text('Clear search'),
              ),
            ],
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: controller.refreshHistory,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        itemCount: controller.filteredList.length,
        itemBuilder: (context, index) {
          final history = controller.filteredList[index];

          return Column(
            children: [
              if (index != 0) const Divider(thickness: 2, height: 16),
              HistoryCard(
                history: history,
                onDelete: () =>
                  _showDeleteDialog(context, controller, history.id),
                onTap: () => _onHistoryTap(context, history),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, HistoryController controller, String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Delete History',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            'Are you sure you want to delete this history item?',
            style: GoogleFonts.inter(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                controller.deleteHistoryItem(id);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('History item deleted'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              child: Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  void _onHistoryTap(BuildContext context, history) {
    // Navigate to history details screen
    context.push('/history/${history.id}');
  }

  void _applyFilter(HistoryController controller, String filterType) {
    switch (filterType) {
      case 'week':
        controller.filterByTime('week');
        break;
      case 'month':
        controller.filterByTime('month');
        break;
      case 'year':
        controller.filterByTime('year');
        break;
      case 'clear':
        controller.clearTimeFilter();
        break;
    }
  }
}
