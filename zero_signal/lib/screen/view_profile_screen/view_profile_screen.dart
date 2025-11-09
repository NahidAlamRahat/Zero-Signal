import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zero_signal/constant/app_image_path.dart';
import 'package:zero_signal/widget/appbar_widget/appbar_widget.dart';

import '../../constant/app_colors.dart';
import '../../gen/assets.gen.dart';
import '../../routes/app_routes.dart';
import '../../widget/text_widget/text_widgets.dart';
import '../profile/controller/profile_controller.dart';
import '../profile/widget/menuItem_widget.dart';

class ViewProfileScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(
        backgroundColor:  AppColor.creamBackgroundColor,

      ),
      backgroundColor: AppColor.creamBackgroundColor,
      body: SingleChildScrollView(
        padding:  EdgeInsets.symmetric(horizontal: 20.w, ),
        child: Column(
          children: [
            // Profile Card
            _buildProfileCard(),
            SizedBox(height: 16.h),
            // Menu Items Card
             _buildMenuItemsCard(),


          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return InkWell(
      onTap: (){
        Get.toNamed(AppRoutes.personalInformationScreen);
      },
      child: Container(
        width: 390,
        // height: 212,
        decoration: BoxDecoration(
          color:  AppColor.overLayBoxColor,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color:  AppColor.boxShadowColor,
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
                  border: Border.all(color:AppColor.yello, width: 2),
                  borderRadius: BorderRadius.circular(24),
                  image: DecorationImage(
                    image: AssetImage(AppImagePath.profileImage),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // Name
              TextWidget(
                text: 'Liam Johnson',
                fontColor: AppColor.textColor,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),

              // Email
              TextWidget(
                text: 'hola@zerosignal.app',
                fontColor: AppColor.subTitleColor,
                fontSize: 10,
                fontWeight: FontWeight.w400,
              ),

              // Bio
              TextWidget(
                text: 'Outdoor enthusiast & explorer',
                fontColor: AppColor.textColor,
                fontSize: 10,
                fontWeight: FontWeight.w400,
              ),

              // Points
              TextWidget(
                textAlignment: TextAlign.start,
                text: "Lam loves to explore new places and experience different cultures. Her heart beats for the thrill of adventure. She finds joy in every journey, whether it's wandering through ancient ruins, hiking up a mountain, or simply getting lost in a new city.",
                fontColor:AppColor.subTitleColor,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItemsCard() {
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
            onTap: () => Get.toNamed(AppRoutes.mySpotsScreen),
          ),
          SizedBox(height: 16.h,),

          _buildDivider(),
          SizedBox(height: 10.h,),

          MenuItemWidget(
            icon: Assets.icons.routesImage.path,
            title: 'My Routes',
            onTap: () => Get.toNamed(AppRoutes.myRoutesScreen),
          ),
          SizedBox(height: 16.h,),

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