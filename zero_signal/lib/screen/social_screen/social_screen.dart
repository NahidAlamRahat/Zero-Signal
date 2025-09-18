import 'package:flutter/material.dart';
import 'package:zero_signal/constant/app_icon_path.dart';
import 'package:zero_signal/constant/app_image_path.dart';
import 'package:zero_signal/utils/app_size.dart';
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
                                      height: 40,
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
