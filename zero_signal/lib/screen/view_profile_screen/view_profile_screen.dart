import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zero_signal/constant/app_image_path.dart';
import 'package:zero_signal/widget/appbar_widget/appbar_widget.dart';

import '../../constant/app_colors.dart';
import '../../gen/assets.gen.dart';
import '../../widget/text_widget/text_widgets.dart';
import '../profile/widget/menuItem_widget.dart';
import 'controller/view_profile_controller.dart';

class ViewProfileScreen extends StatelessWidget {
  const ViewProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ViewProfileController());

    return Scaffold(
      appBar: AppbarWidget(
        backgroundColor: AppColor.creamBackgroundColor,
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

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: TextWidget(
              text: controller.errorMessage.value,
              fontColor: Colors.red,
            ),
          );
        }

        // If no data loaded yet
        if (controller.userData.isEmpty) {
          return const Center(child: Text("No user data found"));
        }

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: 20.w,
          ),
          child: Column(
            children: [
              // Profile Card
              _buildProfileCard(controller),
              SizedBox(height: 16.h),
              // Menu Items Card
              _buildMenuItemsCard(controller),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildProfileCard(ViewProfileController controller) {
    final user = controller.userData;
    final userName = user['name'] ?? 'Unknown User';
    final userEmail = user['email'] ?? '';
    final userBio = user['bio'] ?? '';
    final userOneSentence = user['me_in_one_sentence'] ?? '';
    final userImage = user['image'];

    return InkWell(
      onTap: () {
        // Typically view profile doesn't navigate to personal info unless it's own profile?
        // Keeping as is for now, or maybe only if it's the current user?
        // User request didn't specify changing this action.
      },
      child: Container(
        width: 390,
        // height: 212,
        decoration: BoxDecoration(
          color: AppColor.overLayBoxColor,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: AppColor.boxShadowColor,
              blurRadius: 4,
              offset: const Offset(0, 0),
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              // Profile Image
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColor.yello, width: 2),
                  borderRadius: BorderRadius.circular(24),
                  image: DecorationImage(
                    image: userImage != null
                        ? NetworkImage(userImage.startsWith('http')
                            ? userImage
                            : 'https://shariful5000.binarybards.online$userImage')
                        : AssetImage(AppImagePath.profileImage)
                            as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              SizedBox(height: 8.h),

              // Name
              TextWidget(
                text: userName,
                fontColor: AppColor.textColor,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),

              // Email
              if (userEmail.isNotEmpty)
                TextWidget(
                  text: userEmail,
                  fontColor: AppColor.subTitleColor,
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                ),

              SizedBox(height: 4.h),

              // Bio
              if (userBio.isNotEmpty)
                TextWidget(
                  text: userBio,
                  fontColor: AppColor.textColor,
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                ),

              SizedBox(height: 8.h),

              // Points / One Sentence
              if (userOneSentence.isNotEmpty)
                TextWidget(
                  textAlignment:
                      TextAlign.center, // Changed to center for better look
                  text: userOneSentence,
                  fontColor: AppColor.subTitleColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItemsCard(ViewProfileController controller) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColor.overLayBoxColor,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0x23000000),
            blurRadius: 4,
            offset: const Offset(0, 0),
          )
        ],
      ),
      child: Column(
        children: [
          MenuItemWidget(
            icon: Assets.icons.mySpotsImage.path,
            title: 'My Spots',
            onTap: () => controller.fetchAndNavigateToSpots(),
          ),
          SizedBox(
            height: 16.h,
          ),
          _buildDivider(),
          SizedBox(
            height: 10.h,
          ),
          MenuItemWidget(
            icon: Assets.icons.routesImage.path,
            title: 'My Routes',
            onTap: () => controller.fetchAndNavigateToRoutes(),
          ),
          SizedBox(
            height: 16.h,
          ),
          _buildDivider(),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 0.5,
      color: AppColor.lineColor,
    );
  }
}
