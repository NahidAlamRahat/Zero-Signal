import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zero_signal/constant/app_colors.dart';
import 'package:zero_signal/constant/app_image_path.dart';
import 'package:zero_signal/screen/list_screen/widget/activity_card.dart';
import 'package:zero_signal/widget/text_widget/text_widgets.dart';

import 'controller/list_screen_controller.dart';



class ActivityListsScreen extends StatefulWidget {
  const ActivityListsScreen({super.key});

  @override
  _ActivityListsScreenState createState() => _ActivityListsScreenState();
}

class _ActivityListsScreenState extends State<ActivityListsScreen> {
  int selectedTabIndex = 0;

  final List<String> tabs = [
    'Near Activities',
    'Joined Activities',
    'Created Activities',
    'Saved'
  ];

  final Map<String, List<ActivityItem>> tabActivities = {
    'Near Activities': [
      ActivityItem(
        title: 'Morning Hike',
        location: 'Near Olot, Catalonia',
        category: 'Giromes',
        imagePath: AppImagePath.image1,
      ),
      ActivityItem(
        title: 'Kayak Adventure',
        location: 'de Mar, 34 Km',
        category: 'Near Lloret',
        imagePath: AppImagePath.image3,
      ),
    ],
    'Joined Activities': [
      ActivityItem(
        title: 'Trail Running',
        location: 'Near Vic, 48Km',
        category: 'Near Vic',
        imagePath: AppImagePath.image4,
      ),
      ActivityItem(
        title: 'Evening Yoga',
        location: 'Near Barcelona',
        category: 'Fitness',
        imagePath: AppImagePath.image2,
      ),
    ],
    'Created Activities': [
      ActivityItem(
        title: 'Cycling',
        location: 'Near Girona',
        category: 'Sports',
        imagePath: AppImagePath.image1,
      ),
    ],
    'Saved': [
      ActivityItem(
        title: 'Photography Walk',
        location: 'Near Madrid',
        category: 'Arts',
        imagePath: AppImagePath.image3,
      ),
    ],
  };

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: ListScreenController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColor.creamBackgroundColor,
          appBar: AppBar(
            backgroundColor: AppColor.creamBackgroundColor,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black87, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              'Lists',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
            bottom:  PreferredSize(
              preferredSize: const Size.fromHeight(56),
              child: Stack(
                key: controller.headerKey,
                children: [
                  Container(
                    margin:  EdgeInsets.only(left: 19.w, right: 19.w),
                    height: 56,
                    color:Colors.transparent,
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      height: 5,
                      margin: const EdgeInsets.only(bottom: 4),
                      color: AppColor.base_50,
                    ),
                  ),
                  SingleChildScrollView(
                    controller: controller.scrollController,
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: [
                        for (int i = 0; i < controller.tabs.length; i++)
                          GestureDetector(
                            onTap: () => controller.select(i),
                            behavior: HitTestBehavior.opaque,
                            child: Container(
                              key: controller.tabKeys[i],
                              padding:  EdgeInsets.symmetric(horizontal: 14.w, vertical: 12),
                              child: TextWidget(
                                fontWeight: i == controller.selectedIndex ? FontWeight.w400 : FontWeight.w300,
                                fontColor: i == controller.selectedIndex ? AppColor.textColor : AppColor.subTitleColor,
                                text: controller.tabs[i],),
                            ),
                          ),
                        const SizedBox(width: 8),
                      ],
                    ),
                  ),

                  // Text(
                  //   controller.tabs[i],
                  //   style: TextStyle(
                  //     color: i == controller.selectedIndex ? Colors.black87 : Colors.black54,
                  //     fontWeight: FontWeight.w600,
                  //   ),
                  // )


                  Positioned(
                    bottom: 4,
                    left: controller.indicatorLeft,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeOut,
                      height: 5,
                      width: controller.indicatorWidth > 0 ? controller.indicatorWidth : 0,
                      decoration: BoxDecoration(
                        color: AppColor.backgroundColor,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: Column(
            children: [


              const SizedBox(height: 20),

              // ✅ Activities List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  itemCount: tabActivities[tabs[controller.selectedIndex]]!.length,
                  itemBuilder: (context, index) {
                    final activity = tabActivities[tabs[controller.selectedIndex]]![index];
                    // Pass selectedTabIndex directly to ActivityCard
                    // Now all design handling will be done inside ActivityCard
                    return ActivityCard(
                      activity: activity,
                      tabIndex: controller.selectedIndex,
                    );
                  },
                ),
              )

            ],
          ),
        );
      }
    );
  }
}


class ActivityItem {
  final String title;
  final String location;
  final String category;
  final String imagePath;

  ActivityItem({
    required this.title,
    required this.location,
    required this.category,
    required this.imagePath,
  });
}



