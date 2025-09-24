import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:trip_mate/features/auths/services/auth_service.dart';
import 'package:trip_mate/features/booster/models/booster_model.dart';
import 'package:url_launcher/url_launcher.dart';

class BoosterController extends ChangeNotifier {
  List<BoosterModel> _boosters = [];
  bool _isLoading = false;
  String? _errorMessage;
  String? _selectedBoosterId;

  // Getters
  List<BoosterModel> get boosters => _boosters;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get selectedBoosterId => _selectedBoosterId;
  String? _token;
  BoosterController() {
    _loadBoosters();
  }

  void _loadBoosters() {
    _isLoading = true;
    notifyListeners();

    // Mock data - in real app this would come from API
    _boosters = [
      BoosterModel(
        id: 'lifetime',
        duration: 'Lifetime',
        price: 'HK \$888',
        icon: 'infinity',
        isPopular: true,
      ),
      BoosterModel(
        id: '1hour',
        duration: '1 hour',
        price: 'HK \$8',
        icon: 'clock',
      ),
      BoosterModel(
        id: '6hours',
        duration: '6 hours',
        price: 'HK \$18',
        icon: 'clock',
      ),
      BoosterModel(
        id: '12hours',
        duration: '12 hours',
        price: 'HK \$28',
        icon: 'clock',
      ),
      BoosterModel(
        id: '24hours',
        duration: '24 hours',
        price: 'HK \$38',
        icon: 'clock',
      ),
      BoosterModel(
        id: '2days',
        duration: '2 days',
        price: 'HK \$428',
        icon: 'calendar',
      ),
      BoosterModel(
        id: '5days',
        duration: '5 days',
        price: 'HK \$628',
        icon: 'calendar',
      ),
      BoosterModel(
        id: '7days',
        duration: '7 days',
        price: 'HK \$88',
        icon: 'calendar',
      ),
      BoosterModel(
        id: '10days',
        duration: '10 days',
        price: 'HK \$108',
        icon: 'calendar',
      ),
    ];

    _isLoading = false;
    notifyListeners();
  }

  void selectBooster(String boosterId) {
    _selectedBoosterId = boosterId;
    notifyListeners();
  }

  Future<bool> purchaseBooster(String duration) async {
  try {
    _isLoading = true;
    notifyListeners();
    final authService = AuthService();
    await authService.loadAuthState();
    _token = authService.token;

    final dio = Dio();
    final response = await dio.post(
      "Baseurl.baseUrl/apiapi/payments/create-checkout-session/",
      data: {"plan_name": duration}, 
      options: Options(
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $_token",
        },
      ),
    );

    if (response.statusCode == 200 && response.data["checkout_url"] != null) {
      final checkoutUrl = response.data["checkout_url"];
        if (await canLaunchUrl(Uri.parse(checkoutUrl))) {
          await launchUrl(
            Uri.parse(checkoutUrl),
            mode: LaunchMode.externalApplication,
          );
        }
        _isLoading = false;
      notifyListeners();
      return true;
    } else {
      _errorMessage = "Invalid response from server";
      _isLoading = false;
      notifyListeners();
      return false;
    }
  } catch (e) {
    _errorMessage = 'Failed to purchase booster: $e';
    _isLoading = false;
    notifyListeners();
    return false;
  }
}

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void refreshBoosters() {
    _loadBoosters();
  }
}
