import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:trip_mate/config/theme.dart';
import 'package:trip_mate/features/splash/controllers/splash_controller.dart';


class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _SplashScreenWrapper();
  }
}

class _SplashScreenWrapper extends StatefulWidget {
  @override
  State<_SplashScreenWrapper> createState() => _SplashScreenWrapperState();
}

class _SplashScreenWrapperState extends State<_SplashScreenWrapper> 
    with TickerProviderStateMixin {
  
  late AnimationController _logoAnimationController;
  late AnimationController _textAnimationController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _textFadeAnimation;
  bool _animationsInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startSplashProcess();
  }

  void _initializeAnimations() {
    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _textAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _logoScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.elasticOut,
    ));

    _textFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textAnimationController,
      curve: Curves.easeInOut,
    ));

    setState(() {
      _animationsInitialized = true;
    });
  }

  void _startSplashProcess() {
    // Start logo animation
    _logoAnimationController.forward();
    
    // Start text animation after logo animation
    Future.delayed(const Duration(milliseconds: 800), () {
      _textAnimationController.forward();
    });

    // Initialize splash controller
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SplashController>().initializeSplash(context);
    });
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _textAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor2,
      body: SafeArea(
        child: Consumer<SplashController>(
          builder: (context, splashController, child) {
            if (!_animationsInitialized) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.primaryColors,
                  ),
                ),
              );
            }

            return Stack(
              children: [
                // Main Content
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo with animation
                      AnimatedBuilder(
                        animation: _logoAnimationController,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _logoScaleAnimation.value,
                            child: Container(
                              width: 120.w,
                              height: 120.w,
                              decoration: BoxDecoration(
                                color: AppColors.primaryColors,
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Center(
                                child: Image.asset(
                                  AppAssets.logo2,
                                  width: 110.w,
                                  height: 110.h,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      
                      SizedBox(height: 40.h),
                      
                      // App name with animation
                      AnimatedBuilder(
                        animation: _textAnimationController,
                        builder: (context, child) {
                          return Opacity(
                            opacity: _textFadeAnimation.value,
                            child: Text(
                              'TRIPMATE',
                              style: GoogleFonts.inter(
                                fontSize: 36.sp,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 10.8,
                                color: AppColors.iconColor,
                                height: 1.2,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                
                // Loading indicator (optional)
                if (splashController.isLoading)
                  Positioned(
                    bottom: 100.h,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.primaryColors,
                        ),
                        strokeWidth: 2.w,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
