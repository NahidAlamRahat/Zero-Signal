import 'dart:math' as Math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' hide Position;
import 'package:zero_signal/constant/app_icon_path.dart';
import 'package:zero_signal/constant/app_image_path.dart';
import 'package:zero_signal/screen/home_screen/widget/filter_button_sheet.dart';
import 'package:zero_signal/widget/text_field_widget/text_field_widget.dart';
import 'package:zero_signal/widget/text_widget/text_widgets.dart';
import '../../constant/app_colors.dart';
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
  String selectedMapType = 'Default';
  Position? currentPosition;
  List<SpotModel> nearbySpots = [];
  bool isLoading = true;

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
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        await Geolocator.requestPermission();
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        currentPosition = position;
      });
    } catch (e) {
      print('Error getting location: $e');
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

    setState(() {
      nearbySpots = nearby;
    });
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
          // Background Image
          Container(
            height: double.infinity,
            width: double.infinity,
           child: MapWidget(),
          ),

          // Nearby Spots Markers
          if (!isLoading && currentPosition != null)
            ..._buildNearbySpotMarkers(),

          // Current Location Marker (Blue dot)
          if (!isLoading && currentPosition != null)
            Positioned(
              top: MediaQuery.of(context).size.height * 0.4,
              left: MediaQuery.of(context).size.width * 0.5,
              child: Transform.translate(
                offset: Offset(-15, -15),
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
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Top-right icon (AppBar er niche)
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

  List<Widget> _buildNearbySpotMarkers() {
    return nearbySpots.map((spot) {
      // Calculate marker position based on spot coordinates
      // You might need to adjust this based on your map image coordinates
      final xPosition = (spot.longitude + 74.35) * 1000; // Adjust multiplier
      final yPosition = (spot.latitude - 24.8) * 1000; // Adjust multiplier

      return Positioned(
        left: xPosition,
        top: yPosition,
        child: InkWell(
          onTap: () {
            Get.toNamed(AppRoutes.spotDetailsScreen);
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: _getMarkerColor(spot.type),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 5,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Icon(
                  _getMarkerIcon(spot.type),
                  color: Colors.white,
                  size: 20,
                ),
              ),
              SizedBox(height: 4),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  spot.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  Color _getMarkerColor(String type) {
    switch (type) {
      case 'restaurant':
        return Colors.orange;
      case 'park':
        return Colors.green;
      case 'landmark':
        return Colors.red;
      case 'market':
        return Colors.purple;
      default:
        return Colors.blue;
    }
  }

  IconData _getMarkerIcon(String type) {
    switch (type) {
      case 'restaurant':
        return Icons.restaurant;
      case 'park':
        return Icons.nature;
      case 'landmark':
        return Icons.location_on;
      case 'market':
        return Icons.shopping_cart;
      default:
        return Icons.place;
    }
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
          print('Selected Map Type: $type');
        },
      ),
    );
  }
}