import 'dart:math' as Math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:get/get.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:zero_signal/constant/app_icon_path.dart';
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
  // Map style URIs
  static const String defaultStyleUri = 'mapbox://styles/mapbox/streets-v12';
  static const String satelliteStyleUri = 'mapbox://styles/lede18/cmg91jkk3000r01sf8m1r29ky';
  static const String terrainStyleUri = 'mapbox://styles/lede18/cmg91k73u000s01qo5ye4bl7q';

  String selectedMapType = 'OutDoor';
  geo.Position? currentPosition;
  List<SpotModel> nearbySpots = [];
  bool isLoading = true;
  late MapboxMap mapboxMap;

  // Method to update map style based on selection
  Future<void> _updateMapStyle(String mapType) async {
    String styleUri;
    switch (mapType) {
      case 'Satellite':
        styleUri = satelliteStyleUri;
        break;
      case 'Terrain':
        styleUri = terrainStyleUri;
        break;
      case 'OutDoor':
      default:
        styleUri = defaultStyleUri;
        break;
    }

    try {
      await mapboxMap.loadStyleURI(styleUri);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error changing map style: $e')),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    try {
      await _getCurrentLocation();
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

  Future<void> _getCurrentLocation() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await geo.Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please enable location services')),
          );
        }
        return;
      }

      // Check location permission
      var permission = await geo.Geolocator.checkPermission();
      if (permission == geo.LocationPermission.denied) {
        permission = await geo.Geolocator.requestPermission();
        if (permission == geo.LocationPermission.denied) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Location permission denied')),
            );
          }
          return;
        }
      }

      if (permission == geo.LocationPermission.deniedForever) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permission permanently denied. Please enable from settings.')),
          );
        }
        return;
      }

      // Get current position
      final position = await geo.Geolocator.getCurrentPosition(
        desiredAccuracy: geo.LocationAccuracy.high,
      );

      if (mounted) {
        setState(() {
          currentPosition = position;
        });

        // Animate camera to current location
        await mapboxMap.flyTo(
          CameraOptions(
            center: Point(coordinates: Position.fromJson([position.longitude, position.latitude])),
            zoom: 15.0,
            bearing: 0,
            pitch: 0,
          ),
          MapAnimationOptions(duration: 2000, startDelay: 0),
        );
      }
    } catch (e) {
      print('Error getting location: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error getting location: $e')),
        );
      }
      rethrow;
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
      await _addMarkersToMap();
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

  // Add markers to Mapbox
  Future<void> _addMarkersToMap() async {
    if (!mounted) return;

    try {
      final pointAnnotationManager = await mapboxMap.annotations.createPointAnnotationManager();
      
      for (var spot in nearbySpots) {
        await pointAnnotationManager.create(
          PointAnnotationOptions(
            geometry: Point(coordinates: Position.fromJson([spot.longitude, spot.latitude])),
            iconImage: _getMarkerIconName(spot.type),
            textField: spot.name,
            textSize: 12,
            textColor: Colors.white.value,
            textHaloColor: Colors.black.value,
            textHaloWidth: 1,
          ),
        );
      }
    } catch (e) {
      print('Error adding markers: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding markers: $e')),
        );
      }
    }
  }

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
                prefixIcon: Icon(Icons.search, color: Colors.grey),
              ),
            ),
            const SizedBox(width: 10),

            // Download Icon
            Image.asset(AppIconPath.downloadIcon, width: 40, height: 40),
            const SizedBox(width: 10),

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
                    const FilterBottomSheet(),
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
      body: Stack(
        children: [
          // MapBox Widget
          MapWidget(
            onMapCreated: (controller) async {
              mapboxMap = controller;
              
              // Set initial map style
              await mapboxMap.loadStyleURI(defaultStyleUri);
              
              // Set initial camera position to Dhaka
              await mapboxMap.setCamera(
                CameraOptions(
                  center: Point(coordinates: Position.fromJson([90.4125, 23.8103])), // Dhaka coordinates
                  zoom: 12.0,
                ),
              );
              
              if (nearbySpots.isNotEmpty) {
                await _addMarkersToMap();
              }
            },
          ),

          // Current Location Marker (Blue dot)
          if (!isLoading && currentPosition != null)
            Positioned(
              top: MediaQuery.of(context).size.height * 0.5,
              left: MediaQuery.of(context).size.width * 0.5,
              child: Transform.translate(
                offset: Offset(-15, -15),
                child: TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0.7, end: 1.0),
                  duration: Duration(milliseconds: 1000),
                  curve: Curves.easeInOut,
                  builder: (context, double value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.5),
                              blurRadius: 10,
                              spreadRadius: 2 * value,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

          // Top-right icon
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
            right: 16,
            bottom: 150,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton(
                  backgroundColor: Colors.transparent,
                  heroTag: "home_btn1",
                  onPressed: () {},
                  child: Image.asset(AppIconPath.mapIcon),
                ),
                const SizedBox(height: 10),
                FloatingActionButton(
                  backgroundColor: Colors.transparent,
                  heroTag: "home_btn2",
                  onPressed: () {
                    Get.toNamed(AppRoutes.shareSpotScreen);
                  },
                  child: Image.asset(AppIconPath.addIcon),
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
        onMapTypeSelected: (type) async {
          setState(() {
            selectedMapType = type;
          });
          await _updateMapStyle(type);
        },
      ),
    );
  }
}