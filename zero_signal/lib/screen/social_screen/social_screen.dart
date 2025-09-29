import 'package:flutter/material.dart';
import 'package:zero_signal/constant/app_icon_path.dart';
import 'package:zero_signal/constant/app_image_path.dart';
import 'package:zero_signal/utils/app_size.dart';
import 'package:zero_signal/widget/button_widget/custom_elevated_button.dart';
import 'package:zero_signal/widget/glass_container.dart';
import 'package:zero_signal/widget/text_widget/custom_text.dart';

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
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppImagePath.socialBackgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Image.asset(
                        AppIconPath.addIcon,
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
                          onPressed: () {},
                          icon: Image.asset(
                            AppIconPath.taskIcon,
                            color: Colors.white,
                            height: 24,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
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
            SizedBox(height: AppSize.height(value: 100)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GlassContainer(
                  height: AppSize.height(value: 512),
                  width: AppSize.width(value: 350),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: "Mountain Hike",
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
                        SizedBox(height: AppSize.height(value: 5)),
                        CustomText(
                          textAlign: TextAlign.start,
                          text:
                              "Join me for a scenic hike in the mountains. Everyone is welcome!",
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                        SizedBox(height: AppSize.height(value: 20)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Image.asset(
                                      AppIconPath.batchIcon,
                                      height: 20,
                                    ),
                                    SizedBox(height: AppSize.height(value: 5)),
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
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Image.asset(
                                      AppIconPath.locationIcon,
                                      height: 20,
                                    ),
                                    SizedBox(height: AppSize.height(value: 5)),
                                    CustomText(
                                      text: "Girona, Catalonia",
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: AppSize.height(value: 20)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Image.asset(AppIconPath.groupIcon, height: 20),
                                SizedBox(height: AppSize.height(value: 5)),
                                CustomText(
                                  text: "12 people attending",
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                SizedBox(width: AppSize.width(value: 20)),
                                Image.asset(
                                  AppIconPath.addPeopleIcon,
                                  height: 20,
                                ),
                                SizedBox(height: AppSize.height(value: 5)),
                                CustomText(
                                  text: "15 attendants max.",
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                SizedBox(width: AppSize.width(value: 20)),
                                Image.asset(AppIconPath.saveIcon, height: 20),
                                SizedBox(height: AppSize.height(value: 5)),
                                CustomText(
                                  text: "8 Saved",
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: AppSize.height(value: 20)),
                        CustomText(
                          text: "Attendants",
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                        SizedBox(height: AppSize.height(value: 20)),
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
                                SizedBox(height: AppSize.height(value: 5)),
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
                                SizedBox(height: AppSize.height(value: 5)),
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
                                SizedBox(height: AppSize.height(value: 5)),
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
                        SizedBox(height: AppSize.height(value: 20)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomElevatedButton(
                              fontWeight: FontWeight.w500,
                              backgroundColor: Color(0xFFfc6057),
                              leftIcon: Icons.close,
                              text: "Follow",
                              onPressed: () {},
                            ),
                            CustomElevatedButton(
                              fontWeight: FontWeight.w500,
                              backgroundColor: Color(0xFF2e4f3e),
                              leftIcon: Icons.done,
                              text: "I'm in!",
                              onPressed: () {},
                            ),
                          ],
                        ),
                        SizedBox(height: AppSize.height(value: 20)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: Image.asset(
                                AppIconPath.saveIcon,
                                height: 24,
                              ),
                            ),
                            CustomText(
                              text: "Save",
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
