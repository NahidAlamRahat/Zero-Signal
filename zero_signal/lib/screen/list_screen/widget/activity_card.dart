import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zero_signal/constant/app_strings.dart';
import 'package:zero_signal/widget/text_widget/text_widgets.dart';
import '../../../constant/app_colors.dart';
import '../../../constant/app_icon_path.dart';
import '../../../gen/assets.gen.dart';
import '../../../routes/app_routes.dart';
import '../list_screen.dart';

class ActivityCard extends StatelessWidget {
  final ActivityItem activity;
  final List<Widget>? buttons;
  final Axis buttonsDirection; // Row or Column
  final Alignment buttonsAlignment; // Left or Right
  final int tabIndex; // Add tab index to handle different designs


  const ActivityCard({
    super.key,
    required this.activity,
    this.buttons,
    this.buttonsDirection = Axis.horizontal, // Default: horizontal
    this.buttonsAlignment = Alignment.centerRight, // Default: Right
    required this.tabIndex, // This will determine which design to show
  });

  // Method to get buttons based on tabIndex
  List<Widget> _getButtonsForTabIndex() {
    // You can customize the buttons based on the tabIndex
    switch (tabIndex) {
      case 0: // Near Activities
        // For Near Activities, we use a completely different design with a Stack
        // So we return an empty list here
        return [];


      case 2: // Created Activities
        return [
          Image.asset(
            AppIconPath.editIcon,
            height: 20.h,
          ),
          SizedBox(width: 8.w),
          Container(
            height: 40.h,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              color: AppColor.backgroundColor,
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  AppIconPath.chatIcon,
                  height: 16.h,
                  color: Colors.white,
                ),
                SizedBox(width: 6.w),
                TextWidget(
                 text:  "Chat",
                  fontColor: AppColor.white500,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
          ),
        ];
      case 3: // Saved
        return [TextWidget(text: '18 Aug 2023',
        fontColor: AppColor.darkGray500,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        )];
      default:
        return buttons ?? [];
    }
  }

  @override
  Widget build(BuildContext context) {
    // Generate buttons based on tabIndex
    List<Widget> cardButtons = _getButtonsForTabIndex();

    // For Near Activities tab, use the Figma design
    if (tabIndex == 0) { // Near Activities
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
            // Activity Image
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

            // Content Section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  TextWidget(
                  text:   activity.title,
                    // style: TextStyle(
                    //   color: const Color(0xFF2C2C2C),
                    //   fontSize: 20.sp,
                    //   fontFamily: 'Poppins',
                    //   fontWeight: FontWeight.w500,
                    //   height: 1.10,
                    // ),
                    fontColor: AppColor.textColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),

                  // Category with icon
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
                         text:  activity.category,
                          // style: TextStyle(
                          //   color: const Color(0xFF727272),
                          //   fontSize: 12.sp,
                          //   fontFamily: 'Open Sans',
                          //   fontWeight: FontWeight.w400,
                          textAlignment: TextAlign.start,
                          // ),
                          fontColor: AppColor.darkGay300,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 8.h),

                  // Location
                  TextWidget(
                  text:   activity.location,

                    fontColor: AppColor.textColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),

                  const Spacer(),

                  // View Button
                  Align(
                    alignment: Alignment.bottomRight,
                    child: InkWell(
                      onTap: () {
                        Get.toNamed(AppRoutes.listViewDetailsScreen);
                        print('View button tapped');
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
                         text:  'View',
                          // style: TextStyle(
                          //   color: const Color(0xFFF1F1F1),
                          //   fontSize: 14.sp,
                          //   fontFamily: 'Poppins',
                          //   fontWeight: FontWeight.w400,
                          // ),
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





    if (tabIndex == 1) { // Near Activities
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
            // Activity Image
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

            // Content Section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    activity.title,
                    style: TextStyle(
                      color: const Color(0xFF2C2C2C),
                      fontSize: 20.sp,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      height: 1.10,
                    ),
                  ),

                  // Category with icon
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
                        child: Text(
                          activity.category,
                          style: TextStyle(
                            color: const Color(0xFF727272),
                            fontSize: 12.sp,
                            fontFamily: 'Open Sans',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 8.h),

                  // Location
                  Text(
                    activity.location,
                    style: TextStyle(
                      color: const Color(0xFF2C2C2C),
                      fontSize: 12.sp,
                      fontFamily: 'Open Sans',
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  const Spacer(),

                  // View Buttons
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Get.toNamed(AppRoutes.listViewDetailsScreen);
                            print('Left button tapped');
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 8.h,
                            ),
                            decoration: ShapeDecoration(
                              color: const Color(0x26FB6057),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: TextWidget(
                             text:  'Left',
                              textAlignment: TextAlign.center,
                              // style: TextStyle(
                              //   color: const Color(0xFFFB6057),
                              //   fontSize: 16.sp,
                              //   fontFamily: 'Poppins',
                              //   fontWeight: FontWeight.w500,
                              //   height: 1.10,
                              // ),
                              fontColor: AppColor.red,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Get.toNamed(AppRoutes.chatScreen);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 8.h,
                            ),
                            decoration: ShapeDecoration(
                              color: AppColor.backgroundColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [

                                Image.asset(

                                    height: 20.h,
                                    width: 20.w,
                                    AppIconPath.chatIcon),

                                SizedBox(
                                  width: 4.w,
                                ),
                                TextWidget(
                                text:   "Chat",
                                  textAlignment: TextAlign.center,

                                  fontColor: AppColor.white500,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
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
          ],
        ),
      );
    }

    if (tabIndex == 2) { // Near Activities
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
            // Activity Image
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

            //Content Section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  TextWidget(
                   text:  activity.title,
                    // style: TextStyle(
                    //   color: const Color(0xFF2C2C2C),
                    //   fontSize: 20.sp,
                    //   fontFamily: 'Poppins',
                    //   fontWeight: FontWeight.w500,
                    //   height: 1.10,
                    // ),
                    fontColor: AppColor.darkGray500,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),

                  // Category with icon
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
                        text:   activity.category,
                          // style: TextStyle(
                          //   color: const Color(0xFF727272),
                          //   fontSize: 12.sp,
                          //   fontFamily: 'Open Sans',
                          //   fontWeight: FontWeight.w400,
                          // ),
                          fontColor: AppColor.darkGray500,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),







                  // View Buttons
                  Align(
                    alignment: Alignment.centerRight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,

                      children: [

                        Image.asset(
                            height: 20.h,
                            width: 20.w,
                            AppIconPath.editIcon),

                        SizedBox(
                          height:   12.h,
                        ),

                        InkWell(
                            onTap: (){
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
                                    height: 20.h,
                                    width: 20.w,
                                    AppIconPath.chatIcon),
                                SizedBox(
                                  width: 4.w,                           ),
                                TextWidget(text: "Chat",fontColor: AppColor.white500,fontSize: 14,fontWeight: FontWeight.w400,),
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







    return
      Container(
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
          // Activity Image
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

          // Content Section
          Expanded(
            child: Container(
              height: 116.h,
              child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
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

                   // Category with icon
                   Align(
                     alignment: Alignment.topLeft,
                     child: TextWidget(

                       textAlignment: TextAlign.start,
                       maxLines: 2,

                      overflow: TextOverflow.ellipsis,
                      text: "Join me on a hike to a stunning water...",
                       fontColor: AppColor.subTitleColor,
                       fontSize: 16,
                       fontWeight: FontWeight.w400,
                     ),
                   ),
                 ],
               ),




                // Date at bottom
                TextWidget(
                 text:  '18 Aug 2023',
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
