import 'package:get/get.dart';
import '../../constant/api_end_point.dart';
import '../../screen/my_spots_screen/model/my_spots_response_model.dart';
import '../../service/api_service/api_services.dart';
import '../../utils/app_log/app_log.dart';

/// CommonRepository: Reusable repository for common API calls
/// This can be used across different screens to fetch spots data
class CommonRepository extends GetxController {
  bool _inProgress = false;
  bool get inProgress => _inProgress;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  String _successMessage = '';
  String get successMessage => _successMessage;

  /// Fetch spots list with optional pagination
  /// Can be used for "My Spots", "All Spots", or any spot listing screen
  ///
  /// Parameters:
  /// - page: page number (default: 1)
  /// - limit: items per page (default: 10)
  ///
  /// Returns: MySpotsResponseModel or null if failed
  Future<MySpotsResponseModel?> fetchSpots({
    int? page,
    int? limit,
  }) async {
    _inProgress = true;
    _errorMessage = '';
    _successMessage = '';
    update();

    try {
      Map<String, dynamic> queryParams = {};

      if (page != null) {
        queryParams['page'] = page.toString();
      }

      if (limit != null) {
        queryParams['limit'] = limit.toString();
      }

      final response = await ApiService.getApi(
        AppApiEndPoint.mySpotEndPoint,
        queryParams: queryParams.isNotEmpty ? queryParams : null,
      );

      _inProgress = false;

      if (response.statusCode == 200) {
        _successMessage = response.message.isNotEmpty
            ? response.message
            : "Spots retrieved successfully";

        final MySpotsResponseModel spotsResponse =
            MySpotsResponseModel.fromJson(
                Map<String, dynamic>.from(response.body));

        appLog(
            'Spots fetched successfully: ${spotsResponse.data.length} spots');
        update();
        return spotsResponse;
      } else {
        _errorMessage = response.message.isNotEmpty
            ? response.message
            : "Failed to fetch spots";
        appLog(
            'Fetch spots failed - Status: ${response.statusCode}, Message: ${response.message}');
        update();
        return null;
      }
    } catch (e) {
      _inProgress = false;
      _errorMessage = "Network error occurred";
      appLog('Fetch spots API Error: $e');
      update();
      return null;
    }
  }

  /// Fetch single spot details by ID
  /// Can be used for spot detail screens
  ///
  /// Parameters:
  /// - id: spot ID
  ///
  /// Returns: SpotData or null if failed
  Future<SpotData?> fetchSpotDetails(String id) async {
    _inProgress = true;
    _errorMessage = '';
    _successMessage = '';
    update();

    try {
      final response = await ApiService.getApi(
        AppApiEndPoint.instance.mySpotDetailEndPoint(id),
      );

      _inProgress = false;

      if (response.statusCode == 200) {
        _successMessage = response.message.isNotEmpty
            ? response.message
            : "Spot details retrieved successfully";

        final SpotData spotData =
            SpotData.fromJson(response.body['data'] as Map<String, dynamic>);

        appLog('Spot details fetched successfully: ${spotData.title}');
        update();
        return spotData;
      } else {
        _errorMessage = response.message.isNotEmpty
            ? response.message
            : "Failed to fetch spot details";
        appLog(
            'Fetch spot details failed - Status: ${response.statusCode}, Message: ${response.message}');
        update();
        return null;
      }
    } catch (e) {
      _inProgress = false;
      _errorMessage = "Network error occurred";
      appLog('Fetch spot details API Error: $e');
      update();
      return null;
    }
  }

  /// Delete a spot by ID
  /// Can be used for spot deletion functionality
  ///
  /// Parameters:
  /// - id: spot ID
  ///
  /// Returns: true if successful, false otherwise
  Future<bool> deleteSpot(String id) async {
    _inProgress = true;
    _errorMessage = '';
    _successMessage = '';
    update();

    try {
      final response = await ApiService.deleteApi(
        url: '${AppApiEndPoint.mySpotEndPoint}/$id',
        body: {},
      );

      _inProgress = false;

      if (response.statusCode == 200) {
        _successMessage = response.message.isNotEmpty
            ? response.message
            : "Spot deleted successfully";
        appLog('Spot deleted successfully');
        update();
        return true;
      } else {
        _errorMessage = response.message.isNotEmpty
            ? response.message
            : "Failed to delete spot";
        appLog(
            'Delete spot failed - Status: ${response.statusCode}, Message: ${response.message}');
        update();
        return false;
      }
    } catch (e) {
      _inProgress = false;
      _errorMessage = "Network error occurred";
      appLog('Delete spot API Error: $e');
      update();
      return false;
    }
  }

  /// Toggle favorite status for a spot
  /// Can be used for favorite toggle functionality
  ///
  /// Parameters:
  /// - id: item ID (mapped to 'item' in body)
  /// - type: item type (e.g. 'Spot', 'Activity')
  ///
  /// Returns: true if successful, false otherwise
  Future<bool> toggleFavorite(
      {required String id, required String type}) async {
    _inProgress = true;
    _errorMessage = '';
    _successMessage = '';
    update();

    try {
      final response = await ApiService.postApi(
        AppApiEndPoint.toggleFavoriteEndPoint(),
        {
          'item': id,
          'type': type,
        },
      );

      _inProgress = false;

      if (response.statusCode == 200 || response.statusCode == 201) {
        _successMessage = response.message.isNotEmpty
            ? response.message
            : "Favorite status updated successfully";
        appLog('Favorite status updated successfully');
        update();
        return true;
      } else {
        _errorMessage = response.message.isNotEmpty
            ? response.message
            : "Failed to update favorite status";
        appLog(
            'Favorite toggle failed - Status: ${response.statusCode}, Message: ${response.message}');
        update();
        return false;
      }
    } catch (e) {
      _inProgress = false;
      _errorMessage = "Network error occurred";
      appLog('Favorite toggle API Error: $e');
      update();
      return false;
    }
  }

  /// Fetch favorite spots
  /// Endpoint: /favorite?type=Spot
  Future<MySpotsResponseModel?> fetchFavoriteSpots({
    int? page,
    int? limit,
  }) async {
    _inProgress = true;
    _errorMessage = '';
    _successMessage = '';
    update();

    try {
      Map<String, dynamic> queryParams = {};

      // Add type parameter
      // queryParams['type'] = 'Spot';

      if (page != null) {
        queryParams['page'] = page.toString();
      }

      if (limit != null) {
        queryParams['limit'] = limit.toString();
      }

      final response = await ApiService.getApi(
        AppApiEndPoint.instance.getFavoriteEndPoint("Spot"),
        queryParams: queryParams.isNotEmpty ? queryParams : null,
      );

      _inProgress = false;

      if (response.statusCode == 200) {
        _successMessage = response.message.isNotEmpty
            ? response.message
            : "Favorite spots retrieved successfully";

        final MySpotsResponseModel spotsResponse =
            MySpotsResponseModel.fromJson(
                Map<String, dynamic>.from(response.body));

        appLog(
            'Favorite Spots fetched successfully: ${spotsResponse.data.length} spots');
        update();
        return spotsResponse;
      } else {
        _errorMessage = response.message.isNotEmpty
            ? response.message
            : "Failed to fetch favorite spots";
        appLog(
            'Fetch favorite spots failed - Status: ${response.statusCode}, Message: ${response.message}');
        update();
        return null;
      }
    } catch (e) {
      _inProgress = false;
      _errorMessage = "Network error occurred";
      appLog('Fetch favorite spots API Error: $e');
      update();
      return null;
    }
  }
}
