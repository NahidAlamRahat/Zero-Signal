import 'dart:async';
import 'dart:io';

import 'package:geolocator/geolocator.dart';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:image_picker/image_picker.dart';

import 'package:zero_signal/constant/api_end_point.dart';
import '../../../repository/spot_repository.dart';
import 'package:zero_signal/service/local_database/prefs_helper.dart';
import 'package:zero_signal/service/storage/storage_service.dart';
import '../../../utils/app_log/app_log.dart';
import '../../../widget/app_snack_bar/app_snack_bar.dart';
import '../model/route_request_model.dart';
import '../../share_spot_screen/model/category_response_model.dart' as spot_model;

class ShareRouteController extends GetxController {
  final SpotRepository _repository = SpotRepository();
  final ImagePicker _imagePicker = ImagePicker();

  // Mapbox API Key
  static const String _mapboxAccessToken =
      'pk.eyJ1IjoibGVkZTE4IiwiYSI6ImNtZzgzcmxodDAyejIybXIzcHUyZGRyMzgifQ.jbe1XMovv8MF5TGitB9PwQ';

  // Text Controllers
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController startLocationController = TextEditingController();
  final TextEditingController endLocationController = TextEditingController();

  // State variables
  List<File> selectedImages = [];
  static const int maxImages = 10;

  // Location state for start point
  List<MapboxPlaceSuggestion> startLocationSuggestions = [];
  bool isStartLocationSearching = false;
  double? startLat;
  double? startLng;
  String? startAddress;

  // Location state for end point
  List<MapboxPlaceSuggestion> endLocationSuggestions = [];
  bool isEndLocationSearching = false;
  double? endLat;
  double? endLng;
  String? endAddress;

  Timer? _debounceTimer;

  // Category state
  List<spot_model.CategoryData> categories = [];
  bool isCategoriesLoading = false;
  bool isDropdownOpen = false;
  String selectedTypeName = 'Choose types';

  // Selected subcategories (can select multiple)
  List<spot_model.SubcategoryData> get allSubcategories {
    List<spot_model.SubcategoryData> all = [];
    for (var category in categories) {
      all.addAll(category.subcategories);
    }
    return all;
  }

  List<String> get selectedSubcategoryIds {
    return allSubcategories
        .where((sub) => sub.isSelected)
        .map((sub) => sub.id)
        .toList();
  }

  // Route type state
  String selectedRouteType = 'roundtrip'; // Default to roundtrip
  final List<String> routeTypes = ['roundtrip', 'single_trip'];
  bool isRouteTypeDropdownOpen = false;

  // Difficulty state
  String selectedDifficulty = 'medium'; // Default to medium
  final List<String> difficultyLevels = ['easy', 'medium', 'hard'];
  bool isDifficultyDropdownOpen = false;


  List<String> selectedFacilities = [];

  // Form submission state
  bool isSubmitting = false;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    startLocationController.dispose();
    endLocationController.dispose();
    _debounceTimer?.cancel();
    super.onClose();
  }

  // ==================== IMAGE PICKER ====================

  /// Pick images from gallery (max 10)
  Future<void> pickImages() async {
    try {
      final List<XFile> pickedFiles = await _imagePicker.pickMultiImage(
        imageQuality: 80,
      );

      if (pickedFiles.isNotEmpty) {
        int remainingSlots = maxImages - selectedImages.length;

        if (remainingSlots <= 0) {
          AppSnackBar.error('Maximum $maxImages images allowed');
          return;
        }

        if (pickedFiles.length > remainingSlots) {
          AppSnackBar.error(
              'You can only add $remainingSlots more image${remainingSlots > 1 ? 's' : ''}');
          // Take only what we can fit
          List<File> newImages = pickedFiles
              .take(remainingSlots)
              .map((xFile) => File(xFile.path))
              .toList();
          selectedImages.addAll(newImages);
        } else {
          selectedImages.addAll(
            pickedFiles.map((xFile) => File(xFile.path)).toList(),
          );
        }

        appLog('Selected images: ${selectedImages.length}');
        update();
      }
    } catch (e) {
      appLog('Error picking images: $e');
      AppSnackBar.error('Failed to pick images');
    }
  }

  /// Remove an image from selection
  void removeImage(int index) {
    if (index >= 0 && index < selectedImages.length) {
      selectedImages.removeAt(index);
      update();
    }
  }

  // ==================== MAPBOX LOCATION SEARCH ====================

  /// Search for start location using Mapbox Places API
  void searchStartLocation(String query) {
    _debounceTimer?.cancel();

    if (query.isEmpty) {
      startLocationSuggestions.clear();
      update();
      return;
    }

    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      await _performStartLocationSearch(query);
    });
  }

  Future<void> _performStartLocationSearch(String query) async {
    if (query.isEmpty) return;

    isStartLocationSearching = true;
    update();

    try {
      final encodedQuery = Uri.encodeComponent(query);
      final url =
          'https://api.mapbox.com/geocoding/v5/mapbox.places/$encodedQuery.json?access_token=$_mapboxAccessToken&limit=5';

      final response = await Dio().get(url);

      if (response.statusCode == 200) {
        final data = response.data;
        final features = data['features'] as List<dynamic>? ?? [];

        startLocationSuggestions = features
            .map((feature) =>
                MapboxPlaceSuggestion.fromJson(feature as Map<String, dynamic>))
            .toList();

        appLog('Found ${startLocationSuggestions.length} start location suggestions');
      } else {
        startLocationSuggestions.clear();
        appLog('Mapbox API error: ${response.statusCode}');
      }
    } catch (e) {
      startLocationSuggestions.clear();
      appLog('Start location search error: $e');
    }

    isStartLocationSearching = false;
    update();
  }

  /// Search for end location using Mapbox Places API
  void searchEndLocation(String query) {
    _debounceTimer?.cancel();

    if (query.isEmpty) {
      endLocationSuggestions.clear();
      update();
      return;
    }

    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      await _performEndLocationSearch(query);
    });
  }

  Future<void> _performEndLocationSearch(String query) async {
    if (query.isEmpty) return;

    isEndLocationSearching = true;
    update();

    try {
      final encodedQuery = Uri.encodeComponent(query);
      final url =
          'https://api.mapbox.com/geocoding/v5/mapbox.places/$encodedQuery.json?access_token=$_mapboxAccessToken&limit=5';

      final response = await Dio().get(url);

      if (response.statusCode == 200) {
        final data = response.data;
        final features = data['features'] as List<dynamic>? ?? [];

        endLocationSuggestions = features
            .map((feature) =>
                MapboxPlaceSuggestion.fromJson(feature as Map<String, dynamic>))
            .toList();

        appLog('Found ${endLocationSuggestions.length} end location suggestions');
      } else {
        endLocationSuggestions.clear();
        appLog('Mapbox API error: ${response.statusCode}');
      }
    } catch (e) {
      endLocationSuggestions.clear();
      appLog('End location search error: $e');
    }

    isEndLocationSearching = false;
    update();
  }

  /// Select a start location from suggestions
  void selectStartLocation(MapboxPlaceSuggestion suggestion) {
    startLocationController.text = suggestion.placeName;
    startAddress = suggestion.placeName;
    startLat = suggestion.latitude;
    startLng = suggestion.longitude;
    startLocationSuggestions.clear();
    update();

    appLog(
        'Selected start location: ${suggestion.placeName} (${suggestion.latitude}, ${suggestion.longitude})');
  }

  /// Select an end location from suggestions
  void selectEndLocation(MapboxPlaceSuggestion suggestion) {
    endLocationController.text = suggestion.placeName;
    endAddress = suggestion.placeName;
    endLat = suggestion.latitude;
    endLng = suggestion.longitude;
    endLocationSuggestions.clear();
    update();

    appLog(
        'Selected end location: ${suggestion.placeName} (${suggestion.latitude}, ${suggestion.longitude})');
  }

  /// Reverse geocode: Get address from coordinates
  Future<void> reverseGeocode(double lat, double lng, {bool isStart = true}) async {
    try {
      final url =
          'https://api.mapbox.com/geocoding/v5/mapbox.places/$lng,$lat.json?access_token=$_mapboxAccessToken&limit=1';

      final response = await Dio().get(url);

      if (response.statusCode == 200) {
        final data = response.data;
        final features = data['features'] as List<dynamic>? ?? [];

        if (features.isNotEmpty) {
          final feature = features.first;
          final placeName = feature['place_name'] as String;

          // Update controller with the address
          if (isStart) {
            startLocationController.text = placeName;
            startAddress = placeName;
            startLat = lat;
            startLng = lng;
          } else {
            endLocationController.text = placeName;
            endAddress = placeName;
            endLat = lat;
            endLng = lng;
          }

          appLog('Reverse geocoded: $placeName');
          update();
        }
      }
    } catch (e) {
      appLog('Reverse geocode error: $e');
    }
  }

  /// Clear location suggestions
  void clearStartLocationSuggestions() {
    startLocationSuggestions.clear();
    update();
  }

  void clearEndLocationSuggestions() {
    endLocationSuggestions.clear();
    update();
  }

  // ==================== CURRENT LOCATION ====================

  Future<void> getCurrentStartLocation() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      // Test if location services are enabled.
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        AppSnackBar.error('Location services are disabled.');
        return;
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          AppSnackBar.error('Location permissions are denied');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        AppSnackBar.error(
            'Location permissions are permanently denied, we cannot request permissions.');
        return;
      }

      // When we reach here, permissions are granted and we can
      // continue accessing the position of the device.
      final Position position = await Geolocator.getCurrentPosition();

      startLat = position.latitude;
      startLng = position.longitude;

      // Update address
      await reverseGeocode(position.latitude, position.longitude, isStart: true);

      update();
    } catch (e) {
      appLog('Error getting current location: $e');
      AppSnackBar.error('Failed to get current location');
    }
  }

  Future<void> getCurrentEndLocation() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      // Test if location services are enabled.
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        AppSnackBar.error('Location services are disabled.');
        return;
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          AppSnackBar.error('Location permissions are denied');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        AppSnackBar.error(
            'Location permissions are permanently denied, we cannot request permissions.');
        return;
      }

      // When we reach here, permissions are granted and we can
      // continue accessing the position of the device.
      final Position position = await Geolocator.getCurrentPosition();

      endLat = position.latitude;
      endLng = position.longitude;

      // Update address
      await reverseGeocode(position.latitude, position.longitude, isStart: false);

      update();
    } catch (e) {
      appLog('Error getting current location: $e');
      AppSnackBar.error('Failed to get current location');
    }
  }

  // ==================== CATEGORIES ====================

  /// Fetch categories from API
  Future<void> fetchCategories() async {
    isCategoriesLoading = true;
    update();

    try {
      final response = await _repository.fetchCategories();

      if (response != null && response.success) {
        categories = response.data;
        appLog('Fetched ${categories.length} categories');
      } else {
        appLog('Failed to fetch categories: ${_repository.errorMessage}');
      }
    } catch (e) {
      appLog('Error fetching categories: $e');
    }

    isCategoriesLoading = false;
    update();
  }

  /// Toggle dropdown visibility
  void toggleDropdown() {
    isDropdownOpen = !isDropdownOpen;
    update();
  }

  /// Toggle route type dropdown visibility
  void toggleRouteTypeDropdown() {
    isRouteTypeDropdownOpen = !isRouteTypeDropdownOpen;
    update();
  }

  /// Select route type
  void selectRouteType(String routeType) {
    selectedRouteType = routeType;
    isRouteTypeDropdownOpen = false;
    update();
  }

  /// Toggle difficulty dropdown
  void toggleDifficultyDropdown() {
    isDifficultyDropdownOpen = !isDifficultyDropdownOpen;
    update();
  }

  /// Select difficulty
  void selectDifficulty(String difficulty) {
    selectedDifficulty = difficulty;
    isDifficultyDropdownOpen = false;
    update();
  }

  /// Toggle facility selection
  void toggleFacility(String facility) {
    if (selectedFacilities.contains(facility)) {
      selectedFacilities.remove(facility);
    } else {
      selectedFacilities.add(facility);
    }
    update();
  }

  /// Toggle subcategory selection
  void toggleSubcategorySelection(String categoryId, int subcategoryIndex) {
    for (var category in categories) {
      if (category.id == categoryId) {
        category.subcategories[subcategoryIndex].isSelected =
            !category.subcategories[subcategoryIndex].isSelected;
        break;
      }
    }

    // Update selected type name based on selections
    List<String> selectedNames = [];
    for (var category in categories) {
      for (var sub in category.subcategories) {
        if (sub.isSelected) {
          selectedNames.add(sub.name);
        }
      }
    }

    if (selectedNames.isEmpty) {
      selectedTypeName = 'Choose types';
    } else if (selectedNames.length == 1) {
      selectedTypeName = selectedNames.first;
    } else {
      selectedTypeName = '${selectedNames.length} types selected';
    }

    update();
  }

  // ==================== FORM SUBMISSION ====================

  /// Validate form
  String? validateForm() {
    if (titleController.text.isEmpty) {
      return 'Please enter a title';
    }
    if (descriptionController.text.isEmpty) {
      return 'Please enter a description';
    }
    if (startAddress == null || startAddress!.isEmpty) {
      return 'Please set a start location';
    }
    if (endAddress == null || endAddress!.isEmpty) {
      return 'Please set an end location';
    }
    if (selectedSubcategoryIds.isEmpty) {
      return 'Please select at least one route type';
    }
    if (selectedRouteType.isEmpty) {
      return 'Please select a route type';
    }
    return null;
  }

  /// Submit route for review
  Future<void> submitRoute() async {
    // Validate form
    final validationError = validateForm();
    if (validationError != null) {
      AppSnackBar.error(validationError);
      return;
    }

    isSubmitting = true;
    update();

    try {
      final String typeId = selectedSubcategoryIds.first;
      String token = await PrefsHelper.getString("accessToken");

      if (token.isEmpty) {
        // Retry fetching all data in case it wasn't loaded
        await PrefsHelper.getAllPrefData();
        token = PrefsHelper.accessToken;

        if (token.isEmpty) {
          AppSnackBar.error("Please log in again to post a route.");
          isSubmitting = false;
          update();
          return;
        }
      }

      // Update LocalStorage token for API service
      await LocalStorage.getAllPrefData();

      // Prepare FormData
      final formData = FormData.fromMap({
        'title': titleController.text.trim(),
        'type': typeId,
        'description': descriptionController.text.trim(),
        'inital_lat': startLat!,
        'inital_lng': startLng!,
        'final_lat': endLat!,
        'final_lng': endLng!,
        'route_type': selectedRouteType,
        'difficulty': selectedDifficulty,
        'facilities': selectedFacilities.join(','),
      });

      // Add image
      if (selectedImages.isNotEmpty) {
        final file = selectedImages.first;
        formData.files.add(MapEntry(
          'image',
          await MultipartFile.fromFile(file.path,
              filename: file.path.split('/').last),
        ));
      }

      final requestUrl =
          "${AppApiEndPoint.instance.baseUrl}${AppApiEndPoint.createRoute}";

      // Log Request
      appLog({
        'url': requestUrl,
        'headers': {'Authorization': 'Bearer $token'},
        'title': titleController.text.trim(),
        'type': typeId,
        'description': descriptionController.text.trim(),
        'inital_lat': startLat!,
        'inital_lng': startLng!,
        'final_lat': endLat!,
        'final_lng': endLng!,
        'route_type': selectedRouteType,
        'difficulty': selectedDifficulty,
        'image':
            selectedImages.isNotEmpty ? selectedImages.first.path : 'No Image',
      }, source: 'REQUEST PAYLOAD');

      final response = await Dio().post(
        requestUrl,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      // Log Response
      appLog(response.data, source: 'API RESPONSE');

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data['success'] == true) {
          Fluttertoast.showToast(
            msg: 'Route submitted successfully!',
            backgroundColor: const Color(0xFF2E4F3E),
            textColor: Colors.white,
          );
          Get.back();
        } else {
          AppSnackBar.error(response.data['message'] ?? 'Submission failed');
        }
      }
    } catch (e) {
      if (e is DioException) {
        appLog(e.response?.data ?? e.message, source: 'API ERROR');
        AppSnackBar.error(
            'Error: ${e.response?.data['message'] ?? 'Submission failed'}');
      } else {
        appLog('Error submitting route: $e');
        AppSnackBar.error('Failed to submit route');
      }
    }

    isSubmitting = false;
    update();
  }
}
