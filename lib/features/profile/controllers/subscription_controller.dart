import 'package:flutter/material.dart';
import 'package:trip_mate/features/profile/models/subscription_model.dart';

class SubscriptionController extends ChangeNotifier {
  SubscriptionModel? _subscription;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isUpgrading = false;
  bool _isCancelling = false;

  // Getters
  SubscriptionModel? get subscription => _subscription;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isUpgrading => _isUpgrading;
  bool get isCancelling => _isCancelling;

  SubscriptionController() {
    _loadSubscription();
  }

  // Load subscription data
  Future<void> _loadSubscription() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 800));
      
      // Mock subscription data
      _subscription = SubscriptionModel(
        planName: '7-Day Plan',
        planType: 'Trial',
        isActive: true,
        expiryDate: DateTime.now().add(const Duration(days: 7)),
        remainingDays: 7,
        remainingHours: 0,
        remainingMinutes: 0,
        canUpgrade: true,
        canCancel: true,
      );
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load subscription';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Upgrade subscription
  Future<bool> upgradeSubscription() async {
    if (_subscription == null || !_subscription!.canUpgrade) {
      return false;
    }

    _isUpgrading = true;
    notifyListeners();

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 1500));
      
      // Mock upgrade success
      _subscription = _subscription!.copyWith(
        planName: 'Premium Plan',
        planType: 'Premium',
        canUpgrade: false,
      );
      
      _isUpgrading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to upgrade subscription';
      _isUpgrading = false;
      notifyListeners();
      return false;
    }
  }

  // Cancel subscription
  Future<bool> cancelSubscription() async {
    if (_subscription == null || !_subscription!.canCancel) {
      return false;
    }

    _isCancelling = true;
    notifyListeners();

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 1500));
      
      // Mock cancel success
      _subscription = _subscription!.copyWith(
        isActive: false,
        canCancel: false,
      );
      
      _isCancelling = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to cancel subscription';
      _isCancelling = false;
      notifyListeners();
      return false;
    }
  }

  // Refresh subscription
  Future<void> refreshSubscription() async {
    await _loadSubscription();
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
