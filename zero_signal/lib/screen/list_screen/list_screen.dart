import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zero_signal/constant/app_colors.dart';
import 'package:zero_signal/constant/app_icon_path.dart';
import 'package:zero_signal/constant/app_image_path.dart';
import 'package:zero_signal/screen/list_screen/widget/activity_card.dart';

import '../../widget/button_widget/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:zero_signal/constant/app_colors.dart';
import 'package:zero_signal/constant/app_image_path.dart';
import '../../widget/button_widget/button_widget.dart';



class ActivityListsScreen extends StatefulWidget {
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
      ),
      body: Column(
        children: [
          // ✅ Tab Bar
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: tabs.length,
              itemBuilder: (context, index) {
                bool isSelected = selectedTabIndex == index;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedTabIndex = index;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    margin: const EdgeInsets.only(right: 20),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: isSelected ? Colors.black87 : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                    child: Text(
                      tabs[index],
                      style: TextStyle(
                        color: isSelected ? Colors.black87 : Colors.grey,
                        fontSize: 14,
                        fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          // ✅ Activities List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemCount: tabActivities[tabs[selectedTabIndex]]!.length,
              itemBuilder: (context, index) {
                final activity = tabActivities[tabs[selectedTabIndex]]![index];
                final tabName = tabs[selectedTabIndex]; // current tab

                // ✅ Conditional card style based on tab
                if (tabName == 'Near Activities') {
                  return ActivityCard(
                    activity: activity,
                    buttons: [
                      ButtonWidget(
                        backgroundColor:AppColor.backgroundColor,
                        label: 'view',
                        buttonWidth: 72,
                        buttonHeight: 40,
                        onPressed: () {},
                      ),
                    ],
                    // Optionally, add custom background for Near Activities
                  );
                } else if (tabName == 'Joined Activities') {
                  return ActivityCard(
                    activity: activity,
                    buttons: [

                      Expanded(
                        child: ButtonWidget(
                          backgroundColor:AppColor.red50,
                          label: 'Left',
                          buttonWidth: 110.w,
                          buttonHeight: 40.h,
                          onPressed: () {},
                          textColor: AppColor.red,

                        ),
                      ),

                      Expanded(
                        child: ButtonWidget(
                          icon: Image.asset(AppIconPath.chatIcon),
                          backgroundColor:AppColor.backgroundColor,
                          label: 'Chat',
                          buttonWidth: 110.w,
                          buttonHeight: 40.h,
                          onPressed: () {},
                        ),
                      ),

                    ],
                    // Optionally, change card background or layout
                  );
                } else if (tabName == 'Created Activities') {
                  return ActivityCard(
                    buttonsDirection: Axis.vertical,
                    activity: activity,
                    buttons: [
                      Icon(Icons.edit_outlined),
                      ButtonWidget(
                        icon: Image.asset(AppIconPath.chatIcon),
                        backgroundColor:AppColor.backgroundColor,
                        label: 'Chat',
                        buttonWidth: 110.w,
                        buttonHeight: 40.h,
                        onPressed: () {},
                      ),
                    ],
                  );
                } else {
                  // Saved tab
                  return ActivityCard(
                    buttonsAlignment: Alignment.bottomLeft,
                    activity: activity,
                    buttons: [
                      Text('18 Aug 2023')
                      
                    ],
                  );
                }
              },
            ),
          )

        ],
      ),
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



