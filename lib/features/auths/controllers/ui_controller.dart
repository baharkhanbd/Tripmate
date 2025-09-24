import 'package:flutter/material.dart';

class UIController extends ChangeNotifier {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmNewPassword = true;
  bool _isChecked = false;
  String? _selectedLang;
  String? _selectedValue = 'English';

  // Text Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmNewPasswordController = TextEditingController();
  
  // OTP Controllers
  final List<TextEditingController> otpControllers = List.generate(
    4,
    (index) => TextEditingController(),
  );

  // Getters
  bool get obscurePassword => _obscurePassword;
  bool get obscureConfirmPassword => _obscureConfirmPassword;
  bool get obscureNewPassword => _obscureNewPassword;
  bool get obscureConfirmNewPassword => _obscureConfirmNewPassword;
  bool get isChecked => _isChecked;
  String? get selectedLang => _selectedLang;
  String? get selectedValue => _selectedValue;

  // Setters
  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _obscureConfirmPassword = !_obscureConfirmPassword;
    notifyListeners();
  }

  void toggleNewPasswordVisibility() {
    _obscureNewPassword = !_obscureNewPassword;
    notifyListeners();
  }

  void toggleConfirmNewPasswordVisibility() {
    _obscureConfirmNewPassword = !_obscureConfirmNewPassword;
    notifyListeners();
  }

  void setChecked(bool value) {
    _isChecked = value;
    notifyListeners();
  }

   void setLanguage(String language) {
    _selectedLang = language;
    notifyListeners();
  }
  // void setSelectedLang(String? value) {
  //   _selectedLang = value;
  //   notifyListeners();
  // }

  void setSelectedValue(String? value) {
    _selectedValue = value;
    notifyListeners();
  }

  // Clear all form fields
  void clearAllFormFields() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    newPasswordController.clear();
    confirmNewPasswordController.clear();
    
    // Clear OTP controllers
    for (var controller in otpControllers) {
      controller.clear();
    }
    
    // Reset password visibility states
    _obscurePassword = true;
    _obscureConfirmPassword = true;
    _obscureNewPassword = true;
    _obscureConfirmNewPassword = true;
    
    notifyListeners();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    newPasswordController.dispose();
    confirmNewPasswordController.dispose();
    
    // Dispose OTP controllers
    for (var controller in otpControllers) {
      controller.dispose();
    }
    
    super.dispose();
  }
}
