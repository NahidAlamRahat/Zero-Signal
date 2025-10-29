import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../constant/app_colors.dart';
import '../../../constant/app_icon_path.dart';
import '../../../gen/assets.gen.dart';
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
      case 1: // Joined Activities
        return [
          Expanded(
            child: Container(
              height: 40.h,
              decoration: BoxDecoration(
                color: AppColor.red50,
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Text(
                "Leave",
                style: TextStyle(
                  color: AppColor.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Container(
              height: 40.h,
              decoration: BoxDecoration(
                color: AppColor.backgroundColor,
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    AppIconPath.chatIcon,
                    height: 16.h,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    "Chat",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ];
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
                Text(
                  "Chat",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ];
      case 3: // Saved
        return [Text('18 Aug 2023')];
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
        clipBehavior: Clip.antiAlias,
        margin: const EdgeInsets.only(bottom: 16),
        decoration: ShapeDecoration(
          color:  Colors.green,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          shadows: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Activity Image
            Positioned(
              bottom: 12,
              left: 12,
              top: 12,
              child: Container(
                width: 116.w,
                height: 116.w,
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  image: DecorationImage(
                    image: AssetImage(activity.imagePath),
                    fit: BoxFit.cover,
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
            
            // Content Section
            Positioned(
              left: 140,
              top: 12,
              right: 12, // Add right constraint so it adapts to available width
              child: Container(
                height: 116,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and Category section
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        SizedBox(
                          width: 200.w, // Use a reasonable fixed width instead of infinity
                          child: Text(
                            activity.title,
                            style: TextStyle(
                              color: const Color(0xFF2C2C2C),
                              fontSize: 20,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              height: 1.10,
                            ),
                          ),
                        ),
                        
                        // Category with circle
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 12.w,
                              height: 12.h,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(Assets.icons.location.path),
                                  fit: BoxFit.cover,
                                ),
                                shape: BoxShape.circle,
                              ),
                            ),
                             SizedBox(width: 6.w),
                            Flexible(
                              child: Text(
                                activity.category,
                                style: TextStyle(
                                  color: const Color(0xFF727272),
                                  fontSize: 12.sp,
                                  fontFamily: 'Open Sans',
                                  fontWeight: FontWeight.w400,
                                  height: 1.10.h,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    
                     SizedBox(height: 8.h),
                    
                    // Location
                    Flexible(
                      child: Text(
                        activity.location,
                        style: TextStyle(
                          color: const Color(0xFF2C2C2C),
                          fontSize: 12.sp,
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.w400,
                          height: 1.10,
                        ),
                      ),
                    ),
                    
                    const Spacer(),
                    
                    // View Button
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        margin: EdgeInsets.only(right: 12.w,bottom: 12.h), // Add margin to ensure it's visible
                        child: InkWell(
                          onTap: () {
                            // Add your action here
                            print('View button tapped');
                          },
                          child: Container(
                            width: 72.w,
                            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                            decoration: ShapeDecoration(
                              color: const Color(0xFF2E4F3E),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'View',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: const Color(0xFFF1F1F1),
                                    fontSize: 14.sp,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                    height: 1.10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
    
    // For other tabs, use the original design
    Axis buttonLayout = tabIndex == 2 ? Axis.vertical : Axis.horizontal;
    Alignment buttonAlign = tabIndex == 3 ? Alignment.bottomLeft : Alignment.centerRight;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColor.lightGrayishOrange,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Activity Image
            Container(
              width: 116.w,
              height: 116.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: AssetImage(activity.imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            SizedBox(width: 16.w),

            // ✅ Activity Details + Buttons
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Container(
                        width: 8.w,
                        height: 8.h,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        activity.category,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    activity.location,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),

                  SizedBox(height: 8.h),

                  // ✅ Buttons section with dynamic handling based on tabIndex
                  if (cardButtons.isNotEmpty)
                    Align(
                      alignment: buttonAlign, // Using the dynamic alignment based on tabIndex
                      child: buttonLayout == Axis.horizontal
                          ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: cardButtons
                            .map((btn) => Padding(
                          padding: EdgeInsets.only(left: 8.w),
                          child: btn,
                        ))
                            .toList(),
                      )
                          : Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: buttonAlign == Alignment.centerRight
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: cardButtons
                            .map((btn) => Padding(
                          padding: EdgeInsets.only(top: 8.h),
                          child: btn,
                        ))
                            .toList(),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
