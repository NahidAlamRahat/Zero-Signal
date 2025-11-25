import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zero_signal/constant/app_colors.dart';
import 'package:zero_signal/constant/app_image_path.dart';
import 'package:zero_signal/gen/assets.gen.dart';
import 'package:zero_signal/routes/app_routes.dart';
import 'package:zero_signal/widget/appbar_widget/appbar_widget.dart';
import 'package:zero_signal/widget/button_widget/button_widget.dart';
import 'package:zero_signal/widget/showCustomDialog.dart';
import 'package:zero_signal/widget/text_field_widget/text_field_widget.dart';
import 'package:zero_signal/widget/text_widget/text_widgets.dart';

import '../sport_details/widget/user_dialogs.dart';
import 'controller/save_route_details_screen_controller.dart';

class SaveRouteDetailsScreen extends StatelessWidget {
  const SaveRouteDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RouteDetailsController());

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
      body: Column(
        children: [
          _buildHeaderImage(),
          SizedBox(height: 12.h),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitleSection(controller),
                  SizedBox(height: 10.h),
                  _buildStatsSection(),
                  SizedBox(height: 12.h),
                  _buildActionButtons(),
                  SizedBox(height: 12.h),
                  _buildUserSection(context),
                  SizedBox(height: 16.h),
                  _buildDescriptionSection(),
                  SizedBox(height: 16.h),
                  _buildRouteImagesSection(context, controller),
                  SizedBox(height: 16.h),
                  _buildCommentsSection(controller),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Header Image
  Widget _buildHeaderImage() {
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
          child: Image.asset(
            AppImagePath.viewImage,
            fit: BoxFit.cover,
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
    );
  }

  // Title Section
  Widget _buildTitleSection(RouteDetailsController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextWidget(
         text:  'Portlligat - Cap de Creus',
          // style: TextStyle(
          //   fontSize: 24.sp,
          //   fontWeight: FontWeight.w500,
          //   color: Color(0xFF2D2D2D),
          // ),
          fontSize: 20.sp,
          fontWeight: FontWeight.w500,
          fontColor: AppColor.textColor,
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
    );
  }

  // Stats Section
  Widget _buildStatsSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildStatChip(
          text: '12.5 Km',
          imageIcon: Assets.icons.growth.path,
          width: 15.w,
          height: 15.h,
        ),
        _buildStatChip(
          text: 'Medium',
          imageIcon: Assets.icons.graph.path,
          width: 14.w,
          height: 14.h,
        ),
        _buildStatChip(
          text: 'Hiking',
          isActive: true,
        ),
      ],
    );
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
            textColor:AppColor.textColor,
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
                padding:  EdgeInsets.only(top: 12.h),
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

  void _showUserDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ShowCustomDialog(
        backgroundColor: AppColor.creamBackgroundColor,

        title: '@naturanauta',
        titleStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
        description: "I'm a nature lover and outdoor enthusiast",
        descriptionStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.w400),
        image: Image.asset(AppImagePath.profileImage),
        actionsLayout: ActionsLayout.column,
        actions: [
          Image.asset(Assets.icons.likeIcon.path,height: 24.h,width: 24.w,),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: ButtonWidget(
              onPressed: () => Get.toNamed(AppRoutes.viewProfileScreen),
              backgroundColor: AppColor.backgroundColor,
              label: 'View Profile',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              buttonHeight: 40,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: ButtonWidget(
              backgroundColor: Colors.transparent,
              textColor: Colors.red,
              label: 'Report user',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              buttonHeight: 40,
            ),
          ),
        ],
      ),
    );
  }

  // Description Section
  Widget _buildDescriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextWidget(
         text:  'Description',
         fontColor: AppColor.textColor,
         fontSize: 16,
         fontWeight: FontWeight.w400,
         textAlignment: TextAlign.left,
        ),
        SizedBox(height: 8.h),
        TextWidget(
         text:  'Escape the heat at the Azure Oasis. This stunning, crystal-clear pool is a tranquil paradise, surrounded by lush greenery. Its the perfect spot to relax, refresh, and immerse yourself in serene beauty.',
          fontColor: AppColor.darkGay300,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          textAlignment: TextAlign.left,
        ),
      ],
    );
  }

  // Route Images Section
  Widget _buildRouteImagesSection(
      BuildContext context, RouteDetailsController controller) {
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
        Obx(() => SizedBox(
              height: 84.h,
              child: ListView.separated(
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
                        image: DecorationImage(
                          image: AssetImage(controller.images[index]),
                          fit: BoxFit.cover,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                    ),
                  );
                },
              ),
            )),
      ],
    );
  }

  void _showImageDialog(
      BuildContext context, RouteDetailsController controller, int index) {
    // Set the initial image when the dialog opens
    if (index < controller.images.length) {
      controller.selectImage(controller.images[index]);
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ImageGalleryDialog(controller: controller);
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
                 text:  'Comments',
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
            _buildAddCommentSection(),
          ],
        ));
  }

  Widget _buildCommentItem(Map<String, dynamic> comment) {
    return Container(
      margin: EdgeInsets.only(bottom: 16, top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: comment['avatar'],
                child: Icon(
                  comment['avatarIcon'],
                  color: comment['avatarIconColor'],
                  size: 20,
                ),
              ),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(
                   text:  comment['name'],
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    fontColor: AppColor.textColor,
                  ),

                  TextWidget(
                   text:  comment['date'],
                    fontColor: AppColor.subTitleColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 12),
          TextWidget(
            text: comment['comment'],
            fontWeight: FontWeight.w400,
            fontSize: 14,
            fontColor: AppColor.subTitleColor,
            textAlignment: TextAlign.start,
          ),
        ],
      ),
    );
  }

  Widget _buildAddCommentSection() {
    return SafeArea(
      child: Column(
        children: [
          TextFieldWidget(

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
            child: ButtonWidget(
              backgroundColor: AppColor.backgroundColor,
              label: 'comment ',
              maxLines: 1,
              buttonWidth: 130.w,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              buttonHeight: 40,
              onPressed: () {},
            ),
          ),
          SizedBox(height: 10),
          Center(
            child: InkWell(
              onTap: (){
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
                          child: Icon(Icons.image,
                              size: 64, color: Colors.red),
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
      ),
    );
  }
}
