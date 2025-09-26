import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppPadding {
   static BorderRadius get c4 => BorderRadius.circular(4.r);
  static BorderRadius get c8 => BorderRadius.circular(8.r);
  static BorderRadius get c12 => BorderRadius.circular(12.r);
  static BorderRadius get c16 => BorderRadius.circular(16.r);
  static BorderRadius get c20 => BorderRadius.circular(20.r);
  static BorderRadius get c24 => BorderRadius.circular(24.r);
  static BorderRadius get c32 => BorderRadius.circular(32.r);
  static BorderRadius get c40 => BorderRadius.circular(40.r);
  // All sides padding (responsive)
  static EdgeInsets get r4 => EdgeInsets.all(4.r);
  static EdgeInsets get r8 => EdgeInsets.all(8.r);
  static EdgeInsets get r12 => EdgeInsets.all(12.r);
  static EdgeInsets get r16 => EdgeInsets.all(16.r);
  static EdgeInsets get r20 => EdgeInsets.all(20.r);
  static EdgeInsets get r24 => EdgeInsets.all(24.r);
  static EdgeInsets get r28 => EdgeInsets.all(28.r);
  static EdgeInsets get r32 => EdgeInsets.all(32.r);
  static EdgeInsets get r40 => EdgeInsets.all(40.r);
  static EdgeInsets get r48 => EdgeInsets.all(48.r);

  // Horizontal padding (responsive)
  static EdgeInsets get h4 => EdgeInsets.symmetric(horizontal: 4.r);
  static EdgeInsets get h8 => EdgeInsets.symmetric(horizontal: 8.r);
  static EdgeInsets get h12 => EdgeInsets.symmetric(horizontal: 12.r);
  static EdgeInsets get h16 => EdgeInsets.symmetric(horizontal: 16.r);
  static EdgeInsets get h20 => EdgeInsets.symmetric(horizontal: 20.r);
  static EdgeInsets get h24 => EdgeInsets.symmetric(horizontal: 24.r);
  static EdgeInsets get h32 => EdgeInsets.symmetric(horizontal: 32.r);
  static EdgeInsets get h40 => EdgeInsets.symmetric(horizontal: 40.r);
  static EdgeInsets get h48 => EdgeInsets.symmetric(horizontal: 48.r);

  // Vertical padding (responsive)
  static EdgeInsets get v4 => EdgeInsets.symmetric(vertical: 4.r);
  static EdgeInsets get v8 => EdgeInsets.symmetric(vertical: 8.r);
  static EdgeInsets get v12 => EdgeInsets.symmetric(vertical: 12.r);
  static EdgeInsets get v16 => EdgeInsets.symmetric(vertical: 16.r);
  static EdgeInsets get v20 => EdgeInsets.symmetric(vertical: 20.r);
  static EdgeInsets get v24 => EdgeInsets.symmetric(vertical: 24.r);
  static EdgeInsets get v32 => EdgeInsets.symmetric(vertical: 32.r);
  static EdgeInsets get v40 => EdgeInsets.symmetric(vertical: 40.r);
  static EdgeInsets get v48 => EdgeInsets.symmetric(vertical: 48.r);

  // Mixed padding (common combinations - responsive)
  static EdgeInsets get h16v8 => EdgeInsets.symmetric(horizontal: 16.r, vertical: 8.r);
  static EdgeInsets get h16v12 => EdgeInsets.symmetric(horizontal: 16.r, vertical: 12.r);
  static EdgeInsets get h24v12 => EdgeInsets.symmetric(horizontal: 24.r, vertical: 12.r);
  static EdgeInsets get h24v16 => EdgeInsets.symmetric(horizontal: 24.r, vertical: 16.r);
  
  // Only specific sides (responsive)
  static EdgeInsets get top4 => EdgeInsets.only(top: 4.r);
  static EdgeInsets get top8 => EdgeInsets.only(top: 8.r);
  static EdgeInsets get top16 => EdgeInsets.only(top: 16.r);
  static EdgeInsets get top24 => EdgeInsets.only(top: 24.r);
  
  static EdgeInsets get bottom4 => EdgeInsets.only(bottom: 4.r);
  static EdgeInsets get bottom8 => EdgeInsets.only(bottom: 8.r);
  static EdgeInsets get bottom16 => EdgeInsets.only(bottom: 16.r);
  static EdgeInsets get bottom24 => EdgeInsets.only(bottom: 24.r);
  
  static EdgeInsets get left4 => EdgeInsets.only(left: 4.r);
  static EdgeInsets get left8 => EdgeInsets.only(left: 8.r);
  static EdgeInsets get left16 => EdgeInsets.only(left: 16.r);
  static EdgeInsets get left24 => EdgeInsets.only(left: 24.r);
  
  static EdgeInsets get right4 => EdgeInsets.only(right: 4.r);
  static EdgeInsets get right8 => EdgeInsets.only(right: 8.r);
  static EdgeInsets get right16 => EdgeInsets.only(right: 16.r);
  static EdgeInsets get right24 => EdgeInsets.only(right: 24.r);
}