import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zero_signal/constant/app_colors.dart';
import 'package:zero_signal/gen/assets.gen.dart';
import 'package:zero_signal/routes/app_routes.dart';
import '../../../widget/space_widget.dart';
import '../controller/profile_controller.dart';
import 'package:zero_signal/constant/app_strings.dart';
import 'menuItem_widget.dart';

class MenuItemsCardWidget extends StatelessWidget {
  final ProfileController controller;

  const MenuItemsCardWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
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
            title: AppStrings.mySpots,
            onTap: () => controller.navigateToRoute(AppRoutes.mySpotsScreen),
          ),
          _buildDivider(),
          MenuItemWidget(
            icon: Assets.icons.routesImage.path,
            title: AppStrings.myRoutes,
            onTap: () => controller.navigateToRoute(AppRoutes.myRoutesScreen),
          ),
          _buildDivider(),
          MenuItemWidget(
            icon: Assets.icons.favoriteSiteImage.path,
            title: AppStrings.favoriteSites,
            onTap: () => controller.navigateToRoute(AppRoutes.mySpotsScreen,
                arguments: {'type': 'favorite'}),
          ),
          _buildDivider(),
          MenuItemWidget(
            icon: Assets.icons.favoriteRoutesImage.path,
            title: AppStrings.favoriteRoutes,
            onTap: () =>
                controller.navigateToRoute(AppRoutes.favoriteRoutesScreen),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Column(
      children: [
        SpaceWidget(spaceHeight: 16),
        Container(
          height: 0.5,
          color: const Color(0x99D6C8B0),
        ),
        SpaceWidget(spaceHeight: 10),
      ],
    );
  }
}
