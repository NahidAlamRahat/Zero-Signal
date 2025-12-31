import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:zero_signal/screen/home_screen/widget/map_type_bottom_sheet.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zero_signal/constant/app_colors.dart';
import 'package:zero_signal/constant/app_icon_path.dart';
import 'package:zero_signal/screen/home_screen/conntroller/home_screen_controller.dart';
import 'package:zero_signal/screen/home_screen/widget/filter_button_sheet.dart';
import 'package:zero_signal/widget/text_field_widget/text_field_widget.dart';
import '../../routes/app_routes.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeScreenController controller;

  // Radius dropdown state
  bool isRadiusDropdownOpen = false;

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
              child: GetBuilder<HomeScreenController>(builder: (controller) {
                return TextFieldWidget(
                  controller: controller.searchController,
                  hintText: 'Search in ZeroSignal',
                  fieldHeight: 40.h,
                  borderColor: Colors.transparent,
                  prefixIcon:
                      Icon(Icons.search, color: Colors.grey, size: 20.sp),
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
            InkWell(
              onTap: () {
                _showOfflineMapDownloadDialog();
              },
              child: Image.asset(AppIconPath.downloadIcon,
                  width: 40.w, height: 40.w),
            ),
            SizedBox(width: 10.w),

            // Offline Mode Toggle
            GetBuilder<HomeScreenController>(
              builder: (controller) => InkWell(
                onTap: () {
                  controller.toggleOfflineMode();
                },
                child: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: controller.useOfflineMap
                        ? Colors.green
                        : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Icon(
                    controller.useOfflineMap ? Icons.wifi_off : Icons.wifi,
                    color: Colors.white,
                    size: 20.sp,
                  ),
                ),
              ),
            ),
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
              child: Image.asset(AppIconPath.filtaringIcon,
                  width: 65.w, height: 65.w),
            ),
          ],
        ),
      ),

      // Map Background
      body: GetBuilder<HomeScreenController>(
        builder: (controller) {
          return Stack(
            children: [
              mapbox.MapWidget(
                onMapCreated: controller.onMapCreated,
                cameraOptions: mapbox.CameraOptions(
                  center: mapbox.Point(
                    coordinates: mapbox.Position.fromJson(
                        [90.4125, 23.8103]), // Default center (Dhaka)
                  ),
                  zoom: 12.0,
                ),
                styleUri: mapbox.MapboxStyles.MAPBOX_STREETS,
                key: const ValueKey("mapbox_map"),
                gestureRecognizers: {
                  Factory<OneSequenceGestureRecognizer>(
                      () => EagerGestureRecognizer()),
                },
              ),

              // Suggestion List
              if (controller.searchSuggestions.isNotEmpty)
                Positioned(
                  top: kToolbarHeight + 10.h,
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
                        final suggestion = controller.searchSuggestions[index];
                        return ListTile(
                          leading: Icon(Icons.location_on,
                              color: AppColor.blackColor, size: 20.sp),
                          title: Text(suggestion['place_name'] ?? '',
                              style: TextStyle(fontSize: 14.sp)),
                          onTap: () {
                            controller.searchController.text =
                                suggestion['place_name'];
                            controller.searchLocation(suggestion['place_name']);
                          },
                        );
                      },
                    ),
                  ),
                ),

              // Spots loading indicator
              if (controller.isLoadingSpots)
                Positioned(
                  top: kToolbarHeight + 60.h,
                  left: 20.w,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
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
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
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

              // Radius Dropdown - Just under search box
              Positioned(
                top: kToolbarHeight + 60.h,
                left: 20.w,
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
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 8.h),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: Offset(0, 2.h),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.radar,
                                size: 16.sp, color: AppColor.backgroundColor),
                            SizedBox(width: 6.w),
                            Text(
                              '${controller.currentRadiusInMeters.toStringAsFixed(1)} km',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColor.backgroundColor,
                              ),
                            ),
                            SizedBox(width: 6.w),
                            Icon(
                              isRadiusDropdownOpen
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              color: Colors.grey.shade600,
                              size: 16.sp,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Expandable radius slider
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      margin: EdgeInsets.only(top: 8.h),
                      width: isRadiusDropdownOpen ? 200.w : 0,
                      height: isRadiusDropdownOpen ? 180.h : 0,
                      child: isRadiusDropdownOpen
                          ? Container(
                              padding: EdgeInsets.all(12.w),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 4,
                                    offset: Offset(0, 2.h),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Search Radius',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(height: 12.h),
                                  SliderTheme(
                                    data: SliderTheme.of(context).copyWith(
                                      activeTrackColor:
                                          AppColor.backgroundColor,
                                      inactiveTrackColor: Colors.grey.shade300,
                                      thumbColor: AppColor.backgroundColor,
                                      overlayColor: AppColor.backgroundColor
                                          .withOpacity(0.2),
                                      thumbShape: const RoundSliderThumbShape(
                                          enabledThumbRadius: 6),
                                      trackHeight: 3.h,
                                    ),
                                    child: Slider(
                                      value: controller.currentRadiusInMeters,
                                      min: 0.5,
                                      max: 30.0,
                                      divisions: 59,
                                      onChanged: (value) {
                                        controller.updateRadius(
                                            value.toStringAsFixed(1));
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '0.5 km',
                                        style: TextStyle(
                                          fontSize: 10.sp,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                      Text(
                                        '30 km',
                                        style: TextStyle(
                                          fontSize: 10.sp,
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

              Positioned(
                top: kToolbarHeight + 50.h,
                right: 20.w,
                child: InkWell(
                  onTap: () {
                    _showMapTypeBottomSheet();
                  },
                  child: Image.asset(
                    AppIconPath.choiceMap,
                    width: 40.w,
                    height: 40.w,
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
                        height: 47.w,
                        width: 47.w,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColor.backgroundColor),
                        child: Center(
                          child: Image.asset(
                            AppIconPath.mapIcon,
                            height: 24.w,
                            width: 24.w,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    InkWell(
                      onTap: () {
                        Get.toNamed(AppRoutes.shareSpotScreen);
                      },
                      child: Container(
                        height: 47.w,
                        width: 47.w,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: AppColor.blackColor),
                        child: Center(
                          child: Image.asset(
                            AppIconPath.addIcon,
                            height: 24.w,
                            width: 24.w,
                          ),
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

  void _showOfflineMapDownloadDialog() {
    showDialog(
      context: context,
      builder: (context) => GetBuilder<HomeScreenController>(
        builder: (controller) => AlertDialog(
          backgroundColor: AppColor.creamBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: AppColor.backgroundColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.download,
                  color: AppColor.backgroundColor,
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                'Offline Map Download',
                style: TextStyle(
                  color: AppColor.blackColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (controller.isDownloading) ...[
                Text(
                  'Downloading tiles... ${(controller.downloadProgress * 100).toStringAsFixed(1)}%',
                  style:
                      TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10.h),
                LinearProgressIndicator(
                  value: controller.downloadProgress,
                  backgroundColor: Colors.grey.shade200,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(AppColor.backgroundColor),
                ),
              ] else ...[
                Text(
                  'Download map data for offline use?',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColor.blackColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  'This will allow you to use maps without internet connection. Perfect for areas with poor connectivity!',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey.shade600,
                    height: 1.4,
                  ),
                ),
              ],
              SizedBox(height: 16.h),
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline,
                        color: Colors.blue.shade600, size: 16.sp),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        'Maps will be stored for regional offline use.',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            if (!controller.isDownloading)
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            if (!controller.isDownloading)
              ElevatedButton(
                onPressed: () {
                  controller.downloadOfflineMap();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.backgroundColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Text(
                  'Download',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            else
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Close',
                  style: TextStyle(
                    color: AppColor.backgroundColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
