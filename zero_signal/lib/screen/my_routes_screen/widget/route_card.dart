import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../constant/api_end_point.dart';
import '../model/route_model.dart';
import 'route_actions.dart';
import 'route_image.dart';
import 'route_info.dart';

class RouteCard extends StatelessWidget {
  final RouteData route;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;
  final VoidCallback onDeleteTap;

  const RouteCard({
    Key? key,
    required this.route,
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
              RouteImage(imageUrl: _getFullImageUrl(route.getFirstImageUrl())),
              SizedBox(width: 12.w),
              RouteInfo(
                name: route.title ?? "Unknown Route",
                uploadDate: _formatDate(route.createdAt),
              ),
              RouteActions(
                route: route,
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
    if (imagePath.isEmpty) return "";
    if (imagePath.startsWith('http')) {
      return imagePath;
    }
    return '${AppApiEndPoint.domain}$imagePath';
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return "";
    try {
      // Simple parsing, assuming ISO string.
      // You might want to use intl package if available and required for complex formatting.
      // For now, returning YYYY-MM-DD portion.
      return dateString.split("T")[0];
    } catch (e) {
      return dateString;
    }
  }
}
