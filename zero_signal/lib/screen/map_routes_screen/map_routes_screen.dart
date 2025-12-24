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

import 'dart:async';
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

  @override
  void initState() {
    super.initState();
    appLog('MapRoutesScreen initialized - using controller', type: LogType.info, source: 'INIT');
    controller = Get.put(MapRoutesController());
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
                      },
                      itemBuilder: (context, index) {
                        return RouteCard(
                          routeData: controller.routesList[index],
                          onTap: () {
                            Get.toNamed(
                              AppRoutes.saveRouteDetailsScreen,
                              arguments: controller.routesList[index],
                            );
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
