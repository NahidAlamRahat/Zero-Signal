import 'package:get/get.dart';

class FilterController extends GetxController {
  // Selected filters
  Set<String> selectedFilters = {};

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
    update(); // UI refresh
  }

  /// Clear all filters
  void clearAll() {
    selectedFilters.clear();
    update();
  }
}
