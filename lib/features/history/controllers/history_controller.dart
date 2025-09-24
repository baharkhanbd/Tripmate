import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:trip_mate/config/baseurl/baseurl.dart';
import 'package:trip_mate/features/auths/services/auth_service.dart';
import 'package:trip_mate/features/history/models/history_model.dart';

class HistoryController extends ChangeNotifier {
  List<HistoryModel> _historyList = [];
  List<HistoryModel> _filteredList = [];
  String _searchQuery = '';
  bool _isLoading = false;
  String? _errorMessage;
  String? _token;
  // Getters
  List<HistoryModel> get historyList => _historyList;
  List<HistoryModel> get filteredList => _filteredList;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Baseurl base = Baseurl();
  
  HistoryController() {
    _loadMockData();
  }

  // Load mock data for demonstration
  // void _loadMockData() {
  //   _isLoading = true;
  //   notifyListeners();

  //   // Simulate API call delay
  //   Future.delayed(const Duration(milliseconds: 500), () {
  //     _historyList = [
  //       HistoryModel(
  //         id: '1',
  //         imageUrl: 'https://images.unsplash.com/photo-1564507592333-c60657eea523?w=800&h=400&fit=crop',
  //         date: '19 March, 2025',
  //         location: 'Delhi, India',
  //         description: 'Red Fort - Historical monument',
  //         createdAt: DateTime.now().subtract(const Duration(days: 1)),
  //       ),
  //       HistoryModel(
  //         id: '2',
  //         imageUrl: 'https://images.unsplash.com/photo-1587474260584-136574528ed5?w=800&h=400&fit=crop',
  //         date: '19 March, 2025',
  //         location: 'Delhi, India',
  //         description: 'India Gate - War memorial',
  //         createdAt: DateTime.now().subtract(const Duration(days: 2)),
  //       ),
  //       HistoryModel(
  //         id: '3',
  //         imageUrl: 'https://images.unsplash.com/photo-1513635269975-59663e0ac1ad?w=800&h=400&fit=crop',
  //         date: '19 March, 2025',
  //         location: 'London, UK',
  //         description: 'Stonehenge - Prehistoric monument',
  //         createdAt: DateTime.now().subtract(const Duration(days: 3)),
  //       ),
  //       HistoryModel(
  //         id: '4',
  //         imageUrl: 'https://images.unsplash.com/photo-1501594907352-04cda38ebc29?w=800&h=400&fit=crop',
  //         date: '19 March, 2025',
  //         location: 'South Dakota, USA',
  //         description: 'Mount Rushmore - National memorial',
  //         createdAt: DateTime.now().subtract(const Duration(days: 4)),
  //       ),
  //       HistoryModel(
  //         id: '5',
  //         imageUrl: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800&h=400&fit=crop',
  //         date: '19 March, 2025',
  //         location: 'Paris, France',
  //         description: 'Eiffel Tower - Iconic landmark',
  //         createdAt: DateTime.now().subtract(const Duration(days: 5)),
  //       ),
  //       HistoryModel(
  //         id: '6',
  //         imageUrl: 'https://images.unsplash.com/photo-1555992336-03a23c7b20ee?w=800&h=400&fit=crop',
  //         date: '19 March, 2025',
  //         location: 'Rome, Italy',
  //         description: 'Colosseum - Ancient amphitheater',
  //         createdAt: DateTime.now().subtract(const Duration(days: 6)),
  //       ),
  //     ];

  //     _filteredList = List.from(_historyList);
  //     _isLoading = false;
  //     _errorMessage = null;
  //     notifyListeners();
  //   });
  // }

  Future<void> _loadMockData() async {
  _isLoading = true;
  notifyListeners();

  try {
    // Use a single instance of AuthService
    final authService = AuthService();

    // Wait for the token to be loaded
    await authService.loadAuthState();

    // Now get the token
    _token = authService.token;
    debugPrint("🔑 Using access token: $_token");

    if (_token == null || _token!.isEmpty) {
      debugPrint("⚠️ Access token is null, cannot fetch history");
      _isLoading = false;
      _errorMessage = "No access token available";
      notifyListeners();
      return;
    }

    final dio = Dio();
    final response = await dio.get(
      "${Baseurl.baseUrl}/api/scans/scan/history/",
      options: Options(
        headers: {
          "Authorization": "Bearer $_token",
          "Accept": "application/json",
        },
      ),
    );

    if (response.statusCode == 200) {
      final data = response.data is String ? json.decode(response.data) : response.data;
      final results = List.from(data["results"] ?? []);
      debugPrint("📦 API returned ${results.length} history items");

      _historyList = results.map((item) {
        final scan = item["scan"] ?? {};
        final analysis = item["analysis"] ?? {};

        return HistoryModel(
          id: scan["id"]?.toString() ?? "",
          imageUrl: scan["image_url"] ?? "",
          date: DateTime.tryParse(scan["created_at"] ?? "")
            ?.toLocal().toString().split(" ").first ?? "",
          location: scan["location_name"] ?? analysis["location"] ?? "Unknown",
          description: analysis["historical_overview"] ??
            analysis["landmark_name"] ??
            "No description available",
          createdAt: DateTime.tryParse(scan["created_at"] ?? "") ?? DateTime.now(),
        );
      }).toList();

      _filteredList = List.from(_historyList);
      debugPrint("✅ History loaded: ${_historyList.length}");
      _errorMessage = null;
    } else {
      _errorMessage = "Failed to load data. Status: ${response.statusCode}";
    }
  } catch (e) {
    _errorMessage = "Error: $e";
  }

  _isLoading = false;
  notifyListeners();
}

  // Search functionality
  void searchHistory(String query) {
    _searchQuery = query;
    
    if (query.isEmpty) {
      _filteredList = List.from(_historyList);
    } else {
      _filteredList = _historyList.where((history) {
        final searchLower = query.toLowerCase();
        return history.location?.toLowerCase().contains(searchLower) == true ||
          history.description?.toLowerCase().contains(searchLower) == true ||
          history.date.toLowerCase().contains(searchLower);
        }).toList();
      }
    notifyListeners();
  }

  // Clear search
  void clearSearch() {
    _searchQuery = '';
    _filteredList = List.from(_historyList);
    notifyListeners();
  }

  // Delete history item
  // void deleteHistoryItem(String id) {
  //   _historyList.removeWhere((item) => item.id == id);
  //   _filteredList.removeWhere((item) => item.id == id);
  //   notifyListeners();
  // }

  Future<void> deleteHistoryItem(String id) async {
  try {
    final authService = AuthService();
    await authService.loadAuthState();
    _token = authService.token;
    final dio = Dio();

    final response = await dio.delete(
      "${Baseurl.baseUrl}/api/scans/$id/delete/",
      options: Options(
        headers: {
          "Authorization": "Bearer $_token",
          "Accept": "application/json",
        },
        validateStatus: (status) => true,
      ),
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      _historyList.removeWhere((item) => item.id == id);
      _filteredList.removeWhere((item) => item.id == id);
      notifyListeners();
    } else {
      _errorMessage = "Failed to delete. Status: ${response.statusCode}";
      notifyListeners();
    }
  } catch (e) {
    _errorMessage = "Error deleting item: $e";
    notifyListeners();
  }
}

  // Add new history item
  void addHistoryItem(HistoryModel history) {
    _historyList.insert(0, history);
    _filteredList.insert(0, history);
    notifyListeners();
  }

  // Refresh history
  Future<void> refreshHistory() async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));
      _loadMockData();
    } catch (e) {
      _errorMessage = 'Failed to refresh history';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Time filter functionality
  void filterByTime(String timeFilter) {
    final now = DateTime.now();
    DateTime filterDate;

    switch (timeFilter) {
      case 'week':
        filterDate = now.subtract(const Duration(days: 7));
        break;
      case 'month':
        filterDate = DateTime(now.year, now.month - 1, now.day);
        break;
      case 'year':
        filterDate = DateTime(now.year - 1, now.month, now.day);
        break;
      default:
        filterDate = DateTime(1900); 
    }

    _filteredList = _historyList.where((history) {
      return history.createdAt.isAfter(filterDate);
    }).toList();

    notifyListeners();
  }

  // Clear time filter
  void clearTimeFilter() {
    _filteredList = List.from(_historyList);
    notifyListeners();
  }
}


