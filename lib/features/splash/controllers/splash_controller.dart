import 'dart:async';
import 'package:flutter/material.dart';
import 'package:trip_mate/features/splash/models/splash_model.dart';
import 'package:trip_mate/features/splash/services/splash_service.dart';

class SplashController extends ChangeNotifier {
  final SplashModel _model = SplashModel();
  Timer? _timer;

  SplashModel get model => _model;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void initializeSplash(BuildContext context) {
    _model.setLoading(true);
    notifyListeners();

    // Simulate initialization process
    _timer = Timer(const Duration(seconds: 3), () {
      _model.setLoading(false);
      _model.setInitialized(true);
      notifyListeners();
      
      // Navigate to camera page after splash
      SplashService.navigateToCamera(context);
    });
  }

  bool get isLoading => _model.isLoading;
  bool get isInitialized => _model.isInitialized;
}
