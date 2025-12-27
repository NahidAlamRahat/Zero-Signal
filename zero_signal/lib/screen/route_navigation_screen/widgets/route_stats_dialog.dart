import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class RouteStatsDialog extends StatelessWidget {
  final String movementTime;
  final String distance;
  final String totalTime;
  final String pace;
  final String remaining;
  final String speed;
  final List<double> elevationData;
  final VoidCallback? onResume;
  final VoidCallback? onFinish;

  const RouteStatsDialog({
    super.key,
    required this.movementTime,
    required this.distance,
    required this.totalTime,
    required this.pace,
    required this.remaining,
    required this.speed,
    required this.elevationData,
    this.onResume,
    this.onFinish,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F1EA),
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Close button
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () => Get.back(),
                child: Icon(
                  Icons.close,
                  size: 24.w,
                  color: const Color(0xFF2C2C2C),
                ),
              ),
            ),
            
            SizedBox(height: 16.h),
            
            // Stats Grid - Top Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  value: movementTime,
                  label: 'Movement Time',
                ),
                _buildStatItem(
                  value: distance,
                  label: 'Distance',
                  unit: 'km',
                ),
                _buildStatItem(
                  value: totalTime,
                  label: 'Total Time',
                  unit: 'min',
                ),
              ],
            ),
            
            SizedBox(height: 24.h),
            
            // Stats Grid - Bottom Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  value: pace,
                  label: 'min/km',
                  unit: '/km',
                ),
                _buildStatItem(
                  value: remaining,
                  label: 'Remaining',
                  unit: 'km',
                ),
                _buildStatItem(
                  value: speed,
                  label: 'Speed',
                  unit: 'km/h',
                ),
              ],
            ),
            
            SizedBox(height: 32.h),
            
            // Elevation Chart
            _buildElevationChart(),
            
            SizedBox(height: 32.h),
            
            // Action Buttons
            Row(
              children: [
                // Reanudar Button (Resume)
                Expanded(
                  child: OutlinedButton(
                    onPressed: onResume,
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(
                        color: Color(0xFFE0E0E0),
                        width: 1,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                    ),
                    child: Text(
                      'Reanudar',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF2C2C2C),
                        letterSpacing: -0.2,
                      ),
                    ),
                  ),
                ),
                
                SizedBox(width: 12.w),
                
                // Finalizar Button (Finish)
                Expanded(
                  child: ElevatedButton(
                    onPressed: onFinish,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3A5A4D),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                    ),
                    child: Text(
                      'Finalizar',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 16.h),
            
            // Bottom Indicator
            Container(
              width: 120.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: const Color(0xFF2C2C2C),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required String value,
    required String label,
    String? unit,
  }) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF2C2C2C),
                height: 1,
              ),
            ),
            if (unit != null)
              Padding(
                padding: EdgeInsets.only(left: 2.w, bottom: 2.h),
                child: Text(
                  unit,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF2C2C2C),
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF999999),
            letterSpacing: -0.1,
          ),
        ),
      ],
    );
  }

  Widget _buildElevationChart() {
    return Column(
      children: [
        // Chart area
        SizedBox(
          height: 120.h,
          child: Stack(
            children: [
              // Elevation line
              CustomPaint(
                size: Size(double.infinity, 120.h),
                painter: ElevationChartPainter(elevationData),
              ),
              
              // Elevation labels on right
              Positioned(
                right: 0,
                top: 0,
                child: Text(
                  '620 m',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF999999),
                  ),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Text(
                  '310 m',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF999999),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        SizedBox(height: 8.h),
        
        // Distance markers
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Km',
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF999999),
              ),
            ),
            Text(
              '10.5 km',
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF999999),
              ),
            ),
            Text(
              '15.75 km',
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF999999),
              ),
            ),
            Text(
              '21 km',
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF999999),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// Custom painter for elevation chart
class ElevationChartPainter extends CustomPainter {
  final List<double> data;

  ElevationChartPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF2C2C2C)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final circlePaint = Paint()
      ..color = const Color(0xFF7D9B8E)
      ..style = PaintingStyle.fill;

    if (data.isEmpty) return;

    final path = Path();
    final points = <Offset>[];

    // Calculate points
    for (int i = 0; i < data.length; i++) {
      final x = (size.width - 60) * (i / (data.length - 1));
      final normalizedValue = (data[i] - data.reduce((a, b) => a < b ? a : b)) /
          (data.reduce((a, b) => a > b ? a : b) - data.reduce((a, b) => a < b ? a : b));
      final y = size.height - (normalizedValue * size.height * 0.8) - size.height * 0.1;
      points.add(Offset(x, y));
    }

    // Draw path
    path.moveTo(points.first.dx, points.first.dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    canvas.drawPath(path, paint);

    // Draw dot at approximately 1/3 position
    final dotIndex = (points.length * 0.3).round();
    if (dotIndex < points.length) {
      canvas.drawCircle(points[dotIndex], 6, circlePaint);
      canvas.drawCircle(
        points[dotIndex],
        6,
        Paint()
          ..color = Colors.white
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
