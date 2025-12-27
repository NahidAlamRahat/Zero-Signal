import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;
import 'dart:async';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'dart:math';
import 'package:geolocator/geolocator.dart';

import '../../../constant/app_colors.dart';

class RouteNavigationScreen extends StatefulWidget {
  final String routeId;
  final List<Map<String, dynamic>> routeCoordinates;
  final String routeName;

  const RouteNavigationScreen({
    super.key,
    required this.routeId,
    required this.routeCoordinates,
    required this.routeName,
  });

  @override
  State<RouteNavigationScreen> createState() => _RouteNavigationScreenState();
}

class _RouteNavigationScreenState extends State<RouteNavigationScreen> {
  mapbox.MapboxMap? mapboxMap;
  Timer? navigationTimer;
  int currentCoordinateIndex = 0;
  bool isNavigating = false;
  double currentSpeed = 40.0; // km/h (city driving speed)
  double totalDistance = 0.0;
  double coveredDistance = 0.0;
  int remainingTime = 0; // in minutes
  
  // GPS tracking variables
  Position? currentPosition;
  StreamSubscription<Position>? positionStreamSubscription;
  
  // Driving simulation variables
  double currentLat = 0.0;
  double currentLng = 0.0;
  double targetLat = 0.0;
  double targetLng = 0.0;
  double progress = 0.0; // Progress between current waypoint and next (0.0 to 1.0)
  mapbox.PointAnnotationManager? currentPositionManager;
  mapbox.PointAnnotation? currentPositionMarker;
  
  // Generated route waypoints
  List<Map<String, dynamic>> routeWaypoints = [];
  
  // Map annotations
  mapbox.PointAnnotationManager? pointManager;
  mapbox.PolylineAnnotationManager? lineManager;
  
  @override
  void initState() {
    super.initState();
    _calculateRouteStats();
    _initializeGPS();
  }

  @override
  void dispose() {
    navigationTimer?.cancel();
    positionStreamSubscription?.cancel();
    super.dispose();
  }

  Future<void> _initializeGPS() async {
    try {
      // Check GPS permissions
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Request GPS to be enabled
        await Geolocator.openLocationSettings();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return;
      }

      // Get current position
      currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Start listening to GPS updates
      positionStreamSubscription = Geolocator.getPositionStream(
        locationSettings: LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 5, // Update every 5 meters
        ),
      ).listen((Position position) {
        if (isNavigating) {
          _updateGPSPosition(position);
        }
      });

    } catch (e) {
      print('GPS Error: $e');
    }
  }

  void _updateGPSPosition(Position position) {
    setState(() {
      currentPosition = position;
      currentLat = position.latitude;
      currentLng = position.longitude;
      
      // Update current position marker
      _updateCurrentPositionMarker(currentLat, currentLng);
      
      // Check if user is following the route
      _checkRouteProgress();
      
      // Update speed if available
      if (position.speed > 0) {
        currentSpeed = position.speed * 3.6; // Convert m/s to km/h
      }
    });
  }

  void _checkRouteProgress() {
    final coordinates = routeWaypoints.isNotEmpty ? routeWaypoints : widget.routeCoordinates;
    
    // Find closest point on route
    double minDistance = double.infinity;
    int closestIndex = 0;
    
    for (int i = 0; i < coordinates.length; i++) {
      final coord = coordinates[i];
      final distance = _calculateDistance(
        currentLat, currentLng,
        coord['latitude'], coord['longitude'],
      );
      
      if (distance < minDistance) {
        minDistance = distance;
        closestIndex = i;
      }
    }
    
    // Update progress if we've moved forward
    if (closestIndex > currentCoordinateIndex) {
      currentCoordinateIndex = closestIndex;
      _updateDistanceStats();
    }
    
    // Check if user is off route (more than 50 meters away)
    if (minDistance > 0.05) {
      _showOffRouteAlert();
    }
  }

  void _showOffRouteAlert() {
    // Show alert that user is off route
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('You are off route! Please return to the navigation path.'),
        backgroundColor: Colors.orange,
        duration: Duration(seconds: 3),
      ),
    );
  }

  Future<void> _initializeRoute() async {
    if (mapboxMap == null || widget.routeCoordinates.isEmpty) return;

    // Create realistic route with intermediate waypoints
    await _createRealisticRoute();

    // Center map on route
    _centerMapOnRoute();
  }

  Future<void> _createRealisticRoute() async {
    print('=== CREATING REALISTIC ROUTE ===');
    
    if (widget.routeCoordinates.length < 2) {
      await _drawStraightLineRoute();
      return;
    }

    final startCoord = widget.routeCoordinates.first;
    final endCoord = widget.routeCoordinates.last;
    
    // Try to get real road route first
    final success = await _fetchRealRoadRoute();
    
    if (!success) {
      // Fallback to curved path simulation
      routeWaypoints = _generateIntermediateWaypoints(
        startCoord['latitude'], startCoord['longitude'],
        endCoord['latitude'], endCoord['longitude']
      );

      print('Generated ${routeWaypoints.length} waypoints for realistic route');

      final lineOptions = mapbox.PolylineAnnotationOptions(
        geometry: mapbox.LineString(
          coordinates: routeWaypoints.map((coord) => 
            mapbox.Position(coord['longitude'], coord['latitude'])
          ).toList(),
        ),
        lineColor: const Color(0xFF3A5A4D).value,
        lineWidth: 5.0,
      );

      lineManager = await mapboxMap!.annotations.createPolylineAnnotationManager();
      await lineManager!.create(lineOptions);

      // Add start and end markers
      pointManager = await mapboxMap!.annotations.createPointAnnotationManager();
      
      // Start marker
      await pointManager!.create(mapbox.PointAnnotationOptions(
        geometry: mapbox.Point(coordinates: mapbox.Position(startCoord['longitude'], startCoord['latitude'])),
        iconImage: "start-marker",
        iconSize: 1.5,
      ));

      // End marker
      await pointManager!.create(mapbox.PointAnnotationOptions(
        geometry: mapbox.Point(coordinates: mapbox.Position(endCoord['longitude'], endCoord['latitude'])),
        iconImage: "end-marker", 
        iconSize: 1.5,
      ));

      // Add current position marker
      await _addCurrentPositionMarker();
      
      print('Realistic route completed!');
    }
  }

  Future<bool> _fetchRealRoadRoute() async {
    if (widget.routeCoordinates.length < 2) return false;

    print('=== FETCHING REAL ROAD ROUTE ===');

    try {
      final startCoord = widget.routeCoordinates.first;
      final endCoord = widget.routeCoordinates.last;
      
      // Use OpenStreetMap's OSRM routing service (free and reliable)
      final url = Uri.parse(
        'https://router.project-osrm.org/route/v1/driving/'
        '${startCoord['longitude']},${startCoord['latitude']};'
        '${endCoord['longitude']},${endCoord['latitude']}'
        '?overview=full&geometries=geojson'
      );

      print('Request URL: $url');

      final response = await http.get(url);
      print('Response status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final data = convert.json.decode(response.body);
        print('OSRM Response received');
        
        if (data['routes'] != null && data['routes'].isNotEmpty) {
          final route = data['routes'][0];
          final geometry = route['geometry'];
          final coordinates = geometry['coordinates'] as List;
          
          // Convert API coordinates to our format
          routeWaypoints = coordinates.map((coord) => {
            'latitude': coord[1],
            'longitude': coord[0],
          }).toList();

          print('Got ${routeWaypoints.length} road waypoints from OSRM');

          final lineOptions = mapbox.PolylineAnnotationOptions(
            geometry: mapbox.LineString(
              coordinates: routeWaypoints.map((coord) => 
                mapbox.Position(coord['longitude'], coord['latitude'])
              ).toList(),
            ),
            lineColor: const Color(0xFF3A5A4D).value,
            lineWidth: 5.0,
          );

          lineManager = await mapboxMap!.annotations.createPolylineAnnotationManager();
          await lineManager!.create(lineOptions);

          // Add start and end markers
          pointManager = await mapboxMap!.annotations.createPointAnnotationManager();
          
          // Start marker
          await pointManager!.create(mapbox.PointAnnotationOptions(
            geometry: mapbox.Point(coordinates: mapbox.Position(startCoord['longitude'], startCoord['latitude'])),
            iconImage: "start-marker",
            iconSize: 1.5,
          ));

          // End marker
          await pointManager!.create(mapbox.PointAnnotationOptions(
            geometry: mapbox.Point(coordinates: mapbox.Position(endCoord['longitude'], endCoord['latitude'])),
            iconImage: "end-marker", 
            iconSize: 1.5,
          ));

          // Add current position marker
          await _addCurrentPositionMarker();
          
          print('Real road route completed!');
          return true;
        }
      }
    } catch (e) {
      print('Error fetching real road route: $e');
    }
    
    return false;
  }

  List<Map<String, dynamic>> _generateIntermediateWaypoints(
    double startLat, double startLng, double endLat, double endLng
  ) {
    final waypoints = <Map<String, dynamic>>[];
    final numWaypoints = 8; // Number of intermediate points
    
    for (int i = 0; i <= numWaypoints; i++) {
      final t = i / numWaypoints;
      
      // Add some curve to make it more realistic than straight line
      final curve = sin(t * pi) * 0.002; // Small curve effect
      
      final lat = startLat + (endLat - startLat) * t + curve;
      final lng = startLng + (endLng - startLng) * t;
      
      waypoints.add({
        'latitude': lat,
        'longitude': lng,
      });
    }
    
    return waypoints;
  }

  Future<void> _drawStraightLineRoute() async {
    print('=== DRAWING STRAIGHT LINE ROUTE ===');
    print('Coordinates count: ${widget.routeCoordinates.length}');
    
    // Fallback to straight line between points
    final lineOptions = mapbox.PolylineAnnotationOptions(
      geometry: mapbox.LineString(
        coordinates: widget.routeCoordinates.map((coord) => 
          mapbox.Position(coord['longitude'], coord['latitude'])
        ).toList(),
      ),
      lineColor: const Color(0xFF3A5A4D).value,
      lineWidth: 5.0,
    );

    print('Creating line manager...');
    lineManager = await mapboxMap!.annotations.createPolylineAnnotationManager();
    print('Drawing line...');
    await lineManager!.create(lineOptions);

    // Add start and end markers
    print('Creating point manager...');
    pointManager = await mapboxMap!.annotations.createPointAnnotationManager();
    
    // Start marker
    final startCoord = widget.routeCoordinates.first;
    print('Adding start marker at: ${startCoord['latitude']}, ${startCoord['longitude']}');
    await pointManager!.create(mapbox.PointAnnotationOptions(
      geometry: mapbox.Point(coordinates: mapbox.Position(startCoord['longitude'], startCoord['latitude'])),
      iconImage: "start-marker",
      iconSize: 1.5,
    ));

    // End marker
    final endCoord = widget.routeCoordinates.last;
    print('Adding end marker at: ${endCoord['latitude']}, ${endCoord['longitude']}');
    await pointManager!.create(mapbox.PointAnnotationOptions(
      geometry: mapbox.Point(coordinates: mapbox.Position(endCoord['longitude'], endCoord['latitude'])),
      iconImage: "end-marker", 
      iconSize: 1.5,
    ));

    // Add current position marker (blue dot for navigation)
    await _addCurrentPositionMarker();
    
    print('Straight line route completed!');
  }

  Future<void> _addCurrentPositionMarker() async {
    currentPositionManager = await mapboxMap!.annotations.createPointAnnotationManager();
    
    // Start at first coordinate
    currentLat = widget.routeCoordinates.first['latitude'];
    currentLng = widget.routeCoordinates.first['longitude'];
    
    currentPositionMarker = await currentPositionManager!.create(
      mapbox.PointAnnotationOptions(
        geometry: mapbox.Point(coordinates: mapbox.Position(currentLng, currentLat)),
        iconImage: "default-marker",
        iconSize: 1.2,
        iconColor: Colors.blue.value,
      ),
    );
    
    print('Current position marker added at: $currentLat, $currentLng');
  }

  void _centerMapOnRoute() {
    if (widget.routeCoordinates.isEmpty) return;

    final startCoord = widget.routeCoordinates.first;
    final endCoord = widget.routeCoordinates.last;
    
    // Calculate center point
    final centerLat = (startCoord['latitude'] + endCoord['latitude']) / 2;
    final centerLon = (startCoord['longitude'] + endCoord['longitude']) / 2;

    print('=== CENTERING MAP ===');
    print('Center: $centerLat, $centerLon');
    print('Start: ${startCoord['latitude']}, ${startCoord['longitude']}');
    print('End: ${endCoord['latitude']}, ${endCoord['longitude']}');

    mapboxMap?.flyTo(
      mapbox.CameraOptions(
        center: mapbox.Point(coordinates: mapbox.Position(centerLon, centerLat)),
        zoom: 13.0,
        pitch: 0.0,
      ),
      mapbox.MapAnimationOptions(duration: 1000),
    );
  }

  void _calculateRouteStats() {
    final coordinates = routeWaypoints.isNotEmpty ? routeWaypoints : widget.routeCoordinates;
    if (coordinates.length < 2) return;
    
    totalDistance = 0.0;
    for (int i = 0; i < coordinates.length - 1; i++) {
      final coord1 = coordinates[i];
      final coord2 = coordinates[i + 1];
      totalDistance += _calculateDistance(
        coord1['latitude'], coord1['longitude'],
        coord2['latitude'], coord2['longitude'],
      );
    }
    
    remainingTime = (totalDistance / currentSpeed * 60).round();
  }

  void _startNavigation() {
    final coordinates = routeWaypoints.isNotEmpty ? routeWaypoints : widget.routeCoordinates;
    if (currentCoordinateIndex >= coordinates.length - 1) {
      _resetNavigation();
      return;
    }

    setState(() {
      isNavigating = true;
    });

    // Set target coordinates for smooth movement
    if (currentCoordinateIndex < coordinates.length - 1) {
      final nextCoord = coordinates[currentCoordinateIndex + 1];
      targetLat = nextCoord['latitude'];
      targetLng = nextCoord['longitude'];
      progress = 0.0;
    }

    navigationTimer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      if (currentCoordinateIndex < coordinates.length - 1) {
        _updateSmoothPosition();
      } else {
        _completeNavigation();
      }
    });
  }

  void _updateSmoothPosition() {
    final coordinates = routeWaypoints.isNotEmpty ? routeWaypoints : widget.routeCoordinates;
    if (progress < 1.0) {
      // Smooth interpolation between current and target position
      progress += 0.05; // Adjust speed of movement
      
      if (progress > 1.0) progress = 1.0;
      
      // Linear interpolation
      final newLat = currentLat + (targetLat - currentLat) * progress;
      final newLng = currentLng + (targetLng - currentLng) * progress;
      
      // Update current position marker
      _updateCurrentPositionMarker(newLat, newLng);
      
      // Update distance
      if (progress >= 1.0) {
        currentCoordinateIndex++;
        if (currentCoordinateIndex < coordinates.length - 1) {
          currentLat = targetLat;
          currentLng = targetLng;
          final nextCoord = coordinates[currentCoordinateIndex + 1];
          targetLat = nextCoord['latitude'];
          targetLng = nextCoord['longitude'];
          progress = 0.0;
        }
        
        _updateDistanceStats();
      }
      
      setState(() {});
    }
  }

  void _updateDistanceStats() {
    final coordinates = routeWaypoints.isNotEmpty ? routeWaypoints : widget.routeCoordinates;
    if (currentCoordinateIndex > 0) {
      final prevCoord = coordinates[currentCoordinateIndex - 1];
      final currentCoord = coordinates[currentCoordinateIndex];
      coveredDistance += _calculateDistance(
        prevCoord['latitude'], prevCoord['longitude'],
        currentCoord['latitude'], currentCoord['longitude'],
      );
    }

    final remainingDistance = totalDistance - coveredDistance;
    remainingTime = (remainingDistance / currentSpeed * 60).round();
  }

  Future<void> _updateCurrentPositionMarker(double lat, double lng) async {
    if (currentPositionMarker != null && currentPositionManager != null) {
      // Remove old marker and create new one at updated position
      await currentPositionManager!.delete(currentPositionMarker!);
      currentPositionMarker = await currentPositionManager!.create(
        mapbox.PointAnnotationOptions(
          geometry: mapbox.Point(coordinates: mapbox.Position(lng, lat)),
          iconImage: "default-marker",
          iconSize: 1.2,
          iconColor: Colors.blue.value,
        ),
      );
    }
  }

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371; // km
    final double dLat = _toRadians(lat2 - lat1);
    final double dLon = _toRadians(lon2 - lon1);
    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) * cos(_toRadians(lat2)) *
        sin(dLon / 2) * sin(dLon / 2);
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  double _toRadians(double degrees) {
    return degrees * (pi / 180);
  }

  void _toggleNavigation() {
    if (isNavigating) {
      _pauseNavigation();
    } else {
      _startNavigation();
    }
  }

  void _pauseNavigation() {
    navigationTimer?.cancel();
    setState(() {
      isNavigating = false;
    });
  }

  void _completeNavigation() {
    navigationTimer?.cancel();
    setState(() {
      isNavigating = false;
    });
    
    _showCompletionDialog();
  }

  void _resetNavigation() {
    navigationTimer?.cancel();
    setState(() {
      isNavigating = false;
      currentCoordinateIndex = 0;
      coveredDistance = 0.0;
      remainingTime = (totalDistance / currentSpeed * 60).round();
    });
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Route Completed!'),
        content: Text('You have successfully completed the route navigation.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Get.back();
            },
            child: Text('Done'),
          ),
        ],
      ),
    );
  }

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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.creamBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text(
          widget.routeName,
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: AppColor.creamBackgroundColor,
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              margin: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: mapbox.MapWidget(
                  onMapCreated: (map) {
                    mapboxMap = map;
                    _initializeRoute();
                  },
                  cameraOptions: mapbox.CameraOptions(
                    center: initialCenter ?? mapbox.Point(
                      coordinates: mapbox.Position.fromJson([90.393425, 23.754253]),
                    ),
                    zoom: 13.0,
                  ),
                ),
              ),
            ),
          ),
          
          Expanded(
            flex: 1,
            child: Container(
              margin: EdgeInsets.fromLTRB(16.w, 8.w, 16.w, 16.w),
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Distance',
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            '${coveredDistance.toStringAsFixed(1)} / ${totalDistance.toStringAsFixed(1)} km',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2C2C2C),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Time Remaining',
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            '$remainingTime min',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2C2C2C),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 12.h),
                  
                  LinearProgressIndicator(
                    value: totalDistance > 0 ? coveredDistance / totalDistance : 0.0,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3A5A4D)),
                  ),
                  
                  SizedBox(height: 12.h),
                  
                  if (widget.routeCoordinates.isNotEmpty)
                    Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Color(0xFF3A5A4D),
                            size: 18.w,
                          ),
                          SizedBox(width: 6.w),
                          Expanded(
                            child: Text(
                              'Waypoint ${currentCoordinateIndex + 1} of ${widget.routeCoordinates.length}',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Color(0xFF2C2C2C),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  
                  SizedBox(height: 12.h),
                  
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _resetNavigation,
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Color(0xFF3A5A4D)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 10.h),
                          ),
                          child: Text(
                            'Reset',
                            style: TextStyle(
                              color: Color(0xFF3A5A4D),
                              fontWeight: FontWeight.w600,
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                      ),
                      
                      SizedBox(width: 12.w),
                      
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: _toggleNavigation,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isNavigating ? Colors.red : Color(0xFF3A5A4D),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 10.h),
                          ),
                          child: Text(
                            isNavigating ? 'Pause' : 'Start Navigation',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
