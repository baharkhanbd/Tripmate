import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trip_mate/config/colors/colors.dart';

class RichTextWidget extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color textColor;
  final Color highlightColor;
  final double lineHeight;

  const RichTextWidget({
    super.key,
    required this.text,
    this.fontSize = 14,
    this.fontWeight = FontWeight.w400,
    this.textColor = AppColors.textColor1,
    this.highlightColor = AppColors.highlight,
    this.lineHeight = 1.71,
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: _parseText(text),
      ),
    );
  }

  List<TextSpan> _parseText(String text) {
    List<TextSpan> spans = [];
    RegExp boldPattern = RegExp(r'\*\*(.*?)\*\*');
    
    int lastIndex = 0;
    Iterable<RegExpMatch> matches = boldPattern.allMatches(text);
    
    for (RegExpMatch match in matches) {
      // Add text before the bold part
      if (match.start > lastIndex) {
        spans.add(TextSpan(
          text: text.substring(lastIndex, match.start),
          style: GoogleFonts.inter(
            color: textColor,
            fontSize: fontSize.sp,
            fontWeight: fontWeight,
            height: lineHeight,
            letterSpacing: 0.56,
          ),
        ));
      }
      
      // Add the bold part
      spans.add(TextSpan(
        text: match.group(1),
        style: GoogleFonts.inter(
          color: highlightColor,
          fontSize: fontSize.sp,
          fontWeight: FontWeight.w700,
          height: lineHeight,
          letterSpacing: 0.56,
        ),
      ));
      
      lastIndex = match.end;
    }
    
    // Add remaining text after the last bold part
    if (lastIndex < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastIndex),
        style: GoogleFonts.inter(
          color: textColor,
          fontSize: fontSize.sp,
          fontWeight: fontWeight,
          height: lineHeight,
          letterSpacing: 0.56,
        ),
      ));
    }
    
    return spans;
  }
}
