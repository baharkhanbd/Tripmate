// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:tripmate/config/app_url.dart';

// class LoginProvider extends ChangeNotifier {
//   static final ValueNotifier<bool> isLoading = ValueNotifier(false);

//   static Future<Map<String, dynamic>> login(
//     String email,
//     String password,
//     BuildContext context,
//   ) async {
//     isLoading.value = true;
//     print('Response UI Body: ${email} ${password}');
//     try {
//       final response = await http.post(
//         Uri.parse(AppURl.logOutUrl),
//         headers: {'Content-Type': 'application/json'},

//         body: jsonEncode({'email': email, 'password': password}),

//         // body: jsonEncode({'email': "admin_demo", 'password': "admin123"}),
//       );

//       print('App Url:-- ${AppURl.loginUrl}');
//       print('Response Body: ${response.body}');

//       print('Response Status Code: ${response.statusCode}');
//       print('Response Body: ${response.body}');

//       // Handle successful login (status code 200)
//       if (response.statusCode == 200) {
//         final responseData = jsonDecode(response.body);
//         await _storeLoginData(responseData);
//         await printAllStoredData();
//         return responseData;
//       }
//       // Handle other error cases
//       else {
//         print("Error ${response.statusCode.toString()}");
//         throw Exception(
//           'Login failed with status code: ${response.statusCode}',
//         );
//       }
//     } catch (e) {
//       print("Error ${e.toString()}");

//       rethrow;
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   static Future<void> _storeLoginData(Map<String, dynamic> data) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//   }

//   static Future<void> printAllStoredData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     Set<String> keys = prefs.getKeys();
//     for (String key in keys) {
//       var value = prefs.get(key);
//       print('$key: $value');
//     }
//   }
// }
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tripmate/config/app_url.dart';
import 'package:tripmate/config/shared_pref_helper.dart';
 
class LoginProvider extends ChangeNotifier {
  static final ValueNotifier<bool> isLoading = ValueNotifier(false);

  // Login function
  static Future<Map<String, dynamic>> login(
    String email,
    String password,
    BuildContext context,
  ) async {
    isLoading.value = true;
    print('Trying login with: $email / $password');

    try {
      final response = await http.post(
        Uri.parse(AppURl.loginUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        // Store all login data
        await _storeLoginData(responseData);

        // Print all stored data for debugging
        await _printAllStoredData();

        return responseData;
      } else {
        throw Exception(
          'Login failed with status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      print("Login Error: $e");
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  // Store login data in SharedPreferences
  static Future<void> _storeLoginData(Map<String, dynamic> data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Save access & refresh tokens
    if (data.containsKey('access')) {
      await SharedPrefHelper.setToken(data['access']);
    }
    if (data.containsKey('refresh')) {
      await prefs.setString('refresh_token', data['refresh']);
    }

    // Save user info
    if (data.containsKey('user')) {
      Map<String, dynamic> user = data['user'];
      for (var key in user.keys) {
        var value = user[key];
        if (value is String) {
          await prefs.setString(key, value);
        } else if (value is int) {
          await prefs.setInt(key, value);
        } else if (value is double) {
          await prefs.setDouble(key, value);
        } else if (value is bool) {
          await prefs.setBool(key, value);
        } else if (value == null) {
          await prefs.remove(key);
        }
      }
    }
  }

  // Print all stored SharedPreferences data (debug)
  static Future<void> _printAllStoredData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Set<String> keys = prefs.getKeys();
    for (String key in keys) {
      var value = prefs.get(key);
      print('$key: $value');
    }
  }

  // Clear all login data
  static Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    print("All login data cleared.");
  }
}
