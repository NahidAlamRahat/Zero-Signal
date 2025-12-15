import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../constant/app_icon_path.dart';
import '../../my_spots_screen/model/spot_item.dart';

class FavoriteSitesController extends GetxController {
  final RxList<SpotItem> spots = RxList<SpotItem>([
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
  ]);

  RxBool isLoading = false.obs;

  void toggleFavorite(SpotItem spot) {
    final index = spots.indexWhere((s) => s.id == spot.id);
    if (index != -1) {
      spots[index] =
          spots[index].copyWith(isFavorite: !spots[index].isFavorite);

      Fluttertoast.showToast(
        msg: spots[index].isFavorite
            ? '${spot.name} added to favorites'
            : '${spot.name} removed from favorites',
        backgroundColor: const Color(0xFF2E4F3E),
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
      );
    }
  }

  void deleteSpot(SpotItem spot) {
    spots.removeWhere((s) => s.id == spot.id);
    Fluttertoast.showToast(
      msg: '${spot.name} deleted',
      backgroundColor: const Color(0xFF2E4F3E),
      textColor: Colors.white,
    );
  }

  void addNewSpot() {
    Fluttertoast.showToast(
      msg: 'Add new spot feature coming soon!',
      backgroundColor: const Color(0xFF2E4F3E),
      textColor: Colors.white,
    );
  }

  void onSpotTap(SpotItem spot) {
    Fluttertoast.showToast(
      msg: 'Opening ${spot.name}',
      backgroundColor: const Color(0xFF2E4F3E),
      textColor: Colors.white,
    );
  }

  void showDeleteDialog(SpotItem spot) {
    Get.defaultDialog(
      title: 'Delete Spot',
      content: Text('Are you sure you want to delete "${spot.name}"?'),
      textCancel: 'Cancel',
      textConfirm: 'Delete',
      onCancel: () => Get.back(),
      onConfirm: () {
        deleteSpot(spot);
        Get.back();
      },
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
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
}
