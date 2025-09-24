import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trip_mate/config/baseurl/baseurl.dart';
import 'package:trip_mate/features/auths/controllers/ui_controller.dart';
import 'package:trip_mate/features/auths/services/auth_service.dart';
import 'package:trip_mate/features/profile/models/profile_model.dart';

class ProfileController extends ChangeNotifier {
  ProfileModel? _profile;
  bool _isLoading = false;
  String? _errorMessage;
  String? _token;

  // Getters
  ProfileModel? get profile => _profile;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Baseurl base = Baseurl();
    ProfileController() {
    _init();
  }

  Future<void> _init() async {
    final authService = AuthService();
    await authService.loadAuthState();
    _token = authService.token;
    debugPrint("!+++++++++++$_token");
    _loadProfile();
  }

  
  // ProfileController() {
  //   debugPrint("!+++++++++++$_token");
  //   _loadProfile();
  // }

  // Load profile data
  final ProfileModel _dummyProfile = ProfileModel(
  id: '0',
  name: 'John Doe',
  email: 'johndoe@example.com',
  profileImageUrl: 'https://via.placeholder.com/150', 
  isBoosted: false,
  remainingDays: 0,
  remainingHours: 0,
  remainingMinutes: 0,
);

Future<void> _loadProfile() async {
  _isLoading = true;
  _errorMessage = null;
  notifyListeners();

  try {
    String apiUrl = "${Baseurl.baseUrl}/api/payments/profile/"; 
    final dio = Dio();

    final response = await dio.get(
      apiUrl,
      options: Options(
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $_token",
        },
      ),
    );

    if (response.statusCode == 200 && response.data != null) {
      final data = response.data;

      _profile = ProfileModel(
        id: data['id']?.toString() ?? _dummyProfile.id,
        name: data['username'] ?? _dummyProfile.name,
        email: data['email'] ?? _dummyProfile.email,
        profileImageUrl: data['profile_picture'] ?? _dummyProfile.profileImageUrl,
        isBoosted: data['plan_type'] != 'free',
        remainingDays: data['time_remaining']?['days'] ?? 0,
        remainingHours: data['time_remaining']?['hours'] ?? 0,
        remainingMinutes: data['time_remaining']?['minutes'] ?? 0,
      );
    } else {
      // Use dummy profile if API fails
      _profile = _dummyProfile;
    }
  } catch (e) {
    debugPrint("🔥 Profile fetch error: $e");
    _profile = _dummyProfile; // fallback to dummy
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}


  // Refresh profile
  Future<void> refreshProfile() async {
    await _loadProfile();
  }

  // Update profile
  Future<void> updateProfile(ProfileModel updatedProfile) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 800));
      
      _profile = updatedProfile;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to update profile';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Logout
  Future<void> logout(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Get AuthService and logout
      final authService = Provider.of<AuthService>(context, listen: false);
      await authService.logout();
      
      // Clear profile data
      _profile = null;
      _errorMessage = null;
      _isLoading = false;
      notifyListeners();
      
      // Clear all form fields in UIController
      try {
        final uiController = Provider.of<UIController>(context, listen: false);
        uiController.clearAllFormFields();
      } catch (e) {
        // Handle case where UIController is not available
        print('UIController not available during logout');
      }
      
    } catch (e) {
      _errorMessage = 'Failed to logout';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
