import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../my_routes_screen/model/route_model.dart';
import 'widget/route_details_map_widget.dart';

class RouteDetailsScreen extends StatelessWidget {
  const RouteDetailsScreen({super.key});

  // Colors matching the design
  static const Color backgroundColor = Color(0xFFFFF4E9);
  static const Color primaryTextColor = Color(0xFF333333);
  static const Color secondaryTextColor = Color(0xFF666666);
  static const Color dividerColor = Color(0xFFE0E0E0);

  @override
  Widget build(BuildContext context) {
    // Get route data from arguments
    final RouteData? route = Get.arguments as RouteData?;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.h),
              // Map with route
              RouteDetailsMapWidget(
                startLat: route?.initalLat,
                startLng: route?.initalLng,
                endLat: route?.finalLat,
                endLng: route?.finalLng,
              ),
              SizedBox(height: 24.h),
              // Route Title
              _buildRouteTitle(route),
              SizedBox(height: 16.h),
              // Route Details Rows
              _buildDetailsSection(route),
              SizedBox(height: 24.h),
              // Description
              _buildDescriptionSection(route),
              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.chevron_left,
          color: primaryTextColor,
          size: 28.sp,
        ),
        onPressed: () => Get.back(),
      ),
      centerTitle: true,
      title: Text(
        'Mountain Trail Details',
        style: TextStyle(
          color: primaryTextColor,
          fontSize: 18.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildRouteTitle(RouteData? route) {
    return Text(
      route?.title ?? 'Whispering Pines Trail',
      style: TextStyle(
        fontSize: 22.sp,
        fontWeight: FontWeight.w600,
        color: primaryTextColor,
      ),
    );
  }

  Widget _buildDetailsSection(RouteData? route) {
    return Column(
      children: [
        _buildDetailRow(
          route?.title ?? 'Whispering Pines Trail',
          route?.difficulty ?? '1,200 ft',
        ),
        SizedBox(height: 8.h),
        _buildDetailRow(
          'Distance',
          route?.distance?.text ?? '5.2 miles',
        ),
        SizedBox(height: 8.h),
        _buildDetailRow(
          'Estimated Time',
          route?.duration?.text ?? '3 hours',
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            color: secondaryTextColor,
            fontWeight: FontWeight.w400,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
            color: primaryTextColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionSection(RouteData? route) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: primaryTextColor,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          route?.description ??
              'Escape the heat at the Azure Oasis. This stunning, crystal-clear pool is a tranquil paradise, surrounded by lush greenery. It\'s the perfect spot to relax, refresh, and immerse yourself in serene beauty.',
          style: TextStyle(
            fontSize: 14.sp,
            color: secondaryTextColor,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
