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
import 'package:zero_signal/widgets/image_gallery_dialog.dart';
import 'package:zero_signal/screen/route_navigation_screen/route_navigation_screen.dart';
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
    // Debug: Print route data to console
    print('=== ROUTE DETAILS SCREEN DEBUG ===');
    print('Route ID: $routeId');
    print('Route Data: $routeData');
    if (routeData != null) {
      print('Route Name: ${routeData!['name']}');
      print('Route Coordinates: ${routeData!['coordinates']}');
      print('Coordinates Length: ${routeData!['coordinates']?.length ?? 0}');
    }
    print('================================');

    final controller = Get.put(RouteDetailsController());
    
    // Set route data if provided, or fetch by ID - defer to avoid setState during build
    if (routeData != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.setRouteData(routeData!);
      });
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
            onPressed: () {
  // Use the route data that was passed to this screen
  final routeCoordinates = <Map<String, dynamic>>[];
  
  if (routeData != null) {
    // Add initial coordinate
    routeCoordinates.add({
      'latitude': routeData!['inital_lat'] ?? 0.0,
      'longitude': routeData!['inital_lng'] ?? 0.0,
    });
    
    // Add final coordinate
    routeCoordinates.add({
      'latitude': routeData!['final_lat'] ?? 0.0,
      'longitude': routeData!['final_lng'] ?? 0.0,
    });
  }
  
  final routeName = routeData?['title'] ?? 'Route Navigation';
  
  print('=== NAVIGATION DEBUG ===');
  print('Route Name: $routeName');
  print('Route Coordinates: $routeCoordinates');
  print('Coordinates Count: ${routeCoordinates.length}');
  print('Initial: ${routeData?['inital_lat']}, ${routeData?['inital_lng']}');
  print('Final: ${routeData?['final_lat']}, ${routeData?['final_lng']}');
  print('====================');
  
  Get.to(() => RouteNavigationScreen(
    routeId: routeId ?? '',
    routeCoordinates: routeCoordinates,
    routeName: routeName,
  ));
},
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
    final controller = Get.find<RouteDetailsController>();
    
    return Obx(() {
      // Get user data from route data
      final routeData = controller.routeData;
      final userName = routeData['user']?['name'] ?? routeData['createdBy']?['name'] ?? routeData['user']?['username'] ?? routeData['createdBy']?['username'] ?? 'Unknown User';
      final userRating = routeData['user']?['rating']?.toString() ?? routeData['rating']?.toString() ?? '4.8';
      final reviewCount = routeData['reviewCount']?.toString() ?? '57';
      final luggersCount = routeData['luggersCount']?.toString() ?? '17';
      final planesCount = routeData['planesCount']?.toString() ?? '6';
      final userAvatar = routeData['user']?['image'] ?? routeData['createdBy']?['image'] ?? routeData['user']?['avatar'] ?? routeData['createdBy']?['avatar'];
      
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
                    backgroundImage: userAvatar != null 
                        ? NetworkImage(userAvatar.startsWith('http') 
                            ? userAvatar 
                            : 'https://shariful5000.binarybards.online$userAvatar')
                        : null,
                    child: userAvatar == null 
                        ? Icon(Icons.person, size: 16, color: Colors.white)
                        : null,
                  ),
                ),
                SizedBox(width: 8),
                TextWidget(
                  text: '@$userName $userRating',
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
                text: '  $userRating ($reviewCount)  ($luggersCount luggers / $planesCount planes)',
                fontWeight: FontWeight.w400,
                fontSize: 16,
                fontColor: AppColor.subTitleColor,
              ),
            ],
          ),
        ],
      );
    });
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
    // Combine map screenshot and API images
    final allImages = <String?>[];
    if (mapScreenshot != null) {
      allImages.add(null); // Placeholder for map screenshot
    }
    allImages.addAll(controller.images);
    
    if (allImages.isEmpty) {
      return const SizedBox.shrink(); // Don't show section if no images
    }
    
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
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            itemCount: allImages.length,
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
                    child: _buildImageItem(index),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildImageItem(int index) {
    // Check if this is a map screenshot (first item if screenshot exists)
    if (mapScreenshot != null && index == 0) {
      return Image.memory(
        mapScreenshot!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[300],
            child: Icon(Icons.map, size: 20),
          );
        },
      );
    }
    
    // Adjust index for API images (accounting for screenshot)
    final apiImageIndex = mapScreenshot != null ? index - 1 : index;
    final controller = Get.find<RouteDetailsController>();
    
    return Image.network(
      controller.images[apiImageIndex],
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: Colors.grey[300],
          child: Icon(Icons.image_not_supported, size: 20),
        );
      },
    );
  }

  void _showImageDialog(
      BuildContext context, RouteDetailsController controller, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ImageGalleryDialog(
          networkImages: controller.images,
          mapScreenshot: mapScreenshot,
          initialIndex: index,
        );
      },
    );
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
