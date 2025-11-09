import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zero_signal/constant/app_colors.dart';
import 'package:zero_signal/constant/app_image_path.dart';
import 'package:zero_signal/gen/assets.gen.dart';
import 'package:zero_signal/routes/app_routes.dart';
import 'package:zero_signal/screen/sport_details/widget/date_picker_sheet.dart';
import 'package:zero_signal/widget/appbar_widget/appbar_widget.dart';
import 'package:zero_signal/widget/button_widget/button_widget.dart';
import 'package:zero_signal/widget/showCustomDialog.dart';
import 'package:zero_signal/widget/text_field_widget/text_field_widget.dart';
import 'package:zero_signal/widget/text_widget/text_widgets.dart';

import '../save_route_details_screen/controller/save_route_details_screen_controller.dart';

class SpotDetailsScreen extends StatelessWidget {
  const SpotDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RouteDetailsController());

    return Scaffold(
      appBar: AppbarWidget(
        text: 'Sport Details',
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
                  SizedBox(height: 4.h),


                  Row(
                    children: const [
                      Icon(Icons.location_on,
                          color: Colors.red, size: 16),
                      SizedBox(width: 4),
                      TextWidget(
                        text: 'Espat, Catalonia',
                        fontColor: AppColor.darkGay300,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  ),


                  SizedBox(height: 16.h),

                  _buildStatsSection(context),
                  SizedBox(height: 16.h),

                  _buildActionButtons(context: context),
                  SizedBox(height: 12.h),

                  // Visitor info
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColor.lightGrayishOrange,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextWidget(
                      text: '5 user will visit this place on Sunday',
                      fontColor: AppColor.textColor,
                      fontSize: 14,
                    ),
                  ),

                  SizedBox(height: 16.h),

                  _buildDescriptionSection(),
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
    return AutoCarouselHeader();
  }

  // Title Section
  Widget _buildTitleSection(RouteDetailsController controller) {
    return TextWidget(
      text:  'Lakeside Campsite',
      fontSize: 24,
      fontWeight: FontWeight.w500,
      fontColor: AppColor.textColor,
    );
  }

  Widget _buildStatsSection(BuildContext context) {
    return    Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () {
              _showUserDialog(context);
            },
            child: Row(
              children: const [
                CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.brown,
                  child: Icon(
                    Icons.person,
                    size: 16,
                    color: AppColor.white500,
                  ),
                ),
                SizedBox(width: 8),
                TextWidget(
                  text: '@naturanauta',
                ),
              ],
            ),
          ),
        ),
        Icon(Icons.star, color: AppColor.yello,size: 18,),
        TextWidget(
          text: '(17 lugares / 6 plane)',
          fontWeight: FontWeight.w400,
          fontSize: 16,
        ),
      ],
    );
  }

  // Rating and user info





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
  Widget _buildActionButtons({required BuildContext context}) {
    return Row(
      children: [
        Expanded(
          child: ButtonWidget(

            backgroundColor: AppColor.backgroundColor,
            label: 'How To Arrive',

            fontSize: 11,
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
            fontSize: 11,
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
            label: 'Assist',
            buttonHeight: 40,
            fontSize: 11,
            fontWeight: FontWeight.w400,
            maxLines: 1,
            textColor:AppColor.textColor,
            onPressed: () {
              showDatePickerSheet(context);
            },
          ),
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
          SizedBox(height: 16.h,),
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
              onPressed: (){
                showReportDialog(context);
              },
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
          fontSize: 16,
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
            fontSize: 16,
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




  /// Second dialog → Report details
  void showReportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ShowCustomDialog(

        topPadding: 50,
        showIcon: false,
        backgroundColor: AppColor.creamBackgroundColor,
        title: 'Report User',
        bottomPadding: 30,
        titleStyle:  TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 16.sp,
        ),
        description:
        'Your report is anonymous. Please provide details about the issue to help our moderation team.',
        descriptionStyle:  TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
        ),
        image: Image.asset(AppImagePath.profileImage),
        actionsLayout: ActionsLayout.column,
        actionsAlignment: MainAxisAlignment.start,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(text: 'Reason for reporting',
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
                SizedBox(height: 8,),
                TextFieldWidget(
                  hintText: "e.g., inappropriate content, spam, harassment.....",
                  textColor: AppColor.subTitleColor,
                  backgroundColor: AppColor.lightGrayishOrange,
                  borderColor: AppColor.creamBackgroundColor,
                  maxLines: 4,
                  minLines: 3,
                  borderRadius: 8,
                ),

                SizedBox(height: 30.h,),

                ButtonWidget(
                  buttonHeight: 44,
                  buttonWidth: double.infinity,
                  onPressed: () {
                    Get.back();
                    Get.snackbar("Reported", "Thank you for your feedback!");
                  },
                  backgroundColor: AppColor.backgroundColor,
                  textColor: Colors.white,
                  label: 'Send to Administration',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),



              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Date picker bottom sheet
  Future<DateTime?> showDatePickerSheet(BuildContext context) async {
    return await showModalBottomSheet<DateTime>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => SafeArea(
        child: Container(
          width: Get.width,
          //   height: Get.height*0.5,
          color: AppColor.creamBackgroundColor,
          child: const DatePickerSheet(),
        ),
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

// --- AUTO CAROUSEL HEADER WIDGET ---
class AutoCarouselHeader extends StatefulWidget {
  const AutoCarouselHeader({super.key});

  @override
  State<AutoCarouselHeader> createState() => _AutoCarouselHeaderState();
}

class _AutoCarouselHeaderState extends State<AutoCarouselHeader> with SingleTickerProviderStateMixin {
  late Timer _timer;
  int _currentPage = 0;

  // List of images for the carousel
  final List<String> _images = [
    AppImagePath.viewImage,
    AppImagePath.sunImage,
    AppImagePath.image1,
    AppImagePath.image2,
    // Add more image paths here
  ];

  @override
  void initState() {
    super.initState();
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        if (_currentPage < _images.length - 1) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 800),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  final scaleAnimation = Tween<double>(
                    begin: 0.8,
                    end: 1.0,
                  ).animate(CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutBack,
                  ));
                  
                  return ScaleTransition(
                    scale: scaleAnimation,
                    child: FadeTransition(
                      opacity: animation,
                      child: child,
                    ),
                  );
                },
                child: Image.asset(
                  _images[_currentPage],
                  key: ValueKey<int>(_currentPage),
                  width: double.infinity,
                  height: 219.h,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(Icons.image_not_supported, size: 50),
                      ),
                    );
                  },
                ),
              ),
            ),
             // Page Indicator
            // Positioned(
            //   bottom: 12,
            //   left: 0,
            //   right: 0,
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: List.generate(
            //       _images.length,
            //       (index) => AnimatedContainer(
            //         duration: const Duration(milliseconds: 300),
            //         margin: const EdgeInsets.symmetric(horizontal: 4),
            //         width: _currentPage == index ? 24 : 8,
            //         height: 8,
            //         decoration: BoxDecoration(
            //           borderRadius: BorderRadius.circular(4),
            //           color: _currentPage == index
            //               ? AppColor.white500
            //               : AppColor.white500.withOpacity(0.4),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
