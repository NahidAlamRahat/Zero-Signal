import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import '../../../constant/app_icon_path.dart';
import '../../my_spots_screen/model/spot_item.dart';

class MyRoutesController extends GetxController {
  final List<SpotItem> spots = [
    SpotItem(
      id: '1',
      name: 'Sunset Point',
      uploadDate: '2025-08-15',
      imageUrl: AppIconPath.ukFlag,
    ),
    SpotItem(
      id: '2',
      name: 'Mountain Trailhead',
      uploadDate: '2025-08-15',
      imageUrl: AppIconPath.ukFlag,
    ),
    SpotItem(
      id: '3',
      name: 'Beach Cove',
      uploadDate: '2025-08-15',
      imageUrl: AppIconPath.ukFlag,
    ),
    SpotItem(
      id: '4',
      name: 'Forest Clearing',
      uploadDate: '2025-08-15',
      imageUrl: AppIconPath.ukFlag,
    ),
    SpotItem(
      id: '5',
      name: 'River Bend',
      uploadDate: '2025-08-15',
      imageUrl: AppIconPath.ukFlag,
    ),
  ];

  void onSpotTap(SpotItem spot) {
    print('Tapped on spot: ${spot.name}');
    Fluttertoast.showToast(
      msg: 'Opening ${spot.name}',
      backgroundColor: const Color(0xFF2E4F3E),
      textColor: Colors.white,
    );
  }

  void toggleFavorite(SpotItem spot) {
    spot.isFavorite = !spot.isFavorite;
    update();

    Fluttertoast.showToast(
      msg: spot.isFavorite
          ? '${spot.name} added to favorites'
          : '${spot.name} removed from favorites',
      backgroundColor: const Color(0xFF2E4F3E),
      textColor: Colors.white,
      toastLength: Toast.LENGTH_SHORT,
    );
  }

  void deleteSpot(SpotItem spot) {
    spots.removeWhere((s) => s.id == spot.id);
    update();

    Fluttertoast.showToast(
      msg: '${spot.name} deleted',
      backgroundColor: const Color(0xFF2E4F3E),
      textColor: Colors.white,
    );
  }

  void addNewSpot() {
    print('Add new spot tapped');
    Fluttertoast.showToast(
      msg: 'Add new spot feature coming soon!',
      backgroundColor: const Color(0xFF2E4F3E),
      textColor: Colors.white,
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
