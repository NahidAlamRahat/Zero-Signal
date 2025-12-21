import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart' as geo;

import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;
import 'package:dio/dio.dart';
import '../../../repository/spot_repository.dart';

class HomeScreenController extends GetxController {
  late mapbox. MapWidget mapWidget;
  late mapbox.MapboxMap mapboxMap;
  geo.Position? currentPosition;
  final TextEditingController searchController = TextEditingController();
  final String mapboxAccessToken =
      'pk.eyJ1IjoibGVkZTE4IiwiYSI6ImNtZzgzcmxodDAyejIybXIzcHUyZGRyMzgifQ.jbe1XMovv8MF5TGitB9PwQ';

  List<dynamic> searchSuggestions = [];
  bool isSearching = false;
  
  // Spot related properties
  final SpotRepository _spotRepository = SpotRepository();
  List<SpotCoordinateModel> nearbySpots = [];
  bool isLoadingSpots = false;
  mapbox.PointAnnotationManager? pointAnnotationManager;

  // Map style URIs
  static const String defaultStyleUri = 'mapbox://styles/mapbox/streets-v12';
  static const String satelliteStyleUri =
      'mapbox://styles/lede18/cmg91jkk3000r01sf8m1r29ky';
  static const String terrainStyleUri =
      'mapbox://styles/lede18/cmg91k73u000s01qo5ye4bl7q';

  // Current selected map type
  String selectedMapType = 'OutDoor';
  List<mapbox.Point> markerList = [
    mapbox.Point(
        coordinates: mapbox.Position.fromJson(
            [23.77946286151694, 90.40031401135806])), // San Francisco

// New York
  ];

  Future<void> getUserLocation() async {
    bool serviceEnabled = await geo.Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar(
        "Location Service Disabled",
        "Please enable location services in your device settings.",
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 3),
      );
      return;
    }

    geo.LocationPermission permission = await geo.Geolocator.checkPermission();

    if (permission == geo.LocationPermission.deniedForever) {
      // Permission permanently denied - open app settings
      if (permission == geo.LocationPermission.deniedForever) {
        // Permission permanently denied - open app settings
        Fluttertoast.showToast(
          msg:
              "Location permission is permanently denied. Please enable it in app settings.",
          backgroundColor: Colors.red,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_LONG,
        );
        return;
      }
      return;
    }

    if (permission == geo.LocationPermission.denied) {
      permission = await geo.Geolocator.requestPermission();
      if (permission == geo.LocationPermission.denied) {
        Fluttertoast.showToast(
          msg:
              "Location permission is required to show your location on the map.",
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        return;
      }

      if (permission == geo.LocationPermission.deniedForever) {
        Fluttertoast.showToast(
          msg:
              "Location permission is permanently denied. Please enable it in app settings.",
          backgroundColor: Colors.red,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_LONG,
        );
        return;
      }
    }

    try {
      currentPosition = await geo.Geolocator.getCurrentPosition(
        desiredAccuracy: geo.LocationAccuracy.high,
      );
      update();
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Failed to get location: $e",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  /// When map created
  // Future<void> onMapCreated(mapbox.MapboxMap controller) async {
  //   mapboxMap = controller;
  //   await getUserLocation();
  //
  //   if (currentPosition != null) {
  //     // Move camera to user's location
  //     await mapboxMap.setCamera(
  //       mapbox.CameraOptions(
  //         center: mapbox.Point(
  //           coordinates: mapbox.Position.fromJson([
  //             currentPosition!.longitude,
  //             currentPosition!.latitude,
  //           ]),
  //         ),
  //         zoom: 14.0,
  //       ),
  //     );
  //
  //     // Enable location blue dot
  //     await mapboxMap.location.updateSettings(
  //       mapbox.LocationComponentSettings(
  //         enabled: true,
  //         pulsingEnabled: true,
  //         showAccuracyRing: true,
  //       ),
  //     );
  //
  //     // Enable compass (positioned below the map choice button)
  //     await mapboxMap.compass.updateSettings(
  //       mapbox.CompassSettings(
  //         enabled: true,
  //         position: mapbox.OrnamentPosition.TOP_RIGHT,
  //         marginTop: 56.0 + 50.0 + 40.0 + 10.0, // kToolbarHeight + 50 + button height + spacing
  //         marginRight: 20.0,
  //         clickable: true,
  //         fadeWhenFacingNorth: false,
  //       ),
  //     );
  //   }
  // }

  late mapbox.Point markerPoint;

  /// Load marker icon from assets and register it in map style
  Future<void> _loadMarkerIcon() async {
    try {
      print('Skipping custom icon loading - using simple colored dots');
      // For Mapbox compatibility, we'll use simple colored dots
    } catch (e) {
      print('Error in icon setup: $e');
    }
  }

  Future<void> onMapCreated(mapbox.MapboxMap controller) async {
    mapboxMap = controller;
    await getUserLocation();

    // Set style to streets-v12 which has marker-15 sprite
    await mapboxMap.loadStyleURI('mapbox://styles/mapbox/streets-v12');
    
    // Wait a bit for style to load
    await Future.delayed(Duration(seconds: 1));

    // Load marker icon
    await _loadMarkerIcon();

    // Create point annotation manager for markers
    pointAnnotationManager = await mapboxMap.annotations.createPointAnnotationManager();

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

      await mapboxMap.location.updateSettings(
        mapbox.LocationComponentSettings(
          enabled: true,
          pulsingEnabled: true,
          showAccuracyRing: true,
        ),
      );

      await mapboxMap.compass.updateSettings(
        mapbox.CompassSettings(
          enabled: true,
          position: mapbox.OrnamentPosition.TOP_RIGHT,
          marginTop: 56.0 + 50.0 + 40.0 + 10.0,
          marginRight: 20.0,
          clickable: true,
          fadeWhenFacingNorth: false,
        ),
      );

      // Disable scale bar
      await mapboxMap.scaleBar.updateSettings(
        mapbox.ScaleBarSettings(
          enabled: false,
        ),
      );

      // Fetch nearby spots when map is ready
      await fetchNearbySpots();
    }
  }

  /// Fetch nearby spots from API
  Future<void> fetchNearbySpots({double radius = 5000.0}) async {
    if (currentPosition == null) {
      Fluttertoast.showToast(
        msg: "Location not available. Please enable GPS.",
        backgroundColor: Colors.orange,
        textColor: Colors.white,
      );
      return;
    }

    isLoadingSpots = true;
    update();

    try {
      final spots = await _spotRepository.fetchSpotsByCoordinates(
        latitude: currentPosition!.latitude,
        longitude: currentPosition!.longitude,
        radius: radius, // Default 200 meters radius
      );

      if (spots != null) {
        nearbySpots = spots;
        print('DEBUG: Found ${spots.length} spots from API');
        for (int i = 0; i < spots.length; i++) {
          print('DEBUG: Spot $i: ${spots[i].title} at (${spots[i].latitude}, ${spots[i].longitude})');
        }
        await _addSpotMarkersToMap();
        
        Fluttertoast.showToast(
          msg: "Found ${spots.length} nearby spots",
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
      } else {
        Fluttertoast.showToast(
          msg: _spotRepository.errorMessage.isNotEmpty 
              ? _spotRepository.errorMessage 
              : "Failed to fetch spots",
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error fetching spots: $e",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } finally {
      isLoadingSpots = false;
      update();
    }
  }

  /// Add spot markers to the map
  Future<void> _addSpotMarkersToMap() async {
    if (pointAnnotationManager == null || nearbySpots.isEmpty) return;

    try {
      // Clear existing markers
      await pointAnnotationManager!.deleteAll();
      print('Cleared existing markers');

      // Add markers for each spot
      for (final spot in nearbySpots) {
        print('Adding marker for: ${spot.title} at (${spot.latitude}, ${spot.longitude})');
        
        await pointAnnotationManager!.create(
          mapbox.PointAnnotationOptions(
            geometry: mapbox.Point(
              coordinates: mapbox.Position.fromJson([spot.longitude, spot.latitude]),
            ),
            iconImage: "marker-15",
            iconSize: 1.5,
            textField: spot.title,
            textSize: 12,
            textOffset: [0, 1.5],
          ),
        );
      }
      print('Successfully added ${nearbySpots.length} markers to the map');

      // Move camera to the first spot so markers are visible even if user is far away.
      final first = nearbySpots.first;
      await mapboxMap.flyTo(
        mapbox.CameraOptions(
          center: mapbox.Point(
            coordinates:
                mapbox.Position.fromJson([first.longitude, first.latitude]),
          ),
          zoom: 14,
        ),
        mapbox.MapAnimationOptions(duration: 1200),
      );
    } catch (e) {
      print('Error adding spot markers: $e');
    }
  }

  // Future<void> _addSingleMarker() async {
  //   try {
  //     final pointAnnotationManager = await mapboxMap.annotations.createPointAnnotationManager();
  //
  //     await pointAnnotationManager.create(
  //       mapbox.PointAnnotationOptions(
  //         geometry: markerPoint,
  //         iconImage: 'assets/icons/location.png', // Replace with your marker icon
  //         iconSize: 20,
  //       ),
  //     );
  //     update(); // Works because UI uses GetBuilder
  //   } catch (e) {
  //     print('Error adding marker: $e');
  //   }
  // }
  //
  //
  // Future<void> _addMarkers() async {
  //   if (markerList.isEmpty) return;
  //
  //   try {
  //     final pointAnnotationManager = await mapboxMap.annotations.createPointAnnotationManager();
  //
  //     for (var position in markerList) {
  //       debugPrint('Adding marker at: ${position.coordinates}');
  //
  //       await pointAnnotationManager.create(
  //         mapbox.PointAnnotationOptions(
  //           geometry: position,
  //           iconImage: 'assets/icons/location.png', // Ensure this is the correct path
  //           iconSize: 2000,
  //         ),
  //       );
  //     }
  //     update(); // Works because UI uses GetBuilder
  //   } catch (e) {
  //     debugPrint('Error adding markers: $e');
  //   }
  // }
  /// Refresh location with smooth animation
  Future<void> refreshLocation() async {
    await getUserLocation();
    if (currentPosition != null) {
      // Use flyTo for smooth animation
      await mapboxMap.flyTo(
        mapbox.CameraOptions(
          center: mapbox.Point(
            coordinates: mapbox.Position.fromJson([
              currentPosition!.longitude,
              currentPosition!.latitude,
            ]),
          ),
          zoom: 15.0,
        ),
        mapbox.MapAnimationOptions(
          duration: 2000, // 2 seconds animation
          startDelay: 0,
        ),
      );
      
      // Refresh nearby spots after updating location
      await fetchNearbySpots();
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
      await mapboxMap.loadStyleURI(styleUri);
      selectedMapType = mapType;
      update(); // Update UI
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Failed to change map style: $e",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  /// Fetch suggestions as user types
  Future<void> fetchSuggestions(String query) async {
    if (query.isEmpty) {
      searchSuggestions = [];
      isSearching = false;
      update();
      return;
    }

    isSearching = true;
    update();

    try {
      final String url =
          "https://api.mapbox.com/geocoding/v5/mapbox.places/$query.json?access_token=$mapboxAccessToken&autocomplete=true&limit=5";

      final dio = Dio();
      final response = await dio.get(url);

      if (response.statusCode == 200) {
        searchSuggestions = response.data['features'];
      }
    } catch (e) {
      debugPrint('Suggestion Error: $e');
    } finally {
      isSearching = false;
      update();
    }
  }

  /// Search for a location and move camera
  Future<void> searchLocation(String query) async {
    if (query.isEmpty) return;

    // Clear suggestions when a search is executed
    searchSuggestions = [];
    update();

    try {
      final String url =
          "https://api.mapbox.com/geocoding/v5/mapbox.places/$query.json?access_token=$mapboxAccessToken&limit=1";

      final dio = Dio();
      final response = await dio.get(url);

      if (response.statusCode == 200 && response.data['features'].isNotEmpty) {
        final feature = response.data['features'][0];
        final List<dynamic> center = feature['center']; // [longitude, latitude]

        await mapboxMap.flyTo(
          mapbox.CameraOptions(
            center: mapbox.Point(
              coordinates: mapbox.Position.fromJson(
                  [center[0].toDouble(), center[1].toDouble()]),
            ),
            zoom: 14.0,
          ),
          mapbox.MapAnimationOptions(duration: 2000),
        );
      } else {
        Fluttertoast.showToast(msg: "Location not found");
      }
    } catch (e) {
      debugPrint('Search Error: $e');
      Fluttertoast.showToast(msg: "Error searching location");
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    mapWidget =  mapbox.MapWidget(
      cameraOptions: mapbox.CameraOptions(),
   

    );

    markerPoint = mapbox.Point(
        coordinates:
            mapbox.Position.fromJson([23.78105597835364, 90.40762703426819]));
    super.onInit();
  }
}
