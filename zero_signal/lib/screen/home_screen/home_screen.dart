import 'dart:math' as Math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:get/get.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;
import 'package:zero_signal/constant/app_colors.dart';
import 'package:zero_signal/constant/app_icon_path.dart';
import 'package:zero_signal/screen/home_screen/conntroller/home_screen_controller.dart';
import 'package:zero_signal/screen/home_screen/widget/filter_button_sheet.dart';
import 'package:zero_signal/widget/text_field_widget/text_field_widget.dart';
import '../../routes/app_routes.dart';
import '../map_routes_screen/map_routes_screen.dart';

// Model for Spot
class SpotModel {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final String type; // 'restaurant', 'park', 'landmark', etc.

  SpotModel({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.type,
  });
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  geo.Position? currentPosition;
  List<SpotModel> nearbySpots = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    try {
  //    await _getCurrentLocation();
      await _fetchNearbySpots();
    } catch (e) {
      print('Error initializing location: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to get location: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }


  Future<void> _fetchNearbySpots() async {
    if (currentPosition == null) return;

    // Sample spots data - Replace with your actual API call
    final allSpots = [
      SpotModel(
        id: '1',
        name: 'Basmati Singh Stadium',
        latitude: 24.8607,
        longitude: 67.0011,
        type: 'landmark',
      ),
      SpotModel(
        id: '2',
        name: 'Rani Bagh',
        latitude: 24.8620,
        longitude: 67.0025,
        type: 'park',
      ),
      SpotModel(
        id: '3',
        name: 'Jantar Mantar',
        latitude: 24.8545,
        longitude: 67.0015,
        type: 'landmark',
      ),
      SpotModel(
        id: '4',
        name: 'Connaught Place',
        latitude: 24.8550,
        longitude: 67.0020,
        type: 'market',
      ),
    ];

    // Filter spots within 5 km radius
    final nearby = allSpots.where((spot) {
      double distance = _calculateDistance(
        currentPosition!.latitude,
        currentPosition!.longitude,
        spot.latitude,
        spot.longitude,
      );
      return distance <= 5; // 5 km radius
    }).toList();

    if (mounted) {
      setState(() {
        nearbySpots = nearby;
      });
     // await _addMarkersToMap();
    }
  }

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const p = 0.017453292519943295; // Math.PI / 180
    final a = 0.5 -
        Math.cos((lat2 - lat1) * p) / 2 +
        Math.cos(lat1 * p) *
            Math.cos(lat2 * p) *
            (1 - Math.cos((lon2 - lon1) * p)) /
            2;
    return 12742 * Math.asin(Math.sqrt(a)); // 2 * R; R = 6371 km
  }

  // // Add markers to Mapbox
  // Future<void> _addMarkersToMap() async {
  //   if (!mounted) return;
  //
  //   try {
  //     final pointAnnotationManager = await mapboxMap.annotations.createPointAnnotationManager();
  //
  //     for (var spot in nearbySpots) {
  //       await pointAnnotationManager.create(
  //         PointAnnotationOptions(
  //           geometry: Point(coordinates: Position.fromJson([spot.longitude, spot.latitude])),
  //           iconImage: _getMarkerIconName(spot.type),
  //           textField: spot.name,
  //           textSize: 12,
  //           textColor: Colors.white.value,
  //           textHaloColor: Colors.black.value,
  //           textHaloWidth: 1,
  //         ),
  //       );
  //     }
  //   } catch (e) {
  //     print('Error adding markers: $e');
  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Error adding markers: $e')),
  //       );
  //     }
  //   }
  // }

  String _getMarkerIconName(String type) {
    // Mapbox এ icon names যোগ করুন
    switch (type) {
      case 'restaurant':
        return 'restaurant_marker';
      case 'park':
        return 'park_marker';
      case 'landmark':
        return 'landmark_marker';
      case 'market':
        return 'market_marker';
      default:
        return 'default_marker';
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            // Search Box
            Expanded(
              child: TextFieldWidget(
                hintText: 'Search in ZeroSignal',
                fieldHeight: 40,
                borderColor: Colors.transparent,
                prefixIcon: Icon(Icons.search, color: Colors.grey),
              ),
            ),
             SizedBox(width: 12.w),

            // Download Icon
            Image.asset(AppIconPath.downloadIcon, width: 40.w, height: 40.w),
             SizedBox(width: 10.w),

            // Filtering Icon
            InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => DraggableScrollableSheet(
                    initialChildSize: 0.7,
                    minChildSize: 0.5,
                    maxChildSize: 0.9,
                    builder: (context, scrollController) =>
                     FilterBottomSheet(),
                  ),
                );
              },
              child: Image.asset(AppIconPath.filtaringIcon,
                  width: 65, height: 65),
            ),
          ],
        ),
      ),

      // Map Background
      body: GetBuilder(
        init: HomeScreenController(),
        builder: (controller) {
          return Stack(
            children: [
              // MapBox Widget
              mapbox.MapWidget(
                onMapCreated: controller.onMapCreated,
              ),


              Positioned(
                top: kToolbarHeight + 50.h,
                right: 20,
                child: InkWell(
                  onTap: () {
                    _showMapTypeBottomSheet();
                  },
                  child: Image.asset(
                    AppIconPath.choiceMap,
                    width: 40,
                    height: 40,
                  ),
                ),
              ),

              // Floating Buttons
              Positioned(
                right: 36.w,
                bottom:145.h ,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    InkWell(
                      onTap: () async {
                        final controller = Get.find<HomeScreenController>();
                        await controller.refreshLocation();
                      },
                      child: Container(
                      
                        height: 47.h,
                        width: 47.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColor.backgroundColor
                        ),
                      
                        child: Image.asset(AppIconPath.mapIcon, height: 24.h,width: 24.w,) ,
                      ),
                    ),
                    const SizedBox(height: 10),

                    InkWell(
                      onTap: (){
                        Get.toNamed(AppRoutes.spotDetailsScreen);
                      },
                      child: Container(
                      
                        height: 47.h,
                        width: 47.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColor.blackColor
                        ),
                      
                        child: Image.asset(AppIconPath.addIcon, height: 24.h,width: 24.w,) ,
                      ),
                    ),


                  ],
                ),
              ),

              // Loading Indicator
              if (isLoading)
                Center(
                  child: CircularProgressIndicator(),
                ),
            ],
          );
        }
      ),
    );
  }

  void _showMapTypeBottomSheet() {
    final controller = Get.find<HomeScreenController>();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => MapTypeBottomSheet(
        selectedMapType: controller.selectedMapType,
        onMapTypeSelected: (type) async {
          await controller.updateMapStyle(type);
        },
      ),
    );
  }
}