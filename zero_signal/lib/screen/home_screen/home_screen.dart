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
import 'package:zero_signal/constant/app_strings.dart';
import 'package:zero_signal/widget/text_field_widget/text_field_widget.dart';
import '../../routes/app_routes.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

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
                  hintText: AppStrings.searchInZeroSignal,
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
                    size: 20.w,
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
                        final suggestion = controller.searchSuggestions[index];
                        return ListTile(
                          leading: Icon(Icons.location_on,
                              color: AppColor.blackColor),
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
                  top: kToolbarHeight + 50.h,
                  left: 20,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
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
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          AppStrings.loadingSpots,
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
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
                            Text(
                              '${controller.currentRadiusInMeters.toStringAsFixed(1)} ${AppStrings.km}',
                              style: TextStyle(
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
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppStrings.searchRadius,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  SliderTheme(
                                    data: SliderTheme.of(context).copyWith(
                                      activeTrackColor:
                                          AppColor.backgroundColor,
                                      inactiveTrackColor: Colors.grey.shade300,
                                      thumbColor: AppColor.backgroundColor,
                                      overlayColor: AppColor.backgroundColor
                                          .withValues(alpha: 0.2),
                                      thumbShape: const RoundSliderThumbShape(
                                          enabledThumbRadius: 6),
                                      trackHeight: 3,
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
                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        AppStrings.zeroFiveKm,
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                      Text(
                                        AppStrings.thirtyKm,
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
                            shape: BoxShape.circle, color: AppColor.blackColor),
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

  void _showOfflineMapDownloadDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
                size: 24.w,
              ),
            ),
            SizedBox(width: 12.w),
            Text(
              AppStrings.offlineMapDownload,
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
            Text(
              AppStrings.downloadMapDataOffline,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColor.blackColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              AppStrings.offlineMapInstruction,
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.grey.shade600,
                height: 1.4,
              ),
            ),
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
                      color: Colors.blue.shade600, size: 16.w),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      AppStrings.mapsStoredInDevice,
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
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              AppStrings.cancel,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14.sp,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _downloadOfflineMap();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.backgroundColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              AppStrings.download,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _downloadOfflineMap() async {
    // Get application documents directory
    Directory? appDocDir;
    String storagePath = '';

    try {
      appDocDir = await getApplicationDocumentsDirectory();
      storagePath = appDocDir.path;
    } catch (e) {
      storagePath = 'Local storage';
    }

    // Show progress dialog with storage info
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColor.creamBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppColor.backgroundColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(50.r),
              ),
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(AppColor.backgroundColor),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              AppStrings.downloadingOfflineMap,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppColor.blackColor,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              '${AppStrings.storagePrefix}$storagePath',
              style: TextStyle(
                fontSize: 11.sp,
                color: Colors.grey.shade600,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              AppStrings.downloadInstruction,
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );

    // Simulate download process
    await Future.delayed(Duration(seconds: 3));

    // Create offline map directory
    if (appDocDir != null) {
      final offlineMapDir = Directory('${appDocDir.path}/offline_maps');
      if (!await offlineMapDir.exists()) {
        await offlineMapDir.create(recursive: true);
      }

      // Create a sample offline map file (in real implementation, this would be actual map tiles)
      final mapFile = File('${offlineMapDir.path}/dhaka_region.map');
      await mapFile.writeAsString('offline_map_data_for_dhaka_region');
    }

    // Close progress dialog and show success message
    if (mounted) {
      Navigator.of(context).pop(); // Close progress dialog

      // Show success message with storage location
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColor.backgroundColor,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white, size: 16),
                  SizedBox(width: 8),
                  Text(
                    AppStrings.offlineMapSuccess,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4),
              Text(
                '${AppStrings.storedAt}: $storagePath/offline_maps',
                style: TextStyle(
                  fontSize: 11.sp,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
          duration: Duration(seconds: 4),
        ),
      );
    }
  }
}
