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
  mapbox.PointAnnotationManager? pointAnnotationManager;
  mapbox.PointAnnotation? currentMarker;

  // Default map style
  static const String defaultStyleUri = 'mapbox://styles/mapbox/streets-v12';

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ShareSpotController>(
      builder: (controller) {
        // Get coordinates from controller or use default
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
            child: SingleChildScrollView(
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

                  // Real Mapbox Map with Marker
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15.w),
                    child: SizedBox(
                      height: 250.h,
                      width: double.infinity,
                      child: Stack(
                        children: [
                          mapbox.MapWidget(
                            cameraOptions: mapbox.CameraOptions(
                              center: mapbox.Point(
                                coordinates: mapbox.Position(lng, lat),
                              ),
                              zoom: 14.0,
                            ),
                            styleUri: defaultStyleUri,
                            onMapCreated: (map) => _onMapCreated(map, lat, lng),
                            onTapListener: (mapbox.MapContentGestureContext
                                context) async {
                              // Update location when user taps on map
                              final point = context.point;
                              final coordinates = point.coordinates;
                              final lat = coordinates.lat.toDouble();
                              final lng = coordinates.lng.toDouble();

                              // Update marker position
                              _updateMarker(lat, lng);

                              // Get address from coordinates using reverse geocoding
                              await controller.reverseGeocode(lat, lng);

                              // Move camera to tapped location
                              mapboxMap?.flyTo(
                                mapbox.CameraOptions(
                                  center: point,
                                  zoom: 15.0,
                                ),
                                mapbox.MapAnimationOptions(duration: 500),
                              );
                            },
                          ),
                          // Center pin overlay (always visible at center)
                          Center(
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 40.h),
                              child: Icon(
                                Icons.location_pin,
                                size: 50.w,
                                color: Colors.red,
                              ),
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
                      // Cancel Button
                      Expanded(
                        child: ButtonWidget(
                          onPressed: () {
                            Get.back();
                          },
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
                            // Location is already saved in controller
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
          ),
        );
      },
    );
  }

  Future<void> _onMapCreated(
      mapbox.MapboxMap controller, double lat, double lng) async {
    mapboxMap = controller;

    // Enable location component
    await mapboxMap?.location.updateSettings(
      mapbox.LocationComponentSettings(
        enabled: true,
        pulsingEnabled: true,
        showAccuracyRing: true,
      ),
    );

    // Disable scale bar
    await mapboxMap?.scaleBar.updateSettings(
      mapbox.ScaleBarSettings(enabled: false),
    );

    // Disable attribution
    await mapboxMap?.attribution.updateSettings(
      mapbox.AttributionSettings(enabled: false),
    );

    // Disable logo
    await mapboxMap?.logo.updateSettings(
      mapbox.LogoSettings(enabled: false),
    );

    // Create point annotation manager for markers
    pointAnnotationManager =
        await mapboxMap?.annotations.createPointAnnotationManager();

    // Add initial marker at selected location
    await _addMarker(lat, lng);
  }

  Future<void> _addMarker(double lat, double lng) async {
    if (pointAnnotationManager == null) return;

    currentMarker = await pointAnnotationManager?.create(
      mapbox.PointAnnotationOptions(
        geometry: mapbox.Point(
          coordinates: mapbox.Position(lng, lat),
        ),
        iconSize: 1.5,
        iconColor: Colors.red.value,
      ),
    );
  }

  Future<void> _updateMarker(double lat, double lng) async {
    if (pointAnnotationManager == null) return;

    // Remove old marker
    if (currentMarker != null) {
      await pointAnnotationManager?.delete(currentMarker!);
    }

    // Add new marker at new location
    await _addMarker(lat, lng);
  }
}
