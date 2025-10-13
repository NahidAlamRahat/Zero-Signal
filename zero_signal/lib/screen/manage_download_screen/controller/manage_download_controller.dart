import 'package:get/get.dart';

import '../../../gen/assets.gen.dart';

class ManageDownloadController extends GetxController {
  final List<DownloadedRoute> downloadedRoutes = [
    DownloadedRoute(
      title: 'Mountain Hike',
      description: 'Climb high. Seek peaks. Find yourself. Breathe deep.',
      icon: Assets.icons.routesImage.path,
    ),
    DownloadedRoute(
      title: 'Mountain Hike',
      description: 'Climb high. Seek peaks. Find yourself. Breathe deep.',
      icon: Assets.icons.routesImage.path,
    ),
    DownloadedRoute(
      title: 'Mountain Hike',
      description: 'Climb high. Seek peaks. Find yourself. Breathe deep.',
      icon: Assets.icons.routeMap.path,
    ),
  ];

  void deleteRoute(int index) {
    downloadedRoutes.removeAt(index);
    update();
  }
}

class DownloadedRoute {
  final String title;
  final String description;
  final String icon;

  DownloadedRoute({
    required this.title,
    required this.description,
    required this.icon,
  });
}