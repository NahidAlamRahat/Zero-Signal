import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zero_signal/constant/app_colors.dart';
import 'package:zero_signal/widget/appbar_widget/appbar_widget.dart';
import 'package:zero_signal/widget/space_widget.dart';
import 'package:zero_signal/widget/text_widget/text_widgets.dart';
import 'package:zero_signal/gen/assets.gen.dart';

import 'controller/manage_download_controller.dart';

class ManageDownloadScreen extends StatelessWidget {
  const ManageDownloadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ManageDownloadController>(
      init: ManageDownloadController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColor.creamBackgroundColor,
          appBar: AppbarWidget(
            centerTitle: true,
            backgroundColor: AppColor.lightGrayishOrange,
            text: 'Manage Download',
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(
                  text: 'Downloaded Routes',
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
                SpaceWidget(spaceHeight: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: controller.downloadedRoutes.length,
                    itemBuilder: (context, index) {
                      final route = controller.downloadedRoutes[index];
                      return _buildRouteItem(context, route, index, controller);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRouteItem(
      BuildContext context,
      DownloadedRoute route,
      int index,
      ManageDownloadController controller,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Route header with icon and title
        Row(
          children: [
            Image.asset(
              _getIconPath(route.icon),
              height: 24,
              width: 24,
            ),
            SpaceWidget(spaceWidth: 8),
            TextWidget(text: route.title),
          ],
        ),
        // Route description and delete button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: TextWidget(
                text: route.description,
                fontWeight: FontWeight.w400,
                fontSize: 10,
                fontColor: const Color(0xFF565656),
              ),
            ),
            GestureDetector(
              onTap: () => controller.deleteRoute(index),
              child: Image.asset(
                Assets.icons.deleteAccountImage.path,
                height: 16,
                width: 16,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        const Divider(),
        SpaceWidget(spaceHeight: 16),
      ],
    );
  }

  String _getIconPath(String iconType) {
    switch (iconType) {
      case 'routes_image':
        return Assets.icons.routesImage.path;
      case 'route_map':
        return Assets.icons.routeMap.path;
      default:
        return Assets.icons.routesImage.path;
    }
  }
}