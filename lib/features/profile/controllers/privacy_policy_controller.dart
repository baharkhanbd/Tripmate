import 'package:flutter/material.dart';
import 'package:trip_mate/features/profile/models/privacy_policy_model.dart';

class PrivacyPolicyController extends ChangeNotifier {
  PrivacyPolicyModel? _privacyPolicy;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  PrivacyPolicyModel? get privacyPolicy => _privacyPolicy;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  PrivacyPolicyController() {
    _loadPrivacyPolicy();
  }

  // Load privacy policy data
  Future<void> _loadPrivacyPolicy() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 800));
      
      // Mock privacy policy data
      _privacyPolicy = PrivacyPolicyModel(
        title: 'Privacy & Policy',
        introduction: 'Your privacy is important to us. This Privacy Policy explains how we collect, use, and protect your information when you use our mobile application. By using our app, you agree to the practices described in this policy.',
        sections: [
          PolicySection(
            title: '1. Information We Collect',
            description: 'We may collect the following types of information when you use our app:',
            bulletPoints: [
              'Personal Information: Name, email address, or account details when you sign up.',
              'Usage Data: How you interact with the app, features you use, and pages you visit.',
              'Device Information: Device type, operating system, and app version.',
              'Location Data: With your permission, we may collect your location to provide location-based services.',
              'Images/Uploads: Photos or media you upload for analysis or scanning (processed securely).',
            ],
          ),
          PolicySection(
            title: '2. How We Use Your Information',
            description: 'We use the collected information for:',
            bulletPoints: [
              'Creating and managing your account.',
              'Providing and improving app features.',
              'Personalizing user experience and recommendations.',
              'Communicating updates, offers, or support messages.',
              'Ensuring security and preventing fraudulent activities.',
            ],
          ),
        ],
      );
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load privacy policy';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Refresh privacy policy
  Future<void> refreshPrivacyPolicy() async {
    await _loadPrivacyPolicy();
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
