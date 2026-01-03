import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;
import 'package:zero_signal/constant/app_colors.dart';
import 'package:zero_signal/widget/button_widget/button_widget.dart';

import '../controller/share_spot_controller.dart';

class ConfirmLocationSheet extends StatefulWidget {
  const ConfirmLocationSheet({super.key});

  @override
  State<ConfirmLocationSheet> createState() => _ConfirmLocationSheetState();
}

class _ConfirmLocationSheetState extends State<ConfirmLocationSheet> {
  mapbox.MapboxMap? mapboxMap;
  mapbox.CircleAnnotationManager? circleManager;
  bool isMapReady = false;

  // Default map style
  static const String defaultStyleUri = 'mapbox://styles/mapbox/streets-v12';

  @override
  void initState() {
    super.initState();
    // Auto-fetch location if none selected, or just ensure we have one
    final controller = Get.find<ShareSpotController>();
    if (controller.selectedLat == null || controller.selectedLng == null) {
      controller.getCurrentLocation();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ShareSpotController>(
      builder: (controller) {
        final double lat = controller.selectedLat ?? 23.8103;
        final double lng = controller.selectedLng ?? 90.4125;

        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF0EBE6),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.w),
              topRight: Radius.circular(20.w),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(width: 40.w),
                    Text(
                      'Confirm',
                      style: TextStyle(
                        fontSize: 20.w,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF333333),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Colors.black54,
                        size: 24.w,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const Divider(),
                SizedBox(height: 15.h),

                // Map Picker
                ClipRRect(
                  borderRadius: BorderRadius.circular(15.w),
                  child: SizedBox(
                    height: 250.h,
                    width: double.infinity,
                    child: Stack(
                      children: [
                        mapbox.MapWidget(
                          key: const ValueKey("mapWidget"),
                          cameraOptions: mapbox.CameraOptions(
                            center: mapbox.Point(
                              coordinates: mapbox.Position(lng, lat),
                            ),
                            zoom: 15.0,
                          ),
                          styleUri: defaultStyleUri,
                          onMapCreated: _onMapCreated,
                          onTapListener: _onMapTapped,
                          gestureRecognizers: {
                            Factory<PanGestureRecognizer>(
                              () => PanGestureRecognizer(),
                            ),
                            Factory<ScaleGestureRecognizer>(
                              () => ScaleGestureRecognizer(),
                            ),
                          },
                        ),

                        // My Location Button
                        Positioned(
                          bottom: 16,
                          right: 16,
                          child: FloatingActionButton(
                            mini: true,
                            backgroundColor: Colors.white,
                            onPressed: () async {
                              await controller.getCurrentLocation();
                              // Update marker to new current location
                              if (controller.selectedLat != null &&
                                  controller.selectedLng != null) {
                                final point = mapbox.Point(
                                    coordinates: mapbox.Position(
                                        controller.selectedLng!,
                                        controller.selectedLat!));

                                // Move camera
                                mapboxMap?.flyTo(
                                  mapbox.CameraOptions(
                                    center: point,
                                    zoom: 15.0,
                                  ),
                                  mapbox.MapAnimationOptions(duration: 800),
                                );

                                // Update marker
                                await _addOrMoveMarker(point);
                              }
                            },
                            child: const Icon(Icons.my_location,
                                color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 25.h),

                // Display selected address
                if (controller.selectedAddress != null &&
                    controller.selectedAddress!.isNotEmpty)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(12.w),
                    margin: EdgeInsets.only(bottom: 15.h),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(8.w),
                    ),
                    child: Text(
                      controller.selectedAddress!,
                      style: TextStyle(
                        fontSize: 14.w,
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ButtonWidget(
                        onPressed: () => Get.back(),
                        label: 'Cancel',
                        fontSize: 16.w,
                        fontWeight: FontWeight.w500,
                        backgroundColor: const Color(0xFFE2DACC),
                        buttonRadius: BorderRadius.circular(8.w),
                        textColor: const Color(0xFF565656),
                      ),
                    ),
                    SizedBox(width: 15.w),
                    // Confirm Location Button
                    Expanded(
                      child: ButtonWidget(
                        onPressed: () {
                          // Location is already saved in controller via tap
                          Get.back();
                        },
                        label: 'Confirm location',
                        fontSize: 16.w,
                        fontWeight: FontWeight.w500,
                        backgroundColor: AppColor.backgroundColor,
                        buttonRadius: BorderRadius.circular(8.w),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _onMapCreated(mapbox.MapboxMap controller) async {
    mapboxMap = controller;
    isMapReady = true;

    // Initialize circle annotation manager
    try {
      circleManager =
          await mapboxMap?.annotations.createCircleAnnotationManager();

      // Add initial marker if exists
      final shareController = Get.find<ShareSpotController>();
      if (shareController.selectedLat != null &&
          shareController.selectedLng != null) {
        _addOrMoveMarker(mapbox.Point(
            coordinates: mapbox.Position(
                shareController.selectedLng!, shareController.selectedLat!)));
      }
    } catch (e) {
      // Handle init error
    }

    // Enable gestures
    await mapboxMap?.gestures.updateSettings(
      mapbox.GesturesSettings(
        scrollEnabled: true,
        pinchToZoomEnabled: true,
        doubleTapToZoomInEnabled: true,
        rotateEnabled: true,
      ),
    );

    // Disable UI elements
    await mapboxMap?.scaleBar.updateSettings(
      mapbox.ScaleBarSettings(enabled: false),
    );
    await mapboxMap?.attribution.updateSettings(
      mapbox.AttributionSettings(enabled: false),
    );
    await mapboxMap?.logo.updateSettings(
      mapbox.LogoSettings(enabled: false),
    );
  }

  Future<void> _onMapTapped(mapbox.MapContentGestureContext context) async {
    final point = context.point;

    // Add/Move Marker
    await _addOrMoveMarker(point);

    // Update Controller
    final lat = point.coordinates.lat.toDouble();
    final lng = point.coordinates.lng.toDouble();

    final controller = Get.find<ShareSpotController>();
    controller.selectedLat = lat;
    controller.selectedLng = lng;

    await controller.reverseGeocode(lat, lng);
    debugPrint("Tapped at: $lat , $lng");
  }

  Future<void> _addOrMoveMarker(mapbox.Point point) async {
    if (circleManager == null) return;

    // Clear old markers
    await circleManager?.deleteAll();

    // Add new marker (red circle with white border)
    await circleManager?.create(
      mapbox.CircleAnnotationOptions(
        geometry: point,
        circleColor: Colors.red.toARGB32(),
        circleRadius: 10.0,
        circleStrokeColor: Colors.white.toARGB32(),
        circleStrokeWidth: 2.0,
      ),
    );
  }
}
