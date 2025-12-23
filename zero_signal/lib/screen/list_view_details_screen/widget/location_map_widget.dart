import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;

class LocationMapWidget extends StatefulWidget {
  final double latitude;
  final double longitude;
  final String markerTitle;
  final double height;

  const LocationMapWidget({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.markerTitle,
    this.height = 250,
  });

  @override
  State<LocationMapWidget> createState() => _LocationMapWidgetState();
}

class _LocationMapWidgetState extends State<LocationMapWidget> {
  late mapbox.MapboxMap mapboxMap;
  mapbox.PointAnnotationManager? pointAnnotationManager;
  final String mapboxAccessToken =
      'pk.eyJ1IjoibGVkZTE4IiwiYSI6ImNtZzgzcmxodDAyejIybXIzcHUyZGRyMzgifQ.jbe1XMovv8MF5TGitB9PwQ';

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: mapbox.MapWidget(
          onMapCreated: _onMapCreated,
          cameraOptions: mapbox.CameraOptions(
            center: mapbox.Point(
              coordinates: mapbox.Position.fromJson([
                widget.longitude,
                widget.latitude,
              ]),
            ),
            zoom: 14.0,
          ),
        ),
      ),
    );
  }

  Future<void> _onMapCreated(mapbox.MapboxMap controller) async {
    mapboxMap = controller;

    try {
      await mapboxMap.loadStyleURI('mapbox://styles/mapbox/streets-v12');
    } catch (e) {
      // Handle error silently
    }

    await Future.delayed(Duration(milliseconds: 500));

    try {
      pointAnnotationManager =
          await mapboxMap.annotations.createPointAnnotationManager();
    } catch (e) {
      // Handle error silently
    }

    // Set camera to location
    await mapboxMap.setCamera(
      mapbox.CameraOptions(
        center: mapbox.Point(
          coordinates: mapbox.Position.fromJson([
            widget.longitude,
            widget.latitude,
          ]),
        ),
        zoom: 14.0,
      ),
    );

    // Add marker
    await _addMarker();

    // Disable compass
    await mapboxMap.compass.updateSettings(
      mapbox.CompassSettings(
        enabled: false,
      ),
    );

    // Disable scale bar
    await mapboxMap.scaleBar.updateSettings(
      mapbox.ScaleBarSettings(
        enabled: false,
      ),
    );
  }

  Future<void> _addMarker() async {
    if (pointAnnotationManager == null) return;

    try {
      await pointAnnotationManager!.create(
        mapbox.PointAnnotationOptions(
          geometry: mapbox.Point(
            coordinates: mapbox.Position.fromJson([
              widget.longitude,
              widget.latitude,
            ]),
          ),
          iconImage: "marker-15",
          iconSize: 2.0,
        ),
      );
    } catch (e) {
      // Handle error silently
    }
  }
}
