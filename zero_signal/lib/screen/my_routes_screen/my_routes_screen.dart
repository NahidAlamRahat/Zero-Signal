import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zero_signal/constant/app_strings.dart';
import '../../constant/app_colors.dart';
import '../../widget/appbar_widget/appbar_widget.dart';
import 'controller/my_routes_controller.dart';
import 'widget/route_card.dart';
import 'widget/route_delete_dialog.dart';
import 'widget/route_empty_state.dart';

class MyRoutesScreen extends StatelessWidget {
  MyRoutesScreen({super.key});

  final MyRoutesController controller = Get.put(MyRoutesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(
        text: controller.isFavoriteMode ? 'Favorite Routes' : 'My Routes',
        backgroundColor: AppColor.creamBackgroundColor,
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFFFFF4E9),
      body: SafeArea(
        child: GetBuilder<MyRoutesController>(
          builder: (_) {
            // Show loading indicator
            if (controller.isLoading && controller.routes.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColor.backgroundColor,
                ),
              );
            }

            // Show error message if any
            if (controller.errorMessage.isNotEmpty &&
                controller.routes.isEmpty) {
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
                      onPressed: () => controller.refreshRoutes(),
                      child: Text(AppStrings.retry),
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: [
                Expanded(
                  child: _buildRoutesList(context),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildRoutesList(BuildContext context) {
    if (controller.isEmpty) {
      return RouteEmptyState(
        onAddRoute: () => controller.addNewSpot(),
      );
    }

    return RefreshIndicator(
      onRefresh: () => controller.refreshRoutes(),
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        itemCount: controller.routes.length,
        itemBuilder: (context, index) {
          final route = controller.routes[index];
          return RouteCard(
            route: route,
            onTap: () => controller.onRouteTap(route),
            onFavoriteTap: () => controller.toggleFavorite(route),
            onDeleteTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return RouteDeleteDialog(
                    route: route,
                    onConfirm: () => controller.deleteRoute(route),
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
