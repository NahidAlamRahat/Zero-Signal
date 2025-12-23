import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SportDetailsController extends GetxController {
  // Spot details data
  final RxString spotId = ''.obs;
  final RxString spotTitle = ''.obs;
  final RxString spotDescription = ''.obs;
  final RxString spotAddress = ''.obs;
  final RxDouble spotLatitude = 0.0.obs;
  final RxDouble spotLongitude = 0.0.obs;

  // Observable for showing all comments
  final RxBool showAllComments = false.obs;

  // Observable for selected image in gallery
  final RxString selectedImage = ''.obs;

  // List of images for the route
  final RxList<String> images = <String>[].obs;

  // Comments data
  final RxList<Map<String, dynamic>> comments = <Map<String, dynamic>>[
    {
      'name': '@naturanauta',
      'date': '12/10/2024',
      'comment': 'Amazing place! Highly recommend visiting during sunset.',
      'avatar': const Color(0xFF8B4513),
      'avatarIcon': Icons.person,
      'avatarIconColor': const Color(0xFFFFFFFF),
    },
    {
      'name': '@adventurerJohn',
      'date': '10/10/2024',
      'comment': 'Great spot for camping. The water is crystal clear!',
      'avatar': const Color(0xFF228B22),
      'avatarIcon': Icons.person,
      'avatarIconColor': const Color(0xFFFFFFFF),
    },
    {
      'name': '@wanderlustMary',
      'date': '08/10/2024',
      'comment': 'Beautiful scenery. Perfect for photography.',
      'avatar': const Color(0xFF4169E1),
      'avatarIcon': Icons.person,
      'avatarIconColor': const Color(0xFFFFFFFF),
    },
    {
      'name': '@hikingbob',
      'date': '05/10/2024',
      'comment': 'Nice trail, but bring plenty of water!',
      'avatar': const Color(0xFFFF6347),
      'avatarIcon': Icons.person,
      'avatarIconColor': const Color(0xFFFFFFFF),
    },
    {
      'name': '@explorerlisa',
      'date': '02/10/2024',
      'comment': 'The best place I have visited this year.',
      'avatar': const Color(0xFF9370DB),
      'avatarIcon': Icons.person,
      'avatarIconColor': const Color(0xFFFFFFFF),
    },
  ].obs;

  // Method to toggle comments visibility
  void toggleComments() {
    showAllComments.value = !showAllComments.value;
  }

  // Get displayed comments based on showAllComments flag
  List<Map<String, dynamic>> get displayedComments {
    if (showAllComments.value) {
      return comments;
    } else {
      return comments.take(2).toList();
    }
  }

  // Get remaining comments count
  int get remainingCommentsCount {
    return comments.length - 2;
  }

  // Method to select an image
  void selectImage(String imagePath) {
    selectedImage.value = imagePath;
  }

  @override
  void onInit() {
    super.onInit();
    // Get spot data from arguments
    final arguments = Get.arguments as Map<String, dynamic>?;
    if (arguments != null) {
      spotId.value = arguments['spotId'] ?? '';
      spotTitle.value = arguments['title'] ?? 'Unknown Spot';
      spotDescription.value = arguments['description'] ?? '';
      spotAddress.value = arguments['address'] ?? '';
      spotLatitude.value = arguments['latitude']?.toDouble() ?? 0.0;
      spotLongitude.value = arguments['longitude']?.toDouble() ?? 0.0;
    }
    // Initialize with sample images if needed
  }

  @override
  void onClose() {
    super.onClose();
  }
}
