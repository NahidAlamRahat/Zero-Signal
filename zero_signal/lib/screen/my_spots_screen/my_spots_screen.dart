import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../constant/app_colors.dart';
import '../../widget/appbar_widget/appbar_widget.dart';
import '../my_routes_screen/widget/delete_confirm_dialog.dart';
import '../my_routes_screen/widget/empty_state_widget.dart';
import 'widget/spot_card.dart';
import 'controller/my_spots_controller.dart';

class MySpotsScreen extends StatelessWidget {
  MySpotsScreen({super.key});

  final MySpotsController controller = Get.put(MySpotsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(
        text: 'My Spots',
        backgroundColor: AppColor.creamBackgroundColor,
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFFFFF4E9),
      body: SafeArea(
        child: GetBuilder<MySpotsController>(
          builder: (_) {
            // Show loading indicator
            if (controller.isLoading && controller.spots.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColor.backgroundColor,
                ),
              );
            }

            // Show error message if any
            if (controller.errorMessage.isNotEmpty &&
                controller.spots.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64.sp,
                      color: Colors.red,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      controller.errorMessage,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.red,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16.h),
                    ElevatedButton(
                      onPressed: () => controller.refreshSpots(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: [
                Expanded(
                  child: _buildSpotsList(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSpotsList() {
    if (controller.isEmpty) {
      return EmptyStateWidget(
        onAddSpot: () => controller.addNewSpot(),
      );
    }

    return RefreshIndicator(
      onRefresh: () => controller.refreshSpots(),
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        itemCount: controller.spots.length,
        itemBuilder: (context, index) {
          final spot = controller.spots[index];

          return SpotCard(
            spot: spot,
            onTap: () => controller.onSpotTap(spot),
            onFavoriteTap: () => controller.toggleFavorite(spot),
            onDeleteTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return DeleteConfirmDialog(
                    spot: spot,
                    onConfirm: () => controller.deleteSpot(spot),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
