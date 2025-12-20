import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zero_signal/constant/app_colors.dart';
import 'package:zero_signal/constant/app_image_path.dart';
import 'package:zero_signal/routes/app_routes.dart';
import 'package:zero_signal/widget/appbar_widget/appbar_widget.dart';
import 'package:zero_signal/widget/text_widget/text_widgets.dart';

import '../profile/controller/profile_controller.dart';

class PersonalInformationScreen extends StatelessWidget {
  PersonalInformationScreen({super.key});
  final ProfileController profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(
        backgroundColor: AppColor.creamBackgroundColor,
        textWidget: Align(
          alignment: Alignment.center,
          child: TextWidget(
            text: 'Personal Information',
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      backgroundColor: const Color(0xFFFFF4E9),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header

              // Content
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  spacing: 16,
                  children: [
                    // Profile Card
                    _buildProfileCard(),

                    // Bio Card
                    _buildBioCard(),

                    // Information Form
                    _buildInformationForm(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.overLayBoxColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: const Color(0x23000000),
            blurRadius: 4,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Row(
        children: [
          // Profile Image
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: AppColor.yello, width: 2),
            ),
            child: Obx(() {
              final imagePath = profileController.userImage.value;
              ImageProvider imageProvider;

              if (imagePath.isEmpty) {
                imageProvider = AssetImage(AppImagePath.profileImage);
              } else {
                imageProvider = NetworkImage(imagePath);
              }
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                    onError: (exception, stackTrace) =>
                        AssetImage(AppImagePath.profileImage),
                  ),
                ),
              );
            }),
          ),

          const SizedBox(width: 16),

          // Profile Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4,
              children: [
                Obx(() => TextWidget(
                      text: profileController.userName.value,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      fontColor: AppColor.textColor,
                    )),
                Obx(() => TextWidget(
                      text: profileController.userEmail.value,
                      fontWeight: FontWeight.w400,
                      fontColor: AppColor.subTitleColor,
                      fontSize: 12,
                    )),
              ],
            ),
          ),

          // Edit Button
          GestureDetector(
            onTap: () {
              Get.toNamed(AppRoutes.editProfileScreen);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0x262E4F3E),
                borderRadius: BorderRadius.circular(16),
              ),
              child: TextWidget(
                text: 'Edit Profile',
                fontSize: 9,
                fontWeight: FontWeight.w400,
                fontColor: AppColor.backgroundColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBioCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5E9DF),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: const Color(0x23000000),
            blurRadius: 4,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Obx(() => TextWidget(
            textAlignment: TextAlign.start,
            text: profileController.bio.value,
            fontSize: 12,
            fontWeight: FontWeight.w400,
            fontColor: AppColor.textColor,
          )),
    );
  }

  Widget _buildInformationForm() {
    return Obx(() => Column(
          spacing: 16,
          children: [
            _buildInfoField('Full Name', profileController.userName.value),
            _buildInfoField('Email', profileController.userEmail.value),
            _buildInfoField('Gender', profileController.userGender.value),
            _buildInfoField('Date of birth', profileController.userDob.value),
            _buildInfoField('Address', profileController.userAddress.value),
          ],
        ));
  }

  Widget _buildInfoField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        TextWidget(
          textAlignment: TextAlign.start,
          text: label,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          fontColor: AppColor.textColor,
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFF5E9DF),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextWidget(
            textAlignment: TextAlign.start,
            text: value,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            fontColor: AppColor.textColor,
          ),
        ),
      ],
    );
  }
}
