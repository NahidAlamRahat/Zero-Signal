import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zero_signal/screen/profile/widget/menuItems_card_widget.dart';
import 'package:zero_signal/screen/profile/widget/profile_card_widget.dart';
import 'package:zero_signal/screen/profile/widget/settings_card_widget.dart';
import '../../widget/space_widget.dart';
import 'controller/profile_controller.dart';

class ProfileSectionScreen extends StatelessWidget {
  ProfileSectionScreen({super.key});

  final ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF4E9),
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.getProfile();
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(right: 20.w, left: 20.w, top: 30.h),
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              spacing: 16,
              children: [
                ProfileCardWidget(controller: controller),
                MenuItemsCardWidget(controller: controller),
                SettingsCardWidget(controller: controller),
                SpaceWidget(spaceHeight: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
