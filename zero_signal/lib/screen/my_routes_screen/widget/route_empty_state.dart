import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constant/app_colors.dart';
import '../../../widget/text_widget/text_widgets.dart';

class RouteEmptyState extends StatelessWidget {
  final VoidCallback onAddRoute;

  const RouteEmptyState({Key? key, required this.onAddRoute}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_on_outlined,
              size: 64.sp,
              color: const Color(0xFF999999),
            ),
            SizedBox(height: 16.h),
            TextWidget(
              text: 'No routes yet',
              fontColor: AppColor.textColor,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
            SizedBox(height: 8.h),
            TextWidget(
              text: 'Start exploring and add your favorite routes',
              textAlignment: TextAlign.center,
              fontColor: AppColor.subTitleColor,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: onAddRoute,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E4F3E),
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: TextWidget(
                text: 'Add Your First Route',
                fontColor: AppColor.white500,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                textAlignment: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
