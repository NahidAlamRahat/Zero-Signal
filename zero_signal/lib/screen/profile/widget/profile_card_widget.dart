import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zero_signal/constant/app_image_path.dart';
import 'package:zero_signal/routes/app_routes.dart';

import '../../../gen/assets.gen.dart';
import '../../../widget/space_widget.dart';
import '../controller/profile_controller.dart';

class ProfileCardWidget extends StatelessWidget {
  final ProfileController controller;

  const ProfileCardWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Main Card
        Container(
          width: 390.w,
          height: 146.h,
          decoration: BoxDecoration(
            color: const Color(0xFFF5E9DF),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: const Color(0x23000000),
                blurRadius: 4,
                offset: const Offset(0, 0),
              )
            ],
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildProfileImage(),
                SpaceWidget(spaceHeight: 8),
                _buildUserName(),
                _buildUserEmail(),
                _buildUserBio(),
                SpaceWidget(spaceHeight: 8),
                _buildUserPoints(),
              ],
            ),
          ),
        ),
        // Top Right Corner Image
        Positioned(
          top: 10,
          right: 10,
          child: InkWell(
            onTap: (){
              Get.toNamed(AppRoutes.contactSupportScreen);
            },
            child: Container(
              width: 24.w,
              height: 24.h,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(8),
                ),
                image: DecorationImage(
                  image: AssetImage(Assets.icons.supportImage.path),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileImage() {
    return GestureDetector(
      onTap: () {
        controller.navigateToRoute(AppRoutes.personalInformationScreen);
      },
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFFFCB20), width: 2),
          borderRadius: BorderRadius.circular(24),
          image: DecorationImage(
            image: AssetImage(AppImagePath.profileImage),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildUserName() {
    return Obx(
          () => Text(
        controller.userName.value,
        style: TextStyle(
          color: const Color(0xFF2C2C2C),
          fontSize: 12.sp,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildUserEmail() {
    return Obx(
          () => Text(
        controller.userEmail.value,
        style: TextStyle(
          color: const Color(0xFF565656),
          fontSize: 10.sp,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildUserBio() {
    return Obx(
          () => Text(
        controller.userBio.value,
        style: TextStyle(
          color: const Color(0xFF2C2C2C),
          fontSize: 10.sp,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildUserPoints() {
    return Obx(
          () => Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '${controller.userPoints.value} ',
              style: TextStyle(
                color: const Color(0xFF2E4F3E),
                fontSize: 16.sp,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
            TextSpan(
              text: 'Points',
              style: TextStyle(
                color: const Color(0xFF2E4F3E),
                fontSize: 10.sp,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}