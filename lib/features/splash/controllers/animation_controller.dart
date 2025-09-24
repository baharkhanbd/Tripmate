import 'package:flutter/material.dart';

class SplashAnimationController extends ChangeNotifier {
  late AnimationController _logoAnimationController;
  late AnimationController _textAnimationController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _textFadeAnimation;

  // Getters
  AnimationController get logoAnimationController => _logoAnimationController;
  AnimationController get textAnimationController => _textAnimationController;
  Animation<double> get logoScaleAnimation => _logoScaleAnimation;
  Animation<double> get textFadeAnimation => _textFadeAnimation;

  void initializeAnimations(TickerProvider vsync) {
    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: vsync,
    );

    _textAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: vsync,
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
  }

  void startAnimations() {
    _logoAnimationController.forward();
    
    Future.delayed(const Duration(milliseconds: 800), () {
      _textAnimationController.forward();
    });
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _textAnimationController.dispose();
    super.dispose();
  }
}
