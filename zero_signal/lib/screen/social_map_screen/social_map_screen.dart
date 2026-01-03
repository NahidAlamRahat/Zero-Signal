import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;
import 'package:zero_signal/constant/app_colors.dart';
import 'package:zero_signal/constant/app_image_path.dart';
import 'package:zero_signal/constant/app_icon_path.dart';
import 'package:zero_signal/utils/app_log/app_log.dart';
import 'package:zero_signal/widget/text_widget/text_widgets.dart';
import 'package:zero_signal/widget/text_field_widget/text_field_widget.dart';
import 'package:zero_signal/routes/app_routes.dart';
import '../map_routes_screen/controller/map_routes_controller.dart';
import 'package:zero_signal/repository/activity_repository.dart';
import 'package:zero_signal/screen/social_screen/modell/activity_feed_model.dart';
import 'package:flutter/services.dart';
import 'dart:typed_data';

import 'dart:math' as math;

class SocialMapScreen extends StatefulWidget {
  const SocialMapScreen({super.key});

  @override
  State<SocialMapScreen> createState() => _SocialMapScreenState();
}

class _SocialMapScreenState extends State<SocialMapScreen> {
  String selectedMapType = 'Default';
  late mapbox.MapboxMap mapboxMap;
  final GlobalKey _mapWidgetKey = GlobalKey();

  final MapRoutesController controller = Get.put(MapRoutesController());
  mapbox.CircleAnnotationManager? userLocationCircleAnnotationManager;
  mapbox.PolygonAnnotationManager? radiusPolygonManager;

  // Activity markers
  final ActivityRepository _activityRepository = ActivityRepository();
  mapbox.PointAnnotationManager? activityPointAnnotationManager;
  List<ActivityFeedData> activityFeeds = [];

  bool isRadiusDropdownOpen = false;
  double currentRadiusInMeters = 5000.0;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    appLog('SocialMapScreen initialized - clean version',
        type: LogType.info, source: 'INIT');
  }

  /// Initialize map settings
  Future<void> _initializeMap() async {
    try {
      // Load map style
      await mapboxMap.loadStyleURI('mapbox://styles/mapbox/streets-v12');

      // Load custom marker
      await _loadMarkerIcon();

      await mapboxMap.compass.updateSettings(
        mapbox.CompassSettings(enabled: false),
      );
      await mapboxMap.scaleBar.updateSettings(
        mapbox.ScaleBarSettings(enabled: false),
      );
    } catch (e) {
      appLog('Error initializing map: $e', type: LogType.error, source: 'MAP');
    }
  }

  /// Center map on current location
  Future<void> _centerMapOnCurrentLocation() async {
    try {
      final lat = controller.deviceLat.value;
      final lng = controller.deviceLng.value;

      final camera = mapbox.CameraOptions(
        center: mapbox.Point(
          coordinates: mapbox.Position(lng, lat),
        ),
        zoom: 15.5,
      );
      await mapboxMap.flyTo(
        camera,
        mapbox.MapAnimationOptions(duration: 800),
      );

      userLocationCircleAnnotationManager ??=
          await mapboxMap.annotations.createCircleAnnotationManager();

      await userLocationCircleAnnotationManager!.deleteAll();

      await userLocationCircleAnnotationManager!.create(
        mapbox.CircleAnnotationOptions(
          geometry: mapbox.Point(
            coordinates: mapbox.Position(lng, lat),
          ),
          circleColor: const Color(0xFF2563EB).toARGB32(),
          circleRadius: 7,
          circleStrokeColor: Colors.white.toARGB32(),
          circleStrokeWidth: 2,
        ),
      );

      appLog('Current location shown on map: $lat, $lng',
          type: LogType.info, source: 'MAP');

      // Fetch initial activities
      _fetchAndDisplayActivities();
    } catch (e) {
      appLog('Error centering map: $e', type: LogType.error, source: 'MAP');
    }
  }

  /// Draw search radius circle on map
  Future<void> _drawSearchRadius() async {
    try {
      final lat = controller.deviceLat.value;
      final lng = controller.deviceLng.value;

      if (lat == 0.0 && lng == 0.0) return;

      radiusPolygonManager ??=
          await mapboxMap.annotations.createPolygonAnnotationManager();

      await radiusPolygonManager!.deleteAll();

      final circleCoordinates = _createCirclePolygon(
        lat,
        lng,
        currentRadiusInMeters,
      );

      await radiusPolygonManager!.create(
        mapbox.PolygonAnnotationOptions(
          geometry: mapbox.Polygon(coordinates: [circleCoordinates]),
          fillColor: const Color(0xFF10B981).withOpacity(0.15).value,
          fillOutlineColor: const Color(0xFF10B981).value,
        ),
      );
    } catch (e) {
      appLog('Error drawing radius circle: $e',
          type: LogType.error, source: 'MAP');
    }
  }

  /// Create polygon coordinates for a circle
  List<mapbox.Position> _createCirclePolygon(
      double centerLat, double centerLng, double radiusInMeters) {
    List<mapbox.Position> positions = [];
    const int steps = 64;
    const double earthRadius = 6378137.0;

    for (int i = 0; i <= steps; i++) {
      final double angle = (i * 2 * math.pi) / steps;

      final double dx = radiusInMeters * math.cos(angle);
      final double dy = radiusInMeters * math.sin(angle);

      final double dLat = dy / earthRadius;
      final double dLng =
          dx / (earthRadius * math.cos(math.pi * centerLat / 180));

      final double newLat = centerLat + (dLat * 180 / math.pi);
      final double newLng = centerLng + (dLng * 180 / math.pi);

      positions.add(mapbox.Position(newLng, newLat));
    }
    return positions;
  }

  /// Load marker icon from assets
  Future<void> _loadMarkerIcon() async {
    try {
      final ByteData data = await rootBundle.load('assets/icons/location.png');
      final uint8List = data.buffer.asUint8List();
      final image = await decodeImageFromList(uint8List);
      final mbxImage = mapbox.MbxImage(
        width: image.width,
        height: image.height,
        data: uint8List,
      );
      await mapboxMap.style.addStyleImage(
        "custom-marker",
        1.0,
        mbxImage,
        false,
        [],
        [],
        null,
      );
    } catch (e) {
      appLog('Error loading marker icon: $e',
          type: LogType.error, source: 'MAP');
    }
  }

  /// Fetch and display activities based on current location and radius
  Future<void> _fetchAndDisplayActivities() async {
    try {
      final lat = controller.deviceLat.value;
      final lng = controller.deviceLng.value;

      // Don't fetch if location is not set
      if (lat == 0.0 && lng == 0.0) return;

      final result = await _activityRepository.getActivityFeed(
        lat: lat,
        lng: lng,
        radius: currentRadiusInMeters,
      );

      if (result != null && result.data != null) {
        activityFeeds = result.data!;
        await _updateMarkers();
        appLog('Fetched ${activityFeeds.length} activities',
            type: LogType.info, source: 'MAP');
      }
    } catch (e) {
      appLog('Error fetching activities: $e',
          type: LogType.error, source: 'MAP');
    }
  }

  /// Update markers on the map
  Future<void> _updateMarkers() async {
    if (activityPointAnnotationManager == null) {
      activityPointAnnotationManager =
          await mapboxMap.annotations.createPointAnnotationManager();
    }
    await activityPointAnnotationManager!.deleteAll();

    for (var activity in activityFeeds) {
      if (activity.location?.coordinates != null &&
          activity.location!.coordinates!.length >= 2) {
        final lng = activity.location!.coordinates![0];
        final lat = activity.location!.coordinates![1];

        await activityPointAnnotationManager!.create(
          mapbox.PointAnnotationOptions(
            geometry: mapbox.Point(
              coordinates: mapbox.Position(lng, lat),
            ),
            iconImage: "custom-marker",
            iconSize: 1.0,
            textField: activity.title,
            textOffset: [0, 2.0],
            textSize: 12,
            textColor: Colors.black.toARGB32(),
          ),
        );
      }
    }
  }

  void _onRadiusChanged(double value) {
    setState(() {
      currentRadiusInMeters = value * 1000;
    });
  }

  void _onRadiusChangeEnd(double value) {
    _drawSearchRadius(); // Update circle only when sliding ends
    _fetchAndDisplayActivities(); // Fetch new activities based on new radius
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: Colors.black),
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
      body: Stack(
        children: [
          /// MAP
          Positioned.fill(
            child: RepaintBoundary(
              key: _mapWidgetKey,
              child: mapbox.MapWidget(
                onMapCreated: (map) {
                  mapboxMap = map;
                  _initializeMap();
                },
                cameraOptions: mapbox.CameraOptions(
                  center: mapbox.Point(
                    coordinates: mapbox.Position(90.4125, 23.8103),
                  ),
                  zoom: 12.0,
                ),
              ),
            ),
          ),

          /// RADIUS DROPDOWN - Top Left Corner
          Positioned(
            top: kToolbarHeight + 50.h,
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Radius toggle button
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isRadiusDropdownOpen = !isRadiusDropdownOpen;
                    });
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.radar,
                            size: 16, color: AppColor.backgroundColor),
                        const SizedBox(width: 6),
                        isLoading
                            ? const SizedBox(
                                width: 12,
                                height: 12,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      AppColor.backgroundColor),
                                ),
                              )
                            : Text(
                                '${(currentRadiusInMeters / 1000).toStringAsFixed(1)} km',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColor.backgroundColor,
                                ),
                              ),
                        const SizedBox(width: 6),
                        Icon(
                          isRadiusDropdownOpen
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          color: Colors.grey.shade600,
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ),

                // Expandable radius slider
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  margin: const EdgeInsets.only(top: 8),
                  width: isRadiusDropdownOpen ? 200 : 0,
                  height: isRadiusDropdownOpen ? 180 : 0,
                  child: isRadiusDropdownOpen
                      ? Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    'Search Radius',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const Spacer(),
                                  if (isLoading)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: AppColor.backgroundColor
                                            .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Text(
                                        'Updating...',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: AppColor.backgroundColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  activeTrackColor: isLoading
                                      ? Colors.grey.shade400
                                      : AppColor.backgroundColor,
                                  inactiveTrackColor: Colors.grey.shade300,
                                  thumbColor: isLoading
                                      ? Colors.grey.shade400
                                      : AppColor.backgroundColor,
                                  overlayColor:
                                      AppColor.backgroundColor.withOpacity(0.2),
                                  thumbShape: const RoundSliderThumbShape(
                                      enabledThumbRadius: 6),
                                  trackHeight: 3,
                                ),
                                child: Slider(
                                  value: currentRadiusInMeters / 1000,
                                  min: 0.5,
                                  max: 30.0,
                                  divisions: 59,
                                  onChanged:
                                      isLoading ? null : _onRadiusChanged,
                                  onChangeEnd:
                                      isLoading ? null : _onRadiusChangeEnd,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '0.5 km',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  Text(
                                    '30 km',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),

          /// FLOATING BUTTONS
          Positioned(
            bottom: 350.h,
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
              ],
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
        ],
      ),
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
        },
      ),
    );
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
                width: 3,
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
            fontColor: isSelected ? AppColor.backgroundColor : Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }
}
