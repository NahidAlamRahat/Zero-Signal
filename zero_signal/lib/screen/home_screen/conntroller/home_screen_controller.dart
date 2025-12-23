import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart' as geo;

import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/services.dart';

import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;
import 'package:dio/dio.dart';
import '../../../repository/spot_repository.dart';
import '../../../routes/app_routes.dart';

class HomeScreenController extends GetxController implements mapbox.OnPointAnnotationClickListener {
  late mapbox.MapWidget mapWidget;
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
  Map<String, SpotCoordinateModel> markerSpotMap = {}; // Map to store spot data by marker ID

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



  late mapbox.Point markerPoint;

  /// Load marker icon from assets and register it in map style
  Future<void> _loadMarkerIcon() async {
    try {
      print('DEBUG: Loading custom marker icon');
      
      // Load the marker image from assets
      final ByteData data = await rootBundle.load('assets/icons/location.png');
      final uint8List = data.buffer.asUint8List();
      print('DEBUG: Loaded marker from assets, size: ${uint8List.length} bytes');
      
      // Decode the image to get its actual dimensions
      final image = await decodeImageFromList(uint8List);
      print('DEBUG: Image dimensions: ${image.width}x${image.height}');
      
      // Create MbxImage with actual image dimensions
      final mbxImage = mapbox.MbxImage(
        width: image.width,
        height: image.height,
        data: uint8List,
      );
      
      // Add the image to the map style
      await mapboxMap.style.addStyleImage(
        "custom-marker",
        1.0,
        mbxImage,
        false,
        [],
        [],
        null,
      );
      print('DEBUG: Custom marker image added to style');
      
    } catch (e) {
      print('ERROR: Failed to load marker icon: $e');
    }
  }

  /// Create a simple red dot marker image
  Future<Uint8List> _createSimpleMarkerImage() async {
    try {
      // For simplicity, use a pre-made marker image from assets
      final ByteData data = await rootBundle.load('assets/icons/location.png');
      print('DEBUG: Loaded marker from assets');
      return data.buffer.asUint8List();
    } catch (e) {
      print('DEBUG: Assets icon not found: $e');
      // If asset doesn't exist, return empty list

      return _createFallbackMarkerBytes();
    }
  }

  /// Create a fallback marker (simple colored pixel)
  Uint8List _createFallbackMarkerBytes() {
    // Create a simple 16x16 PNG with red color
    // This is a minimal PNG file representation of a red dot
    final bytes = <int>[
      0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, // PNG signature
      0x00, 0x00, 0x00, 0x0D, 0x49, 0x48, 0x44, 0x52, // IHDR chunk
      0x00, 0x00, 0x00, 0x10, 0x00, 0x00, 0x00, 0x10,
      0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0xF3, 0xFF,
      0x61, 0x00, 0x00, 0x00, 0x4A, 0x49, 0x44, 0x41,
      0x54, 0x78, 0x9C, 0xED, 0xC1, 0x01, 0x0D, 0x00,
      0x00, 0x00, 0xC2, 0xA0, 0xF5, 0x4F, 0x6D, 0x0E,
      0x37, 0xA0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
      0x00, 0xB0, 0xFF, 0x00, 0x01, 0xFE, 0x7B, 0xEE,
      0x41, 0xFE, 0x00, 0x00, 0x00, 0x00, 0x49, 0x45,
      0x4E, 0x44, 0xAE, 0x42, 0x60, 0x82
    ];
    return Uint8List.fromList(bytes);
  }

  Future<void> onMapCreated(mapbox.MapboxMap controller) async {
    mapboxMap = controller;
    print('DEBUG: Map created, initializing...');
    
    await getUserLocation();

    // Set style to streets-v12 which has marker-15 sprite
    try {
      await mapboxMap.loadStyleURI('mapbox://styles/mapbox/streets-v12');
      print('DEBUG: Style loaded successfully');
    } catch (e) {
      print('DEBUG: Error loading style: $e');
    }
    
    // Wait longer for style to load completely
    await Future.delayed(Duration(seconds: 2));

    // Load marker icon
    await _loadMarkerIcon();

    // Create point annotation manager for markers
    try {
      pointAnnotationManager = await mapboxMap.annotations.createPointAnnotationManager();
      print('DEBUG: Point annotation manager created');
      
      // Add tap listener for markers
      pointAnnotationManager?.addOnPointAnnotationClickListener(this);
      print('DEBUG: Marker tap listener added');
    } catch (e) {
      print('DEBUG: Error creating annotation manager: $e');
    }

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
    print('DEBUG: _addSpotMarkersToMap called');
    print('DEBUG: pointAnnotationManager: $pointAnnotationManager');
    print('DEBUG: nearbySpots.length: ${nearbySpots.length}');
    
    if (pointAnnotationManager == null) {
      print('ERROR: pointAnnotationManager is null!');
      return;
    }
    
    if (nearbySpots.isEmpty) {
      print('WARNING: nearbySpots is empty!');
      return;
    }

    try {
      // Clear existing markers and spot map
      await pointAnnotationManager!.deleteAll();
      markerSpotMap.clear();
      print('DEBUG: Cleared existing markers');

      // Add markers for each spot
      for (final spot in nearbySpots) {
        print('DEBUG: Adding marker for: ${spot.title} at (${spot.latitude}, ${spot.longitude})');
        
        try {
          final annotation = await pointAnnotationManager!.create(
            mapbox.PointAnnotationOptions(
              geometry: mapbox.Point(
                coordinates: mapbox.Position.fromJson([spot.longitude, spot.latitude]),
              ),
              iconImage: "custom-marker", // Use the custom marker we loaded
              iconSize: 1.0,
              textField: spot.title,
              textSize: 12,
              textOffset: [0, 2.0],
              textColor: Colors.black.value,
            ),
          );
          
          // Store spot data with marker ID
          markerSpotMap[annotation.id] = spot;
          print('DEBUG: Stored spot data for marker: ${annotation.id}');
          
        } catch (markerError) {
          print('ERROR: Failed to create marker for ${spot.title}: $markerError');
        }
      }
      print('DEBUG: Successfully added ${nearbySpots.length} markers to the map');

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
        mapbox.MapAnimationOptions(duration: 2000),
      );
    } catch (e) {
      print('Error adding spot markers: $e');
    }
  }

  @override
  void onPointAnnotationClick(mapbox.PointAnnotation annotation) {
    final spot = markerSpotMap[annotation.id];
    if (spot != null) {
      print('DEBUG: Marker tapped: ${spot.title}');
      
      // Navigate to spot details screen
      Get.toNamed(
        AppRoutes.spotDetailsScreen,
        arguments: {
          'spotId': spot.id,
          'title': spot.title,
          'latitude': spot.latitude,
          'longitude': spot.longitude,
          'description': spot.description,
          'address': spot.address,
        },
      );
      
      Fluttertoast.showToast(
        msg: "Opening ${spot.title}",
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    } else {
      print('DEBUG: No spot data found for marker: ${annotation.id}');
      Fluttertoast.showToast(
        msg: "Spot information not available",
        backgroundColor: Colors.orange,
        textColor: Colors.white,
      );
    }
  }

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
    mapWidget = mapbox.MapWidget(
      onMapCreated: onMapCreated,
      cameraOptions: mapbox.CameraOptions(),
    );

    markerPoint = mapbox.Point(
        coordinates:
            mapbox.Position.fromJson([23.78105597835364, 90.40762703426819]));
    super.onInit();
  }
}