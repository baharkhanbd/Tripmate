import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:trip_mate/config/baseurl/baseurl.dart';

class AuthController extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  int _resendTimer = 0;
  Timer? _timer;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get resendTimer => _resendTimer;

  String? _otpToken;
  String? get otpToken => _otpToken;

  Baseurl base = Baseurl();

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  void startResendTimer() {
    _resendTimer = 30;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendTimer > 0) {
        _resendTimer--;
        notifyListeners();
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<bool> login(String email, String password) async {
    setLoading(true);
    setErrorMessage(null);

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      // Mock validation
      if (email.isEmpty || password.isEmpty) {
        setErrorMessage('Please fill in all fields');
        return false;
      }

      if (!email.contains('@')) {
        setErrorMessage('Please enter a valid email');
        return false;
      }

      // Mock successful login
      setLoading(false);
      return true;
    } catch (e) {
      setErrorMessage('Login failed. Please try again.');
      setLoading(false);
      return false;
    }
  }

  Future<bool> signUp(String name, String email, String password, String confirmPassword) async {
    setLoading(true);
    setErrorMessage(null);

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      // Mock validation
      if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
        setErrorMessage('Please fill in all fields');
        return false;
      }

      if (!email.contains('@')) {
        setErrorMessage('Please enter a valid email');
        return false;
      }

      if (password != confirmPassword) {
        setErrorMessage('Passwords do not match');
        return false;
      }

      if (password.length < 6) {
        setErrorMessage('Password must be at least 6 characters');
        return false;
      }

      // Mock successful signup
      setLoading(false);
      return true;
    } catch (e) {
      setErrorMessage('Sign up failed. Please try again.');
      setLoading(false);
      return false;
    }
  }

  Future<bool> forgotPassword(String email) async {
    setLoading(true);
    setErrorMessage(null);

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      // Mock validation
      if (email.isEmpty) {
        setErrorMessage('Please enter your email address');
        return false;
      }

      if (!email.contains('@')) {
        setErrorMessage('Please enter a valid email address');
        return false;
      }

      // Mock successful OTP sent
      setLoading(false);
      startResendTimer();
      return true;
    } catch (e) {
      setErrorMessage('Failed to send OTP. Please try again.');
      setLoading(false);
      return false;
    }
  }

  Future<bool> verifyOTP(String otp, String otpToken) async {
  setLoading(true);
  setErrorMessage(null);

  try {
    if (otp.isEmpty || otp.length != 4) {
      setErrorMessage('Please enter a valid 4-digit OTP');
      setLoading(false);
      return false;
    }
    final String apiUrl = "${Baseurl.baseUrl}/api/users/verify-otp/";
    final dio = Dio();
    debugPrint("📩 Sending OTP verify request: {otp: $otp, otp_token: $otpToken}");

    final response = await dio.post(
      apiUrl,
      data: {
        "otp": otp,
        "otp_token": otpToken, 
      },
      options: Options(
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json", 
        },
      ),
    );
    debugPrint("✅ OTP Verify Status: ${response.statusCode}");
    debugPrint("✅ OTP Verify Response: ${response.data}");

    if (response.statusCode == 200) {
      final data = response.data;

      if (data["detail"] == "OTP verified successfully.") {
        setLoading(false);
        return true;
      }
    }
    setErrorMessage("Invalid OTP. Please try again.");
    setLoading(false);
    return false;
  } catch (e) {
    debugPrint("🔥 OTP verify error: $e");
    setErrorMessage('OTP verification failed. Please try again.');
    setLoading(false);
    return false;
  }
}


  void resendOTP() {
    if (_resendTimer == 0) {
      startResendTimer();
      // Mock resend OTP
      print('Resending OTP...');
    }
  }

  Future<bool> resetPassword(
  String newPassword,
  String confirmPassword,
  String otpToken,
) async {
  setLoading(true);
  setErrorMessage(null);

  try {
    // 🔹 Mock validation (keep this)
    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      setErrorMessage('Please fill in all fields');
      setLoading(false);
      return false;
    }

    if (newPassword != confirmPassword) {
      setErrorMessage('Passwords do not match');
      setLoading(false);
      return false;
    }

    if (newPassword.length < 6) {
      setErrorMessage('Password must be at least 6 characters');
      setLoading(false);
      return false;
    }

    String apiUrl = "${Baseurl.baseUrl}/api/users/reset-password/";
    final dio = Dio();

    debugPrint("📩 Sending Reset Password Request: "
    "{new_password: $newPassword, confirm_password: $confirmPassword, otp_token: $otpToken}");

    final response = await dio.post(
      apiUrl,
      data: {
        "new_password": newPassword,
        "confirm_password": confirmPassword,
        "otp_token": otpToken,
      },
      options: Options(
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
      ),
    );

    debugPrint("✅ Reset Password Status: ${response.statusCode}");
    debugPrint("✅ Reset Password Response: ${response.data}");

    if (response.statusCode == 200) {
  final data = response.data;

  if (data["detail"] == "OTP verified successfully." ||
      data["detail"] == "Password reset successfully.") {
    setLoading(false);
    return true;
  }
}


    setErrorMessage("Reset password failed. Please try again.");
    setLoading(false);
    return false;
  } catch (e) {
    debugPrint("🔥 Reset password error: $e");
    setErrorMessage('Password reset failed. Please try again.');
    setLoading(false);
    return false;
  }
}

}
