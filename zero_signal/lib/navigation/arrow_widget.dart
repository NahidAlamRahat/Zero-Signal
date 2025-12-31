import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ArrowWidget extends StatelessWidget {
  final double angle;
  final String instruction;
  final double distance;

  const ArrowWidget({
    super.key,
    required this.angle,
    required this.instruction,
    required this.distance,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.85),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Navigation Arrow
          Transform.rotate(
            angle: angle * pi / 180,
            child: Icon(
              Icons.navigation,
              size: 44.sp,
              color: Colors.white,
            ),
          ),
          SizedBox(width: 20.w),
          // Instruction Text
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                instruction,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                distance < 1000
                    ? "${distance.round()} m"
                    : "${(distance / 1000).toStringAsFixed(1)} km",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
