import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_indicator/loading_indicator.dart';

class CustomLoadinIndicator extends StatelessWidget {
  const CustomLoadinIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 80.w,
          height: 80.h,
          child: const LoadingIndicator(
            indicatorType: Indicator.ballSpinFadeLoader,
            colors: [Colors.teal, Colors.blue, Colors.orange], // Colors
            strokeWidth: 2,
          ),
        ),
      ),
    );
  }
}