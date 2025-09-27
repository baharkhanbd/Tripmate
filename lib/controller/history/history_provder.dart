// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:tripmate/config/shared_pref_helper.dart';
// import 'package:tripmate/model/history_model.dart';

// class HistoryProvder extends ChangeNotifier {
//   List<HistoryModel> historyList = [];
//   List<HistoryModel> filteredList = [];
//   bool isLoading = false;
//   String? errorMessage;
//   String searchQuery = '';
//   String currentFilter = '';

//   Future<void> fetchHistory({String? filter}) async {
//     isLoading = true;
//     errorMessage = null;
//     notifyListeners();

//     try {
//       String? token = SharedPrefHelper.getToken();
//       String url =
//           "https://ppp7rljm-8000.inc1.devtunnels.ms/api/scans/scan/history/";

//       if (filter != null && filter.isNotEmpty) {
//         url += "?filter=$filter";
//         currentFilter = filter;
//       } else {
//         currentFilter = '';
//       }

//       final response = await http.get(Uri.parse(url), headers: {
//         'Authorization': 'Bearer $token',
//         'Content-Type': 'application/json',
//       });
// if (response.statusCode == 200) {
//   final Map<String, dynamic> data = jsonDecode(response.body);
//   final historyModel = HistoryModel.fromJson(data); // সব results parse হবে
// historyList = (historyModel.results ?? [])
//     .map((r) => HistoryModel(results: [r]))
//     .toList();


//   // সব items কনসোলে print
//   print("===== History Items =====");
//   for (var item in historyList) {
//     print(item.toJson());
//   }

//   applySearch(searchQuery); // Search filter
// } else {
//   errorMessage = 'Error: ${response.statusCode}';
//   print("===== API Error =====");
//   print(errorMessage);
// }

//     } catch (e) {
//       errorMessage = e.toString();
//       print("===== Exception =====");
//       print(errorMessage);
//     } finally {
//       isLoading = false;
//       notifyListeners();
//     }
//   }

//   // Search inside history
//   void searchHistory(String query) {
//     searchQuery = query;
//     applySearch(query);
//   }

//   void applySearch(String query) {
//     if (query.isEmpty) {
//       filteredList = List.from(historyList);
//     } else {
     
//     }

//     // প্রিন্ট filtered list
//     print("===== Filtered Items =====");
//     for (var item in filteredList) {
//       print(item.toJson());
//     }

//     notifyListeners();
//   }

//   // Filter by time
//   void filterByTime(String filter) {
//     fetchHistory(filter: filter);
//   }

//   void clearTimeFilter() {
//     fetchHistory();
//   }

//   void clearSearch() {
//     searchQuery = '';
//     applySearch('');
//   }

//   Future<void> refreshHistory() async {
//     await fetchHistory(filter: currentFilter);
//   }
// }


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tripmate/config/shared_pref_helper.dart';
import 'package:tripmate/model/history_model.dart';
import 'package:fuzzy/fuzzy.dart';

class HistoryProvder extends ChangeNotifier {
  List<Results> historyList = [];
  List<Results> filteredList = [];
  bool isLoading = false;
  String? errorMessage;
  String searchQuery = '';
  String currentFilter = '';

  Future<void> fetchHistory({String? filter}) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      String? token = SharedPrefHelper.getToken();
      String url =
          "https://ppp7rljm-8000.inc1.devtunnels.ms/api/scans/scan/history/";

      if (filter != null && filter.isNotEmpty) {
        url += "?filter=$filter";
        currentFilter = filter;
      } else {
        currentFilter = '';
      }

      final response = await http.get(Uri.parse(url), headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final historyModel = HistoryModel.fromJson(data);

        historyList = historyModel.results ?? [];
        applySearch(searchQuery); // apply search if exist
      } else {
        errorMessage = 'Error: ${response.statusCode}';
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void searchHistory(String query) {
    searchQuery = query;
    applySearch(query);
  }

  void applySearch(String query) {
    if (query.isEmpty) {
      filteredList = List.from(historyList);
    } else {
      final fuse = Fuzzy<Results>(
        historyList,
        options: FuzzyOptions(
          keys: [
            WeightedKey<Results>(
              name: 'result_text',
              getter: (res) => res.scan?.resultText ?? "",
              weight: 1.0,
            ),
            WeightedKey<Results>(
              name: 'location',
              getter: (res) => res.scan?.locationName ?? "",
              weight: 0.8,
            ),
            WeightedKey<Results>(
              name: 'landmark',
              getter: (res) => res.analysis?.landmarkName ?? "",
              weight: 0.7,
            ),
          ],
          threshold: 0.4,
        ),
      );

      final results = fuse.search(query);
      filteredList = results.map((r) => r.item).toList();
    }
    notifyListeners();
  }

  void filterByTime(String filter) {
    fetchHistory(filter: filter);
  }

  void clearTimeFilter() {
    fetchHistory();
  }

  void clearSearch() {
    searchQuery = '';
    applySearch('');
  }
  void resetState() {
    searchQuery = '';
    currentFilter = '';
    filteredList = List.from(historyList);
    errorMessage = null;
    notifyListeners();
  }
  Future<void> refreshHistory() async {
    await fetchHistory(filter: currentFilter);
  }
}
