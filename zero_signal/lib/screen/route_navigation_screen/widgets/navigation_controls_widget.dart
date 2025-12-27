import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NavigationControlsWidget extends StatelessWidget {
  final bool isNavigating;
  final double coveredDistance;
  final double totalDistance;
  final int remainingTime;
  final int currentCoordinateIndex;
  final int totalCoordinates;
  final VoidCallback onReset;
  final VoidCallback onToggleNavigation;
  final VoidCallback onShowStats;

  const NavigationControlsWidget({
    super.key,
    required this.isNavigating,
    required this.coveredDistance,
    required this.totalDistance,
    required this.remainingTime,
    required this.currentCoordinateIndex,
    required this.totalCoordinates,
    required this.onReset,
    required this.onToggleNavigation,
    required this.onShowStats,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 8.w, 16.w, 16.w),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Distance and Time Info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Distance',
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    '${coveredDistance.toStringAsFixed(1)} / ${totalDistance.toStringAsFixed(1)} km',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2C2C2C),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Time Remaining',
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    '$remainingTime min',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2C2C2C),
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          SizedBox(height: 12.h),
          
          // Progress Bar
          LinearProgressIndicator(
            value: totalDistance > 0 ? coveredDistance / totalDistance : 0.0,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3A5A4D)),
          ),
          
          SizedBox(height: 12.h),
          
          // Waypoint Info
          if (totalCoordinates > 0)
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: Color(0xFF3A5A4D),
                    size: 18.w,
                  ),
                  SizedBox(width: 6.w),
                  Expanded(
                    child: Text(
                      'Waypoint ${currentCoordinateIndex + 1} of $totalCoordinates',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Color(0xFF2C2C2C),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          
          SizedBox(height: 12.h),
          
          // Control Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onReset,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Color(0xFF3A5A4D)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                  ),
                  child: Text(
                    'Reset',
                    style: TextStyle(
                      color: Color(0xFF3A5A4D),
                      fontWeight: FontWeight.w600,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              ),
              
              SizedBox(width: 8.w),
              
              Expanded(
                child: OutlinedButton(
                  onPressed: onShowStats,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.blue),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                  ),
                  child: Text(
                    'Stats',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w600,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              ),
              
              SizedBox(width: 8.w),
              
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: onToggleNavigation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isNavigating ? Colors.red : Color(0xFF3A5A4D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                  ),
                  child: Text(
                    isNavigating ? 'Pause' : 'Start Navigation',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
