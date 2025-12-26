import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;
import 'package:dio/dio.dart';
import '../../../repository/spot_repository.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/app_log/app_log.dart';

class PointAnnotationClickListener implements mapbox.OnPointAnnotationClickListener {
  final HomeScreenController controller;
  
  PointAnnotationClickListener(this.controller);
  
  @override
  void onPointAnnotationClick(mapbox.PointAnnotation annotation) {
    controller.onPointAnnotationTap(annotation);
  }
}

class HomeScreenController extends GetxController {
  late mapbox.MapWidget mapWidget;
  late mapbox.MapboxMap mapboxMap;
  geo.Position? currentPosition;
  final TextEditingController searchController = TextEditingController();
  // Radius control
  final TextEditingController radiusController =
      TextEditingController(text: '2');
  double currentRadiusInMeters = 2.0;
  Timer? _radiusDebounceTimer;

  final String mapboxAccessToken =
      'pk.eyJ1IjoibGVkZTE4IiwiYSI6ImNtZzgzcmxodDAyejIybXIzcHUyZGRyMzgifQ.jbe1XMovv8MF5TGitB9PwQ';

  List<dynamic> searchSuggestions = [];
  bool isSearching = false;

  // Offline map properties
  bool isOfflineMapAvailable = false;
  bool useOfflineMap = false;
  String offlineMapPath = '';

  // Spot related properties
  final SpotRepository _spotRepository = SpotRepository();
  List<SpotCoordinateModel> nearbySpots = [];
  bool isLoadingSpots = false;
  mapbox.PointAnnotationManager? pointAnnotationManager;
  Map<String, SpotCoordinateModel> markerSpotMap =
      {}; // Map to store spot data by marker ID

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

  /// Update search radius and fetch spots
  void updateRadius(String kmValue) {
    if (_radiusDebounceTimer?.isActive ?? false) _radiusDebounceTimer!.cancel();
    _radiusDebounceTimer = Timer(const Duration(milliseconds: 800), () {
      appLog('DEBUG: Input radius value: "$kmValue"');
      if (kmValue.isEmpty) return;
      final double? km = double.tryParse(kmValue);
      if (km != null && km > 0) {
        currentRadiusInMeters = km; // User requested KM
        appLog('DEBUG: Radius updated to $currentRadiusInMeters (KM/Units). Fetching spots...');
        fetchNearbySpots();
      } else {
        appLog('DEBUG: Invalid radius input');
      }
    });
  }

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
        locationSettings: geo.LocationSettings(
          accuracy: geo.LocationAccuracy.high,
        ),
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

      // Load the marker image from assets
      final ByteData data = await rootBundle.load('assets/icons/location.png');
      final uint8List = data.buffer.asUint8List();
      
      

      // Decode the image to get its actual dimensions
      final image = await decodeImageFromList(uint8List);
      

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
    } catch (e) {
      appLog('Failed to load marker icon: $e');
    }
  }



  Future<void> onMapCreated(mapbox.MapboxMap controller) async {
    mapboxMap = controller;


    await getUserLocation();

    // Set style to streets-v12 which has marker-15 sprite
    try {
      await mapboxMap.loadStyleURI('mapbox://styles/mapbox/streets-v12');
    } catch (e) {
      appLog('Failed to load style: $e');
    }

    // Wait longer for style to load completely
    await Future.delayed(Duration(seconds: 2));

    // Load marker icon
    await _loadMarkerIcon();

    // Create point annotation manager for markers
    try {
      pointAnnotationManager =
          await mapboxMap.annotations.createPointAnnotationManager();

      // Add tap listener for markers
      final listener = PointAnnotationClickListener(this);
      pointAnnotationManager?.addOnPointAnnotationClickListener(listener);
    } catch (e) {
      appLog('Failed to add annotation listener: $e');
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
  Future<void> fetchNearbySpots() async {
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
        radius: currentRadiusInMeters,
      );

      if (spots != null) {
        nearbySpots = spots;
        appLog('DEBUG: Found ${spots.length} spots from API');
        for (int i = 0; i < spots.length; i++) {
          appLog(
              'DEBUG: Spot $i: ${spots[i].title} at (${spots[i].latitude}, ${spots[i].longitude})');
        }
        await _addSpotMarkersToMap();

        Fluttertoast.showToast(
          msg:
              "Found ${spots.length} nearby spots in ${currentRadiusInMeters / 1000}km",
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
      } else {
        nearbySpots = []; // Clear if null
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
    appLog('DEBUG: _addSpotMarkersToMap called');
    appLog('DEBUG: pointAnnotationManager: $pointAnnotationManager');
    appLog('DEBUG: nearbySpots.length: ${nearbySpots.length}');

    if (pointAnnotationManager == null) {
      appLog('ERROR: pointAnnotationManager is null!');
      return;
    }

    if (nearbySpots.isEmpty) {
      appLog('WARNING: nearbySpots is empty!');
      return;
    }

    try {
      // Clear existing markers and spot map
      await pointAnnotationManager!.deleteAll();
      markerSpotMap.clear();
      appLog('DEBUG: Cleared existing markers');

      // Add markers for each spot
      for (final spot in nearbySpots) {
        appLog(
            'DEBUG: Adding marker for: ${spot.title} at (${spot.latitude}, ${spot.longitude})');

        try {
          final annotation = await pointAnnotationManager!.create(
            mapbox.PointAnnotationOptions(
              geometry: mapbox.Point(
                coordinates:
                    mapbox.Position.fromJson([spot.longitude, spot.latitude]),
              ),
              iconImage: "custom-marker", // Use the custom marker we loaded
              iconSize: 1.0,
              textField: spot.title,
              textSize: 12,
              textOffset: [0, 2.0],
              textColor: Colors.black.toARGB32(),
            ),
          );

          // Store spot data with marker ID
          markerSpotMap[annotation.id] = spot;
          appLog('DEBUG: Stored spot data for marker: ${annotation.id}');
        } catch (markerError) {
          appLog(
              'ERROR: Failed to create marker for ${spot.title}: $markerError');
        }
      }
      appLog(
          'DEBUG: Successfully added ${nearbySpots.length} markers to the map');

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
      appLog('Error adding spot markers: $e');
    }
  }

  void onPointAnnotationTap(mapbox.PointAnnotation annotation) {
    final spot = markerSpotMap[annotation.id];
    if (spot != null) {
      appLog('DEBUG: Marker tapped: ${spot.title}');

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
      appLog('DEBUG: No spot data found for marker: ${annotation.id}');
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
      appLog('Suggestion Error: $e');
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
      appLog('Search Error: $e');
      Fluttertoast.showToast(msg: "Error searching location");
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  // Offline map methods
  Future<void> checkOfflineMapAvailability() async {
    try {
      final appDocDir = await getApplicationDocumentsDirectory();
      final offlineMapDir = Directory('${appDocDir.path}/offline_maps');
      final mapFile = File('${offlineMapDir.path}/dhaka_region.map');
      
      isOfflineMapAvailable = await mapFile.exists();
      offlineMapPath = offlineMapDir.path;
      
      if (isOfflineMapAvailable) {
        appLog('Offline map available at: $offlineMapPath', type: LogType.info, source: 'OFFLINE_MAP');
      }
    } catch (e) {
      appLog('Error checking offline map: $e', type: LogType.error, source: 'OFFLINE_MAP');
      isOfflineMapAvailable = false;
    }
  }

  Future<void> toggleOfflineMode() async {
    if (!isOfflineMapAvailable) {
      Fluttertoast.showToast(msg: "No offline map available. Please download first.");
      return;
    }
    
    useOfflineMap = !useOfflineMap;
    
    if (useOfflineMap) {
      // Switch to offline mode - use a local style or cached tiles
      try {
        // For now, we'll use a basic style that might have cached tiles
        await mapboxMap.loadStyleURI('mapbox://styles/mapbox/basic-v9');
        Fluttertoast.showToast(msg: "Offline mode enabled");
        appLog('Switched to offline mode', type: LogType.info, source: 'OFFLINE_MAP');
      } catch (e) {
        appLog('Error switching to offline mode: $e', type: LogType.error, source: 'OFFLINE_MAP');
        useOfflineMap = false;
        Fluttertoast.showToast(msg: "Failed to enable offline mode");
      }
    } else {
      // Switch back to online mode
      try {
        await mapboxMap.loadStyleURI(defaultStyleUri);
        Fluttertoast.showToast(msg: "Online mode enabled");
        appLog('Switched to online mode', type: LogType.info, source: 'OFFLINE_MAP');
      } catch (e) {
        appLog('Error switching to online mode: $e', type: LogType.error, source: 'OFFLINE_MAP');
        Fluttertoast.showToast(msg: "Failed to enable online mode");
      }
    }
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
    
    // Check for offline map on initialization
    checkOfflineMapAvailability();
    
    super.onInit();
  }
}
