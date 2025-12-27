import 'package:get/get.dart';
import 'package:zero_signal/repository/route_repository/route_repository.dart';
import 'package:zero_signal/screen/filters_screen/model/route_category_model.dart';
import 'package:zero_signal/utils/app_log/app_log.dart';
import 'package:zero_signal/screen/map_routes_screen/controller/map_routes_controller.dart';

class FiltersController extends GetxController {
  final RouteRepository _repository = RouteRepository();

  // Observables
  final RxList<RouteCategoryModel> categories = <RouteCategoryModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString selectedActivity = ''.obs;
  final RxString selectedDifficulty = 'Easy'.obs;
  final RxDouble distanceValue = 125.0.obs;
  final RxString selectedRouteType = 'Round trip'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final result = await _repository.fetchRouteCategories();

      if (result != null && result.isNotEmpty) {
        categories.value = result;
        // Set first category as selected by default
        if (selectedActivity.value.isEmpty) {
          selectedActivity.value = result.first.name;
        }
        appLog('Fetched ${result.length} route categories');
      } else {
        errorMessage.value = 'No categories found';
      }
    } catch (e) {
      errorMessage.value = 'Failed to fetch categories';
      appLog('Error in FiltersController: $e', type: LogType.error);
    } finally {
      isLoading.value = false;
    }
  }

  void selectActivity(String activity) {
    if (selectedActivity.value == activity) {
      selectedActivity.value = ''; // Toggle off
    } else {
      selectedActivity.value = activity;
    }
  }

  void selectDifficulty(String difficulty) {
    if (selectedDifficulty.value == difficulty) {
      selectedDifficulty.value = ''; // Toggle off
    } else {
      selectedDifficulty.value = difficulty;
    }
  }

  void selectRouteType(String routeType) {
    if (selectedRouteType.value == routeType) {
      selectedRouteType.value = ''; // Toggle off
    } else {
      selectedRouteType.value = routeType;
    }
  }

  void setDistanceValue(double value) {
    distanceValue.value = value;
  }

  Future<void> applyFilters() async {
    isLoading.value = true;
    try {
      final mapController = Get.find<MapRoutesController>();

      // Get ID for selected activity
      final selectedCat =
          categories.firstWhereOrNull((c) => c.name == selectedActivity.value);
      final typeId = selectedCat?.id ?? '';

      // Map difficulty and route type to lowercase as per API
      final difficulty = selectedDifficulty.value.toLowerCase();
      final typeOfRoute =
          selectedRouteType.value.toLowerCase().replaceAll(' ', '');

      // Radius from distanceValue (km to meters)
      final radius = (distanceValue.value * 1000).toInt();

      appLog(
          'Applying Filters - Type: $typeId, Diff: $difficulty, Route: $typeOfRoute, Radius: $radius');

      // Call API from repository
      final responseBody = await _repository.getRoutesByGeocode(
        lat: mapController.deviceLat.value.toString(),
        lng: mapController.deviceLng.value.toString(),
        radius: radius.toString(),
        type: typeId,
        difficulty: difficulty,
        typeOfRoute: typeOfRoute,
      );

      if (responseBody != null) {
        final bool success = responseBody['success'] ?? false;
        final String message =
            responseBody['message'] ?? 'Successfully fetched routes';
        final List<dynamic> data = responseBody['data'] ?? [];

        if (success) {
          mapController.routesList.value =
              List<Map<String, dynamic>>.from(data);
          mapController.update(); // Rebuild GetBuilder widgets

          appLog('Filters applied successfully: $message');
          Get.snackbar('Success', message, snackPosition: SnackPosition.BOTTOM);

          // Delay pop slightly to ensure snackbar is visible or just pop immediately
          Get.back();
        } else {
          Get.snackbar('Notice', message, snackPosition: SnackPosition.BOTTOM);
        }
      } else {
        Get.snackbar('Error', 'Failed to fetch filtered routes',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      appLog('Error applying filters: $e', type: LogType.error);
      Get.snackbar('Error', 'Something went wrong while applying filters');
    } finally {
      isLoading.value = false;
    }
  }
}
