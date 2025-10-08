import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:zero_signal/constant/app_icon_path.dart';
import 'package:zero_signal/constant/app_image_path.dart';
import 'package:zero_signal/screen/home_screen/widget/filter_button_sheet.dart';
import 'package:zero_signal/widget/text_field_widget/text_field_widget.dart';
import 'package:zero_signal/widget/text_widget/text_widgets.dart';

import '../../constant/app_colors.dart';
import '../../routes/app_routes.dart';
import '../map_routes_screen/map_routes_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
            top: 252.h,
            right: 80.w,
            child: InkWell(
              onTap: () {
                Get.toNamed(AppRoutes.spotDetailsScreen);
              },
              child: CircleAvatar(
                backgroundColor: Colors.red,
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
                  heroTag: "home_btn1", // Changed from "btn1" to "home_btn1"
                  onPressed: () {},
                  child: Image.asset(AppIconPath.mapIcon),
                ),
                const SizedBox(height: 10),
                FloatingActionButton(
                  backgroundColor: Colors.transparent,
                  heroTag: "home_btn2", // Changed from "btn2" to "home_btn2"
                  onPressed: () {
                    Get.toNamed(AppRoutes.shareSpotScreen);
                  },
                  child: Image.asset(AppIconPath.addIcon),
                ),
              ],
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
          print('Selected Map Type: $type'); // Debug purpose
        },
      ),
    );
  }
}
