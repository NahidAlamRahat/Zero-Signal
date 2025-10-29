import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zero_signal/constant/app_colors.dart';
import 'package:zero_signal/constant/app_image_path.dart';
import 'package:zero_signal/screen/list_screen/widget/activity_card.dart';



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
              padding: const EdgeInsets.symmetric(horizontal: 15),
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
                    height: 5,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    margin: const EdgeInsets.only(right: 0),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.transparent)
                      )
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Text(
                            tabs[index],
                            textAlign: TextAlign.center,

                            style: TextStyle(
                              color: isSelected ? Colors.black87 : Colors.grey,
                              fontSize: 14,
                              fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w400,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        // 👇 Rounded underline only when selected
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          height: 5,
                                               width: 150.w,

                                               // line width, you can adjust
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColor.backgroundColor
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(50), // rounded underline
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
,

          const SizedBox(height: 20),

          // ✅ Activities List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemCount: tabActivities[tabs[selectedTabIndex]]!.length,
              itemBuilder: (context, index) {
                final activity = tabActivities[tabs[selectedTabIndex]]![index];
                // Pass selectedTabIndex directly to ActivityCard
                // Now all design handling will be done inside ActivityCard
                return ActivityCard(
                  activity: activity,
                  tabIndex: selectedTabIndex,
                );
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



