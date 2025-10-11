import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../favorite_sites_screen/favorite_sites_screen.dart';
import '../../gen/assets.gen.dart';

class MySpotsController extends GetxController {
  final List<SpotItem> spots = [
    SpotItem(
      id: '1',
      name: 'Sunset Point',
      uploadDate: '2025-08-15',
      imageUrl: Assets.images.sunImage.path,
    ),
    SpotItem(
      id: '2',
      name: 'Mountain Trailhead',
      uploadDate: '2025-08-15',
      imageUrl: Assets.images.image1.path,
    ),
    SpotItem(
      id: '3',
      name: 'Beach Cove',
      uploadDate: '2025-08-15',
      imageUrl: Assets.images.image2.path,
    ),
    SpotItem(
      id: '4',
      name: 'Forest Clearing',
      uploadDate: '2025-08-15',
      imageUrl: Assets.images.image3.path,
    ),
    SpotItem(
      id: '5',
      name: 'River Bend',
      uploadDate: '2025-08-15',
      imageUrl: Assets.images.image4.path,
    ),
  ];

  void onSpotTap(SpotItem spot) {
    print('Tapped on spot: ${spot.name}');
    Get.snackbar(
      'Spot',
      'Opening ${spot.name}',
      backgroundColor: const Color(0xFF2E4F3E),
      colorText: Colors.white,
    );
  }

  void toggleFavorite(SpotItem spot) {
    spot.isFavorite = !spot.isFavorite;
    update();

    Get.snackbar(
      'Favorite',
      spot.isFavorite
          ? '${spot.name} added to favorites'
          : '${spot.name} removed from favorites',
      backgroundColor: const Color(0xFF2E4F3E),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  void deleteSpot(SpotItem spot) {
    spots.removeWhere((s) => s.id == spot.id);
    update();

    Get.snackbar(
      'Deleted',
      '${spot.name} deleted',
      backgroundColor: const Color(0xFF2E4F3E),
      colorText: Colors.white,
    );
  }

  void addNewSpot() {
    print('Add new spot tapped');
    Get.snackbar(
      'Info',
      'Add new spot feature coming soon!',
      backgroundColor: const Color(0xFF2E4F3E),
      colorText: Colors.white,
    );
  }

  String formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  bool get isEmpty => spots.isEmpty;
}