import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart' as geo;

import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;
class HomeScreenController extends GetxController {
  late mapbox.MapboxMap mapboxMap;
  geo.Position? currentPosition;

  
  // Map style URIs
  static const String defaultStyleUri = 'mapbox://styles/mapbox/streets-v12';
  static const String satelliteStyleUri = 'mapbox://styles/lede18/cmg91jkk3000r01sf8m1r29ky';
  static const String terrainStyleUri = 'mapbox://styles/lede18/cmg91k73u000s01qo5ye4bl7q';
  
  // Current selected map type
  String selectedMapType = 'OutDoor';
  List<mapbox.Point> markerList = [
    mapbox.Point(coordinates: mapbox.Position.fromJson([ 23.77946286151694,  90.40031401135806 ])), // San Francisco

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
      Get.snackbar(
        "Permission Required",
        "Location permission is permanently denied. Please enable it in app settings.",
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 4),
        mainButton: TextButton(
          onPressed: () async {
            await geo.Geolocator.openAppSettings();
          },
          child: Text("Open Settings", style: TextStyle(color: CupertinoColors.activeBlue)),
        ),
      );
      return;
    }
    
    if (permission == geo.LocationPermission.denied) {
      permission = await geo.Geolocator.requestPermission();
      if (permission == geo.LocationPermission.denied) {
        Get.snackbar(
          "Permission Denied",
          "Location permission is required to show your location on the map.",
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 3),
        );
        return;
      }
      
      if (permission == geo.LocationPermission.deniedForever) {
        Get.snackbar(
          "Permission Required",
          "Location permission is permanently denied. Please enable it in app settings.",
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 4),
          mainButton: TextButton(
            onPressed: () async {
              await geo.Geolocator.openAppSettings();
            },
            child: Text("Open Settings", style: TextStyle(color: CupertinoColors.activeBlue)),
          ),
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
      Get.snackbar(
        "Error",
        "Failed to get location: $e",
        snackPosition: SnackPosition.BOTTOM,
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


  Future<void> onMapCreated(mapbox.MapboxMap controller) async {
    mapboxMap = controller;
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

      // Add static markers
      //await _addSingleMarker();
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
      Get.snackbar(
        "Error", 
        "Failed to change map style: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  void onInit() {
    markerPoint = mapbox.Point(coordinates: mapbox.Position.fromJson([23.78105597835364, 90.40762703426819]));
    super.onInit();
  }
}
