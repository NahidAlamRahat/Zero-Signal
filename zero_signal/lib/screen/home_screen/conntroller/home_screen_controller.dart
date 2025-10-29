import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;
class HomeScreenController extends GetxController {
  late mapbox.MapboxMap mapboxMap;
  geo.Position? currentPosition;


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
}
