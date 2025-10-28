import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zero_signal/constant/app_icon_path.dart';
import 'package:zero_signal/constant/app_image_path.dart';
import 'package:zero_signal/screen/map_routes_screen/widget/route_card_widget.dart';
import 'package:zero_signal/widget/text_field_widget/text_field_widget.dart';

import '../../constant/app_colors.dart';
import '../../routes/app_routes.dart';

class MapRoutesScreen extends StatefulWidget {
  const MapRoutesScreen({super.key});

  @override
  State<MapRoutesScreen> createState() => _MapRoutesScreenState();
}

class _MapRoutesScreenState extends State<MapRoutesScreen> {
  String selectedMapType = 'Default';

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

            // Filtering Icon
            InkWell(
              onTap: () {
                Get.toNamed(AppRoutes.filtersScreen);
              },
              child:
                  Image.asset(AppIconPath.filtaringIcon, width: 65, height: 65),
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
            decoration: BoxDecoration(
              image: DecorationImage(
                // image: AssetImage(_getMapImageByType()), // Dynamic map image
                image: AssetImage(AppImagePath.mapImage),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Top-right icon (AppBar er niche)
          Positioned(
            top: kToolbarHeight + 50.h,
            right: 20,
            child: InkWell(
              onTap: () {
                // Proper way to show bottom sheet
                _showMapTypeBottomSheet();
              },
              child: Image.asset(
                AppIconPath.choiceMap,
                width: 40,
                height: 40,
              ),
            ),
          ),
          Positioned(
            bottom: 300.h,
            right: 20,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  mini: true,
                  backgroundColor: Colors.transparent,
                  heroTag: "map_btn1", // Changed from "btn1" to "map_btn1"
                  onPressed: () {},
                  child: Image.asset(AppIconPath.mapIcon),
                ),
                const SizedBox(height: 10),
                FloatingActionButton(
                  mini: true,
                  backgroundColor: Colors.transparent,
                  heroTag: "map_btn2", // Changed from "btn2" to "map_btn2"
                  onPressed: () {
                    Get.toNamed(AppRoutes.shareSpotScreen);
                  },
                  child: Image.asset(
                    AppIconPath.addIcon,
                    width: 40,
                    height: 40,
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            bottom: 80.h,
            left: 0,
            right: 0,
            child: GestureDetector(
                onTap: () {
                  Get.toNamed(AppRoutes.saveRouteDetailsScreen);
                },
                child: RouteCard()),
          )
        ],
      ),

      // Floating Buttons
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
          print('Selected Map Type: $type'); // Debug purpose
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
              const Text(
                'Map Type',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
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
          Text(
            type,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.black : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
