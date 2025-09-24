import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trip_mate/config/baseurl/baseurl.dart';

class AuthService extends ChangeNotifier {
  static const String _isLoggedInKey = 'isLoggedIn';
  static const String _userIdKey = 'userId';
  static const String _userEmailKey = 'userEmail';
  static const String _pendingImagePathKey = 'pendingImagePath';
  static const String _refreshTokenKey = "refresh_token";

  bool _isLoggedIn = false;
  bool _isLoading = false;
  String? _userId;
  String? _userEmail;
  String? _pendingImagePath;

  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  String? get userId => _userId;
  String? get userEmail => _userEmail;
  
  Map<String, dynamic>? _user;
  Map<String, dynamic>? get user => _user;

  String? get pendingImagePath => _pendingImagePath;

  String? _token;
  String? _refreshToken; 
  String? get token=>_token;
  String? get refreshToken => _refreshToken;

  final String _tokenKey = "auth_token";
  String get tokenKey=> _tokenKey;
  
  String? _otpToken;
  String? get otpToken => _otpToken;

 Baseurl base = Baseurl();
  

  AuthService() {
    loadAuthState();
  }

  // Load authentication state from SharedPreferences
  Future<void> loadAuthState() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool(_isLoggedInKey) ?? false;
    _userId = prefs.getString(_userIdKey);
    _userEmail = prefs.getString(_userEmailKey);
    _pendingImagePath = prefs.getString(_pendingImagePathKey);
    _token = prefs.getString(_tokenKey);
    _refreshToken = prefs.getString(_refreshTokenKey);  
    debugPrint("!================$_token");
    notifyListeners();
  } catch (e) {
    print('Error loading auth state: $e');
  }
}

  // Save authentication state to SharedPreferences
  Future<void> _saveAuthState() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, _isLoggedIn);
    if (_userId != null) {
      await prefs.setString(_userIdKey, _userId!);
    }
    if (_userEmail != null) {
      await prefs.setString(_userEmailKey, _userEmail!);
    }
    if (_pendingImagePath != null) {
      await prefs.setString(_pendingImagePathKey, _pendingImagePath!);
    }
    if (_token != null) {
      await prefs.setString(_tokenKey, _token!); 
    }
    if (_refreshToken != null) await prefs.setString(_refreshTokenKey, _refreshToken!);
  } catch (e) {
    print('Error saving auth state: $e');
  }
}

Future<void> updateAuthTokens(String access, String refresh) async {
    _token = access;
    _refreshToken = refresh;
    await _saveAuthState();
    notifyListeners();
  }

//!---------sent otp----------!
Future<bool> sendOtp(String email) async {
  try {
    _isLoading = true;
    notifyListeners();

    String apiUrl = "${Baseurl.baseUrl}/api/users/forgot-password/";

    final dio = Dio();
    final response = await dio.post(
      apiUrl,
      data: {"email": email},
      options: Options(headers: {"Content-Type": "application/json"}),
    );

    debugPrint("📩 OTP Response Status: ${response.statusCode}");
    debugPrint("📩 OTP Response Data: ${response.data}");

    if (response.statusCode == 200) {
      final data = response.data;

      if (data["detail"] != null) {
        // ✅ Save OTP token from API response
        _otpToken = data["otp_token"]?.toString();
        debugPrint("🔑 Saved OTP Token: $_otpToken");

        _isLoading = false;
        notifyListeners();
        return true;
      }
    }

    _isLoading = false;
    notifyListeners();
    return false;
  } catch (e) {
    debugPrint("🔥 OTP send error: $e");
    _isLoading = false;
    notifyListeners();
    return false;
  }
}

//!---------------------------!

  // Login user
  Future<bool> login(String email, String password) async {
  try {
    _isLoading = true;
    notifyListeners();
    debugPrint("!---------Attempting login with email: $email");

    String apiUrl = "${Baseurl.baseUrl}/api/users/login/";

    final dio = Dio();
    final response = await dio.post(
      apiUrl,
      data: {
        "email": email,
        "password": password,
      },
      options: Options(
        headers: {"Content-Type": "application/json"},
      ),
    );

    debugPrint("API Response Status: ${response.statusCode}");
    debugPrint("API Response Data: ${response.data}");

    if (response.statusCode == 200) {
      final data = response.data;

      if (data["access"] != null) {
        _isLoggedIn = true;
        _userId = data["user"]?["id"]?.toString();
        _userEmail = data["user"]?["email"]?.toString();
        _user = response.data["user"];
        // Save both tokens
        _token = data["access"]?.toString();
        _refreshToken = data["refresh"]?.toString();

        await _saveAuthState();

        debugPrint("Login success!");
        debugPrint("User ID: $_userId");
        debugPrint("User Email: $_userEmail");
        debugPrint("Access Token: $_token");
        debugPrint("Refresh Token: $refreshToken");

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        debugPrint("Login failed: No access token in response.");
      }
    } else {
      debugPrint("Login failed: Server returned status ${response.statusCode}");
    }

    _isLoading = false;
    notifyListeners();
    return false;
  } catch (e) {
    print("🔥 Login error: $e");
    _isLoading = false;
    notifyListeners();
    return false;
  }
}

  // Sign up user
  Future<bool> signUp(String name, String email, String password) async {
  try {
    _isLoading = true;
    notifyListeners();

    String apiUrl = "${Baseurl.baseUrl}/api/users/signup/";

    final dio = Dio();
    final response = await dio.post(
      apiUrl,
      data: {
        "username": name,
        "email": email,
        "password": password,
        "password2": password,
        "agree_terms": true,
      },
      options: Options(
        headers: {"Content-Type": "application/json"},
      ),
    );

    debugPrint("✅ Signup Response Status: ${response.statusCode}");
    debugPrint("✅ Signup Response Data: ${response.data}");

    if (response.statusCode == 201 || response.statusCode == 200) {
      final data = response.data;

      // Mark signup as successful based on HTTP status (no access token expected)
      _isLoggedIn = true;
      _userId = data["id"]?.toString();
      _userEmail = data["email"]?.toString();

      await _saveAuthState();

      _isLoading = false;
      notifyListeners();
      return true;
    } else {
      debugPrint("⚠️ Signup failed: Server returned status ${response.statusCode}");
    }

    _isLoading = false;
    notifyListeners();
    return false;
  } catch (e) {
    if (e is DioException) {
      debugPrint("🔥 Signup Dio error: ${e.response?.statusCode}");
      debugPrint("🔥 Signup Dio response data: ${e.response?.data}");
    } else {
      debugPrint("🔥 Signup unexpected error: $e");
    }
    _isLoading = false;
    notifyListeners();
    return false;
  }
}

  // Logout user
  Future<void> logout() async {
    try {
      if (_refreshToken == null) {
        print("No refresh token available for logout.");
        return;
      }

      final dio = Dio();
      final response = await dio.post(
        "${Baseurl.baseUrl}/api/users/logout/",
        data: {"refresh": _refreshToken}, 
        options: Options(
          headers: {
            "Content-Type": "application/json",
             "Authorization": "Bearer $_token",
          },
        ),
      );

      if (response.statusCode == 200) {
        print("✅ Server logout success: ${response.data}");
      } else {
        print("⚠️ Server logout failed: ${response.data}");
      }
    } catch (e) {
      print("❌ Logout error: $e");
    } finally {
      // Clear local auth state regardless
      _isLoggedIn = false;
      _userId = null;
      _userEmail = null;
      _token = null;
      _refreshToken = null;

      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      notifyListeners();
    }
  }
  

  // Check if user is authenticated
  bool isAuthenticated() {
    return _isLoggedIn;
  }

  // Store pending image path for after login
  Future<void> setPendingImagePath(String imagePath) async {
    _pendingImagePath = imagePath;
    await _saveAuthState();
    notifyListeners();
  }

  // Clear pending image path
  Future<void> clearPendingImagePath() async {
    _pendingImagePath = null;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_pendingImagePathKey);
    } catch (e) {
      print('Error clearing pending image path: $e');
    }
    notifyListeners();
  }

  // Clear all auth data
  Future<void> clearAuthData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_isLoggedInKey);
      await prefs.remove(_userIdKey);
      await prefs.remove(_userEmailKey);
      await prefs.remove(_pendingImagePathKey);
      
      _isLoggedIn = false;
      _userId = null;
      _userEmail = null;
      _pendingImagePath = null;
      notifyListeners();
    } catch (e) {
      print('Error clearing auth data: $e');
    }
  }

  bool hasReachedFreeLimit() {
  return (user != null &&(user?["free_scans_used"] ?? 0) >= 3 && (user?["is_active_premium"] == false));
  }
}
