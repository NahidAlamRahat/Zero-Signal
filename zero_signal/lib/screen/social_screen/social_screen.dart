import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zero_signal/constant/app_icon_path.dart';
import 'package:zero_signal/constant/app_image_path.dart';
import 'package:zero_signal/routes/app_routes.dart';
import 'package:zero_signal/widget/button_widget/custom_elevated_button.dart';
import 'package:zero_signal/widget/glass_container.dart';
import 'package:zero_signal/widget/space_widget.dart';
import 'package:zero_signal/widget/text_widget/custom_text.dart';
import 'package:zero_signal/widget/text_widget/text_widgets.dart';

import '../../report_button_sheet/report_button_sheet.dart';

class SocialScreen extends StatefulWidget {
  const SocialScreen({super.key});

  @override
  State<SocialScreen> createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen> {
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
        child: SingleChildScrollView(
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
                      color: Colors.white,
                      height: 24,
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
                          color: Colors.white,
                          height: 24,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Get.toNamed(AppRoutes.activityListsScreen);
                        },
                        icon: Image.asset(
                          AppIconPath.taskIcon,
                          color: Colors.white,
                          height: 24,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Get.toNamed(AppRoutes.websiteViewScreen);

                        },
                        icon: Image.asset(
                          AppIconPath.shareIcon,
                          color: Colors.white,
                          height: 24,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GlassContainer(
              //  height: 512.h,
                width: 350.w,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: "Mountailn Hike",
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        CustomText(
                          text: "April 24",
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                        SizedBox(height: 5.h),
                        CustomText(
                          textAlign: TextAlign.start,
                          text:
                              "Join me for a scenic hike in the mountains. Everyone is welcome!",
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                        SizedBox(height: 20.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      AppIconPath.batchIcon,
                                      height: 20,
                                    ),
                                    SizedBox(height: 5.h),
                                    CustomText(
                                      text:
                                          "@naturanauta • 4,8 ✰\n(17 luggers / 6 planes)",
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Image.asset(
                                    AppIconPath.locationIcon,
                                    height: 20,
                                  ),
                                  SizedBox(width: 5.w),
                                  Flexible(
                                    child: CustomText(
                                      overflow: TextOverflow.ellipsis,
                                      text: "Girona, Catalonia",
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          ],
                        ),
                        SizedBox(height: 20.h),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Image.asset(AppIconPath.groupIcon, height: 20.w, width: 20.w,),
                                  SizedBox(height: 5.h),
                                  CustomText(
                                    text: "12 people attending",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
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
                                    text: "15 attendants max.",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  SizedBox(width: 20.w),
                                  Image.asset(AppIconPath.saveIcon, height: 20),
                                  SizedBox(height: 5.h),
                                  CustomText(
                                    text: "@Saved",
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 20.h),
                        CustomText(
                          text: "Attendants",
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                        SizedBox(height: 20.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundImage: AssetImage(
                                    AppImagePath.profileImage1,
                                  ),
                                ),
                                SizedBox(height: 5.h),
                                CustomText(
                                  text: "@alexa, 28",
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundImage: AssetImage(
                                    AppImagePath.profileImage2,
                                  ),
                                ),
                                SizedBox(height: 5.h),
                                CustomText(
                                  text: "@john.d, 32",
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundImage: AssetImage(
                                    AppImagePath.profileImage3,
                                  ),
                                ),
                                SizedBox(height: 5.h),
                                CustomText(
                                  text: "@samira_k, 25",
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundImage: AssetImage(
                                    AppImagePath.profileImage4,
                                  ),
                                ),
                                CustomText(
                                  text: "@alexa, 28",
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(

                              child: CustomElevatedButton(
                                fontWeight: FontWeight.w500,
                                backgroundColor: Color(0xFFfc6057),
                                leftIcon: Icons.close,
                                text: "Follow",
                                onPressed: () {},
                              ),
                            ),
                            Expanded(
                              child: CustomElevatedButton(
                                fontWeight: FontWeight.w500,
                                backgroundColor: Color(0xFF2e4f3e),
                                leftIcon: Icons.done,
                                text: "I'm in!",
                                onPressed: () {
                                  Get.toNamed(AppRoutes.activityListsScreen);
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              AppIconPath.saveIcon,
                              height: 24,
                              width: 24,
                            ),

                            SizedBox(
                              width: 5.w,
                            ),
                            CustomText(
                              text: "Save",
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),

                          ],
                        ),
                        SpaceWidget(spaceHeight: 8,),
                        Center(
                          child: InkWell(
                            onTap: () {
                              showReportBottomSheet(context);
                            },
                            child: TextWidget(
                              text: 'Report Activity',
                              fontColor: Colors.white,
                              textAlignment: TextAlign.center,
                              fontSize: 16.sp,
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
              ],
            ),



          ],
                  ),
        ),
    ),
        );
  }
}
