import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;

class RouteMapWidget extends StatefulWidget {
  final List<Map<String, dynamic>> routeCoordinates;
  final String routeName;
  final Function(mapbox.MapboxMap) onMapCreated;

  const RouteMapWidget({
    super.key,
    required this.routeCoordinates,
    required this.routeName,
    required this.onMapCreated,
  });

  @override
  State<RouteMapWidget> createState() => _RouteMapWidgetState();
}

class _RouteMapWidgetState extends State<RouteMapWidget> {
  @override
  Widget build(BuildContext context) {
    // Calculate initial camera position based on route coordinates
    mapbox.Point? initialCenter;
    if (widget.routeCoordinates.isNotEmpty) {
      final startCoord = widget.routeCoordinates.first;
      final endCoord = widget.routeCoordinates.last;
      final centerLat = (startCoord['latitude'] + endCoord['latitude']) / 2;
      final centerLon = (startCoord['longitude'] + endCoord['longitude']) / 2;
      initialCenter = mapbox.Point(coordinates: mapbox.Position(centerLon, centerLat));
    }

    return Container(
      margin: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: mapbox.MapWidget(
          onMapCreated: widget.onMapCreated,
          cameraOptions: mapbox.CameraOptions(
            center: initialCenter ?? mapbox.Point(
              coordinates: mapbox.Position.fromJson([90.393425, 23.754253]),
            ),
            zoom: 13.0,
          ),
        ),
      ),
    );
  }
}
