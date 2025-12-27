import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;
import 'package:geolocator/geolocator.dart';
import 'package:zero_signal/constant/app_colors.dart';
import 'package:zero_signal/screen/route_navigation_screen/widgets/navigation_controls_widget.dart';
import 'package:zero_signal/screen/route_navigation_screen/widgets/route_map_widget.dart';
import 'package:zero_signal/screen/route_navigation_screen/widgets/route_stats_dialog.dart';
import 'package:zero_signal/screen/route_navigation_screen/services/route_service.dart';
import 'dart:math';

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
  
  // Blinking animation variables
  Timer? blinkTimer;
  bool isMarkerVisible = true;
  double pulseScale = 1.0; // For pulsing effect
  
  // Generated route waypoints
  List<Map<String, dynamic>> routeWaypoints = [];
  
  // Map annotations
  mapbox.PointAnnotationManager? pointManager;
  mapbox.PolylineAnnotationManager? lineManager;
  mapbox.CircleAnnotationManager? circleManager; // Add circle manager
  
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
    blinkTimer?.cancel();
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
      final distance = RouteService.calculateDistance(
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
    await _fetchRealRoadRoute();
    
    if (routeWaypoints.isEmpty) {
      // Fallback to curved path simulation
      routeWaypoints = RouteService.generateIntermediateWaypoints(
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
      
      // Create circle manager for current position marker
      circleManager = await mapboxMap!.annotations.createCircleAnnotationManager();
      
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
      // await _addCurrentPositionMarker(); // Only add when navigation starts
      
      print('Realistic route completed!');
    }
  }

  Future<void> _fetchRealRoadRoute() async {
    await RouteService.fetchRealRoadRoute(
      widget.routeCoordinates,
      (waypoints) {
        setState(() {
          routeWaypoints = waypoints;
        });
        _drawRealRoadRoute();
      },
    );
    
    if (routeWaypoints.isEmpty) {
      print('=== FALLING BACK TO STRAIGHT LINE ROUTE ===');
      await _drawStraightLineRoute();
    }
  }

  Future<void> _drawRealRoadRoute() async {
    if (routeWaypoints.isEmpty) return;
    
    print('=== DRAWING REAL ROAD ROUTE ===');
    print('Waypoints count: ${routeWaypoints.length}');

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
    
    // Create circle manager for current position marker
    circleManager = await mapboxMap!.annotations.createCircleAnnotationManager();
    
    final startCoord = widget.routeCoordinates.first;
    final endCoord = widget.routeCoordinates.last;
    
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
    // await _addCurrentPositionMarker(); // Only add when navigation starts
    
    print('Real road route completed!');
  }

  void _calculateRouteStats() {
    final coordinates = routeWaypoints.isNotEmpty ? routeWaypoints : widget.routeCoordinates;
    if (coordinates.length < 2) return;
    
    totalDistance = 0.0;
    for (int i = 0; i < coordinates.length - 1; i++) {
      final coord1 = coordinates[i];
      final coord2 = coordinates[i + 1];
      totalDistance += RouteService.calculateDistance(
        coord1['latitude'], coord1['longitude'],
        coord2['latitude'], coord2['longitude'],
      );
    }
    
    remainingTime = (totalDistance / currentSpeed * 60).round();
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
    // await _addCurrentPositionMarker(); // Only add when navigation starts
    
    print('Straight line route completed!');
  }

  Future<void> _addCurrentPositionMarker() async {
    // Create a separate point manager for the current position marker
    currentPositionManager = await mapboxMap!.annotations.createPointAnnotationManager();
    
    // Start at the FIRST coordinate (starting point) instead of current GPS
    final coordinates = routeWaypoints.isNotEmpty ? routeWaypoints : widget.routeCoordinates;
    if (coordinates.isNotEmpty) {
      final startCoord = coordinates.first;
      currentLat = startCoord['latitude'];
      currentLng = startCoord['longitude'];
    }
    
    // Try to use a walking icon - fallback to default if not available
    try {
      currentPositionMarker = await currentPositionManager!.create(
        mapbox.PointAnnotationOptions(
          geometry: mapbox.Point(coordinates: mapbox.Position(currentLng, currentLat)),
          iconImage: "walking-15", // Try Mapbox walking icon
          iconSize: 2.0,
          iconColor: Colors.red.value,
        ),
      );
    } catch (e) {
      print('Walking icon not available, trying navigation icon: $e');
      try {
        currentPositionMarker = await currentPositionManager!.create(
          mapbox.PointAnnotationOptions(
            geometry: mapbox.Point(coordinates: mapbox.Position(currentLng, currentLat)),
            iconImage: "road-sign", // Try road sign icon
            iconSize: 2.0,
            iconColor: Colors.red.value,
          ),
        );
      } catch (e2) {
        print('Navigation icon not available, using default marker: $e2');
        currentPositionMarker = await currentPositionManager!.create(
          mapbox.PointAnnotationOptions(
            geometry: mapbox.Point(coordinates: mapbox.Position(currentLng, currentLat)),
            iconSize: 2.0,
            iconColor: Colors.red.value,
          ),
        );
      }
    }
        // Start blinking animation
    _startBlinkingAnimation();
    
    print('Car marker added at starting point: $currentLat, $currentLng');
  }

  void _startBlinkingAnimation() {
    blinkTimer?.cancel();
    blinkTimer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      if (mounted && isNavigating) {
        setState(() {
          // Create pulsing wave effect
          pulseScale = 1.0 + (sin(DateTime.now().millisecondsSinceEpoch / 200.0) * 0.3);
        });
      }
    });
  }

  void _updateMarkerVisibility() async {
    if (currentPositionManager != null) {
      // Only try to delete if marker exists
      if (currentPositionMarker != null) {
        try {
          await currentPositionManager!.delete(currentPositionMarker!);
        } catch (e) {
          print('Marker already deleted or not added: $e');
        }
        currentPositionMarker = null;
      }
      
      // Create new marker with updated visibility
      if (isMarkerVisible) {
        currentPositionMarker = await currentPositionManager!.create(
          mapbox.PointAnnotationOptions(
            geometry: mapbox.Point(coordinates: mapbox.Position(currentLng, currentLat)),
            iconImage: "walking-15",
            iconSize: 2.0,
            iconColor: Colors.red.value,
          ),
        );
      } else {
        currentPositionMarker = await currentPositionManager!.create(
          mapbox.PointAnnotationOptions(
            geometry: mapbox.Point(coordinates: mapbox.Position(currentLng, currentLat)),
            iconImage: "walking-15",
            iconSize: 1.5, // Smaller when "invisible"
            iconColor: Colors.pink.value,
          ),
        );
      }
    }
  }

  void _stopBlinkingAnimation() {
    blinkTimer?.cancel();
    setState(() {
      isMarkerVisible = true;
    });
    _updateMarkerVisibility();
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

  void _startNavigation() {
    final coordinates = routeWaypoints.isNotEmpty ? routeWaypoints : widget.routeCoordinates;
    if (currentCoordinateIndex >= coordinates.length - 1) {
      _resetNavigation();
      return;
    }

    setState(() {
      isNavigating = true;
    });

    // Add current position marker when navigation starts
    _addCurrentPositionMarker();

    // Start blinking when navigation starts
    _startBlinkingAnimation();

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
      
      // Follow the marker with camera during navigation
      _followMarker(newLat, newLng);
      
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

  void _followMarker(double lat, double lng) {
    if (mapboxMap != null && isNavigating) {
      // Smoothly follow the marker with camera
      mapboxMap?.flyTo(
        mapbox.CameraOptions(
          center: mapbox.Point(coordinates: mapbox.Position(lng, lat)),
          zoom: 15.0, // Closer zoom for better navigation view
          pitch: 0.0,
        ),
        mapbox.MapAnimationOptions(duration: 500), // Smooth transition
      );
    }
  }

  void _updateDistanceStats() {
    final coordinates = routeWaypoints.isNotEmpty ? routeWaypoints : widget.routeCoordinates;
    if (currentCoordinateIndex > 0) {
      final prevCoord = coordinates[currentCoordinateIndex - 1];
      final currentCoord = coordinates[currentCoordinateIndex];
      coveredDistance += RouteService.calculateDistance(
        prevCoord['latitude'], prevCoord['longitude'],
        currentCoord['latitude'], currentCoord['longitude'],
      );
    }

    final remainingDistance = totalDistance - coveredDistance;
    remainingTime = (remainingDistance / currentSpeed * 60).round();
  }

  Future<void> _updateCurrentPositionMarker(double lat, double lng) async {
    currentLat = lat;
    currentLng = lng;
    
    // Update circle marker position (will maintain blinking state)
    _updateMarkerVisibility();
  }

  void _toggleNavigation() {
    if (isNavigating) {
      _pauseNavigation();
      _stopBlinkingAnimation();
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
    _showRouteStatsDialog();
  }

  void _showRouteStatsDialog() {
    // Calculate pace (minutes per km)
    final pace = currentSpeed > 0 ? (60 / currentSpeed).toStringAsFixed(1) : '0.0';
    
    // Generate sample elevation data
    final elevationData = List.generate(20, (index) {
      final baseElevation = 350.0;
      final variation = sin(index * 0.5) * 50 + cos(index * 0.3) * 30;
      return baseElevation + variation;
    });

    showDialog(
      context: context,
      builder: (context) => RouteStatsDialog(
        movementTime: '${(coveredDistance / currentSpeed * 60).toStringAsFixed(0)}:${((coveredDistance / currentSpeed * 60 % 1) * 60).toStringAsFixed(0).padLeft(2, '0')}',
        distance: totalDistance.toStringAsFixed(1),
        totalTime: '$remainingTime',
        pace: pace,
        remaining: '${(totalDistance - coveredDistance).toStringAsFixed(1)}',
        speed: currentSpeed.toStringAsFixed(1),
        elevationData: elevationData,
        onResume: () {
          Get.back();
          _startNavigation();
        },
        onFinish: () {
          Get.back();
          _completeNavigation();
        },
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
                child: Stack(
                  children: [
                    mapbox.MapWidget(
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
                    
                    // Custom car icon overlay
                    if (currentLat > 0 && currentLng > 0)
                      Positioned(
                        top: MediaQuery.of(context).size.height * 0.3, // Adjust position as needed
                        left: MediaQuery.of(context).size.width * 0.5 - 20, // Center horizontally
                        child: Transform.scale(
                          scaleX: -1.0, // Horizontal flip for mirror side
                          child: Icon(
                            Icons.pedal_bike, // Bicycle icon
                            size: 40.0,
                            color: const Color.fromARGB(255, 97, 86, 85),
                            shadows: [
                              Shadow(
                                color: Colors.white.withOpacity(0.8),
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
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
                      
                      SizedBox(width: 8.w),
                      
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _showRouteStatsDialog,
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.blue),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 10.h),
                          ),
                          child: Text(
                            'Stats',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w600,
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                      ),
                      
                      SizedBox(width: 8.w),
                      
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
