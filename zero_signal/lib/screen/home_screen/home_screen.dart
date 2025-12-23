import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zero_signal/constant/app_colors.dart';
import 'package:zero_signal/constant/app_icon_path.dart';
import 'package:zero_signal/screen/home_screen/conntroller/home_screen_controller.dart';
import 'package:zero_signal/screen/home_screen/widget/filter_button_sheet.dart';
import 'package:zero_signal/widget/text_field_widget/text_field_widget.dart';
import '../../routes/app_routes.dart';
import '../map_routes_screen/map_routes_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeScreenController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(HomeScreenController());
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
              child: GetBuilder<HomeScreenController>(
                builder: (controller) {
                  return TextFieldWidget(
                    controller: controller.searchController,
                    hintText: 'Search in ZeroSignal',
                    fieldHeight: 40,
                    borderColor: Colors.transparent,
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    onChanged: (value) {
                      controller.fetchSuggestions(value);
                    },
                    onFieldSubmitted: (value) {
                      controller.searchLocation(value);
                    },
                  );
                }),
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
                    builder: (context, scrollController) => FilterBottomSheet(),
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
      body: GetBuilder<HomeScreenController>(
        builder: (controller) {
          return Stack(
            children: [
    controller.mapWidget,

        // mapbox.MapWidget(
        //         onMapCreated: controller.onMapCreated,
        //         mapOptions: mapbox.MapOptions(
        //           pixelRatio: 1.0,
        //         ),
        //       ),

              // Suggestion List
              if (controller.searchSuggestions.isNotEmpty)
                Positioned(
                  top: 0,
                  left: 15.w,
                  right: 15.w,
                  child: Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(10.r),
                    color: Colors.white,
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: controller.searchSuggestions.length,
                      itemBuilder: (context, index) {
                        final suggestion =
                            controller.searchSuggestions[index];
                        return ListTile(
                          leading: Icon(Icons.location_on,
                              color: AppColor.blackColor),
                          title: Text(suggestion['place_name'] ?? '',
                              style: TextStyle(fontSize: 14.sp)),
                          onTap: () {
                            controller.searchController.text =
                                suggestion['place_name'];
                            controller
                                .searchLocation(suggestion['place_name']);
                          },
                        );
                      },
                    ),
                  ),
                ),

              // Spots loading indicator
              if (controller.isLoadingSpots)
                Positioned(
                  top: kToolbarHeight + 50.h,
                  left: 20,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 16.w,
                          height: 16.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'Loading spots...',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
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
                bottom: 145.h,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () async {
                        await controller.refreshLocation();
                      },
                      child: Container(
                        height: 47.h,
                        width: 47.h,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColor.backgroundColor),
                        child: Image.asset(
                          AppIconPath.mapIcon,
                          height: 24.h,
                          width: 24.w,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    InkWell(
                      onTap: () {
                        Get.toNamed(AppRoutes.shareSpotScreen);
                      },
                      child: Container(
                        height: 47.h,
                        width: 47.h,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColor.blackColor),
                        child: Image.asset(
                          AppIconPath.addIcon,
                          height: 24.h,
                          width: 24.w,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
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
