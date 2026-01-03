import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;
import 'dart:math' as math;

class RouteDetailsMapWidget extends StatefulWidget {
  final double? startLat;
  final double? startLng;
  final double? endLat;
  final double? endLng;

  const RouteDetailsMapWidget({
    super.key,
    this.startLat,
    this.startLng,
    this.endLat,
    this.endLng,
  });

  @override
  State<RouteDetailsMapWidget> createState() => _RouteDetailsMapWidgetState();
}

class _RouteDetailsMapWidgetState extends State<RouteDetailsMapWidget> {
  mapbox.MapboxMap? _mapboxMap;

  @override
  Widget build(BuildContext context) {
    // Calculate center point between start and end
    final hasCoordinates = widget.startLat != null &&
        widget.startLng != null &&
        widget.endLat != null &&
        widget.endLng != null;

    final centerLat =
        hasCoordinates ? (widget.startLat! + widget.endLat!) / 2 : 23.754253;
    final centerLng =
        hasCoordinates ? (widget.startLng! + widget.endLng!) / 2 : 90.393425;

    return Container(
      height: 180.h,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: Colors.grey[200],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: mapbox.MapWidget(
          onMapCreated: _onMapCreated,
          cameraOptions: mapbox.CameraOptions(
            center: mapbox.Point(
              coordinates: mapbox.Position(centerLng, centerLat),
            ),
            zoom: 10.0, // Start with a lower zoom, will adjust after map loads
          ),
        ),
      ),
    );
  }

  void _onMapCreated(mapbox.MapboxMap mapboxMap) async {
    _mapboxMap = mapboxMap;

    if (widget.startLat != null &&
        widget.startLng != null &&
        widget.endLat != null &&
        widget.endLng != null) {
      await _addRouteLineAndMarkers();
      await _fitCameraToBounds();
    }
  }

  Future<void> _fitCameraToBounds() async {
    if (_mapboxMap == null) return;

    final startLng = widget.startLng!;
    final startLat = widget.startLat!;
    final endLng = widget.endLng!;
    final endLat = widget.endLat!;

    // Calculate bounds with padding
    final minLat = math.min(startLat, endLat);
    final maxLat = math.max(startLat, endLat);
    final minLng = math.min(startLng, endLng);
    final maxLng = math.max(startLng, endLng);

    // Set camera to fit bounds
    await _mapboxMap!.setCamera(
      mapbox.CameraOptions(
        center: mapbox.Point(
          coordinates: mapbox.Position(
            (minLng + maxLng) / 2,
            (minLat + maxLat) / 2,
          ),
        ),
        zoom: _calculateZoomForBounds(minLat, maxLat, minLng, maxLng),
      ),
    );
  }

  double _calculateZoomForBounds(
      double minLat, double maxLat, double minLng, double maxLng) {
    final latDiff = (maxLat - minLat).abs();
    final lngDiff = (maxLng - minLng).abs();
    final maxDiff = math.max(latDiff, lngDiff);

    // More aggressive zoom out for better visibility
    if (maxDiff > 0.5) return 8.0;
    if (maxDiff > 0.2) return 9.0;
    if (maxDiff > 0.1) return 10.0;
    if (maxDiff > 0.05) return 11.0;
    if (maxDiff > 0.02) return 12.0;
    if (maxDiff > 0.01) return 13.0;
    return 14.0;
  }

  Future<void> _addRouteLineAndMarkers() async {
    if (_mapboxMap == null) return;

    final startLng = widget.startLng!;
    final startLat = widget.startLat!;
    final endLng = widget.endLng!;
    final endLat = widget.endLat!;

    // Add route line
    final lineAnnotationManager =
        await _mapboxMap!.annotations.createPolylineAnnotationManager();

    await lineAnnotationManager.create(
      mapbox.PolylineAnnotationOptions(
        geometry: mapbox.LineString(
          coordinates: [
            mapbox.Position(startLng, startLat),
            mapbox.Position(endLng, endLat),
          ],
        ),
        lineColor: 0xFF4285F4, // Google Maps blue color
        lineWidth: 5.0,
      ),
    );

    // Add start marker (green circle)
    final startPointManager =
        await _mapboxMap!.annotations.createCircleAnnotationManager();
    await startPointManager.create(
      mapbox.CircleAnnotationOptions(
        geometry: mapbox.Point(
          coordinates: mapbox.Position(startLng, startLat),
        ),
        circleColor: 0xFF4CAF50, // Green
        circleRadius: 10.0,
        circleStrokeColor: 0xFFFFFFFF,
        circleStrokeWidth: 2.0,
      ),
    );

    // Add end marker (red pin style with circle)
    final endPointManager =
        await _mapboxMap!.annotations.createCircleAnnotationManager();
    await endPointManager.create(
      mapbox.CircleAnnotationOptions(
        geometry: mapbox.Point(
          coordinates: mapbox.Position(endLng, endLat),
        ),
        circleColor: 0xFFE53935, // Red
        circleRadius: 12.0,
        circleStrokeColor: 0xFFFFFFFF,
        circleStrokeWidth: 3.0,
      ),
    );
  }
}
