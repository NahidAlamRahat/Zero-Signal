import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zero_signal/constant/app_colors.dart';
import 'package:zero_signal/gen/assets.gen.dart';
import 'package:zero_signal/routes/app_routes.dart';
import 'package:zero_signal/widget/appbar_widget/appbar_widget.dart';
import 'package:zero_signal/widget/button_widget/button_widget.dart';
import 'package:zero_signal/widget/text_field_widget/text_field_widget.dart';
import 'package:zero_signal/widget/text_widget/text_widgets.dart';
import 'dart:typed_data';

import '../sport_details/widget/user_dialogs.dart';
import 'controller/save_route_details_screen_controller.dart';

class SaveRouteDetailsScreen extends StatelessWidget {
  final Map<String, dynamic>? routeData;
  final String? routeId;
  final Uint8List? mapScreenshot;
  
  const SaveRouteDetailsScreen({super.key, this.routeData, this.routeId, this.mapScreenshot});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RouteDetailsController());
    
    // Set route data if provided, or fetch by ID
    if (routeData != null) {
      controller.setRouteData(routeData!);
    } else if (routeId != null) {
      // Fetch route details by ID
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.fetchRouteDetails(routeId!);
      });
    }

    return Scaffold(
      appBar: AppbarWidget(
        backgroundColor: AppColor.creamBackgroundColor,
        centerTitle: true,
        action: Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Icon(Icons.ios_share),
        ),
      ),
      backgroundColor: AppColor.creamBackgroundColor,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColor.backgroundColor,
            ),
          );
        }
        
        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64.sp,
                  color: Colors.red,
                ),
                SizedBox(height: 16.h),
                Text(
                  controller.errorMessage.value,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.red,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.h),
                ElevatedButton(
                  onPressed: () {
                    if (routeId != null) {
                      controller.fetchRouteDetails(routeId!);
                    }
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }
        
        return SingleChildScrollView(
          child: Column(
            children: [
              _buildHeaderImage(controller),
              SizedBox(height: 12.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTitleSection(controller),
                    SizedBox(height: 10.h),
                    _buildStatsSection(controller),
                    SizedBox(height: 12.h),
                    _buildActionButtons(),
                    SizedBox(height: 12.h),
                    _buildUserSection(context),
                    SizedBox(height: 16.h),
                    _buildDescriptionSection(controller),
                    SizedBox(height: 16.h),
                    _buildRouteImagesSection(context, controller),
                    SizedBox(height: 16.h),
                    _buildCommentsSection(controller),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  // Header Image
  Widget _buildHeaderImage(RouteDetailsController controller) {
    return Obx(() {
      final images = controller.images;
      
      return Center(
        child: Container(
          margin: EdgeInsets.only(
            right: 20.w,
            left: 20.w,
          ),
          width: double.infinity,
          height: 219.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: images.isNotEmpty
                ? Image.network(
                    images.first,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.map, size: 50, color: Colors.grey[600]),
                              SizedBox(height: 8),
                              Text(
                                'Route Map View',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                              ),
                      );
                    },
                  )
                : Container(
                    color: Colors.grey[300],
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.map, size: 50, color: Colors.grey[600]),
                          SizedBox(height: 8),
                          Text(
                            'Route Map View',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        ),
      );
    });
  }

  // Title Section
  Widget _buildTitleSection(RouteDetailsController controller) {
    return Obx(() => Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: TextWidget(
            text: controller.routeData['title'] ?? 'Untitled Route',
            fontSize: 20.sp,
            fontWeight: FontWeight.w500,
            fontColor: AppColor.textColor,
          ),
        ),
        CircleAvatar(
          backgroundColor: Color(0xFFFFA726),
          foregroundColor: Colors.white,
          child: Image.asset(
            Assets.icons.download.path,
            width: 24.w,
            height: 20.h,
          ),
        ),
      ],
    ));
  }

  // Stats Section
  Widget _buildStatsSection(RouteDetailsController controller) {
    return Obx(() {
      final routeData = controller.routeData;
      final distance = routeData['distance']?['text'] ?? 'Unknown';
      final duration = routeData['duration']?['text'] ?? 'Unknown';
      final difficulty = routeData['difficulty'] ?? 'Unknown';
      
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStatChip(
            text: distance,
            imageIcon: Assets.icons.growth.path,
            width: 15.w,
            height: 15.h,
          ),
          _buildStatChip(
            text: duration,
            imageIcon: Assets.icons.graph.path,
            width: 14.w,
            height: 14.h,
          ),
          _buildStatChip(
            text: difficulty,
            isActive: true,
          ),
        ],
      );
    });
  }

  Widget _buildStatChip({
    required String text,
    String? imageIcon,
    bool isActive = false,
    double width = 20,
    double height = 20,
  }) {
    return Container(
      width: 96.w,
      height: 36.h,
      decoration: ShapeDecoration(
        color: isActive ? Color(0xFF2E4F3E) : Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (imageIcon != null) ...[
            Image.asset(imageIcon, width: width, height: height),
            SizedBox(width: 6.w),
          ],
          TextWidget(
            text: text,
            textAlignment: TextAlign.center,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            fontColor: isActive ? AppColor.white500 : AppColor.textColor,
          ),
        ],
      ),
    );
  }

  // Action Buttons
  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ButtonWidget(
            backgroundColor: AppColor.backgroundColor,
            label: 'Follow Route',
            fontSize: 10,
            fontWeight: FontWeight.w400,
            buttonHeight: 33,
            buttonWidth: 120,
            maxLines: 1,
            onPressed: () => Get.toNamed(AppRoutes.fullMapScreen),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: ButtonWidget(
            backgroundColor: AppColor.overLayBoxColor,
            label: 'Add Favorites',
            buttonWidth: 120,
            fontSize: 10,
            buttonHeight: 33,
            fontWeight: FontWeight.w400,
            textColor: AppColor.textColor,
            onPressed: () {},
            maxLines: 1,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: ButtonWidget(
            backgroundColor: Color.fromRGBO(245, 233, 223, 1),
            label: 'Create Outing',
            buttonHeight: 40,
            fontSize: 10,
            fontWeight: FontWeight.w400,
            maxLines: 1,
            textColor: AppColor.textColor,
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  // User Section
  Widget _buildUserSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => showUserDialog(context),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 12.h),
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.brown,
                  child: Icon(Icons.person, size: 16, color: Colors.white),
                ),
              ),
              SizedBox(width: 8),
              TextWidget(
                text: '@naturanauta 4.8',
                fontWeight: FontWeight.w400,
                fontSize: 16,
                fontColor: AppColor.textColor,
              ),
            ],
          ),
        ),
        Row(
          children: [
            SizedBox(width: 30),
            TextWidget(
              text: '  4,8 (57)  (17 luggers / 6 planes)',
              fontWeight: FontWeight.w400,
              fontSize: 16,
              fontColor: AppColor.subTitleColor,
            ),
          ],
        ),
      ],
    );
  }


  // Description Section
  Widget _buildDescriptionSection(RouteDetailsController controller) {
    return Obx(() {
      final routeData = controller.routeData;
      final description = routeData['description'] ?? 'No description available';
      
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(
            text: 'Description',
            fontColor: AppColor.textColor,
            fontSize: 16,
            fontWeight: FontWeight.w400,
            textAlignment: TextAlign.left,
          ),
          SizedBox(height: 8.h),
          TextWidget(
            text: description,
            fontColor: AppColor.darkGay300,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            textAlignment: TextAlign.left,
          ),
        ],
      );
    });
  }

  // Route Images Section
  Widget _buildRouteImagesSection(
      BuildContext context, RouteDetailsController controller) {
    // Use map screenshot if available, otherwise use API images
    final hasMapScreenshot = mapScreenshot != null;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Route Images',
          style: TextStyle(
            color: Color(0xFF2C2C2C),
            fontSize: 16.sp,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 8.h),
        SizedBox(
          height: 84.h,
          child: hasMapScreenshot
              ? ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  itemCount: 1, // Only show map screenshot
                  separatorBuilder: (context, index) => SizedBox(width: 8.w),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        _showImageDialog(context, controller, index);
                      },
                      child: Container(
                        width: 84.w,
                        height: 84.h,
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4.r),
                          child: Image.memory(
                            mapScreenshot!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                )
              : Obx(() => ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  itemCount: controller.images.length,
                  separatorBuilder: (context, index) => SizedBox(width: 8.w),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        _showImageDialog(context, controller, index);
                      },
                      child: Container(
                        width: 84.w,
                        height: 84.h,
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4.r),
                          child: Image.network(
                            controller.images[index],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[300],
                                child: Icon(Icons.image_not_supported, size: 20),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                )),
        ),
      ],
    );
  }

  void _showImageDialog(
      BuildContext context, RouteDetailsController controller, int index) {
    // Check if this is a map screenshot
    if (mapScreenshot != null && index == 0) {
      // Show map screenshot in dialog with zoom
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.zero,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.8,
              child: Stack(
                children: [
                  // Interactive image with zoom
                  InteractiveViewer(
                    panEnabled: true,
                    boundaryMargin: EdgeInsets.all(20),
                    minScale: 0.5,
                    maxScale: 4.0,
                    child: SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: Image.memory(
                        mapScreenshot!,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  // Close button
                  Positioned(
                    top: 40.h,
                    right: 20.w,
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        width: 40.w,
                        height: 40.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha:0.3),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(Icons.close, color: Colors.black),
                      ),
                    ),
                  ),
                  // Zoom instructions
                  Positioned(
                    bottom: 20.h,
                    left: 20.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        'Pinch to zoom',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    } else {
      // Handle API images
      final adjustedIndex = mapScreenshot != null ? index - 1 : index;
      if (adjustedIndex >= 0 && adjustedIndex < controller.images.length) {
        controller.selectImage(controller.images[adjustedIndex]);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: EdgeInsets.zero,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.8,
                child: Stack(
                  children: [
                    // Interactive image with zoom
                    InteractiveViewer(
                      panEnabled: true,
                      boundaryMargin: EdgeInsets.all(20),
                      minScale: 0.5,
                      maxScale: 4.0,
                      child: SizedBox(
                        width: double.infinity,
                        height: double.infinity,
                        child: Image.network(
                          controller.selectedImage.value,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[300],
                              child: Center(
                                child: Icon(Icons.image_not_supported, size: 50),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    // Close button
                    Positioned(
                      top: 40.h,
                      right: 20.w,
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          width: 40.w,
                          height: 40.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.3),
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(Icons.close, color: Colors.black),
                        ),
                      ),
                    ),
                    // Zoom instructions
                    Positioned(
                      bottom: 20.h,
                      left: 20.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          'Pinch to zoom',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }
    }
  }

  // Comments Section
  Widget _buildCommentsSection(RouteDetailsController controller) {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextWidget(
                  text: 'Comments',
                  fontColor: AppColor.textColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  textAlignment: TextAlign.left,
                ),
                GestureDetector(
                  onTap: () => controller.toggleComments(),
                  child: TextWidget(
                    text: controller.showAllComments.value
                        ? 'Show less'
                        : 'See more (${controller.remainingCommentsCount})',
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    fontColor: AppColor.backgroundColor,
                    underline: true,
                  ),
                ),
              ],
            ),
            ...controller.displayedComments
                .map((comment) => _buildCommentItem(comment)),
            _buildAddCommentSection(controller),
          ],
        ));
  }

  Widget _buildCommentItem(Map<String, dynamic> comment) {
    // Handle API response format
    final userName = comment['user']?['name'] ?? comment['name'] ?? 'Anonymous';
    final commentText = comment['comment'] ?? '';
    final createdAt = comment['createdAt'] ?? comment['date'] ?? '';
    
    return Container(
      margin: EdgeInsets.only(bottom: 16, top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.blue[100],
                child: Icon(
                  Icons.person,
                  color: Colors.blue,
                  size: 20,
                ),
              ),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(
                    text: userName,
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    fontColor: AppColor.textColor,
                  ),
                  TextWidget(
                    text: createdAt,
                    fontColor: AppColor.subTitleColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 8),
          TextWidget(
            text: commentText,
            fontWeight: FontWeight.w400,
            fontSize: 14,
            fontColor: AppColor.textColor,
            textAlignment: TextAlign.start,
          ),
        ],
      ),
    );
  }

  Widget _buildAddCommentSection(RouteDetailsController controller) {
    return SafeArea(
      child: Column(
        children: [
          TextFieldWidget(
            controller: controller.commentController,
            maxLines: 3,
            minLines: 3,
            borderColor: AppColor.lightGrayishOrange,
            backgroundColor: AppColor.lightGrayishOrange,
            borderRadius: 8,
            hintText: 'Add a comment here....',
            hintStyle: TextStyle(
              color: AppColor.subTitleColor,
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              fontFamily: GoogleFonts.openSans().fontFamily,
            ),
          ),
          SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: Obx(() => ButtonWidget(
              backgroundColor: AppColor.backgroundColor,
              label: controller.isPostingComment.value ? 'Posting...' : 'Comment',
              maxLines: 1,
              buttonWidth: 130.w,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              buttonHeight: 40,
              onPressed: controller.isPostingComment.value 
                  ? null 
                  : () => controller.postComment(controller.routeData['_id']),
            )),
          ),
          SizedBox(height: 10),
          Center(
            child: InkWell(
              onTap: () {
                Get.toNamed(AppRoutes.updateInformationScreen);
              },
              child: TextWidget(
                text: 'Update Status',
                fontWeight: FontWeight.w400,
                fontSize: 14,
                fontColor: AppColor.backgroundColor,
                underline: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- NEW EXTRACTED DIALOG WIDGET ---
class ImageGalleryDialog extends StatelessWidget {
  final RouteDetailsController controller;
  const ImageGalleryDialog({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(24),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColor.creamBackgroundColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Main Image Display
            Obx(() => ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: controller.selectedImage.value.isNotEmpty
                      ? Image.asset(
                          controller.selectedImage.value,
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            height: 200,
                            color: Colors.grey[300],
                            child: Icon(Icons.error,
                                size: 64, color: Colors.grey[600]),
                          ),
                        )
                      : Container(
                          width: double.infinity,
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(Icons.image, size: 64, color: Colors.red),
                        ),
                )),
            SizedBox(height: 16),
            // Thumbnails List
            SizedBox(
              height: 70,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 10),
                itemCount: controller.images.length,
                separatorBuilder: (context, index) => SizedBox(width: 10),
                itemBuilder: (context, imgIndex) {
                  final imgPath = controller.images[imgIndex];
                  return Obx(() {
                    final isSelected =
                        controller.selectedImage.value == imgPath;
                    return GestureDetector(
                      onTap: () => controller.selectImage(imgPath),
                      child: Container(
                        width: 90,
                        height: 110,
                        padding: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: isSelected
                                  ? Colors.amber
                                  : Colors.transparent,
                              width: 3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Image.asset(
                            imgPath,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                      ),
                    );
                  });
                },
              ),
            ),
          ],
        ),
      )
    );
  }
}
