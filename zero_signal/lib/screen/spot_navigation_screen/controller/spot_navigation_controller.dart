import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;
import 'package:dio/dio.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:math';
import 'dart:io';

class SpotNavigationController extends GetxController {
  // Mapbox map instance
  late mapbox.MapboxMap mapboxMap;
  mapbox.PointAnnotationManager? pointAnnotationManager;
  mapbox.PolylineAnnotationManager? polylineAnnotationManager;
  
  // HTTP client for API calls
  final Dio _dio = Dio();
  
  // Screenshot controller
  final ScreenshotController screenshotController = ScreenshotController();
  
  // Mapbox access token
  final String mapboxAccessToken = 'pk.eyJ1IjoibGVkZTE4IiwiYSI6ImNtZzgzcmxodDAyejIybXIzcHUyZGRyMzgifQ.jbe1XMovv8MF5TGitB9PwQ';
  
  // Spot data
  final RxString spotId = ''.obs;
  final RxString spotTitle = ''.obs;
  final RxDouble spotLatitude = 0.0.obs;
  final RxDouble spotLongitude = 0.0.obs;
  
  // Current location
  final RxDouble currentLatitude = 0.0.obs;
  final RxDouble currentLongitude = 0.0.obs;
  
  // Distance calculation
  final RxDouble distance = 0.0.obs;
  final RxBool isLoading = false.obs;
  final RxBool hasRoute = false.obs;
  final RxBool mapInitialized = false.obs;

  /// Get route from Mapbox Directions API
  Future<List<mapbox.Position>?> getMapboxRoute(
    double startLat, double startLon, double endLat, double endLon) async {
    try {
      final String url =
          'https://api.mapbox.com/directions/v5/mapbox/driving/$startLon,$startLat;$endLon,$endLat'
          '?access_token=$mapboxAccessToken'
          '&geometries=geojson'
          '&overview=full';

      final response = await _dio.get(url);
      
      if (response.statusCode == 200) {
        final data = response.data;
        final routes = data['routes'] as List;
        if (routes.isNotEmpty) {
          final geometry = routes[0]['geometry'];
          final coordinates = geometry['coordinates'] as List;
          
          // Convert coordinates to Position list
          return coordinates.map((coord) {
            return mapbox.Position(coord[0], coord[1]);
          }).toList();
        }
      }
    } catch (e) {
      // Handle error silently
    }
    return null;
  }

  @override
  void onInit() {
    super.onInit();
    // Get spot data from arguments
    final arguments = Get.arguments as Map<String, dynamic>?;
    if (arguments != null) {
      spotId.value = arguments['spotId'] ?? '';
      spotTitle.value = arguments['title'] ?? 'Unknown Spot';
      spotLatitude.value = arguments['latitude']?.toDouble() ?? 0.0;
      spotLongitude.value = arguments['longitude']?.toDouble() ?? 0.0;
    }
    
    // Get current location
    getCurrentLocation();
  }

  /// Get current device location
  Future<void> getCurrentLocation() async {
    try {
      // Check location services
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return;
      }

      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      currentLatitude.value = position.latitude;
      currentLongitude.value = position.longitude;
      
      // Calculate distance
      calculateDistance();
      
    } catch (e) {
      // Handle error silently
    }
  }

  /// Calculate distance between current location and spot
  void calculateDistance() {
    if (currentLatitude.value == 0 || currentLongitude.value == 0 ||
        spotLatitude.value == 0 || spotLongitude.value == 0) {
      return;
    }

    double calculatedDistance = _calculateDistance(
      currentLatitude.value,
      currentLongitude.value,
      spotLatitude.value,
      spotLongitude.value,
    );
    
    distance.value = calculatedDistance;
  }

  /// Calculate distance using Haversine formula
  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371; // Earth's radius in kilometers
    
    double dLat = _toRadians(lat2 - lat1);
    double dLon = _toRadians(lon2 - lon1);
    
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) * cos(_toRadians(lat2)) *
        sin(dLon / 2) * sin(dLon / 2);
    
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    
    return earthRadius * c;
  }

  double _toRadians(double degrees) {
    return degrees * (pi / 180);
  }

  /// Initialize map
  Future<void> onMapCreated(mapbox.MapboxMap controller) async {
    mapboxMap = controller;
    mapInitialized.value = true;

    try {
      await mapboxMap.loadStyleURI('mapbox://styles/mapbox/streets-v12');
    } catch (e) {
      // Handle error silently
    }

    // Initialize annotation managers
    try {
      pointAnnotationManager = await mapboxMap.annotations.createPointAnnotationManager();
      polylineAnnotationManager = await mapboxMap.annotations.createPolylineAnnotationManager();
    } catch (e) {
      // Handle error silently
    }

    // Add markers and calculate initial route
    await addMarkers();
    // Note: calculateRoute is called by user action, not during initialization

    // Disable compass and scale bar
    await mapboxMap.compass.updateSettings(
      mapbox.CompassSettings(enabled: false),
    );
    await mapboxMap.scaleBar.updateSettings(
      mapbox.ScaleBarSettings(enabled: false),
    );
  }

  /// Add markers for current location and spot
  Future<void> addMarkers() async {
    if (pointAnnotationManager == null) return;

    try {
      // Clear existing markers
      await pointAnnotationManager?.deleteAll();

      // Add current location marker (blue)
      if (currentLatitude.value != 0 && currentLongitude.value != 0) {
        await pointAnnotationManager!.create(
          mapbox.PointAnnotationOptions(
            geometry: mapbox.Point(
              coordinates: mapbox.Position.fromJson([
                currentLongitude.value,
                currentLatitude.value,
              ]),
            ),
            iconImage: "marker-15",
            iconSize: 2.0,
          ),
        );
      }

      // Add spot location marker (red)
      if (spotLatitude.value != 0 && spotLongitude.value != 0) {
        await pointAnnotationManager!.create(
          mapbox.PointAnnotationOptions(
            geometry: mapbox.Point(
              coordinates: mapbox.Position.fromJson([
                spotLongitude.value,
                spotLatitude.value,
              ]),
            ),
            iconImage: "marker-15",
            iconSize: 2.0,
          ),
        );
      }
    } catch (e) {
      // Handle error silently
    }
  }

  /// Calculate and draw route between current location and spot
  Future<void> calculateRoute() async {
    if (currentLatitude.value == 0 || currentLongitude.value == 0 ||
        spotLatitude.value == 0 || spotLongitude.value == 0) {
      return;
    }

    isLoading.value = true;

    try {
      // Draw route line between current location and spot
      await drawRouteLine();
      await centerMap();
      
      hasRoute.value = true;
    } catch (e) {
      // Handle error silently without snackbar
    } finally {
      isLoading.value = false;
    }
  }

  /// Draw route line on map using actual roads
  Future<void> drawRouteLine() async {
    if (polylineAnnotationManager == null) return;

    try {
      // Clear existing route
      await polylineAnnotationManager?.deleteAll();

      // Get route from Mapbox Directions API
      final routeCoordinates = await getMapboxRoute(
        currentLatitude.value,
        currentLongitude.value,
        spotLatitude.value,
        spotLongitude.value,
      );

      List<mapbox.Position> coordinates;
      
      if (routeCoordinates != null) {
        // Use actual road route from API
        coordinates = routeCoordinates;
      } else {
        // Fallback to straight line if API fails
        coordinates = [
          mapbox.Position(currentLongitude.value, currentLatitude.value),
          mapbox.Position(spotLongitude.value, spotLatitude.value),
        ];
      }

      // Create polyline annotation for route
      await polylineAnnotationManager!.create(
        mapbox.PolylineAnnotationOptions(
          geometry: mapbox.LineString(coordinates: coordinates),
          lineColor: 0xFF10B981, // Green color for route
          lineWidth: 4.0,
        ),
      );
    } catch (e) {
      // Handle error silently
    }
  }

  /// Center map to show both markers
  Future<void> centerMap() async {
    if (currentLatitude.value == 0 || currentLongitude.value == 0 ||
        spotLatitude.value == 0 || spotLongitude.value == 0) {
      return;
    }

    // Check if map is initialized
    if (!mapInitialized.value) {
      return;
    }

    try {
      // Calculate center point
      double centerLat = (currentLatitude.value + spotLatitude.value) / 2;
      double centerLon = (currentLongitude.value + spotLongitude.value) / 2;

      // Calculate appropriate zoom level to show both points
      double distance = _calculateDistance(
        currentLatitude.value,
        currentLongitude.value,
        spotLatitude.value,
        spotLongitude.value,
      );

      double zoom = _getZoomLevelForDistance(distance);

      await mapboxMap.flyTo(
        mapbox.CameraOptions(
          center: mapbox.Point(
            coordinates: mapbox.Position.fromJson([centerLon, centerLat]),
          ),
          zoom: zoom,
        ),
        mapbox.MapAnimationOptions(duration: 1000),
      );
    } catch (e) {
      // Handle error silently
    }
  }

  /// Get appropriate zoom level based on distance
  double _getZoomLevelForDistance(double distance) {
    if (distance < 1) return 16.0;
    if (distance < 5) return 14.0;
    if (distance < 20) return 12.0;
    if (distance < 50) return 10.0;
    return 8.0;
  }

  /// Capture screenshot of the route and return to details screen
  Future<void> captureRouteScreenshot() async {
    try {
      // Capture screenshot
      final imageFile = await screenshotController.capture();
      if (imageFile != null) {
        // Get application documents directory
        final directory = await getApplicationDocumentsDirectory();
        final screenshotsDir = Directory('${directory.path}/route_screenshots');
        
        // Create directory if it doesn't exist
        if (!await screenshotsDir.exists()) {
          await screenshotsDir.create(recursive: true);
        }
        
        // Save screenshot with timestamp
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final fileName = 'route_${spotTitle.value}_$timestamp.png';
        final savedFile = File('${screenshotsDir.path}/$fileName');
        
        await savedFile.writeAsBytes(imageFile);
        
        // Show success message (optional, can be removed if not needed)
        print('Route screenshot saved: ${savedFile.path}');
      }
    } catch (e) {
      // Handle error silently
      print('Failed to capture screenshot: $e');
    }
    
    // Go back to details screen
    Get.back();
  }
}
