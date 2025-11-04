import 'package:get/get.dart';

class FilterController extends GetxController {
  // Selected filters
  final selectedFilters = <String>[];

  // Filter categories and options
  final Map<String, List<String>> filterCategories = {
    'Nature & Landscape': [
      'View Points',
      'Natural Pool',
      'River',
      'Cove',
      'Waterfall',
      'Monumental Trees',
      'Natural Spring',
      'Swamp',
      'Thermal Water',
    ],
    'Overnight & Rest': [
      'Verified Overnight Area',
      'Wild Rest Area',
      'Hostel',
      'Camper Area',
      'Shelter',
      'Bivouac Area',
      'Picnic Area',
    ],
    'Exploration & Adventure': [
      'Mines',
      'Caves',
      'Hanging Bridges',
      'Tunnels',
      'Hidden Passage',
    ],
  };

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
}