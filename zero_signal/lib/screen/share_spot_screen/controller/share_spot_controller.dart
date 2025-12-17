import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../repository/spot_repository.dart';
import '../../../utils/app_log/app_log.dart';
import '../../../widget/app_snack_bar/app_snack_bar.dart';
import '../model/category_response_model.dart';
import '../model/spot_request_model.dart';

class ShareSpotController extends GetxController {
  final SpotRepository _repository = SpotRepository();
  final ImagePicker _imagePicker = ImagePicker();

  // Mapbox API Key
  static const String _mapboxAccessToken =
      'pk.eyJ1IjoibGVkZTE4IiwiYSI6ImNtZzgzcmxodDAyejIybXIzcHUyZGRyMzgifQ.jbe1XMovv8MF5TGitB9PwQ';

  // Text Controllers
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  // State variables
  List<File> selectedImages = [];
  static const int maxImages = 10;

  // Location state
  List<MapboxPlaceSuggestion> locationSuggestions = [];
  bool isLocationSearching = false;
  double? selectedLat;
  double? selectedLng;
  String? selectedAddress;
  Timer? _debounceTimer;

  // Category state
  List<CategoryData> categories = [];
  bool isCategoriesLoading = false;
  bool isDropdownOpen = false;
  String selectedTypeName = 'Choose types';

  // Selected subcategories (can select multiple)
  List<SubcategoryData> get allSubcategories {
    List<SubcategoryData> all = [];
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
    locationController.dispose();
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

  /// Search for locations using Mapbox Places API
  void searchLocation(String query) {
    _debounceTimer?.cancel();

    if (query.isEmpty) {
      locationSuggestions.clear();
      update();
      return;
    }

    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      await _performLocationSearch(query);
    });
  }

  Future<void> _performLocationSearch(String query) async {
    if (query.isEmpty) return;

    isLocationSearching = true;
    update();

    try {
      final encodedQuery = Uri.encodeComponent(query);
      final url =
          'https://api.mapbox.com/geocoding/v5/mapbox.places/$encodedQuery.json?access_token=$_mapboxAccessToken&limit=5';

      final response = await Dio().get(url);

      if (response.statusCode == 200) {
        final data = response.data;
        final features = data['features'] as List<dynamic>? ?? [];

        locationSuggestions = features
            .map((feature) =>
                MapboxPlaceSuggestion.fromJson(feature as Map<String, dynamic>))
            .toList();

        appLog('Found ${locationSuggestions.length} location suggestions');
      } else {
        locationSuggestions.clear();
        appLog('Mapbox API error: ${response.statusCode}');
      }
    } catch (e) {
      locationSuggestions.clear();
      appLog('Location search error: $e');
    }

    isLocationSearching = false;
    update();
  }

  /// Select a location from suggestions
  void selectLocation(MapboxPlaceSuggestion suggestion) {
    locationController.text = suggestion.placeName;
    selectedAddress = suggestion.placeName;
    selectedLat = suggestion.latitude;
    selectedLng = suggestion.longitude;
    locationSuggestions.clear();
    update();

    appLog(
        'Selected location: ${suggestion.placeName} (${suggestion.latitude}, ${suggestion.longitude})');
  }

  /// Reverse geocode: Get address from coordinates
  Future<void> reverseGeocode(double lat, double lng) async {
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
          locationController.text = placeName;
          selectedAddress = placeName;
          selectedLat = lat;
          selectedLng = lng;

          appLog('Reverse geocoded: $placeName');
          update();
        }
      }
    } catch (e) {
      appLog('Reverse geocode error: $e');
    }
  }

  /// Clear location suggestions
  void clearLocationSuggestions() {
    locationSuggestions.clear();
    update();
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
    if (selectedAddress == null || selectedAddress!.isEmpty) {
      return 'Please set a location';
    }
    if (selectedSubcategoryIds.isEmpty) {
      return 'Please select at least one spot type';
    }
    return null;
  }

  /// Submit spot for review
  Future<void> submitSpot() async {
    // Validate form
    final validationError = validateForm();
    if (validationError != null) {
      AppSnackBar.error(validationError);
      return;
    }

    isSubmitting = true;
    update();

    try {
      // Use the first selected subcategory ID
      final String typeId = selectedSubcategoryIds.first;

      final success = await _repository.createSpot(
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        address: selectedAddress!,
        type: typeId,
        images: selectedImages,
      );

      if (success) {
        Fluttertoast.showToast(
          msg: 'Spot submitted for review!',
          backgroundColor: const Color(0xFF2E4F3E),
          textColor: Colors.white,
        );
        Get.back();
      }
    } catch (e) {
      appLog('Error submitting spot: $e');
      AppSnackBar.error('Failed to submit spot');
    }

    isSubmitting = false;
    update();
  }
}
