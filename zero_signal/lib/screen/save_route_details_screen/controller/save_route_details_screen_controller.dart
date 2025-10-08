import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../gen/assets.gen.dart';

class RouteDetailsController extends GetxController {
  // Selected image for dialog
  var selectedImage = ''.obs;

  // Images list - Test er jonno static images (pore API theke asbe)
  var images = <String>[
    Assets.images.image1.path,
    Assets.images.image2.path,
    Assets.images.image3.path,
    Assets.images.image4.path,
    Assets.images.sunImage.path,
  ].obs;

  // Comments data
  var showAllComments = false.obs;

  var allComments = <Map<String, dynamic>>[
    {
      'name': 'Charolette Hanlin',
      'date': 'Feb 3, 2025',
      'comment': 'Chill atmosphere, friendly crowd. Exactly the relaxed spot we were looking for on a Friday night. Loved it. 😍😍',
      'avatar': Colors.blue[100],
      'avatarIcon': Icons.person,
      'avatarIconColor': Colors.blue,
    },
    {
      'name': 'Olivia Gabriella Hernandez',
      'date': 'Apr 21, 2025',
      'comment': 'Good music, but the service was slow. Maybe an off night? The overall vibe was still positive though. 😊😊',
      'avatar': Colors.green[100],
      'avatarIcon': Icons.person,
      'avatarIconColor': Colors.green,
    },
    {
      'name': 'Emma Victoria Lewis',
      'date': 'Mar 13, 2025',
      'comment': 'Incredible vibes and even better cocktails. A bit crowded but that just adds to the fun. Highly recommend! 😍😍',
      'avatar': Colors.orange[100],
      'avatarIcon': Icons.person,
      'avatarIconColor': Colors.orange,
    },
    {
      'name': 'Emma Victoria Lewis',
      'date': 'Mar 13, 2025',
      'comment': 'Incredible vibes and even better cocktails. A bit crowded but that just adds to the fun. Highly recommend! 😍😍',
      'avatar': Colors.orange[100],
      'avatarIcon': Icons.person,
      'avatarIconColor': Colors.orange,
    },
  ].obs;

  // Methods
  void selectImage(String img) {
    selectedImage.value = img;
  }

  void toggleComments() {
    showAllComments.value = !showAllComments.value;
  }

  List<Map<String, dynamic>> get displayedComments {
    return showAllComments.value ? allComments : [allComments.first];
  }

  int get remainingCommentsCount => allComments.length - 1;

  @override
  void onInit() {
    super.onInit();
    // First image selected by default
    if (images.isNotEmpty) {
      selectedImage.value = images.first;
    }
    // TODO: Pore API call korben
    // fetchRouteImages();
  }

  // API call - Future e use korben
  void fetchRouteImages() async {
    try {
      // Example API call
      // var response = await apiService.getRouteImages(routeId);
      // images.value = response.data.map((item) => item.imageUrl).toList();
      // if (images.isNotEmpty) {
      //   selectedImage.value = images.first;
      // }

      print('Images loaded: ${images.length}');
    } catch (e) {
      print('Error loading images: $e');
    }
  }
}