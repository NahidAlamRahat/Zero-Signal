import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_connect.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;
import 'package:geolocator/geolocator.dart';

import '../controller/share_route_controller.dart';
import '../../../constant/app_colors.dart';

// Import Factory for gesture recognizers
import 'package:flutter/foundation.dart';

class MapLocationPickerWidget extends StatefulWidget {
  final bool isStartLocation;
  final double? initialLat;
  final double? initialLng;

  const MapLocationPickerWidget({
    super.key,
    required this.isStartLocation,
    this.initialLat,
    this.initialLng,
  });

  @override
  State<MapLocationPickerWidget> createState() => _MapLocationPickerWidgetState();
}

class _MapLocationPickerWidgetState extends State<MapLocationPickerWidget> {
  mapbox.MapboxMap? mapboxMap;
  mapbox.PointAnnotationManager? pointManager;
  bool isMapReady = false;
  
  // Default map style
  static const String defaultStyleUri = 'mapbox://styles/mapbox/streets-v12';
  
  // Mapbox access token
  static const String _mapboxAccessToken =
      'pk.eyJ1IjoibGVkZTE4IiwiYSI6ImNtZzgzcmxodDAyejIybXIzcHUyZGRyMzgifQ.jbe1XMovv8MF5TGitB9PwQ';

  @override
  void dispose() {
    // Clean up gesture recognizers if needed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get initial coordinates - use current location if start location is selected
    double lat = widget.initialLat ?? 23.8103; // Default to Dhaka
    double lng = widget.initialLng ?? 90.4125;
    
    // If this is start location and no coordinates provided, get current location
    if (widget.isStartLocation && widget.initialLat == null) {
      _getCurrentLocation();
    }

    return Container(
      height: 300.h,
      margin: const EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.overLayBoxColor),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            // Map Widget
            mapbox.MapWidget(
              key: ValueKey("mapWidget_${widget.isStartLocation}"),
              cameraOptions: mapbox.CameraOptions(
                center: mapbox.Point(
                  coordinates: mapbox.Position(lng, lat),
                ),
                zoom: 13.0,
              ),
              onMapCreated: _onMapCreated,
              onTapListener: _onMapTapped,
              styleUri: defaultStyleUri,
              gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                Factory<PanGestureRecognizer>(() => PanGestureRecognizer()),
                Factory<ScaleGestureRecognizer>(() => ScaleGestureRecognizer()),
                Factory<TapGestureRecognizer>(() => TapGestureRecognizer()),
              },
            ),
            
            // Map instructions
            Positioned(
              top: 12,
              left: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  'Tap on map to select ${widget.isStartLocation ? 'start' : 'end'} location',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            
            // Current location button
            Positioned(
              bottom: 12,
              right: 12,
              child: FloatingActionButton(
                mini: true,
                backgroundColor: AppColor.backgroundColor,
                onPressed: _getCurrentLocation,
                child: const Icon(
                  Icons.my_location,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onMapCreated(mapbox.MapboxMap controller) async {
    mapboxMap = controller;
    isMapReady = true;

    try {
      // Create annotation manager for markers
      pointManager = await mapboxMap?.annotations.createPointAnnotationManager();

      // Add custom marker image
      await _addCustomMarkerImage();

      // Add initial marker if coordinates are provided
      if (widget.initialLat != null && widget.initialLng != null) {
        _addOrMoveMarker(mapbox.Point(
            coordinates: mapbox.Position(widget.initialLng!, widget.initialLat!)));
      }

      // Configure map settings
      await mapboxMap?.gestures.updateSettings(
        mapbox.GesturesSettings(
          scrollEnabled: true,
          rotateEnabled: false,
        ),
      );

      // Hide map attribution and logo for cleaner look
      await mapboxMap?.scaleBar.updateSettings(
        mapbox.ScaleBarSettings(enabled: false),
      );
      await mapboxMap?.attribution.updateSettings(
        mapbox.AttributionSettings(enabled: false),
      );
      await mapboxMap?.logo.updateSettings(
        mapbox.LogoSettings(enabled: false),
      );
    } catch (e) {
      print('Error setting up map: $e');
    }
  }

  Future<void> _addCustomMarkerImage() async {
    try {
      // Use a simple colored circle marker instead of custom image
      // We'll use the built-in marker with color
      print('Using built-in marker for ${widget.isStartLocation ? 'start' : 'end'} location');
    } catch (e) {
      print('Error setting up marker: $e');
    }
  }

  Future<void> _onMapTapped(mapbox.MapContentGestureContext context) async {
    final point = mapbox.Point(
        coordinates: mapbox.Position(
          context.point.coordinates.lng,
          context.point.coordinates.lat,
        ));

    // Smoothly move camera to tapped location first
    await mapboxMap?.flyTo(
      mapbox.CameraOptions(
        center: point,
        zoom: 16.0,
        pitch: 0.0,
        bearing: 0.0,
      ),
      mapbox.MapAnimationOptions(
        duration: 1200,
      ),
    );

    // Wait for animation to complete before adding marker
    await Future.delayed(const Duration(milliseconds: 600));

    // Add or move marker to tapped position
    await _addOrMoveMarker(point);

    // Update controller with selected location
    final controller = Get.find<ShareRouteController>();
    
    // Reverse geocode to get address
    await _reverseGeocode(
      context.point.coordinates.lat.toDouble(),
      context.point.coordinates.lng.toDouble(),
    );

    if (widget.isStartLocation) {
      controller.startLat = context.point.coordinates.lat.toDouble();
      controller.startLng = context.point.coordinates.lng.toDouble();
    } else {
      controller.endLat = context.point.coordinates.lat.toDouble();
      controller.endLng = context.point.coordinates.lng.toDouble();
    }
    
    controller.update();
  }

  Future<void> _addOrMoveMarker(mapbox.Point point) async {
    if (pointManager == null) return;

    try {
      // Remove existing markers
      await pointManager?.deleteAll();

      // Add new marker with better visibility
      await pointManager?.create(
        mapbox.PointAnnotationOptions(
          geometry: point,
          iconImage: "marker-15",
          iconSize: 3.0,
        ),
      );
      print('Marker added at: ${point.coordinates.lat}, ${point.coordinates.lng}');
      
      // Add a visual feedback by creating a pulsing effect
      _showSelectionFeedback(point);
    } catch (e) {
      print('Error adding marker: $e');
      
      // Try alternative marker names with larger size
      final markerNames = ["marker-15", "default-marker", "pin", "place"];
      for (final markerName in markerNames) {
        try {
          await pointManager?.create(
            mapbox.PointAnnotationOptions(
              geometry: point,
              iconImage: markerName,
              iconSize: 3.0,
            ),
          );
          print('Marker added with name: $markerName');
          _showSelectionFeedback(point);
          return;
        } catch (e2) {
          print('Failed with $markerName: $e2');
        }
      }
      
      // Final fallback - create a simple point with larger size
      try {
        await pointManager?.create(
          mapbox.PointAnnotationOptions(
            geometry: point,
            iconSize: 0,
          ),
        );
        print('Simple point marker added');
        _showSelectionFeedback(point);
      } catch (e3) {
        print('All marker attempts failed: $e3');
      }
    }
  }

  void _showSelectionFeedback(mapbox.Point point) {
    // Add haptic feedback for better user experience
    // This will be implemented if needed
    print('Location selected: ${point.coordinates.lat}, ${point.coordinates.lng}');
  }

  Future<void> _reverseGeocode(double lat, double lng) async {
    try {
      final url =
          'https://api.mapbox.com/geocoding/v5/mapbox.places/$lng,$lat.json?access_token=$_mapboxAccessToken&limit=1';

      final response = await GetConnect().get(url);

      if (response.statusCode == 200 && response.body != null) {
        final data = response.body;
        
        // Handle both Mapbox API response formats
        List<dynamic> features = [];
        
        if (data is Map<String, dynamic>) {
          // Standard Mapbox response
          features = data['features'] as List<dynamic>? ?? [];
        } else if (data is List) {
          // Some APIs return features directly as a list
          features = data;
        }

        if (features.isNotEmpty) {
          final feature = features.first;
          
          // Safely extract place_name
          String placeName = '';
          if (feature is Map<String, dynamic>) {
            placeName = feature['place_name']?.toString() ?? 'Unknown Location';
            
            // Fallback to other fields if place_name is not available
            if (placeName.isEmpty || placeName == 'Unknown Location') {
              placeName = feature['text']?.toString() ?? 
                         feature['name']?.toString() ?? 
                         'Unknown Location';
            }
          } else {
            placeName = feature.toString();
          }

          // Update controller with the address
          final controller = Get.find<ShareRouteController>();
          if (widget.isStartLocation) {
            controller.startLocationController.text = placeName;
            controller.startAddress = placeName;
          } else {
            controller.endLocationController.text = placeName;
            controller.endAddress = placeName;
          }

          controller.update();
          print('Reverse geocoded successfully: $placeName');
        }
      } else {
        print('Reverse geocode failed: Status ${response.statusCode}');
      }
    } catch (e) {
      print('Reverse geocode error: $e');
      
      // Set a default location name on error
      final controller = Get.find<ShareRouteController>();
      final defaultName = 'Selected Location (${lat.toStringAsFixed(4)}, ${lng.toStringAsFixed(4)})';
      
      if (widget.isStartLocation) {
        controller.startLocationController.text = defaultName;
        controller.startAddress = defaultName;
      } else {
        controller.endLocationController.text = defaultName;
        controller.endAddress = defaultName;
      }
      
      controller.update();
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      // Use Geolocator to get current location
      final position = await Geolocator.getCurrentPosition();
      
      // Move map to current location
      await mapboxMap?.flyTo(
        mapbox.CameraOptions(
          center: mapbox.Point(
            coordinates: mapbox.Position(position.longitude, position.latitude),
          ),
          zoom: 15.0,
        ),
        mapbox.MapAnimationOptions(duration: 800),
      );

      // Add marker at current location
      await _addOrMoveMarker(mapbox.Point(
          coordinates: mapbox.Position(position.longitude, position.latitude)));

      // Update controller
      final controller = Get.find<ShareRouteController>();
      await _reverseGeocode(position.latitude.toDouble(), position.longitude.toDouble());
      
      if (widget.isStartLocation) {
        controller.startLat = position.latitude.toDouble();
        controller.startLng = position.longitude.toDouble();
      } else {
        controller.endLat = position.latitude.toDouble();
        controller.endLng = position.longitude.toDouble();
      }
      
      controller.update();
    } catch (e) {
      print('Error getting current location: $e');
      Get.snackbar('Error', 'Failed to get current location');
    }
  }
}
