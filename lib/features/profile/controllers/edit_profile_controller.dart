import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trip_mate/config/baseurl/baseurl.dart';
import 'dart:io';
import 'package:trip_mate/features/auths/services/auth_service.dart';

class EditProfileController extends ChangeNotifier {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final ImagePicker _imagePicker = ImagePicker();
  
  bool _isLoading = false;
  bool _isSaving = false;
  String? _errorMessage;
  String? _successMessage;
  
  // Visibility toggles for password fields
  bool _isOldPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  
  // Profile image
  File? _selectedImage;
  String _currentImageUrl = 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face';

  // Getters
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  bool get isOldPasswordVisible => _isOldPasswordVisible;
  bool get isNewPasswordVisible => _isNewPasswordVisible;
  File? get selectedImage => _selectedImage;
  String get currentImageUrl => _currentImageUrl;
  String? _token;
  
  Baseurl base = Baseurl();
  
  EditProfileController() {
    _loadInitialData();
  }

  // Load initial data from profile
   Future<void> _loadInitialData() async {
    _isLoading = true;
    notifyListeners();

    try {
      final authService = AuthService();
      await authService.loadAuthState();
      _token = authService.token;

      final dio = Dio();

      final response = await dio.get(
        "${Baseurl.baseUrl}/api/users/me/", 
        options: Options(
          headers: {
            "Authorization": "Bearer $_token",
            "Content-Type": "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;

        // Fill text fields
        fullNameController.text = data['username'] ?? '';
        emailController.text = data['email'] ?? '';
        oldPasswordController.text = '';
        newPasswordController.text = '';

        // Preload profile image
        if (data['profile_picture'] != null &&
            data['profile_picture'].toString().isNotEmpty) {
          _currentImageUrl = data['profile_picture'];
        } else {
          _currentImageUrl ='https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face';
        }
        _isLoading = false;
        notifyListeners();
      } else {
        _errorMessage = "Failed to load profile (${response.statusCode})";
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = "Error loading profile: $e";
      _isLoading = false;
      notifyListeners();
    }
  }
  // Pick image from gallery
  Future<void> pickImageFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 512,
        maxHeight: 512,
      );
      
      if (image != null) {
        _selectedImage = File(image.path);
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Failed to pick image. Please try again.';
      notifyListeners();
    }
  }



  // Show image picker options
  Future<void> showImagePickerOptions(BuildContext context) async {
    await pickImageFromGallery();
  }

  // Toggle password visibility
  void toggleOldPasswordVisibility() {
    _isOldPasswordVisible = !_isOldPasswordVisible;
    notifyListeners();
  }

  void toggleNewPasswordVisibility() {
    _isNewPasswordVisible = !_isNewPasswordVisible;
    notifyListeners();
  }

  // Validate form
  bool validateForm() {
    if (formKey.currentState?.validate() ?? false) {
      return true;
    }
    return false;
  }

  // Save profile changes
  Future<bool> saveProfile() async {
  if (!validateForm()) return false;

  _isSaving = true;
  _errorMessage = null;
  _successMessage = null;
  notifyListeners();

  try {
    final authService = AuthService();
    await authService.loadAuthState();
    _token = authService.token;

    final dio = Dio();

    // Prepare FormData
    final formData = FormData.fromMap({
      "username": fullNameController.text.trim(),
        "email": emailController.text.trim(),
        if (oldPasswordController.text.isNotEmpty)
          "old_password": oldPasswordController.text,
        if (newPasswordController.text.isNotEmpty)
          "new_password": newPasswordController.text,
        if (_selectedImage != null)
          "profile_picture": await MultipartFile.fromFile(
          _selectedImage!.path,
          filename: _selectedImage!.path.split('/').last,
        ),
      });

    final response = await dio.patch(
      "${Baseurl.baseUrl}/api/users/edit-profile/",
      data: formData,
      options: Options(
        headers: {
          "Authorization": "Bearer $_token",
          "Content-Type": "multipart/form-data",
        },
      ),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Update local selected image with server response if needed
      if (response.data["profile_picture"] != null) {
        _selectedImage = response.data["profile_picture"];
      }

      _successMessage = "Profile updated successfully!";
      _isSaving = false;
      notifyListeners();
      return true;
    } else {
      _errorMessage = "Failed to update profile (${response.statusCode})";
      _isSaving = false;
      notifyListeners();
      return false;
    }
  } catch (e) {
    _errorMessage = "Error updating profile: $e";
    _isSaving = false;
    notifyListeners();
    return false;
  }
}


  // Clear messages
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearSuccess() {
    _successMessage = null;
    notifyListeners();
  }

  // Reset form
  void resetForm() {
    fullNameController.clear();
    emailController.clear();
    oldPasswordController.clear();
    newPasswordController.clear();
    _selectedImage = null;
    _errorMessage = null;
    _successMessage = null;
    _isOldPasswordVisible = false;
    _isNewPasswordVisible = false;
    notifyListeners();
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    oldPasswordController.dispose();
    newPasswordController.dispose();
    super.dispose();
  }
}
