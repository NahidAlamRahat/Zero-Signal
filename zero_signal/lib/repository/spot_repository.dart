import 'dart:io';

import '../constant/api_end_point.dart';
import '../screen/share_spot_screen/model/category_response_model.dart';
import '../service/api_service/api_services.dart';
import '../utils/app_log/app_log.dart';
import '../widget/app_snack_bar/app_snack_bar.dart';

// Spot model for coordinates API response
class SpotCoordinateModel {
  final String id;
  final String title;
  final String description;
  final String address;
  final double latitude;
  final double longitude;
  final String type;
  final List<String> images;
  final String user;
  final DateTime createdAt;
  final DateTime updatedAt;

  SpotCoordinateModel({
    required this.id,
    required this.title,
    required this.description,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.type,
    required this.images,
    required this.user,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SpotCoordinateModel.fromJson(Map<String, dynamic> json) {
    return SpotCoordinateModel(
      id: json['_id']?.toString() ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      address: json['address'] ?? '',
      latitude: (json['lat'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['lng'] as num?)?.toDouble() ?? 0.0,
      type: json['type'] ?? '',
      images: (json['images'] as List?)?.map((e) => e.toString()).toList() ?? [],
      user: json['user']?.toString() ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }
}

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

  /// Fetch spots by coordinates
  /// Endpoint: GET /spot/coordinates?lng={longitude}&radius={radius}&lat={latitude}
  Future<List<SpotCoordinateModel>?> fetchSpotsByCoordinates({
    required double latitude,
    required double longitude,
    required double radius, // radius in meters
  }) async {
    _inProgress = true;
    _errorMessage = '';
    _successMessage = '';

    try {
      // Build query parameters
      final Map<String, dynamic> queryParams = {
        'lat': latitude.toString(),
        'lng': longitude.toString(),
        'radius': radius.toString(),
      };

      appLog('📡 API Request - Spot Coordinates:');
      appLog('   Endpoint: ${AppApiEndPoint.spotCoordinatesEndPoint}');
      appLog('   Params: $queryParams');

      final response = await ApiService.getApi(
        AppApiEndPoint.spotCoordinatesEndPoint,
        queryParams: queryParams,
      );

      _inProgress = false;

      appLog('📡 Raw API Response Status: ${response.statusCode}');
      appLog('📡 Raw API Response Body Type: ${response.body.runtimeType}');
      appLog('📡 Raw API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        _successMessage = response.message.isNotEmpty
            ? response.message
            : "Spots retrieved successfully";

        // Parse the response data
        List<dynamic> data = [];
        
        if (response.body is List) {
          data = response.body as List<dynamic>;
          appLog('✅ Response is a List with ${data.length} items');
        } else if (response.body is Map) {
          final bodyMap = response.body as Map<dynamic, dynamic>;
          if (bodyMap.containsKey('data') && bodyMap['data'] != null) {
            final dynamic dataField = bodyMap['data'];
            if (dataField is List) {
              data = dataField as List<dynamic>;
              appLog('✅ Response is a Map with data field containing ${data.length} items');
            } else {
              appLog('⚠️ Response data field is not a List');
            }
          } else {
            appLog('⚠️ Response Map has no data field');
          }
        } else {
          appLog('⚠️ Response body is neither List nor Map');
        }
        
        appLog('📊 Parsed data count: ${data.length}');
        
        final List<SpotCoordinateModel> spots = data
            .map((spotJson) => SpotCoordinateModel.fromJson(spotJson))
            .toList();

        appLog('✅ Spots by coordinates fetched successfully: ${spots.length} spots');
        return spots;
      } else {
        _errorMessage = response.message.isNotEmpty
            ? response.message
            : "Failed to fetch spots";
        appLog(
            '❌ Fetch spots by coordinates failed - Status: ${response.statusCode}, Message: ${response.message}');
        return null;
      }
    } catch (e) {
      _inProgress = false;
      _errorMessage = "Network error occurred";
      appLog('❌ Fetch spots by coordinates API Error: $e');
      return null;
    }
  }
}
