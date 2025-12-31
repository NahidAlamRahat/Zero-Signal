import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'dart:typed_data';
import 'package:geolocator/geolocator.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;
import '../../../constant/api_end_point.dart';
import '../../../utils/app_log/app_log.dart';
import '../../../service/api_service/api_services.dart';

class MapRoutesController extends GetxController {
  // Route data
  var routesList = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;
  var lastApiRequest = ''.obs;
  var lastApiResponse = ''.obs;

  var isTracking = false.obs;
  var trackedPositions = <mapbox.Position>[].obs;
  StreamSubscription<Position>? _positionStream;
  
  // Auto-select first route
  var autoSelectedRouteIndex = 0.obs;
  
  // Route screenshots storage
  var routeScreenshots = <String, Uint8List>{}.obs;
  
  // Location data
  var deviceLat = 23.777628.obs;
  var deviceLng = 90.4076217.obs;
  
  // Pagination for varied results
  var currentOffset = 0.obs;
  static const int resultLimit = 10;
  
  // Radius control
  final TextEditingController radiusController = TextEditingController(text: '1');
  var currentRadiusInMeters = 1000.0.obs;
  Timer? _radiusDebounceTimer;

  @override
  void onInit() {
    super.onInit();
    appLog('MapRoutesController initialized', type: LogType.info, source: 'CONTROLLER');
    _getCurrentLocation();
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
      // Remove filters to show all routes
      // 'difficulty': 'medium', // Default difficulty
      // 'type_of_route': 'roundtrip', // Default route type
      'limit': resultLimit,
      'offset': currentOffset.value, // Add offset for pagination
      '_t': DateTime.now().millisecondsSinceEpoch, // Cache-busting timestamp
    };
  }

  /// Get current device location
  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        appLog('Location services are disabled', type: LogType.warning, source: 'LOCATION');
        fetchRoutes(); // Fetch with default location
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          appLog('Location permissions are denied', type: LogType.warning, source: 'LOCATION');
          fetchRoutes(); // Fetch with default location
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        appLog('Location permissions are permanently denied', type: LogType.warning, source: 'LOCATION');
        fetchRoutes(); // Fetch with default location
        return;
      }

      // Get current location
      final Position position = await Geolocator.getCurrentPosition(
        locationSettings: AndroidSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      deviceLat.value = position.latitude;
      deviceLng.value = position.longitude;
      
      appLog('Current location: ${position.latitude}, ${position.longitude}', type: LogType.info, source: 'LOCATION');
      
      // Fetch routes with updated location
      fetchRoutes();
    } catch (e) {
      appLog('Error getting current location: $e', type: LogType.error, source: 'LOCATION');
      fetchRoutes(); // Fetch with default location on error
    }
  }

  Future<bool> _ensureLocationPermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      appLog('Location services are disabled',
          type: LogType.warning, source: 'TRACKING');
      return false;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      appLog('Location permission not granted: $permission',
          type: LogType.warning, source: 'TRACKING');
      return false;
    }
    return true;
  }

  Future<void> startTracking() async {
    if (isTracking.value) return;

    final canTrack = await _ensureLocationPermission();
    if (!canTrack) return;

    isTracking.value = true;
    trackedPositions.clear();

    final Position pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    deviceLat.value = pos.latitude;
    deviceLng.value = pos.longitude;

    trackedPositions.add(mapbox.Position(pos.longitude, pos.latitude));

    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.best,
      distanceFilter: 5,
    );

    _positionStream?.cancel();
    _positionStream = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen(
      (Position pos) {
        deviceLat.value = pos.latitude;
        deviceLng.value = pos.longitude;
        trackedPositions.add(mapbox.Position(pos.longitude, pos.latitude));
      },
      onError: (e) {
        appLog('Position stream error: $e',
            type: LogType.error, source: 'TRACKING');
      },
    );

    appLog('Tracking started', type: LogType.info, source: 'TRACKING');
  }

  Future<void> stopTracking() async {
    if (!isTracking.value) return;
    isTracking.value = false;

    await _positionStream?.cancel();
    _positionStream = null;

    appLog('Tracking stopped. Points: ${trackedPositions.length}',
        type: LogType.info, source: 'TRACKING');
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

  /// Update search radius from slider and fetch routes
  void updateRadiusFromSlider(double value) {
    if (_radiusDebounceTimer?.isActive ?? false) _radiusDebounceTimer!.cancel();
    _radiusDebounceTimer = Timer(const Duration(milliseconds: 500), () {
      // Convert km to meters for API
      currentRadiusInMeters.value = value * 1000;
      radiusController.text = value.toStringAsFixed(1);
      appLog('Radius updated to ${currentRadiusInMeters.value} meters ($value km). Fetching routes...', type: LogType.info, source: 'RADIUS');
      currentOffset.value = 0; // Reset offset when radius changes
      fetchRoutes();
    });
  }

  /// Refresh routes with new results (next page)
  void fetchNextRoutes() {
    currentOffset.value += resultLimit;
    appLog('Fetching next routes with offset: ${currentOffset.value}', type: LogType.info, source: 'API');
    fetchRoutes();
  }

  /// Refresh routes with previous results (previous page)
  void fetchPreviousRoutes() {
    if (currentOffset.value >= resultLimit) {
      currentOffset.value -= resultLimit;
      appLog('Fetching previous routes with offset: ${currentOffset.value}', type: LogType.info, source: 'API');
      fetchRoutes();
    }
  }

  /// Reset and fetch routes from beginning
  void resetAndFetchRoutes() {
    currentOffset.value = 0;
    appLog('Resetting offset and fetching routes', type: LogType.info, source: 'API');
    fetchRoutes();
  }

  /// Refresh routes with random offset for variety
  void fetchRandomRoutes() {
    // Generate a random offset between 0 and 50
    final randomOffset = (DateTime.now().millisecondsSinceEpoch % 5) * resultLimit;
    currentOffset.value = randomOffset;
    appLog('Fetching random routes with offset: $randomOffset', type: LogType.info, source: 'API');
    fetchRoutes();
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
    _positionStream?.cancel();
    radiusController.dispose();
    _radiusDebounceTimer?.cancel();
    super.onClose();
  }

  // Store route screenshot
  void setRouteScreenshot(String routeId, Uint8List screenshot) {
    routeScreenshots[routeId] = screenshot;
    appLog('Screenshot stored for route: $routeId', type: LogType.info, source: 'MAP');
  }

  // Get route screenshot
  Uint8List? getRouteScreenshot(String routeId) {
    return routeScreenshots[routeId];
  }
}
