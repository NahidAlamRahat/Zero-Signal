import 'dart:io';

import '../constant/api_end_point.dart';
import '../screen/share_spot_screen/model/category_response_model.dart';
import '../service/api_service/api_services.dart';
import '../utils/app_log/app_log.dart';
import '../widget/app_snack_bar/app_snack_bar.dart';

/// Spot Repository: Handles spot-related API calls
class SpotRepository {
  bool _inProgress = false;
  bool get inProgress => _inProgress;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  String _successMessage = '';
  String get successMessage => _successMessage;

  /// Fetch all categories with subcategories
  /// Endpoint: GET /category?withSub=true
  Future<CategoryResponse?> fetchCategories() async {
    _inProgress = true;
    _errorMessage = '';
    _successMessage = '';

    try {
      final response = await ApiService.getApi(
        AppApiEndPoint.categoryEndPoint,
      );

      _inProgress = false;

      if (response.statusCode == 200) {
        _successMessage = response.message.isNotEmpty
            ? response.message
            : "Categories retrieved successfully";

        final CategoryResponse categoryResponse =
            CategoryResponse.fromJson(Map<String, dynamic>.from(response.body));

        appLog(
            'Categories fetched successfully: ${categoryResponse.data.length} categories');
        return categoryResponse;
      } else {
        _errorMessage = response.message.isNotEmpty
            ? response.message
            : "Failed to fetch categories";
        appLog(
            'Fetch categories failed - Status: ${response.statusCode}, Message: ${response.message}');
        return null;
      }
    } catch (e) {
      _inProgress = false;
      _errorMessage = "Network error occurred";
      appLog('Fetch categories API Error: $e');
      return null;
    }
  }

  /// Create a new spot
  /// Endpoint: POST /spot with multipart form data
  Future<bool> createSpot({
    required String title,
    required String description,
    required String address,
    required String type, // subcategory ID
    required List<File> images,
  }) async {
    _inProgress = true;
    _errorMessage = '';
    _successMessage = '';

    try {
      // Prepare form data (matching API format: title, type, description, address)
      Map<String, dynamic> body = {
        'title': title,
        'type': type,
        'description': description,
        'address': address,
      };

      // Prepare multipart files - API expects 'image' key (singular)
      List<MultipartBody> multipartFiles =
          images.map((file) => MultipartBody('image', file)).toList();

      final response = await ApiService.postMultipartApi(
        AppApiEndPoint.spotEndPoint,
        body,
        multipartBody: multipartFiles,
      );

      _inProgress = false;

      if (response.statusCode == 200 || response.statusCode == 201) {
        _successMessage = response.message.isNotEmpty
            ? response.message
            : "Spot created successfully";
        appLog('Spot created successfully');
        AppSnackBar.success(_successMessage);
        return true;
      } else {
        _errorMessage = response.message.isNotEmpty
            ? response.message
            : "Failed to create spot";
        appLog(
            'Create spot failed - Status: ${response.statusCode}, Message: ${response.message}');
        AppSnackBar.error(_errorMessage);
        return false;
      }
    } catch (e) {
      _inProgress = false;
      _errorMessage = "Network error occurred";
      appLog('Create spot API Error: $e');
      AppSnackBar.error(_errorMessage);
      return false;
    }
  }
}
