// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:tripmate/core/constants/app_colors.dart';

// class Details extends StatefulWidget {
//   const Details({super.key});

//   @override
//   State<Details> createState() => _DetailsState();
// }

//   void _showDeleteDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text(
//             'Delete History',
//             style: GoogleFonts.inter(
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           content: Text(
//             'Are you sure you want to delete this history item?',
//             style: GoogleFonts.inter(),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 Navigator.of(context).pop(); // Go back to history list
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                     content: Text('History item deleted'),
//                     duration: const Duration(seconds: 2),
//                   ),
//                 );
//               },
//               child: Text(
//                 'Delete',
//                 style: TextStyle(color: Colors.red),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// class _DetailsState extends State<Details> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//     backgroundColor: AppColors.backgroundColor2,
//       body: CustomScrollView(
//         slivers: [
//           // App Bar with Image
//           SliverAppBar(
//             expandedHeight: 300.h,
//             floating: false,
//             pinned: true,
//           backgroundColor: AppColors.backgroundColor2,
//             leading: GestureDetector(
//               onTap: () => Navigator.of(context).pop(),
//               child: Container(
//                 margin: EdgeInsets.all(8.w),
//                 decoration: const BoxDecoration(
//                   color: Colors.white,
//                   shape: BoxShape.circle,
//                 ),
//                 child: Icon(
//                   Icons.arrow_back,
//                  color: AppColors.iconColor,
//                   size: 22.sp,
//                 ),
//               ),
//             ),
//             actions: [
//               GestureDetector(
//                 onTap: () =>  _showDeleteDialog(context),
//                 child: Container(
//                   margin: EdgeInsets.all(8.w),
//                   decoration: const BoxDecoration(
//                     color: Colors.white,
//                     shape: BoxShape.circle,
//                   ),
//                   child: Icon(
//                     Icons.delete_outline,
//                     color: Colors.red,
//                     size: 20.sp,
//                   ),
//                 ),
//               ),
//             ],
//             flexibleSpace: FlexibleSpaceBar(
//               background: Container(
//                 decoration: const BoxDecoration(
//                   image: DecorationImage(
//                     image: NetworkImage(
//                         "https://upload.wikimedia.org/wikipedia/commons/thumb/1/1d/Taj_Mahal_%28Edited%29.jpeg/1200px-Taj_Mahal_%28Edited%29.jpeg"),
//                     fit: BoxFit.cover,
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
//             ),
//           ),

//           // Content
//           SliverToBoxAdapter(
//             child: Padding(
//               padding: EdgeInsets.all(16.w),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Title
//                   Text(
//                     "Red Fort - Historical Monument",
//                     style: GoogleFonts.inter(
//                       fontSize: 24.sp,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.black87,
//                     ),
//                   ),
//                   SizedBox(height: 12.h),

//                   // Meta info row
//                   Row(
//                     children: [
//                       Row(
//                         children: [
//                           Icon(Icons.location_on,
//                               size: 16.sp, color: Colors.grey[700]),
//                           SizedBox(width: 4.w),
//                           Text("Delhi, India",
//                               style: GoogleFonts.inter(
//                                   fontSize: 14.sp, color: Colors.grey[700])),
//                         ],
//                       ),
//                       SizedBox(width: 24.w),
//                       Row(
//                         children: [
//                           Icon(Icons.business,
//                               size: 16.sp, color: Colors.grey[700]),
//                           SizedBox(width: 4.w),
//                           Text("1648",
//                               style: GoogleFonts.inter(
//                                   fontSize: 14.sp, color: Colors.grey[700])),
//                         ],
//                       ),
//                     ],
//                   ),

//                   SizedBox(height: 16.h),
//                   Divider(color: Colors.grey[400]),
//                   SizedBox(height: 16.h),

//                   // Description
//                   Text(
//                     "The Red Fort is a historic fort in Delhi, India. It was the main residence of Mughal emperors for nearly 200 years.",
//                     style: GoogleFonts.inter(
//                       fontSize: 16.sp,
//                       fontWeight: FontWeight.w400,
//                       height: 1.5,
//                       color: Colors.black87,
//                     ),
//                   ),

//                   SizedBox(height: 24.h),

//                   // Sections
//                   _buildSection("Location",
//                       "Located in Old Delhi, built by Mughal emperor Shah Jahan.", Icons.location_on),
//                   SizedBox(height: 16.h),
//                   _buildSection("Construction",
//                       "Construction began in 1638 and was completed in 1648.", Icons.construction),
//                   SizedBox(height: 16.h),
//                   _buildSection("Architecture",
//                       "Showcases the peak of Mughal architecture with red sandstone walls.", Icons.architecture),
//                   SizedBox(height: 24.h),

//                   // Visiting Hours
//                   _buildVisitingHours("9:00 AM - 5:00 PM"),
//                   SizedBox(height: 24.h),

//                   // Extra Info
//                   Text(
//                     "UNESCO World Heritage Site since 2007.",
//                     style: GoogleFonts.inter(
//                       fontSize: 16.sp,
//                       fontWeight: FontWeight.w400,
//                       color: Colors.black87,
//                     ),
//                   ),
//                   SizedBox(height: 24.h),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSection(String title, String content, IconData icon) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Icon(icon, size: 18.sp, color: Colors.deepPurple),
//             SizedBox(width: 8.w),
//             Text(
//               title,
//               style: GoogleFonts.inter(
//                 fontSize: 16.sp,
//                 fontWeight: FontWeight.w700,
//                 color: Colors.deepPurple,
//               ),
//             ),
//           ],
//         ),
//         SizedBox(height: 8.h),
//         Text(
//           content,
//           style: GoogleFonts.inter(
//             fontSize: 14.sp,
//             fontWeight: FontWeight.w400,
//             color: Colors.black87,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildVisitingHours(String hours) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Icon(Icons.access_time, size: 18.sp, color: Colors.deepPurple),
//             SizedBox(width: 8.w),
//             Text(
//               "Visiting Hours (approx.):",
//               style: GoogleFonts.inter(
//                 fontSize: 16.sp,
//                 fontWeight: FontWeight.w700,
//                 color: Colors.deepPurple,
//               ),
//             ),
//           ],
//         ),
//         SizedBox(height: 12.h),
//         Text(
//           hours,
//           style: GoogleFonts.inter(
//             fontSize: 14.sp,
//             fontWeight: FontWeight.w400,
//             color: Colors.black87,
//           ),
//         ),
//       ],
//     );
//   }
// } 

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tripmate/core/constants/app_colors.dart';

class Details extends StatefulWidget {
  const Details({super.key});

  @override
  State<Details> createState() => _DetailsState();
}
 

class _DetailsState extends State<Details> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor1,
      body: CustomScrollView(
        slivers: [
          // App Bar with Image
          SliverAppBar(
            expandedHeight: 300.h,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.backgroundColor2,
            leading: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                margin: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: AppColors.backgroundColor1,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_back,
                  color: AppColors.iconColor,
                  size: 22.sp,
                ),
              ),
            ),
            
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                        "https://upload.wikimedia.org/wikipedia/commons/thumb/1/1d/Taj_Mahal_%28Edited%29.jpeg/1200px-Taj_Mahal_%28Edited%29.jpeg"),
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
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    "Red Fort - Historical Monument",
                    style: GoogleFonts.inter(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textColor1,
                    ),
                  ),
                  SizedBox(height: 12.h),

                  // Meta info row
                  Row(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.location_on,
                              size: 16.sp, color: AppColors.iconColor),
                          SizedBox(width: 4.w),
                          Text("Delhi, India",
                              style: GoogleFonts.inter(
                                  fontSize: 14.sp,
                                  color: AppColors.textColor1)),
                        ],
                      ),
                      SizedBox(width: 24.w),
                      Row(
                        children: [
                          Icon(Icons.business,
                              size: 16.sp, color: AppColors.iconColor),
                          SizedBox(width: 4.w),
                          Text("1648",
                              style: GoogleFonts.inter(
                                  fontSize: 14.sp,
                                  color: AppColors.textColor1)),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 16.h),
                  Divider(color: AppColors.disabled1),
                  SizedBox(height: 16.h),

                  // Description
                  Text(
                    "The Red Fort is a historic fort in Delhi, India. It was the main residence of Mughal emperors for nearly 200 years.",
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                      color: AppColors.textColor1,
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // Sections
                  _buildSection("Location",
                      "Located in Old Delhi, built by Mughal emperor Shah Jahan.", Icons.location_on),
                  SizedBox(height: 16.h),
                  _buildSection("Construction",
                      "Construction began in 1638 and was completed in 1648.", Icons.construction),
                  SizedBox(height: 16.h),
                  _buildSection("Architecture",
                      "Showcases the peak of Mughal architecture with red sandstone walls.", Icons.architecture),
                  SizedBox(height: 24.h),

                  // Visiting Hours
                  _buildVisitingHours("9:00 AM - 5:00 PM"),
                  SizedBox(height: 24.h),

                  // Extra Info
                  Text(
                    "UNESCO World Heritage Site since 2007.",
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textColor1,
                    ),
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18.sp,  color: AppColors.highlight,),
            SizedBox(width: 8.w),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
              color: AppColors.highlight,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Text(
          content,
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.textColor1,
          ),
        ),
      ],
    );
  }

  Widget _buildVisitingHours(String hours) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.access_time, size: 18.sp, color: AppColors.highlight,),
            SizedBox(width: 8.w),
            Text(
              "Visiting Hours (approx.):",
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
               color: AppColors.highlight,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Text(
          hours,
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.textColor1,
          ),
        ),
      ],
    );
  }
}
