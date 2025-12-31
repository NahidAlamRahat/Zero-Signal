import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;
import 'package:geolocator/geolocator.dart';
import 'package:zero_signal/constant/app_colors.dart';
import 'package:zero_signal/navigation/navigation_controller.dart';
import 'package:zero_signal/navigation/instruction_engine.dart';
import 'package:zero_signal/navigation/navigation_tts.dart';
import 'package:zero_signal/navigation/arrow_widget.dart';
import 'package:zero_signal/navigation/route_cache_service.dart';
import 'package:zero_signal/screen/home_screen/widget/map_type_bottom_sheet.dart';
import 'package:zero_signal/screen/route_navigation_screen/services/route_service.dart';

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
  final NavigationController _navController = NavigationController();
  final NavigationTTS _tts = NavigationTTS();

  StreamSubscription<Position>? _positionStream;
  mapbox.PolylineAnnotationManager? _lineManager;
  mapbox.PolylineAnnotationManager? _remainingLineManager;

  List<Map<String, dynamic>> _currentRoutePoints = [];
  String _currentInstruction = "Follow the route";
  double _instructionBearing = 0;
  bool _isLoading = true;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _initNavigation();
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    _tts.stop();
    mapboxMap = null; // CRITICAL: Stop using the map reference
    _lineManager = null;
    _remainingLineManager = null;
    super.dispose();
  }

  Future<void> _initNavigation() async {
    final cached = await RouteCacheService.getRoute(widget.routeId);
    if (cached != null) {
      _currentRoutePoints = cached;
      setState(() => _isLoading = false);
    }

    await RouteService.fetchRealRoadRoute(widget.routeCoordinates, (points) {
      if (mounted) {
        setState(() {
          _currentRoutePoints = points;
          _isLoading = false;
        });
        RouteCacheService.saveRoute(widget.routeId, points);
        _drawRoute();
      }
    });

    if (_currentRoutePoints.isEmpty) {
      _currentRoutePoints = widget.routeCoordinates;
      setState(() => _isLoading = false);
    }

    await _startGPS();
  }

  Future<void> _startGPS() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) return;

    final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    _onLocationUpdate(pos);

    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 3,
      ),
    ).listen(
      _onLocationUpdate,
      onError: (error) => print("GPS Stream Error: $error"),
    );
  }

  void _onLocationUpdate(Position pos) {
    if (!mounted) return;

    int oldIdx = _navController.closestIdx;

    setState(() {
      _navController.updatePosition(pos);
    });

    if (_navController.isNavigating) {
      _updatePuckSettings(pos);
      _updateNavigationLogic(pos);
      _followUser(pos);

      if (oldIdx != _navController.closestIdx) {
        _drawRoute();
      }
    }
  }

  void _updatePuckSettings(Position pos) {
    mapboxMap?.location.updateSettings(
      mapbox.LocationComponentSettings(
        enabled: true,
        pulsingEnabled: true,
        puckBearingEnabled: true,
        puckBearing: mapbox.PuckBearing.COURSE,
        locationPuck: mapbox.LocationPuck(
          locationPuck2D: mapbox.LocationPuck2D(),
        ),
      ),
    );
  }

  void _updateNavigationLogic(Position pos) {
    if (_currentRoutePoints.length < 2) return;

    double minDist = double.infinity;
    int closestIdx = 0;

    for (int i = 0; i < _currentRoutePoints.length; i++) {
      double d = Geolocator.distanceBetween(
          pos.latitude,
          pos.longitude,
          _currentRoutePoints[i]['latitude'],
          _currentRoutePoints[i]['longitude']);
      if (d < minDist) {
        minDist = d;
        closestIdx = i;
      }
    }

    if (minDist > 50) {
      _currentInstruction = "Off route! Return to path";
      _navController.hasSpoken = false;
    } else if (closestIdx < _currentRoutePoints.length - 1) {
      final p1 = _currentRoutePoints[closestIdx];
      final p2 = _currentRoutePoints[
          min(closestIdx + 1, _currentRoutePoints.length - 1)];

      double currentBearing = pos.heading;
      double targetBearing = InstructionEngine.calculateBearing(
          p1['latitude'], p1['longitude'], p2['latitude'], p2['longitude']);

      _instructionBearing = targetBearing - currentBearing;
      _currentInstruction =
          InstructionEngine.getInstruction(currentBearing, targetBearing);

      if (minDist < 35 && !_navController.hasSpoken) {
        _tts.speak(_currentInstruction);
        _navController.hasSpoken = true;
      }

      if (minDist > 40) {
        _navController.hasSpoken = false;
      }
    } else {
      _currentInstruction = "You have arrived!";
      _tts.speak(_currentInstruction);
    }
  }

  void _followUser(Position pos) {
    mapboxMap?.easeTo(
      mapbox.CameraOptions(
        center: mapbox.Point(
            coordinates: mapbox.Position(pos.longitude, pos.latitude)),
        zoom: _navController.mode == TravelMode.walking ? 19.5 : 18.5,
        bearing: pos.heading,
        pitch: 15.0,
      ),
      mapbox.MapAnimationOptions(duration: 800),
    );
  }

  Future<void> _drawRoute() async {
    if (mapboxMap == null || _currentRoutePoints.isEmpty || !mounted) return;

    try {
      if (_lineManager == null) {
        if (!mounted) return;
        _lineManager =
            await mapboxMap!.annotations.createPolylineAnnotationManager();
      } else {
        await _lineManager!.deleteAll();
      }

      if (_remainingLineManager == null) {
        if (!mounted) return;
        _remainingLineManager =
            await mapboxMap!.annotations.createPolylineAnnotationManager();
      } else {
        await _remainingLineManager!.deleteAll();
      }

      if (!mounted) return;
      int splitIdx = _navController.closestIdx;

      if (splitIdx < _currentRoutePoints.length) {
        final remainingCoords = _currentRoutePoints.sublist(splitIdx);
        final remainingOptions = mapbox.PolylineAnnotationOptions(
          geometry: mapbox.LineString(
            coordinates: remainingCoords
                .map((p) => mapbox.Position(p['longitude'], p['latitude']))
                .toList(),
          ),
          lineColor: Colors.blue.value,
          lineWidth: 6.0,
        );
        if (mounted && _remainingLineManager != null) {
          await _remainingLineManager!.create(remainingOptions);
        }
      }

      if (splitIdx > 0) {
        final passedCoords = _currentRoutePoints.sublist(0, splitIdx + 1);
        final passedOptions = mapbox.PolylineAnnotationOptions(
          geometry: mapbox.LineString(
            coordinates: passedCoords
                .map((p) => mapbox.Position(p['longitude'], p['latitude']))
                .toList(),
          ),
          lineColor: Colors.greenAccent.value,
          lineWidth: 4.0,
          lineOpacity: 0.6,
        );
        if (mounted && _lineManager != null) {
          await _lineManager!.create(passedOptions);
        }
      }
    } catch (e) {
      print("Error drawing route: $e");
    }
  }

  void _startNavigation() {
    if (_navController.currentPosition == null) {
      Get.snackbar("Location Error", "Waiting for GPS signal...",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white);
      return;
    }

    HapticFeedback.heavyImpact();
    _navController.start(_navController.currentPosition!, _currentRoutePoints);

    _updatePuckSettings(_navController.currentPosition!);
    _followUser(_navController.currentPosition!);
    _drawRoute();

    Get.snackbar(
      "Navigation Active",
      "Guidance started successfully",
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green.withOpacity(0.8),
      colorText: Colors.white,
      icon: Icon(Icons.navigation, color: Colors.white),
    );

    _tts.speak("Starting navigation. Follow the highlighted route.");
    setState(() {});
  }

  void _stopNavigation() {
    HapticFeedback.mediumImpact();
    _navController.stop();
    _tts.stop();
    setState(() => _isExpanded = false);
  }

  void _toggleTravelMode() {
    setState(() {
      _navController.mode = _navController.mode == TravelMode.driving
          ? TravelMode.walking
          : TravelMode.driving;

      if (_navController.isNavigating &&
          _navController.currentPosition != null) {
        _updatePuckSettings(_navController.currentPosition!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          _buildMap(),
          if (_isLoading) _buildLoader(),
          if (_navController.isNavigating) _buildArrowOverlay(),
          _buildFloatingControls(),
          _buildBottomPanel(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: Container(
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        child: IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 16.w),
          child: GestureDetector(
            onTap: _toggleTravelMode,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
              ),
              child: Row(
                children: [
                  Icon(
                    _navController.mode == TravelMode.driving
                        ? Icons.directions_car
                        : Icons.directions_walk,
                    color: AppColor.backgroundColor,
                    size: 20.sp,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    _navController.mode == TravelMode.driving
                        ? "Driving"
                        : "Walking",
                    style: TextStyle(
                        color: Colors.black87, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMap() {
    return mapbox.MapWidget(
      onMapCreated: (map) {
        mapboxMap = map;
        _drawRoute();
        if (_navController.currentPosition != null) {
          _followUser(_navController.currentPosition!);
        }
      },
      onStyleLoadedListener: (styleLoadedEvent) {
        // Redraw route when style changes
        _drawRoute();
        if (_navController.currentPosition != null &&
            _navController.isNavigating) {
          _updatePuckSettings(_navController.currentPosition!);
        }
      },
      cameraOptions: mapbox.CameraOptions(
        center: _navController.currentPosition != null
            ? mapbox.Point(
                coordinates: mapbox.Position(
                    _navController.currentPosition!.longitude,
                    _navController.currentPosition!.latitude))
            : mapbox.Point(coordinates: mapbox.Position(90.4125, 23.8103)),
        zoom: 12.0,
      ),
    );
  }

  Widget _buildLoader() {
    return Center(
        child: CircularProgressIndicator(color: AppColor.backgroundColor));
  }

  Widget _buildArrowOverlay() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 60.h,
      left: 20.w,
      right: 20.w,
      child: ArrowWidget(
        angle: _instructionBearing,
        instruction: _currentInstruction,
        distance: _navController.remainingDistance,
      ),
    );
  }

  Widget _buildFloatingControls() {
    return Positioned(
      bottom: _isExpanded ? 460.h : 120.h,
      left: 0,
      right: 0,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (_navController.isNavigating)
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  if (_navController.currentPosition != null) {
                    _followUser(_navController.currentPosition!);
                  }
                },
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30.r),
                    boxShadow: [
                      BoxShadow(color: Colors.black26, blurRadius: 10)
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.room, color: Colors.blue, size: 20.sp),
                      SizedBox(width: 8.w),
                      Text(
                        "Re-center",
                        style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: 13.sp),
                      ),
                    ],
                  ),
                ),
              ),
            Column(
              children: [
                _circularControl(Icons.layers, onTap: _showMapTypeBottomSheet),
                SizedBox(height: 10.h),
                _circularControl(Icons.compass_calibration,
                    onTap: _resetBearing),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _circularControl(IconData icon, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 45.w,
        height: 45.w,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
        ),
        child: Icon(icon, color: Colors.black87, size: 22.sp),
      ),
    );
  }

  void _resetBearing() {
    HapticFeedback.lightImpact();
    mapboxMap?.easeTo(
      mapbox.CameraOptions(bearing: 0),
      mapbox.MapAnimationOptions(duration: 500),
    );
  }

  void _showMapTypeBottomSheet() {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => MapTypeBottomSheet(
        selectedMapType: "OutDoor", // Default or track state
        onMapTypeSelected: (type) {
          String styleUri = 'mapbox://styles/mapbox/streets-v12';
          if (type == 'Satellite') {
            styleUri = 'mapbox://styles/lede18/cmg91jkk3000r01sf8m1r29ky';
          } else if (type == 'Terrain') {
            styleUri = 'mapbox://styles/lede18/cmg91k73u000s01qo5ye4bl7q';
          }

          // CRITICAL: Reset managers so they are recreated for the new style
          _lineManager = null;
          _remainingLineManager = null;

          mapboxMap?.style.setStyleURI(styleUri);
        },
      ),
    );
  }

  Widget _buildBottomPanel() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        height:
            _navController.isNavigating ? (_isExpanded ? 500.h : 115.h) : 85.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20)],
        ),
        child: SingleChildScrollView(
          physics: _isExpanded
              ? const BouncingScrollPhysics()
              : const NeverScrollableScrollPhysics(),
          child: _navController.isNavigating
              ? _buildNavigationStats()
              : _buildStartButton(),
        ),
      ),
    );
  }

  Widget _buildStartButton() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: SizedBox(
          width: double.infinity,
          height: 50.h,
          child: ElevatedButton(
            onPressed: _startNavigation,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.backgroundColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.r)),
            ),
            child: Text(
              "START NAVIGATION",
              style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationStats() {
    return Column(
      children: [
        GestureDetector(
          onTap: () => setState(() => _isExpanded = !_isExpanded),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 12.h),
            color: Colors.transparent,
            child: Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _statItem(_navController.elapsedFormatted, "Time", isLarge: true),
              _statItem(
                "${(_navController.remainingDistance / 1000).toStringAsFixed(2)} km",
                "Distance",
                isLarge: true,
              ),
              IconButton(
                onPressed: () => setState(() => _isExpanded = !_isExpanded),
                icon: Icon(_isExpanded
                    ? Icons.keyboard_arrow_down
                    : Icons.keyboard_arrow_up),
                color: Colors.grey,
              )
            ],
          ),
        ),
        if (_isExpanded) ...[
          SizedBox(height: 25.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _statItem(_navController.elapsedFormatted, "Time"),
                    _statItem(
                        "${(_navController.remainingDistance / 1000).toStringAsFixed(2)}km",
                        "Distance"),
                    _statItem("0m", "Elevation"),
                  ],
                ),
                SizedBox(height: 25.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _statItem("${_navController.etaMinutes}m", "Remaining"),
                    _statItem("${_navController.pace}/km", "Pace"),
                    _statItem(
                        "${_navController.speedKmh.toStringAsFixed(1)}km/h",
                        "Speed"),
                  ],
                ),
              ],
            ),
          ),
          Container(
            height: 90.h,
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Center(
              child:
                  Icon(Icons.show_chart, color: Colors.grey[300], size: 45.sp),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.w),
            child: SizedBox(
              width: double.infinity,
              height: 45.h,
              child: OutlinedButton(
                onPressed: _stopNavigation,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.red, width: 1.5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r)),
                ),
                child: Text(
                  "STOP",
                  style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 13.sp),
                ),
              ),
            ),
          )
        ]
      ],
    );
  }

  Widget _statItem(String value, String label, {bool isLarge = false}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: isLarge ? 22.sp : 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.grey[500],
          ),
        ),
      ],
    );
  }
}
