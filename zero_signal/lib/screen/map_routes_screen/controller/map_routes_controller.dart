import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import '../../../constant/api_end_point.dart';
import '../../../utils/app_log/app_log.dart';
import '../../../service/api_service/api_services.dart';

class MapRoutesController extends GetxController {
  // Route data
  var routesList = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;
  var lastApiRequest = ''.obs;
  var lastApiResponse = ''.obs;
  
  // Auto-select first route
  var autoSelectedRouteIndex = 0.obs;
  
  // Location data
  var deviceLat = 23.777628.obs;
  var deviceLng = 90.4076217.obs;
  
  // Radius control
  final TextEditingController radiusController = TextEditingController(text: '2');
  var currentRadiusInMeters = 2000.0.obs;
  Timer? _radiusDebounceTimer;

  @override
  void onInit() {
    super.onInit();
    appLog('MapRoutesController initialized', type: LogType.info, source: 'CONTROLLER');
    fetchRoutes();
  }

  /// Build API endpoint with device coordinates and parameters
  String buildApiEndpoint() {
    final endpoint = '${AppApiEndPoint.instance.baseUrl}${AppApiEndPoint.getRouteEndPoint}';
    appLog('Built API endpoint: $endpoint', type: LogType.info, source: 'API');
    return endpoint;
  }

  /// Build query parameters for API request
  Map<String, dynamic> buildQueryParameters() {
    return {
      'lat': deviceLat.value,
      'lng': deviceLng.value,
      'radius': currentRadiusInMeters.value.toInt(),
      'difficulty': 'medium', // Default difficulty
      'type_of_route': 'roundtrip', // Default route type
      'limit': 10, // Limit number of results
    };
  }

  /// Update search radius and fetch routes
  void updateRadius(String value) {
    if (_radiusDebounceTimer?.isActive ?? false) _radiusDebounceTimer!.cancel();
    _radiusDebounceTimer = Timer(const Duration(milliseconds: 800), () {
      appLog('Input radius value: "$value"', type: LogType.info, source: 'RADIUS');
      if (value.isEmpty) return;
      final double? radius = double.tryParse(value);
      if (radius != null && radius > 0) {
        currentRadiusInMeters.value = radius;
        appLog('Radius updated to $currentRadiusInMeters meters. Fetching routes...', type: LogType.info, source: 'RADIUS');
        fetchRoutes();
      } else {
        appLog('Invalid radius input', type: LogType.warning, source: 'RADIUS');
      }
    });
  }

  /// Fetch routes from API using the geocode endpoint
  Future<void> fetchRoutes() async {
    appLog('=== Starting fetchRoutes() ===', type: LogType.info, source: 'API');
    isLoading.value = true;
    
    try {
      final endpoint = buildApiEndpoint();
      final queryParams = buildQueryParameters();
      
      appLog('API Request URL: $endpoint', type: LogType.info, source: 'API');
      appLog('Query Parameters: $queryParams', type: LogType.info, source: 'API');
      
      // Use ApiService for the API call
      final response = await ApiService.getApi(endpoint, queryParams: queryParams);
      
      // Store request and response for display
      lastApiRequest.value = '$endpoint?$queryParams';
      lastApiResponse.value = response.data.toString();
      
      appLog('Response Status Code: ${response.statusCode}', type: LogType.info, source: 'API');
      appLog('Response Data: ${response.data}', type: LogType.info, source: 'API');
      
      if (response.statusCode == 200 && response.data['success'] == true) {
        routesList.value = List<Map<String, dynamic>>.from(response.data['data'] ?? []);
        appLog('Successfully fetched ${routesList.length} routes', type: LogType.info, source: 'API');
        
        // Auto-select first route if available
        if (routesList.isNotEmpty) {
          autoSelectedRouteIndex.value = 0;
          appLog('Auto-selected first route: ${routesList[0]['title']}', type: LogType.info, source: 'API');
        }
      } else {
        appLog('API returned success=false or error status: ${response.statusCode}', type: LogType.warning, source: 'API');
        routesList.clear();
      }
    } catch (e) {
      appLog('Error fetching routes: $e', type: LogType.error, source: 'API');
      routesList.clear();
    } finally {
      isLoading.value = false;
      appLog('=== fetchRoutes() completed, isLoading: $isLoading ===', type: LogType.info, source: 'API');
    }
  }

  @override
  void onClose() {
    radiusController.dispose();
    _radiusDebounceTimer?.cancel();
    super.onClose();
  }
}
