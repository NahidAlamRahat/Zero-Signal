import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../../../constant/api_end_point.dart';
import '../../../utils/app_log/app_log.dart';

class FilterController extends GetxController {
  // Selected filters
  final selectedFilters = <String>[];
  
  // API and loading states
  final Dio _dio = Dio();
  bool isLoading = false;
  String errorMessage = '';
  
  // Filter categories and options (will be populated from API)
  final Map<String, List<String>> filterCategories = <String, List<String>>{};

  @override
  void onInit() {
    super.onInit();
    fetchFilterCategories();
  }

  /// Fetch filter categories and subcategories from API
  Future<void> fetchFilterCategories() async {
    isLoading = true;
    errorMessage = '';
    update();

    try {
      // Use actual API endpoint from AppApiEndPoint
      final url = "${AppApiEndPoint.instance.baseUrl}${AppApiEndPoint.categoryEndPoint}";
      
      appLog('DEBUG: Fetching categories from: $url');
      
      final response = await _dio.get(url);
      
      if (response.statusCode == 200) {
        final data = response.data;
        appLog('DEBUG: API response received: $data');
        
        // Parse API response and populate filterCategories
        if (data['success'] == true && data['data'] != null) {
          filterCategories.clear();
          
          for (var category in data['data']) {
            final categoryName = category['name'] ?? '';
            final subcategories = <String>[];
            
            if (category['subcategories'] != null) {
              for (var subcategory in category['subcategories']) {
                subcategories.add(subcategory['name'] ?? '');
              }
            }
            
            filterCategories[categoryName] = subcategories;
            appLog('DEBUG: Added category: $categoryName with ${subcategories.length} subcategories');
          }
        } else {
          appLog('DEBUG: API response format unexpected');
          errorMessage = 'Invalid response format from server';
        }
      } else {
        appLog('DEBUG: API returned status ${response.statusCode}');
        errorMessage = 'Failed to load categories (Status: ${response.statusCode})';
      }
    } catch (e) {
      appLog('DEBUG: Error in fetchFilterCategories: $e');
      errorMessage = 'Error loading categories: $e';
    } finally {
      isLoading = false;
      update();
    }
  }



  /// Add/remove filter
  void toggleFilter(String option) {
    if (selectedFilters.contains(option)) {
      selectedFilters.remove(option);
    } else {
      selectedFilters.add(option);
    }
    update(); // Update UI
  }

  /// Check if filter is selected
  bool isFilterSelected(String option) {
    return selectedFilters.contains(option);
  }

  /// Get all selected filters
  List<String> getSelectedFilters() {
    return selectedFilters.toList();
  }

  /// Clear all filters
  void clearAll() {
    selectedFilters.clear();
    update(); // Update UI
  }

  /// Get all filter options
  List<String> getAllOptions() {
    List<String> allOptions = [];
    filterCategories.forEach((category, options) {
      allOptions.addAll(options);
    });
    return allOptions;
  }

  /// Refresh categories from API
  Future<void> refreshCategories() async {
    await fetchFilterCategories();
  }
}