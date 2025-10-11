import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmptyStateWidget extends StatelessWidget {
  final VoidCallback onAddSpot;

  const EmptyStateWidget({Key? key, required this.onAddSpot})
      : super(key: key);

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
            Text(
              'No spots yet',
              style: TextStyle(
                color: const Color(0xFF2C2C2C),
                fontSize: 20.sp,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Start exploring and add your favorite spots',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFF565656),
                fontSize: 14.sp,
                fontFamily: 'Open Sans',
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: onAddSpot,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E4F3E),
                padding:
                EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                'Add Your First Spot',
                style: TextStyle(
                  color: const Color(0xFFF1F1F1),
                  fontSize: 14.sp,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}