 
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// import '../constants/app_colors.dart';
// import '../constants/font_manager.dart';

// class CustomButton extends StatefulWidget {
//   final String text;
//   final Future<void> Function()? onTap; // API call এর জন্য future

//   const CustomButton({super.key, required this.text, required this.onTap});

//   @override
//   State<CustomButton> createState() => _CustomButtonState();
// }

// class _CustomButtonState extends State<CustomButton> {
//   bool _isLoading = false;

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: double.infinity,
//       child: OutlinedButton(
//         onPressed: _isLoading
//             ? null
//             : () async {
//                 if (widget.onTap != null) {
//                   setState(() => _isLoading = true);
//                   try {
//                     await widget.onTap!();
//                   } finally {
//                     if (mounted) setState(() => _isLoading = false);
//                   }
//                 }
//               },
//         style: OutlinedButton.styleFrom(
//           padding: EdgeInsets.symmetric(vertical: 14.h),
//           backgroundColor: AppColors.blue0B5FFF, // Button background
//           side: BorderSide(color: AppColors.blue0B5FFF, width: 2), // Border
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(8.r), // Updated radius
//           ),
//         ),
//         child: _isLoading
//             ? SizedBox(
//                 height: 20.h,
//                 width: 20.h,
//                 child: CircularProgressIndicator(
//                   strokeWidth: 2.0,
//                   valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
//                 ),
//               )
//             : Text(
//                 widget.text,
//                 style: FontManager.whiteButtonText() 
//               ),
//       ),
//     );
//   }
// }
