import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../constant/api_end_point.dart';
import '../../my_routes_screen/widget/spot_actions.dart';
import '../../my_routes_screen/widget/spot_image.dart';
import '../../my_routes_screen/widget/spot_info.dart';
import '../model/my_spots_response_model.dart';

class SpotCard extends StatelessWidget {
  final SpotData spot;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;
  final VoidCallback onDeleteTap;

  const SpotCard({
    Key? key,
    required this.spot,
    required this.onTap,
    required this.onFavoriteTap,
    required this.onDeleteTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      height: 72.h,
      decoration: BoxDecoration(
        color: const Color(0xFFF5E9DF),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.r),
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Row(
            children: [
              SpotImage(imageUrl: _getFullImageUrl(spot.getFirstImageUrl())),
              SizedBox(width: 12.w),
              SpotInfo(
                name: spot.title,
                uploadDate: spot.createdAt,
              ),
              SpotActions(
                spot: spot,
                onFavoriteTap: onFavoriteTap,
                onDeleteTap: onDeleteTap,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Get full image URL with domain prepended
  String _getFullImageUrl(String imagePath) {
    if (imagePath.isEmpty || imagePath.startsWith('http')) {
      return imagePath;
    }
    return '${AppApiEndPoint.domain}$imagePath';
  }
}
