// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';

// class HistoryCard extends StatelessWidget {
//   final VoidCallback? onDelete;
//   final VoidCallback? onTap;

//     HistoryCard({
//     super.key,
//     this.onDelete,
//     this.onTap,
//   });

//   // Fake data for the history card
//   final Map<String, dynamic> _fakeHistoryData = {
//     'imageUrl': 'https://images.unsplash.com/photo-1587474260584-136574528ed5?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=80',
//     'date': '15 Jan 2024',
//     'location': 'Delhi, India',
//     'description': 'Visit to Red Fort - Historical monument with rich Mughal architecture and cultural significance',
//   };

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(8.r),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               blurRadius: 4,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(8.r),
//           child: Stack(
//             children: [
//               // Background Image
//               Container(
//                 width: double.infinity,
//                 height: 149.h,
//                 decoration: BoxDecoration(
//                   image: DecorationImage(
//                     image: NetworkImage(_fakeHistoryData['imageUrl']),
//                     fit: BoxFit.cover,
//                     onError: (exception, stackTrace) {
//                       // Fallback to a placeholder color if image fails to load
//                     },
//                   ),
//                 ),
//                 child: Container(
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       begin: Alignment.topCenter,
//                       end: Alignment.bottomCenter,
//                       colors: [
//                         Colors.transparent,
//                         Colors.black.withOpacity(0.3),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),

//               // Date Badge (Top Left)
//               Positioned(
//                 top: 12.h,
//                 left: 12.w,
//                 child: Container(
//                   padding: EdgeInsets.all(4.w),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(12.r),
//                   ),
//                   child: Row(
//                     children: [
//                       Icon(
//                         Icons.calendar_month_outlined,
//                         size: 12.sp,
//                         color: const Color(0xFF666666),
//                       ),
//                       SizedBox(width: 4.w),
//                       Text(
//                         _fakeHistoryData['date'],
//                         style: GoogleFonts.inter(
//                           color: const Color(0xFF666666),
//                           fontSize: 10.sp,
//                           fontWeight: FontWeight.w400,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),

//               // Location Badge
//               Positioned(
//                 top: 12.h,
//                 left: 130.w,
//                 child: Container(
//                   padding: EdgeInsets.all(4.w),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(12.r),
//                   ),
//                   child: Row(
//                     children: [
//                       Icon(
//                         Icons.location_on,
//                         size: 12.sp,
//                         color: const Color(0xFF666666),
//                       ),
//                       SizedBox(width: 4.w),
//                       SizedBox(
//                         width: 50.w,
//                         child: Text(
//                           _fakeHistoryData['location'],
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                           style: GoogleFonts.inter(
//                             color: const Color(0xFF666666),
//                             fontSize: 10.sp,
//                             fontWeight: FontWeight.w400,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),

//               // Delete Button (Top Right)
//               Positioned(
//                 top: 12.h,
//                 right: 12.w,
//                 child: GestureDetector(
//                   onTap: onDelete,
//                   child: Container(
//                     width: 20.w,
//                     height: 20.w,
//                     decoration: const BoxDecoration(
//                       color: Colors.white,
//                       shape: BoxShape.circle,
//                     ),
//                     child: Icon(
//                       Icons.delete_outline,
//                       size: 14.sp,
//                       color: Colors.red,
//                     ),
//                   ),
//                 ),
//               ),

//               // Description (Bottom)
//               Positioned(
//                 bottom: 12.h,
//                 left: 12.w,
//                 right: 12.w,
//                 child: Text(
//                   _fakeHistoryData['description'],
//                   style: GoogleFonts.inter(
//                     color: Colors.white,
//                     fontSize: 12.sp,
//                     fontWeight: FontWeight.w500,
//                     shadows: [
//                       Shadow(
//                         offset: const Offset(0, 1),
//                         blurRadius: 2,
//                         color: Colors.black.withOpacity(0.5),
//                       ),
//                     ],
//                   ),
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tripmate/model/history_model.dart';

class HistoryDetailsScreen extends StatelessWidget {
  final dynamic history;

  const HistoryDetailsScreen({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    final scan = history.scan;
    final analysis = history.analysis;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300.h,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                scan?.imageUrl ?? 'https://via.placeholder.com/150',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[300],
                  child: Icon(Icons.image, size: 100.sp, color: Colors.grey),
                ),
              ),
            ),
            pinned: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white, size: 24.sp),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.delete_outline, color: Colors.white, size: 24.sp),
                onPressed: () => _showDeleteDialog(context),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Landmark Name
                  Text(
                    analysis?.landmarkName ?? 'Unknown Landmark',
                    style: GoogleFonts.inter(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Basic Info Cards
                  _buildInfoGrid(scan, analysis),
                  SizedBox(height: 24.h),

                  // Historical Overview
                  if (analysis?.historicalOverview != null)
                    _buildInfoSection(
                      'Historical Overview',
                      analysis!.historicalOverview!,
                      Icons.history,
                    ),

                  // Cultural Impact
                  if (analysis?.culturalImpact != null)
                    _buildInfoSection(
                      'Cultural Impact',
                      analysis!.culturalImpact!,
                      Icons.architecture,
                    ),

                  // Architectural Style
                  if (analysis?.architecturalStyle != null)
                    _buildInfoSection(
                      'Architectural Style',
                      analysis!.architecturalStyle!,
                      Icons.business,
                    ),

                  // Materials
                  if (analysis?.materials != null)
                    _buildInfoSection(
                      'Construction Materials',
                      analysis!.materials!,
                      Icons.construction,
                    ),

                  // Famous For
                  if (analysis?.famousFor != null && analysis!.famousFor!.isNotEmpty)
                    _buildFamousForSection(analysis!.famousFor!),

                  // Original Result Text (fallback)
                  if ((analysis?.historicalOverview == null && 
                       analysis?.culturalImpact == null) && 
                      scan?.resultText != null)
                    _buildInfoSection(
                      'Description',
                      scan!.resultText!,
                      Icons.description,
                    ),

                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoGrid(Scan? scan, Analysis? analysis) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12.w,
      mainAxisSpacing: 12.h,
      childAspectRatio: 3,
      children: [
        _buildInfoItem(Icons.calendar_today, 'Date', _formatDate(scan?.createdAt)),
        _buildInfoItem(Icons.location_on, 'Location', analysis?.location ?? scan?.locationName ?? 'Unknown'),
        if (analysis?.yearCompleted != null)
          _buildInfoItem(Icons.date_range, 'Year Completed', analysis!.yearCompleted!),
        
      ],
    );
  }

  Widget _buildInfoItem(IconData icon, String title, String value) {
    return Container(
      padding: EdgeInsets.all(8.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), 
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 16.sp, color: const Color(0xFF666666)),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: GoogleFonts.inter(
                    fontSize: 10.sp,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String title, String content, IconData icon) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18.sp, color: const Color(0xFF666666)),
              SizedBox(width: 8.w),
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            content,
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              color: Colors.grey[700],
              height: 1.5,
            ),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }

  Widget _buildFamousForSection(List<String> famousFor) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.star, size: 18.sp, color: const Color(0xFFFFD700)),
              SizedBox(width: 8.w),
              Text(
                'Famous For',
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: famousFor.map((item) => Chip(
              label: Text(
                item,
                style: GoogleFonts.inter(fontSize: 12.sp),
              ),
              backgroundColor: Colors.blue[50],
              visualDensity: VisualDensity.compact,
            )).toList(),
          ),
        ],
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'Unknown';
    try {
      final dateTime = DateTime.parse(dateString);
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    } catch (e) {
      return dateString;
    }
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete History',
          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you sure you want to delete this history item?',
          style: GoogleFonts.inter(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: GoogleFonts.inter()),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to history list
              // TODO: Implement delete functionality
            },
            child: Text(
              'Delete',
              style: GoogleFonts.inter(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}