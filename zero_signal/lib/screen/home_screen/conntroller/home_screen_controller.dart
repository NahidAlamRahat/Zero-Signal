import 'dart:math' as Math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;
import '../model/spot_model.dart';

class HomeScreenController extends GetxController {
  late mapbox.MapboxMap mapboxMap;
  geo.Position? currentPosition;
  
  // Map style URIs
  static const String defaultStyleUri = 'mapbox://styles/mapbox/streets-v12';
  static const String satelliteStyleUri = 'mapbox://styles/lede18/cmg91jkk3000r01sf8m1r29ky';
  static const String terrainStyleUri = 'mapbox://styles/lede18/cmg91k73u000s01qo5ye4bl7q';
  
  String selectedMapType = 'OutDoor';
  List<SpotModel> nearbySpots = [];
  bool isLoading = true;


  Future<void> getUserLocation() async {
    bool serviceEnabled = await geo.Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar("Error", "Location services are disabled.");
      return;
    }

    geo.LocationPermission permission = await geo.Geolocator.checkPermission();
    if (permission == geo.LocationPermission.denied) {
      permission = await geo.Geolocator.requestPermission();
      if (permission == geo.LocationPermission.denied) {
        Get.snackbar("Error", "Location permission denied.");
        return;
      }
    }

    if (permission == geo.LocationPermission.deniedForever) {
      Get.snackbar("Error", "Location permission permanently denied.");
      return;
    }

    currentPosition = await geo.Geolocator.getCurrentPosition(
      desiredAccuracy: geo.LocationAccuracy.high,
    );
    update();
  }

  /// When map created
  Future<void> onMapCreated(mapbox.MapboxMap controller) async {
    mapboxMap = controller;
    await getUserLocation();

    if (currentPosition != null) {
      // Move camera to user's location
      await mapboxMap.setCamera(
        mapbox.CameraOptions(
          center: mapbox.Point(
            coordinates: mapbox.Position.fromJson([
              currentPosition!.longitude,
              currentPosition!.latitude,
            ]),
          ),
          zoom: 14.0,
        ),
      );

      // Enable location blue dot
      await mapboxMap.location.updateSettings(
        mapbox.LocationComponentSettings(
          enabled: true,
          pulsingEnabled: true,
          showAccuracyRing: true,
        ),
      );

      // Enable compass ornament (positioned below the map choice button)
      await mapboxMap.compass.updateSettings(
        mapbox.CompassSettings(
          enabled: true,
          position: mapbox.OrnamentPosition.TOP_RIGHT,
          marginTop:  kToolbarHeight + 100.h,
          marginRight: 20.0,
          clickable: true,
          fadeWhenFacingNorth: false,
          visibility: true,
        ),
      );
    }
  }

  /// Refresh location
  Future<void> refreshLocation() async {
    await getUserLocation();
    if (currentPosition != null) {
      await mapboxMap.setCamera(
        mapbox.CameraOptions(
          center: mapbox.Point(
            coordinates: mapbox.Position.fromJson([
              currentPosition!.longitude,
              currentPosition!.latitude,
            ]),
          ),
          zoom: 14.0,
        ),
      );
    }
  }

  /// Initialize location
  Future<void> initializeLocation() async {
    try {
      await fetchNearbySpots();
    } catch (e) {
      print('Error initializing location: $e');
      Get.snackbar('Error', 'Failed to get location: $e');
    } finally {
      isLoading = false;
      update();
    }
  }

  /// Update map style based on selection
  Future<void> updateMapStyle(String mapType) async {
    String styleUri;
    switch (mapType) {
      case 'Satellite':
        styleUri = satelliteStyleUri;
        break;
      case 'Terrain':
        styleUri = terrainStyleUri;
        break;
      case 'OutDoor':
      default:
        styleUri = defaultStyleUri;
        break;
    }

    try {
      // await mapboxMap.loadStyleURI(styleUri);
    } catch (e) {
      Get.snackbar('Error', 'Error changing map style: $e');
    }
  }

  /// Fetch nearby spots
  Future<void> fetchNearbySpots() async {
    if (currentPosition == null) return;

    // Sample spots data - Replace with your actual API call
    final allSpots = [
      SpotModel(
        id: '1',
        name: 'Basmati Singh Stadium',
        latitude: 24.8607,
        longitude: 67.0011,
        type: 'landmark',
      ),
      SpotModel(
        id: '2',
        name: 'Rani Bagh',
        latitude: 24.8620,
        longitude: 67.0025,
        type: 'park',
      ),
      SpotModel(
        id: '3',
        name: 'Jantar Mantar',
        latitude: 24.8545,
        longitude: 67.0015,
        type: 'landmark',
      ),
      SpotModel(
        id: '4',
        name: 'Connaught Place',
        latitude: 24.8550,
        longitude: 67.0020,
        type: 'market',
      ),
    ];

    // Filter spots within 5 km radius
    final nearby = allSpots.where((spot) {
      double distance = calculateDistance(
        currentPosition!.latitude,
        currentPosition!.longitude,
        spot.latitude,
        spot.longitude,
      );
      return distance <= 5; // 5 km radius
    }).toList();

    nearbySpots = nearby;
    update();
  }

  /// Calculate distance between two coordinates
  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const p = 0.017453292519943295; // Math.PI / 180
    final a = 0.5 -
        Math.cos((lat2 - lat1) * p) / 2 +
        Math.cos(lat1 * p) *
            Math.cos(lat2 * p) *
            (1 - Math.cos((lon2 - lon1) * p)) /
            2;
    return 12742 * Math.asin(Math.sqrt(a)); // 2 * R; R = 6371 km
  }

  /// Get marker icon name based on spot type
  String getMarkerIconName(String type) {
    switch (type) {
      case 'restaurant':
        return 'restaurant_marker';
      case 'park':
        return 'park_marker';
      case 'landmark':
        return 'landmark_marker';
      case 'market':
        return 'market_marker';
      default:
        return 'default_marker';
    }
  }
}
