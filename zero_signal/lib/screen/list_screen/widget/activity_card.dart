import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zero_signal/widget/button_widget/button_widget.dart';
import 'package:zero_signal/widget/text_widget/text_widgets.dart';
import '../../../constant/app_colors.dart';
import '../../../constant/app_icon_path.dart';
import '../../../gen/assets.gen.dart';
import '../../../routes/app_routes.dart';
import '../list_screen.dart';

class ActivityCard extends StatelessWidget {
  final ActivityItem activity;
  final int tabIndex;

  const ActivityCard({
    super.key,
    required this.activity,
    required this.tabIndex,
  });

  @override
  Widget build(BuildContext context) {
    // Tab 0: Near Activities
    if (tabIndex == 0) {
      return Container(
        width: double.infinity,
        height: 140.h,
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: ShapeDecoration(
          color: AppColor.creamBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          shadows: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 116.w,
              height: 116.h,
              decoration: ShapeDecoration(
                image: DecorationImage(
                  image: AssetImage(activity.imagePath),
                  fit: BoxFit.cover,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(
                    text: activity.title,
                    fontColor: AppColor.textColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                  Row(
                    children: [
                      Container(
                        width: 12.w,
                        height: 12.h,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(Assets.icons.location.path),
                            fit: BoxFit.cover,
                          ),
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Expanded(
                        child: TextWidget(
                          text: activity.category,
                          textAlignment: TextAlign.start,
                          fontColor: AppColor.darkGay300,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  TextWidget(
                    text: activity.location,
                    fontColor: AppColor.textColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                  const Spacer(),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: InkWell(
                      onTap: () {
                        Get.toNamed(AppRoutes.listViewDetailsScreen);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: ShapeDecoration(
                          color: const Color(0xFF2E4F3E),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: TextWidget(
                          text: 'View',
                          fontColor: AppColor.white500,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // Tab 1: Joined Activities
    if (tabIndex == 1) {
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: ShapeDecoration(
          color: AppColor.creamBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          shadows: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 116.w,
              height: 116.h,
              decoration: ShapeDecoration(
                image: DecorationImage(
                  image: AssetImage(activity.imagePath),
                  fit: BoxFit.cover,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(
                    text: activity.title,
                    fontColor: AppColor.textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                  Row(
                    children: [
                      Container(
                        width: 12.w,
                        height: 12.h,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(Assets.icons.location.path),
                            fit: BoxFit.cover,
                          ),
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Expanded(
                        child: TextWidget(
                          textAlignment: TextAlign.start,
                          text: 'May 18',
                          fontColor: AppColor.darkGray500,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  TextWidget(
                    text: activity.location,
                    fontColor: AppColor.textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                  SizedBox(height: 16.h,),
                  Row(
                    children: [
                      Expanded(
                        child: ButtonWidget(
                          backgroundColor: AppColor.red50,
                          textColor: AppColor.red,
                          buttonHeight: 43,
                          label: 'Left',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          onPressed: () {
                            Get.toNamed(AppRoutes.sunsetPointDetailsScreen);
                          },
                        ),
                      ),
                      SizedBox(width: 20.w),
                      Expanded(
                        child: ButtonWidget(

                          backgroundColor: AppColor.backgroundColor,
                          textColor: AppColor.white500,
                          buttonHeight: 43,
                          icon:Image(image: AssetImage(Assets.icons.chatIcon2.path),height: 20.h,width: 20.w, ),
                          label: 'Chat',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          onPressed: () {
                            Get.toNamed(AppRoutes.chatScreen);
                          },
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // Tab 2: Created Activities
    if (tabIndex == 2) {
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: ShapeDecoration(
          color: AppColor.creamBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          shadows: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 116.w,
              height: 116.h,
              decoration: ShapeDecoration(
                image: DecorationImage(
                  image: AssetImage(activity.imagePath),
                  fit: BoxFit.cover,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(
                    text: activity.title,
                    fontColor: AppColor.darkGray500,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  Row(
                    children: [
                      Container(
                        width: 12.w,
                        height: 12.h,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(Assets.icons.location.path),
                            fit: BoxFit.cover,
                          ),
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Expanded(
                        child: TextWidget(
                          textAlignment: TextAlign.start,
                          text: activity.category,
                          fontColor: AppColor.darkGray500,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            Get.toNamed(AppRoutes.editActivityScreen);
                          },
                          child: Image.asset(
                            AppIconPath.editIcon,
                            height: 20.h,
                            width: 20.w,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        InkWell(
                          onTap: () {
                            Get.toNamed(AppRoutes.chatScreen);
                          },
                          child: Container(
                            height: 32.h,
                            width: 95.w,
                            decoration: BoxDecoration(
                              color: AppColor.backgroundColor,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  Assets.icons.chatIcon2.path,
                                  height: 20.h,
                                  width: 20.w,
                                ),
                                SizedBox(width: 4.w),
                                TextWidget(
                                  text: "Chat",
                                  fontColor: AppColor.white500,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // Tab 3: Saved Activities (Default)
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: ShapeDecoration(
        color: AppColor.creamBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        shadows: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 116.w,
            height: 116.h,
            decoration: ShapeDecoration(
              image: DecorationImage(
                image: AssetImage(activity.imagePath),
                fit: BoxFit.cover,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: SizedBox(
              height: 116.h,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidget(
                        text: activity.title,
                        fontColor: const Color(0xFF2C2C2C),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        textAlignment: TextAlign.start,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      TextWidget(
                        textAlignment: TextAlign.start,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        text: "Join me on a hike to a stunning water...",
                        fontColor: AppColor.subTitleColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  ),
                  TextWidget(
                    text: '18 Aug 2023',
                    fontColor: AppColor.darkGray500,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}