import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;
import 'package:zero_signal/constant/app_icon_path.dart';
import 'package:zero_signal/constant/app_image_path.dart';
import 'package:zero_signal/screen/map_routes_screen/widget/route_card_widget.dart';
import 'package:zero_signal/widget/text_field_widget/text_field_widget.dart';
import 'package:zero_signal/widget/text_widget/text_widgets.dart';
import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:math' as math;
import 'dart:convert' as convert;
import '../../constant/app_colors.dart';
import '../../gen/assets.gen.dart';
import '../../routes/app_routes.dart';
import '../../utils/app_log/app_log.dart';
import 'controller/map_routes_controller.dart';

class MapRoutesScreen extends StatefulWidget {
  const MapRoutesScreen({super.key});

  @override
  State<MapRoutesScreen> createState() => _MapRoutesScreenState();
}

class _MapRoutesScreenState extends State<MapRoutesScreen> {
  String selectedMapType = 'Default';
  late mapbox.MapboxMap mapboxMap;
  final PageController _pageController = PageController();
  int currentRouteIndex = 0;
  late MapRoutesController controller;
  
  // Route display variables
  Map<String, dynamic>? selectedRoute;
  mapbox.PointAnnotationManager? pointAnnotationManager;
  mapbox.CircleAnnotationManager? circleAnnotationManager;
  mapbox.PolylineAnnotationManager? polylineAnnotationManager;

  @override
  void initState() {
    super.initState();
    appLog('MapRoutesScreen initialized - using controller', type: LogType.info, source: 'INIT');
    controller = Get.put(MapRoutesController());
    
    // Listen for route data changes and auto-display first route
    ever(controller.routesList, (routes) {
      if (routes.isNotEmpty && selectedRoute == null) {
        // Auto-display the first route when data is loaded
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _onRouteSelected(routes[0]);
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// Initialize map settings
  Future<void> _initializeMap() async {
    try {
      // Load map style
      await mapboxMap.loadStyleURI('mapbox://styles/mapbox/streets-v12');
      
      // Disable compass and scale bar for cleaner look
      await mapboxMap.compass.updateSettings(
        mapbox.CompassSettings(enabled: false),
      );
      await mapboxMap.scaleBar.updateSettings(
        mapbox.ScaleBarSettings(enabled: false),
      );
      
      // Auto-display first route if data is already available
      if (controller.routesList.isNotEmpty && selectedRoute == null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _onRouteSelected(controller.routesList[0]);
        });
      }
    } catch (e) {
      appLog('Error initializing map: $e', type: LogType.error, source: 'MAP');
    }
  }

  /// Center map on current location (Dhaka coordinates for demo)
  Future<void> _centerMapOnCurrentLocation() async {
    try {
      final camera = mapbox.CameraOptions(
        center: mapbox.Point(
          coordinates: mapbox.Position.fromJson([90.4125, 23.8103]), // Dhaka coordinates
        ),
        zoom: 14.0,
      );
      final animationOptions = mapbox.MapAnimationOptions(
        duration: 1000, // Duration in milliseconds
      );
      await mapboxMap.flyTo(camera, animationOptions);
    } catch (e) {
      appLog('Error centering map: $e', type: LogType.error, source: 'MAP');
    }
  }

  /// Display route on map
  Future<void> _displayRouteOnMap(Map<String, dynamic> routeData) async {
    try {
      appLog('=== Starting _displayRouteOnMap ===', type: LogType.info, source: 'MAP');
      
      // Clear previous route
      await _clearRouteFromMap();
      
      final initialLat = routeData['inital_lat'] as double?;
      final initialLng = routeData['inital_lng'] as double?;
      final finalLat = routeData['final_lat'] as double?;
      final finalLng = routeData['final_lng'] as double?;
      
      appLog('Extracted coordinates - Initial: $initialLat, $initialLng | Final: $finalLat, $finalLng', type: LogType.info, source: 'MAP');
      
      if (initialLat == null || initialLng == null || finalLat == null || finalLng == null) {
        appLog('Invalid route coordinates - one or more coordinates are null', type: LogType.error, source: 'MAP');
        return;
      }
      
      // Create annotation manager if not already created
      pointAnnotationManager ??= await mapboxMap.annotations.createPointAnnotationManager();
      appLog('Point annotation manager created/obtained', type: LogType.info, source: 'MAP');
      
      // Add start and end point markers
      await _addRouteMarkers(initialLat, initialLng, finalLat, finalLng);
      appLog('Route markers added', type: LogType.info, source: 'MAP');
      
      // Center map on route
      await _centerMapOnRoute(initialLat, initialLng, finalLat, finalLng);
      appLog('Map centered on route', type: LogType.info, source: 'MAP');
      
      appLog('Route displayed on map successfully', type: LogType.info, source: 'MAP');
    } catch (e) {
      appLog('Error displaying route on map: $e', type: LogType.error, source: 'MAP');
    }
  }

  /// Add start and end markers for the route
  Future<void> _addRouteMarkers(double initialLat, double initialLng, double finalLat, double finalLng) async {
    try {
      appLog('=== Starting _addRouteMarkers ===', type: LogType.info, source: 'MAP');
      appLog('PointAnnotationManager is null: ${pointAnnotationManager == null}', type: LogType.info, source: 'MAP');
      
      if (pointAnnotationManager == null) {
        appLog('PointAnnotationManager is null, returning early', type: LogType.warning, source: 'MAP');
        return;
      }
      
      // Create circle annotations for better visibility
      circleAnnotationManager = await mapboxMap.annotations.createCircleAnnotationManager();
      
      // Create polyline annotation for route line
      polylineAnnotationManager = await mapboxMap.annotations.createPolylineAnnotationManager();
      
      // Get real road route using Mapbox Directions API
      await _drawRealRoadRoute(initialLat, initialLng, finalLat, finalLng);
      
      // Start point circle (green)
      final startCircle = mapbox.CircleAnnotationOptions(
        geometry: mapbox.Point(coordinates: mapbox.Position(initialLng, initialLat)),
        circleColor: Colors.green.value,
        circleRadius: 8.0,
        circleStrokeColor: Colors.white.value,
        circleStrokeWidth: 2.0,
      );
      
      // End point circle (red)
      final endCircle = mapbox.CircleAnnotationOptions(
        geometry: mapbox.Point(coordinates: mapbox.Position(finalLng, finalLat)),
        circleColor: Colors.red.value,
        circleRadius: 8.0,
        circleStrokeColor: Colors.white.value,
        circleStrokeWidth: 2.0,
      );
      
      appLog('Creating start circle at: $initialLat, $initialLng', type: LogType.info, source: 'MAP');
      await circleAnnotationManager!.create(startCircle);
      
      appLog('Creating end circle at: $finalLat, $finalLng', type: LogType.info, source: 'MAP');
      await circleAnnotationManager!.create(endCircle);
      
      appLog('Real road route and markers created successfully', type: LogType.info, source: 'MAP');
    } catch (e) {
      appLog('Error in _addRouteMarkers: $e', type: LogType.error, source: 'MAP');
    }
  }

  /// Draw real road route using Mapbox Directions API (same method as SpotNavigationController)
  Future<void> _drawRealRoadRoute(double initialLat, double initialLng, double finalLat, double finalLng) async {
    try {
      appLog('=== Getting real road route ===', type: LogType.info, source: 'MAP');
      appLog('From: $initialLat, $initialLng To: $finalLat, $finalLng', type: LogType.info, source: 'MAP');
      
      // Use same method as SpotNavigationController
      final String mapboxAccessToken = 'pk.eyJ1IjoibGVkZTE4IiwiYSI6ImNtZzgzcmxodDAyejIybXIzcHUyZGRyMzgifQ.jbe1XMovv8MF5TGitB9PwQ';
      final String url = 'https://api.mapbox.com/directions/v5/mapbox/driving/$initialLng,$initialLat;$finalLng,$finalLat'
          '?access_token=$mapboxAccessToken'
          '&geometries=geojson'
          '&overview=full';
      
      appLog('Directions API URL: $url', type: LogType.info, source: 'MAP');
      
      // Make API call using http directly (same as SpotNavigationController)
      final response = await http.get(Uri.parse(url));
      appLog('Response status: ${response.statusCode}', type: LogType.info, source: 'MAP');
      
      if (response.statusCode == 200) {
        final data = convert.jsonDecode(response.body);
        final routes = data['routes'] as List;
        
        if (routes.isNotEmpty) {
          final geometry = routes[0]['geometry'];
          final coordinates = geometry['coordinates'] as List;
          
          appLog('Got route with ${coordinates.length} coordinate points', type: LogType.info, source: 'MAP');
          appLog('First 3 coordinates: ${coordinates.take(3).toList()}', type: LogType.info, source: 'MAP');
          
          // Convert coordinates to Position list (same as SpotNavigationController)
          final routeCoordinates = coordinates.map((coord) {
            return mapbox.Position(coord[0], coord[1]);
          }).toList();
          
          if (routeCoordinates.length > 2) {
            // Create LineString from real route coordinates
            final routeLine = mapbox.PolylineAnnotationOptions(
              geometry: mapbox.LineString(coordinates: routeCoordinates),
              lineColor: 0xFF10B981, // Green color like SpotNavigationController
              lineWidth: 4.0,
            );
            
            await polylineAnnotationManager!.create(routeLine);
            appLog('Real road route drawn successfully with ${routeCoordinates.length} points - THIS IS THE ACTUAL DRIVING ROUTE!', type: LogType.info, source: 'MAP');
          } else {
            appLog('Route has insufficient coordinates (${routeCoordinates.length}), falling back to straight line', type: LogType.warning, source: 'MAP');
            await _drawStraightLineFallback(initialLat, initialLng, finalLat, finalLng);
          }
        } else {
          appLog('No routes found in response, falling back to straight line', type: LogType.warning, source: 'MAP');
          await _drawStraightLineFallback(initialLat, initialLng, finalLat, finalLng);
        }
      } else {
        appLog('API call failed with status ${response.statusCode}, falling back to straight line', type: LogType.warning, source: 'MAP');
        appLog('Response body: ${response.body}', type: LogType.warning, source: 'MAP');
        await _drawStraightLineFallback(initialLat, initialLng, finalLat, finalLng);
      }
    } catch (e) {
      appLog('Error getting real road route: $e, falling back to straight line', type: LogType.error, source: 'MAP');
      await _drawStraightLineFallback(initialLat, initialLng, finalLat, finalLng);
    }
  }

  /// Fallback to straight line if directions API fails
  Future<void> _drawStraightLineFallback(double initialLat, double initialLng, double finalLat, double finalLng) async {
    try {
      final routeLine = mapbox.PolylineAnnotationOptions(
        geometry: mapbox.LineString(
          coordinates: [
            mapbox.Position(initialLng, initialLat), // Start point
            mapbox.Position(finalLng, finalLat),     // End point
          ],
        ),
        lineColor: Colors.red.value,
        lineWidth: 4.0,
        lineOpacity: 0.8,
      );
      
      appLog('Creating fallback straight line from: $initialLat, $initialLng to $finalLat, $finalLng', type: LogType.info, source: 'MAP');
      await polylineAnnotationManager!.create(routeLine);
    } catch (e) {
      appLog('Error creating fallback straight line: $e', type: LogType.error, source: 'MAP');
    }
  }

  /// Clear route from map
  Future<void> _clearRouteFromMap() async {
    try {
      // Clear point annotations
      if (pointAnnotationManager != null) {
        await pointAnnotationManager!.deleteAll();
      }
      
      // Clear circle annotations
      if (circleAnnotationManager != null) {
        await circleAnnotationManager!.deleteAll();
      }
      
      // Clear polyline annotations
      if (polylineAnnotationManager != null) {
        await polylineAnnotationManager!.deleteAll();
      }
      
      appLog('Route cleared from map', type: LogType.info, source: 'MAP');
    } catch (e) {
      appLog('Error clearing route from map: $e', type: LogType.error, source: 'MAP');
    }
  }

  /// Center map on route bounds
  Future<void> _centerMapOnRoute(double initialLat, double initialLng, double finalLat, double finalLng) async {
    try {
      // Calculate center point
      final centerLat = (initialLat + finalLat) / 2;
      final centerLng = (initialLng + finalLng) / 2;
      
      // Calculate appropriate zoom level based on distance
      final distance = _calculateDistance(initialLat, initialLng, finalLat, finalLng);
      double zoomLevel = 12.0;
      
      if (distance > 50000) {
        zoomLevel = 8.0;
      } else if (distance > 20000) {
        zoomLevel = 10.0;
      } else if (distance > 10000) {
        zoomLevel = 11.0;
      } else if (distance > 5000) {
        zoomLevel = 12.0;
      } else {
        zoomLevel = 13.0;
      }
      
      final camera = mapbox.CameraOptions(
        center: mapbox.Point(coordinates: mapbox.Position(centerLng, centerLat)),
        zoom: zoomLevel,
      );
      
      final animationOptions = mapbox.MapAnimationOptions(
        duration: 1000,
      );
      
      await mapboxMap.flyTo(camera, animationOptions);
    } catch (e) {
      appLog('Error centering map on route: $e', type: LogType.error, source: 'MAP');
    }
  }

  /// Calculate distance between two points in meters
  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371000; // Earth's radius in meters
    
    final double dLat = _toRadians(lat2 - lat1);
    final double dLon = _toRadians(lon2 - lon1);
    
    final double a = 
        math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRadians(lat1)) * math.cos(_toRadians(lat2)) *
        math.sin(dLon / 2) * math.sin(dLon / 2);
    final double c = 2 * math.asin(math.sqrt(a));
    
    return earthRadius * c;
  }

  double _toRadians(double degrees) {
    return degrees * (3.14159265359 / 180);
  }

  /// Handle route selection
  void _onRouteSelected(Map<String, dynamic> routeData) {
    appLog('Route selected: ${routeData['title']}', type: LogType.info, source: 'MAP');
    appLog('Route ID: ${routeData['_id']}', type: LogType.info, source: 'MAP');
    appLog('Route coordinates from API - Initial: ${routeData['inital_lat']}, ${routeData['inital_lng']} | Final: ${routeData['final_lat']}, ${routeData['final_lng']}', type: LogType.info, source: 'MAP');
    appLog('Full route data: $routeData', type: LogType.info, source: 'MAP');
    
    setState(() {
      selectedRoute = routeData;
    });
    
    _displayRouteOnMap(routeData);
  }

  @override
  Widget build(BuildContext context) {
    appLog('=== MapRoutesScreen build() called ===',
        type: LogType.info, source: 'BUILD');

    return GetBuilder<MapRoutesController>(
      builder: (controller) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            title: Row(
              children: [
                Expanded(
                  child: TextFieldWidget(
                    hintText: 'Search in ZeroSignal',
                    fieldHeight: 40,
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  ),
                ),
                const SizedBox(width: 10),
                InkWell(
                  onTap: () {
                    Get.toNamed(AppRoutes.filtersScreen);
                  },
                  child: Image.asset(
                    AppIconPath.filtaringIcon,
                    width: 65,
                    height: 65,
                  ),
                ),
              ],
            ),
          ),

          // ================= BODY =================
          body: Stack(
            children: [
              /// MAP
              Positioned.fill(
                child: mapbox.MapWidget(
                  onMapCreated: (map) {
                    mapboxMap = map;
                    _initializeMap();
                  },
                  cameraOptions: mapbox.CameraOptions(
                    center: mapbox.Point(
                      coordinates:
                          mapbox.Position.fromJson([90.4125, 23.8103]),
                    ),
                    zoom: 12.0,
                  ),
                  gestureRecognizers: {
                    Factory<OneSequenceGestureRecognizer>(
                      () => EagerGestureRecognizer(),
                    ),
                  },
                ),
              ),

              /// MAP TYPE BUTTON
              Positioned(
                top: kToolbarHeight + 50.h,
                right: 20,
                child: InkWell(
                  onTap: _showMapTypeBottomSheet,
                  child: Image.asset(
                    AppIconPath.choiceMap,
                    width: 40,
                    height: 40,
                  ),
                ),
              ),

              /// FLOATING BUTTONS
              Positioned(
                bottom: 310.h,
                right: 20,
                child: Column(
                  children: [
                    FloatingActionButton(
                      mini: true,
                      heroTag: "map_btn1",
                      backgroundColor: Colors.transparent,
                      onPressed: _centerMapOnCurrentLocation,
                      child: Image.asset(AppIconPath.mapIcon),
                    ),
                    const SizedBox(height: 10),
                    FloatingActionButton(
                      mini: true,
                      heroTag: "map_btn2",
                      backgroundColor: Colors.transparent,
                      onPressed: () {
                        Get.toNamed(AppRoutes.shareSpotScreen);
                      },
                      child: Image.asset(
                        Assets.icons.addGreenbutton.path,
                        width: 40.w,
                        height: 40.w,
                      ),
                    ),
                  ],
                ),
              ),

              /// RADIUS INPUT
              Positioned(
                top: kToolbarHeight + 150.h,
                right: 20,
                child: Container(
                  width: 80.w,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: controller.radiusController,
                    keyboardType: TextInputType.number,
                    onChanged: controller.updateRadius,
                    onSubmitted: controller.updateRadius,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.radar, size: 20),
                      hintText: 'm',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),

              /// ROUTE CARDS
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: SafeArea(
                  child: SizedBox(
                    height: 240,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: controller.routesList.length,
                      onPageChanged: (index) {
                        setState(() => currentRouteIndex = index);
                        // Update map when card is changed
                        if (controller.routesList.isNotEmpty) {
                          _onRouteSelected(controller.routesList[index]);
                        }
                      },
                      itemBuilder: (context, index) {
                        return RouteCard(
                          routeData: controller.routesList[index],
                          onTap: () {
                            // Display route on map when card is tapped
                            _onRouteSelected(controller.routesList[index]);
                          },
                          onSave: () {},
                          onPlace: () {},
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showMapTypeBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => MapTypeBottomSheet(
        selectedMapType: selectedMapType,
        onMapTypeSelected: (type) {
          setState(() {
            selectedMapType = type;
          });
          appLog('Selected Map Type: $type', type: LogType.info, source: 'MAP'); // Debug purpose
        },
      ),
    );
  }

  String _getMapImageByType() {
    switch (selectedMapType) {
      case 'Satellite':
        return AppImagePath.roadMap;
      case 'Terrain':
        return AppImagePath.mountainMap;
      case 'Default':
      default:
        return AppImagePath.normalMap;
    }
  }
}

class MapTypeBottomSheet extends StatefulWidget {
  final String selectedMapType;
  final Function(String) onMapTypeSelected;

  const MapTypeBottomSheet({
    super.key,
    required this.selectedMapType,
    required this.onMapTypeSelected,
  });

  @override
  State<MapTypeBottomSheet> createState() => _MapTypeBottomSheetState();
}

class _MapTypeBottomSheetState extends State<MapTypeBottomSheet> {
  String selectedType = '';

  @override
  void initState() {
    super.initState();
    selectedType = widget.selectedMapType;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 50),
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: AppColor.creamBackgroundColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const TextWidget(
                text: 'Map Type',
                fontColor: AppColor.darkGray500,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(
                  Icons.close,
                  color: Colors.black54,
                  size: 24,
                ),
              ),
            ],
          ),

          const SizedBox(height: 30),

          // Map Type Options
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildMapTypeOption(
                'Default',
                AppImagePath.normalMap,
                Icons.map_outlined,
              ),
              _buildMapTypeOption(
                'Satellite',
                AppImagePath.roadMap,
                Icons.satellite_alt,
              ),
              _buildMapTypeOption(
                'Terrain',
                AppImagePath.mountainMap,
                Icons.terrain,
              ),
            ],
          ),

          const SizedBox(height: 30),

          // Bottom indicator
          Container(
            width: 60,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildMapTypeOption(
      String type, String imagePath, IconData fallbackIcon) {
    final bool isSelected = selectedType == type;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedType = type;
        });
        widget.onMapTypeSelected(type);
        Navigator.pop(context);
      },
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? AppColor.backgroundColor : Colors.grey,
                width: isSelected ? 3 : 3,
              ),
              color: AppColor.creamBackgroundColor,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(11),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.red,
                      child: Icon(
                        fallbackIcon,
                        size: 40,
                        color: Colors.yellow,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          TextWidget(
            text: type,
            // style: TextStyle(
            //   fontSize: 14,
            //   fontWeight: FontWeight.w500,
            //   color: isSelected ? Colors.black : Colors.black87,
            // ),
            fontColor: isSelected ? AppColor.backgroundColor : Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }
}
