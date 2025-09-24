import 'package:flutter/material.dart';

class CameraUIController extends ChangeNotifier {
  bool _isFlashOn = false;
  bool _isFrontCamera = false;
  String _selectedLanguage = 'English';
  bool _isCapturing = false;

  // Getters
  bool get isFlashOn => _isFlashOn;
  bool get isFrontCamera => _isFrontCamera;
  String get selectedLanguage => _selectedLanguage;
  bool get isCapturing => _isCapturing;

  // Setters
  void toggleFlash() {
    _isFlashOn = !_isFlashOn;
    notifyListeners();
  }

  void toggleCamera() {
    _isFrontCamera = !_isFrontCamera;
    notifyListeners();
  }

  void setLanguage(String language) {
    _selectedLanguage = language;
    notifyListeners();
  }

  void setCapturing(bool capturing) {
    _isCapturing = capturing;
    notifyListeners();
  }
}
