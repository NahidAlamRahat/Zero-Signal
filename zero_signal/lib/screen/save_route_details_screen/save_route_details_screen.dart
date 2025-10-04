import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:zero_signal/constant/app_colors.dart';
import 'package:zero_signal/constant/app_icon_path.dart';
import 'package:zero_signal/constant/app_image_path.dart';
import 'package:zero_signal/widget/appbar_widget/appbar_widget.dart';
import 'package:zero_signal/widget/button_widget/button_widget.dart';
import 'package:zero_signal/widget/text_field_widget/text_field_widget.dart';
import 'package:zero_signal/widget/text_widget/text_widgets.dart';

import '../../routes/app_routes.dart';
import '../../widget/showCustomDialog.dart';

class SaveRouteDetailsScreen extends StatefulWidget {
  const SaveRouteDetailsScreen({super.key});

  @override
  State<SaveRouteDetailsScreen> createState() => _SaveRouteDetailsScreenState();
}

class _SaveRouteDetailsScreenState extends State<SaveRouteDetailsScreen> {
  bool showAllComments = false;

  // Sample comments data
  List<Map<String, dynamic>> allComments = [
    {
      'name': 'Charolette Hanlin',
      'date': 'Feb 3, 2025',
      'comment':
          'Chill atmosphere, friendly crowd. Exactly the relaxed spot we were looking for on a Friday night. Loved it. 😍😍',
      'avatar': Colors.blue[100],
      'avatarIcon': Icons.person,
      'avatarIconColor': Colors.blue,
    },
    {
      'name': 'Olivia Gabriella Hernandez',
      'date': 'Apr 21, 2025',
      'comment':
          'Good music, but the service was slow. Maybe an off night? The overall vibe was still positive though. 😊😊',
      'avatar': Colors.green[100],
      'avatarIcon': Icons.person,
      'avatarIconColor': Colors.green,
    },
    {
      'name': 'Emma Victoria Lewis',
      'date': 'Mar 13, 2025',
      'comment':
          'Incredible vibes and even better cocktails. A bit crowded but that just adds to the fun. Highly recommend! 😍😍',
      'avatar': Colors.orange[100],
      'avatarIcon': Icons.person,
      'avatarIconColor': Colors.orange,
    },

    {
      'name': 'Emma Victoria Lewis',
      'date': 'Mar 13, 2025',
      'comment':
          'Incredible vibes and even better cocktails. A bit crowded but that just adds to the fun. Highly recommend! 😍😍',
      'avatar': Colors.orange[100],
      'avatarIcon': Icons.person,
      'avatarIconColor': Colors.orange,
    },
  ];

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> commentsToShow = showAllComments
        ? allComments
        : [allComments.first];

    int remainingComments = allComments.length - 1;

    return Scaffold(
      appBar: AppbarWidget(
        backgroundColor: AppColor.creamBackgroundColor,
        centerTitle: true,
        action: Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Icon(Icons.ios_share),
        ),
      ),
      backgroundColor: AppColor.creamBackgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with image
          Container(
            width: 390,
            height: 219,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                child: Image.asset(
                  AppImagePath.viewImage,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(Icons.image_not_supported, size: 50),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),


          // Title and location
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Portlligat - Cap de Creus',
                                style: TextStyle(
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF2D2D2D),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Image.asset(AppIconPath.yelloDownloadIcon),

                          // Route stats (distance, difficulty, type)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildStatChip('12.5 Km', Icons.route),
                              _buildStatChip('Medium', Icons.trending_up),
                              _buildStatChip(
                                'Hiking',
                                Icons.hiking,
                                isActive: true,
                              ),
                            ],
                          ),
                           SizedBox(height: 12.h),

                          Row(
                            children: [
                              Expanded(
                                child: ButtonWidget(
                                  backgroundColor: AppColor.backgroundColor,
                                  label: 'Follow Route',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  buttonHeight: 48,
                                  onPressed: () {
                                    Get.toNamed(AppRoutes.fullMapScreen);
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ButtonWidget(
                                  backgroundColor: Color.fromRGBO(
                                    245,
                                    233,
                                    223,
                                    1,
                                  ),
                                  label: 'Add Favorites',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  textColor: Colors.black,
                                  onPressed: () {},
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ButtonWidget(
                                  backgroundColor: Color.fromRGBO(
                                    245,
                                    233,
                                    223,
                                    1,
                                  ),
                                  label: 'Create Outing',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  textColor: Colors.black,
                                  onPressed: () {},
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),

                          // Rating and user info
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => ShowCustomDialog(
                                      backgroundColor:
                                      AppColor.creamBackgroundColor,
                                      title: '@naturanauta',
                                      titleStyle: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                      ),
                                      description:
                                      'I’m a nature lover and outdoor enthusiast',
                                      descriptionStyle: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      image: Image.asset(
                                        AppImagePath.profileImage,
                                      ),
                                      actionsLayout: ActionsLayout.column,
                                      actions: [
                                        Icon(
                                          Icons.thumb_up_outlined,
                                          size: 32,
                                        ),

                                        Padding(
                                          padding: const EdgeInsets.only(
                                            right: 20,
                                            left: 20,
                                          ),
                                          child: ButtonWidget(
                                            onPressed: (){
                                              Get.toNamed(AppRoutes.viewProfileScreen);
                                            },
                                            backgroundColor:
                                            AppColor.backgroundColor,
                                            label: 'View Profile',
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            buttonHeight: 40,
                                          ),
                                        ),

                                        Padding(
                                          padding: const EdgeInsets.only(
                                            right: 20,
                                            left: 20,
                                          ),
                                          child: ButtonWidget(
                                            backgroundColor:
                                            Colors.transparent,
                                            textColor: Colors.red,
                                            label: 'Report user',
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            buttonHeight: 40,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 12,
                                      backgroundColor: Colors.brown,
                                      child: const Icon(
                                        Icons.person,
                                        size: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Text('@naturanauta'),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  SizedBox(width: 30,),
                                  TextWidget(
                                    text: '4,8 (57)  (17 luggers / 6 planes)',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                  ),
                                ],
                              ),
                            ],
                          ),

                           SizedBox(height: 16.h),

                          // Description section
                          const Text(
                            'Description',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D2D2D),
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Escape the heat at the Azure Oasis. This stunning, crystal-clear pool is a tranquil paradise, surrounded by lush greenery. Its the perfect spot to relax, refresh, and immerse yourself in serene beauty.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              height: 1.5,
                            ),
                          ),

                          SizedBox(height: 16.h),

                          // Route Images section
                          Text(
                            'Route Images',
                            style: TextStyle(
                              color: const Color(0xFF2C2C2C),
                              fontSize: 16.sp,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                              height: 1.10,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(
                              4,
                              (index) => Container(
                                width: 84.w,
                                height: 84.h,
                                decoration: ShapeDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(AppImagePath.sunImage),
                                    fit: BoxFit.cover,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.r),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 16.h),

                          // Comments section
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Comments',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2D2D2D),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    showAllComments = !showAllComments;
                                  });
                                },
                                child: TextWidget(
                                  text: showAllComments
                                      ? 'Show less'
                                      : 'See more ($remainingComments)',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  fontColor: AppColor.backgroundColor,
                                  underline: true,
                                ),
                              ),
                            ],
                          ),


                          // Comments List
                          ...commentsToShow.map((comment) {
                            return Container(
                              margin: const EdgeInsets.only(bottom: 16,top: 10),
                              decoration: BoxDecoration(
                                color: AppColor.creamBackgroundColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 20,
                                        backgroundColor: comment['avatar'],
                                        child: Icon(
                                          comment['avatarIcon'],
                                          color: comment['avatarIconColor'],
                                          size: 20,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            comment['name'],
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                            ),
                                          ),
                                          Text(
                                            comment['date'],
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  TextWidget(
                                    text: comment['comment'],
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                    textAlignment: TextAlign.start,
                                  ),
                                ],
                              ),
                            );
                          }),

                          // Add comment section (only show when not showing all comments or at the end)
                          if (!showAllComments || showAllComments) ...[
                            TextFieldWidget(
                              borderColor: AppColor.lightGrayishOrange,
                              backgroundColor: AppColor.lightGrayishOrange,
                              borderRadius: 8,
                              hintText: 'Add a comment here....',
                            ),
                            const SizedBox(height: 16),

                            // Comment Button
                            Align(
                              alignment: Alignment.centerRight,
                              child: ButtonWidget(
                                backgroundColor: AppColor.backgroundColor,
                                label: 'Comment',
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                buttonHeight: 40,
                                buttonWidth: 100,
                                onPressed: () {
                                  // Handle comment submission
                                },
                              ),
                            ),
                            const SizedBox(height: 10),

                            // Update Status
                            Center(
                              child: TextWidget(
                                text: 'Update Status',
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                fontColor: AppColor.backgroundColor,
                                underline: true,
                              ),
                            ),
                          ],

                          const SizedBox(height: 20),
                        ],
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

  Widget _buildStatChip(String text, IconData icon, {bool isActive = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: ShapeDecoration(
        color: isActive ? const Color(0xFF2E4F3E) : Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 15.w,
            color: isActive ? Colors.white : const Color(0xFF2C2C2C),
          ),
          SizedBox(width: 6.w),
          Text(
            text,
            style: TextStyle(
              color: isActive
                  ? const Color(0xFFF1F1F1)
                  : const Color(0xFF2C2C2C),
              fontSize: 14.sp,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
              height: 1.10,
            ),
          ),
        ],
      ),
    );
  }
}
