import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../constant/app_colors.dart';
import '../../widget/appbar_widget/appbar_widget.dart';
import '../my_routes_screen/widget/delete_confirm_dialog.dart';
import '../my_routes_screen/widget/empty_state_widget.dart';
import '../my_routes_screen/widget/spot_card.dart';
import '../my_spots_screen/controller/my_spots_controller.dart';

class FavoriteRoutesScreen extends StatelessWidget {
  FavoriteRoutesScreen({super.key});

  final MySpotsController controller = Get.put(MySpotsController());

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (context, child) {
        return Scaffold(
          appBar: AppbarWidget(
            text: 'Favorite Routes',
            backgroundColor: AppColor.creamBackgroundColor,
            centerTitle: true,
          ),
          backgroundColor: const Color(0xFFFFF4E9),
          body: SafeArea(
            child: GetBuilder<MySpotsController>(
              builder: (_) {
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
      },
    );
  }

  Widget _buildSpotsList() {
    if (controller.isEmpty) {
      return EmptyStateWidget(
        onAddSpot: () => controller.addNewSpot(),
      );
    }

    return ListView.builder(
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
    );
  }
}