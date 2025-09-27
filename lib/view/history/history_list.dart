 

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tripmate/controller/history/history_provder.dart';
import 'package:tripmate/core/widgets/custom_loadin_indicator.dart';
import 'package:tripmate/view/history/history_card.dart';

class HistoryListScreen extends StatefulWidget {
  const HistoryListScreen({super.key});

  @override
  State<HistoryListScreen> createState() => _HistoryListScreenState();
}

class _HistoryListScreenState extends State<HistoryListScreen> {
  bool _isSearching = false; // Search overlay visibility
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetch history on first build
    Future.microtask(() {
      final provider = Provider.of<HistoryProvder>(context, listen: false);
      provider.fetchHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
      final provider = Provider.of<HistoryProvder>(context, listen: false);
      provider.resetState();
      return true;
    },
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        body: Stack(
          children: [
            SafeArea(
              child: Column(
                children: [
                  _buildAppBar(),
                  _buildSearchBar(),
                  Expanded(child: _buildHistoryList()),
                ],
              ),
            ),
            if (_isSearching) _buildSearchOverlay(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.arrow_back, size: 24.sp, color: Colors.grey[700]),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Text(
              'History',
              style: GoogleFonts.inter(
                fontSize: 22.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(width: 16.w),
          GestureDetector(
            onTap: () {},
            child: Icon(Icons.person, size: 24.sp, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    final provider = Provider.of<HistoryProvder>(context, listen: false);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              cursorColor: Colors.black,
              decoration: InputDecoration(
                hintText: 'Search history...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide.none,
                ),
                fillColor: Colors.grey[200],
                filled: true,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 8.h,
                ),
              ),
              onChanged: (value) {
                provider.searchHistory(value);
              },
            ),
          ),

          SizedBox(width: 8.w),
          PopupMenuButton<String>(
            icon: Icon(Icons.sort, color: Colors.grey[700]),
            onSelected: (value) => provider.filterByTime(value),
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'week', child: Text('Last week')),
              const PopupMenuItem(value: 'month', child: Text('Last month')),
              const PopupMenuItem(value: 'year', child: Text('Last year')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchOverlay() {
    final provider = Provider.of<HistoryProvder>(context);

    return Positioned.fill(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isSearching = false;
            _searchController.clear();
            provider.clearSearch();
          });
        },
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            color: Colors.black.withOpacity(0.3),
            alignment: Alignment.topCenter,
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 40.h),
            child: Row(
              children: [
                Expanded(
                  child: Material(
                    color: Colors.transparent,
                    child: TextField(
                      controller: _searchController,
                      autofocus: true,
                      cursorColor: Colors.white,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 16.sp,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search history...',
                        hintStyle: GoogleFonts.inter(color: Colors.white54),
                        filled: true,
                        fillColor: Colors.black.withOpacity(0.4),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: Icon(Icons.search, color: Colors.white),
                      ),
                      onChanged: (value) {
                        provider.searchHistory(value);
                      },
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isSearching = false;
                      _searchController.clear();
                      provider.clearSearch();
                    });
                  },
                  child: Text(
                    "Cancel",
                    style: GoogleFonts.inter(
                      color: const Color.fromRGBO(245, 78, 67, 1),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryList() {
    return Consumer<HistoryProvder>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(child: CustomLoadinIndicator());
        }
        if (provider.errorMessage != null) {
          return Center(child: Text(provider.errorMessage!));
        }
        final list = provider.filteredList;

        if (list.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.history, // হাইস্ট্রি আইকন
                  size: 80,
                  color: Colors.grey[400],
                ),
                SizedBox(height: 20),
                Text(
                  'No history found',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Your past scans or activities will appear here.',
                  style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          itemCount: list.length,
          separatorBuilder: (_, __) =>
              Divider(height: 16.h, thickness: 1, color: Colors.grey[300]),
          itemBuilder: (context, index) {
            final history = list[index];
            return _buildHistoryCard(history);
          },
        );
      },
    );
  }

  Widget _buildHistoryCard(dynamic history) {
    final scan = history.scan;
    final analysis = history.analysis;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => HistoryDetailsScreen(history: history),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 8.h),
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
              Container(
                width: double.infinity,
                height: 170.h,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      scan?.imageUrl ?? 'https://via.placeholder.com/150',
                    ),
                    fit: BoxFit.cover,
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
              Positioned(
                top: 12.h,
                left: 12.w,
                child: _buildInfoChip(
                  Icons.calendar_month_outlined,
                  _formatDate(scan?.createdAt) ?? '',
                ),
              ),
              Positioned(
                top: 12.h,
                left: 130.w,
                child: _buildInfoChip(
                  Icons.location_on,
                  analysis?.location ?? scan?.locationName ?? 'Unknown',
                ),
              ),
              Positioned(
                top: 12.h,
                right: 12.w,
                child: GestureDetector(
                  onTap: () {
                    // delete action
                  },
                  child: Container(
                    width: 24.w,
                    height: 24.w,
                    decoration: const BoxDecoration(
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
              Positioned(
                bottom: 12.h,
                left: 12.w,
                right: 12.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      analysis?.landmarkName ?? 'Unknown Landmark',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            offset: Offset(0, 1),
                            blurRadius: 4,
                            color: Colors.black.withOpacity(0.7),
                          ),
                        ],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      analysis?.historicalOverview ??
                          analysis?.culturalImpact ??
                          scan?.resultText ??
                          '',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 12.sp,
                        shadows: [
                          Shadow(
                            offset: Offset(0, 1),
                            blurRadius: 4,
                            color: Colors.black.withOpacity(0.7),
                          ),
                        ],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12.sp, color: Colors.grey[700]),
          SizedBox(width: 4.w),
          SizedBox(
            width: 60.w,
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize: 10.sp,
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String? _formatDate(String? dateString) {
    if (dateString == null) return null;
    try {
      final dateTime = DateTime.parse(dateString);
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    } catch (e) {
      return dateString;
    }
  }
}
