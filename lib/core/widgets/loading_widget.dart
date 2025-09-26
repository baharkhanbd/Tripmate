import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class LoadingWidget extends StatelessWidget {
  final String? message;

  const LoadingWidget({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            color: AppColors.dark1F2937,
          ),
          if (message != null) ...[
            const SizedBox(height: 10),
            Text(
              message!,
              style: const TextStyle(
                color: AppColors.dark1F2937,
                fontSize: 16,
              ),
            ),
          ]
        ],
      ),
    );
  }
}
