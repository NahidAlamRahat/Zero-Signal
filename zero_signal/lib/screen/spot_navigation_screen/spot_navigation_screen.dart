import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;
import 'package:screenshot/screenshot.dart';
import 'dart:typed_data';
import 'package:zero_signal/constant/app_colors.dart';
import 'package:zero_signal/screen/spot_navigation_screen/controller/spot_navigation_controller.dart';
import 'package:zero_signal/widget/appbar_widget/appbar_widget.dart';
import 'package:zero_signal/widget/text_widget/text_widgets.dart';

class SpotNavigationScreen extends StatefulWidget {
  const SpotNavigationScreen({super.key});

  @override
  State<SpotNavigationScreen> createState() => _SpotNavigationScreenState();
}

class _SpotNavigationScreenState extends State<SpotNavigationScreen> {
  late SpotNavigationController controller;

  @override
  void initState() {
    super.initState();
    print('=== SpotNavigationScreen initState START ===');
    try {
      // Initialize controller in initState to ensure it's ready before build
      print('Initializing SpotNavigationController...');
      controller = Get.put(SpotNavigationController());
      print('Controller initialized successfully');
    } catch (e) {
      print('Error initializing controller: $e');
      // If controller initialization fails, go back
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          print('Going back due to controller initialization failure');
          Get.back();
        }
      });
    }
    print('=== SpotNavigationScreen initState END ===');
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppbarWidget(
        text: 'Navigation',
        backgroundColor: AppColor.creamBackgroundColor,
        centerTitle: true,
        action: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Get.back(),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: AppColor.creamBackgroundColor,
      body: Column(
        children: [
          // Distance and location info
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            margin: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: GetBuilder<SpotNavigationController>(
              builder: (controller) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.red, size: 20.sp),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: TextWidget(
                          text: controller.spotTitle.value,
                          fontColor: AppColor.textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  if (controller.distance.value > 0)
                    Row(
                      children: [
                        Icon(Icons.directions, color: AppColor.backgroundColor, size: 20.sp),
                        SizedBox(width: 8.w),
                        TextWidget(
                          text: '${controller.distance.value.toStringAsFixed(2)} km away',
                          fontColor: AppColor.darkGay300,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ],
                    ),
                  if (controller.isLoading.value)
                    Padding(
                      padding: EdgeInsets.only(top: 8.h),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 16.sp,
                            height: 16.sp,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(AppColor.backgroundColor),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          TextWidget(
                            text: 'Calculating route...',
                            fontColor: AppColor.darkGay300,
                            fontSize: 14,
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
          
          // Map
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Screenshot(
                  controller: controller.screenshotController,
                  child: mapbox.MapWidget(
                    onMapCreated: (map) {
                      controller.onMapCreated(map);
                    },
                    cameraOptions: mapbox.CameraOptions(
                      center: mapbox.Point(
                        coordinates: mapbox.Position.fromJson([
                          controller.currentLongitude.value,
                          controller.currentLatitude.value,
                        ]),
                      ),
                      zoom: 14.0,
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          // Bottom action buttons
          Container(
            padding: EdgeInsets.all(16.w),
            child: GetBuilder<SpotNavigationController>(
              builder: (controller) => Column(
                children: [
                  if (controller.hasRoute.value)
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: AppColor.lightGrayishOrange,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: TextWidget(
                        text: 'Route calculated successfully!',
                        fontColor: AppColor.textColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: controller.isLoading.value ? null : controller.calculateRoute,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.backgroundColor,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          child: TextWidget(
                            text: controller.hasRoute.value ? 'Recalculate Route' : 'Calculate Route',
                            fontColor: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            try {
                              // Capture screenshot and show preview popup
                              final imageBytes = await controller.captureRouteScreenshot();
                              if (imageBytes != null) {
                                _showScreenshotPopup(imageBytes);
                              } else {
                                // If screenshot fails, just go back
                                Get.back();
                              }
                            } catch (e) {
                              print('Error in Confirm button: $e');
                              // If anything fails, just go back to details screen
                              Get.back();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.yello,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          child: TextWidget(
                            text: 'Confirm',
                            fontColor: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Show screenshot preview popup for 3 seconds with distance info
  void _showScreenshotPopup(Uint8List imageBytes) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextWidget(
                text: 'Route Screenshot Captured!',
                fontColor: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(height: 8.h),
              // Show distance prominently
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppColor.backgroundColor,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: TextWidget(
                  text: 'Distance: ${controller.distance.value.toStringAsFixed(2)} km',
                  fontColor: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 12.h),
              Container(
                height: 300.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Image.memory(
                    imageBytes,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 12.w,
                    height: 12.h,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  TextWidget(
                    text: 'Your Location',
                    fontColor: Colors.grey.shade600,
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                  ),
                  SizedBox(width: 16.w),
                  Container(
                    width: 12.w,
                    height: 12.h,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  TextWidget(
                    text: 'Destination',
                    fontColor: Colors.grey.shade600,
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              TextWidget(
                text: 'Screenshot saved successfully',
                fontColor: Colors.grey.shade600,
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );

    // Auto close after 3 seconds and go back
    Future.delayed(const Duration(seconds: 3), () {
      if (Get.isDialogOpen ?? false) {
        Get.back(); // Close dialog
        Get.back(); // Go back to details screen
      }
    });
  }
}
