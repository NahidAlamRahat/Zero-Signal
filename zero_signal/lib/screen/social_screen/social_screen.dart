import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zero_signal/constant/app_colors.dart';
import 'package:zero_signal/constant/app_strings.dart';
import 'package:zero_signal/constant/app_icon_path.dart';
import 'package:zero_signal/constant/app_image_path.dart';
import 'package:zero_signal/routes/app_routes.dart';
import 'package:zero_signal/widget/button_widget/custom_elevated_button.dart';
import 'package:zero_signal/widget/glass_container.dart';
import 'package:zero_signal/widget/space_widget.dart';
import 'package:zero_signal/widget/text_widget/custom_text.dart';
import 'package:zero_signal/widget/text_widget/text_widgets.dart';

import '../../report_button_sheet/report_button_sheet.dart';
import 'controller/social_controller.dart';

class SocialScreen extends StatefulWidget {
  const SocialScreen({super.key});

  @override
  State<SocialScreen> createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen> {
  final SocialController controller = Get.put(SocialController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppImagePath.socialBackgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: RefreshIndicator(
          onRefresh: () async {
            await controller.fetchActivityFeed();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                SizedBox(height: 50.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        IconButton(
                          onPressed: () {
                            Get.toNamed(AppRoutes.createActivityScreen);
                          },
                          icon: Image.asset(
                            AppIconPath.addIcon2,
                            color: AppColor.white500,
                            height: 24.h,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: Image.asset(
                                AppIconPath.searchIcon,
                                color: AppColor.white500,
                                height: 24.h,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                Get.toNamed(AppRoutes.activityListsScreen);
                              },
                              icon: Image.asset(
                                AppIconPath.taskIcon,
                                color: AppColor.white500,
                                height: 24.h,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                Get.toNamed(AppRoutes.websiteViewScreen);
                              },
                              icon: Image.asset(
                                AppIconPath.shareIcon,
                                color: AppColor.white500,
                                height: 24.h,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                SizedBox(height: 20.h),
                Obx(() {
                  if (controller.isLoading.value) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (controller.activityFeed.isEmpty) {
                    return Center(
                      child: CustomText(
                        text: AppStrings.noActivitiesFound,
                        color: AppColor.white500,
                      ),
                    );
                  }
                  return SizedBox(
                    height: 600.h,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.activityFeed.length,
                      itemBuilder: (context, index) {
                        final item = controller.activityFeed[index];
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: GlassContainer(
                            width: Get.width - 40.w,
                            child: Padding(
                              padding: EdgeInsets.all(20.r),
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      text: item.title ?? "",
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600,
                                      color: AppColor.white500,
                                    ),
                                    CustomText(
                                      text: controller.formatDate(item.date),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: AppColor.white500,
                                    ),
                                    SizedBox(height: 12.h),
                                    CustomText(
                                      textAlign: TextAlign.start,
                                      text: item.description ?? "",
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: AppColor.white500,
                                    ),
                                    SizedBox(height: 20.h),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Image.asset(
                                                  AppIconPath.batchIcon,
                                                  height: 16.h,
                                                  width: 16.w,
                                                ),
                                                SizedBox(height: 5.h),
                                                CustomText(
                                                  text:
                                                      "@${item.user?.username ?? 'user'} • 4,8 ✰\n(17 luggers / 6 planes)",
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                  color: AppColor.white500,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Image.asset(
                                                AppIconPath.locationIcon,
                                                height: 20.h,
                                              ),
                                              SizedBox(width: 5.w),
                                              Flexible(
                                                child: CustomText(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  text: item.address ?? "",
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                  color: AppColor.white500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 20.h),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Column(
                                            children: [
                                              Image.asset(
                                                AppIconPath.groupIcon,
                                                height: 20.w,
                                                width: 20.w,
                                              ),
                                              SizedBox(height: 5.h),
                                              CustomText(
                                                text:
                                                    "${item.currentParticipants} ${AppStrings.peopleAttending}",
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                color: AppColor.white500,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Column(
                                            children: [
                                              SizedBox(width: 20.w),
                                              Image.asset(
                                                AppIconPath.addPeopleIcon,
                                                height: 20.h,
                                              ),
                                              SizedBox(height: 5.h),
                                              CustomText(
                                                text:
                                                    "${item.maxParticipants} ${AppStrings.attendantsMax}",
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                color: AppColor.white500,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Column(
                                            children: [
                                              SizedBox(width: 20.w),
                                              Image.asset(AppIconPath.saveIcon,
                                                  height: 20),
                                              SizedBox(height: 5.h),
                                              CustomText(
                                                text:
                                                    "${item.saved} ${AppStrings.savedHeader}",
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                                color: AppColor.white500,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 20.h),
                                    CustomText(
                                      text: AppStrings.attendantsHeader,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: AppColor.white500,
                                    ),
                                    SizedBox(height: 20.h),
                                    (item.participants == null ||
                                            item.participants!.isEmpty)
                                        ? Center(
                                            child: CustomText(
                                              text: AppStrings.noAttendants,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color: AppColor.white500,
                                            ),
                                          )
                                        : SizedBox(
                                            height: 80.h,
                                            child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount:
                                                  item.participants?.length ??
                                                      0,
                                              itemBuilder: (context, pIndex) {
                                                final participant =
                                                    item.participants![pIndex];
                                                return Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 16.w),
                                                  child: Column(
                                                    children: [
                                                      CircleAvatar(
                                                        radius: 20,
                                                        backgroundImage:
                                                            NetworkImage(
                                                          participant.image ??
                                                              "",
                                                        ),
                                                        onBackgroundImageError:
                                                            (_, __) =>
                                                                AssetImage(
                                                          AppImagePath
                                                              .profileImage1,
                                                        ),
                                                      ),
                                                      SizedBox(height: 5.h),
                                                      CustomText(
                                                        text:
                                                            "@${participant.username ?? ''}, 28",
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color:
                                                            AppColor.white500,
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                    SizedBox(height: 20.h),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: CustomElevatedButton(
                                            fontWeight: FontWeight.w500,
                                            backgroundColor: Color(0xFFfc6057),
                                            leftIcon: Icons.close,
                                            text: AppStrings.notToday,
                                            fontSize: 16,
                                            onPressed: () {
                                              controller.removeItem(index);
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          child: CustomElevatedButton(
                                            borderColor:
                                                AppColor.backgroundColor,
                                            fontWeight: FontWeight.w500,
                                            backgroundColor: Color(0xFF2e4f3e),
                                            leftIcon: Icons.done,
                                            text: AppStrings.imIn,
                                            onPressed: () {
                                              if (item.sId != null) {
                                                controller
                                                    .joinActivity(item.sId!);
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 32.h),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            if (item.sId != null) {
                                              controller.saveActivity(
                                                  item.sId!, index);
                                            }
                                          },
                                          child: Image.asset(
                                            (item.isSaved == true)
                                                ? AppIconPath.isSavedIcon
                                                : AppIconPath.saveIcon,
                                            height: 24,
                                            width: 24,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5.w,
                                        ),
                                        CustomText(
                                          text: (item.isSaved == true)
                                              ? AppStrings.savedHeader
                                              : AppStrings.saveHeader,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: AppColor.white500,
                                        ),
                                      ],
                                    ),
                                    SpaceWidget(
                                      spaceHeight: 8,
                                    ),
                                    Center(
                                      child: InkWell(
                                        onTap: () {
                                          if (item.sId != null) {
                                            showReportBottomSheet(
                                              context,
                                              itemId: item.sId!,
                                              type: "Activity",
                                            );
                                          }
                                        },
                                        child: TextWidget(
                                          text: AppStrings.reportActivity,
                                          fontColor: AppColor.white500,
                                          textAlignment: TextAlign.center,
                                          fontSize: 16,
                                          underline: true,
                                          underlineColor: Colors.white,
                                          underlineWidth: 1.5,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
