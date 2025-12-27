import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import '../../../constant/api_end_point.dart';
import '../../../repository/common_repository/common_repository.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/app_log/app_log.dart';
import '../model/my_spots_response_model.dart';

class MySpotsController extends GetxController {
  final CommonRepository _repository = CommonRepository();

  List<SpotData> spots = [];
  bool isLoading = false;
  String errorMessage = '';

  int currentPage = 1;
  int totalPages = 1;
  int totalSpots = 0;

  bool isFavoriteMode = false;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      if (Get.arguments is List) {
        final list = Get.arguments as List;
        spots = list.map((e) => SpotData.fromJson(e)).toList();
        isLoading = false;
        appLog('Loaded ${spots.length} spots from arguments');
        return;
      } else if (Get.arguments is Map) {
        isFavoriteMode = Get.arguments['type'] == 'favorite';
      }
    }
    fetchMySpots();
  }

  /// Fetch spots from API
  Future<void> fetchMySpots({int page = 1}) async {
    isLoading = true;
    errorMessage = '';
    update();

    try {
      final response = isFavoriteMode
          ? await _repository.fetchFavoriteSpots(
              page: page,
              limit: 10,
            )
          : await _repository.fetchSpots(
              page: page,
              limit: 10,
            );

      isLoading = false;

      if (response != null && response.success) {
        spots = response.data;

        if (response.pagination != null) {
          currentPage = response.pagination!.page;
          totalPages = response.pagination!.totalPage;
          totalSpots = response.pagination!.total;
        }

        if (isFavoriteMode) {
          for (var spot in spots) {
            spot.isFavorite = true;
          }
        }

        appLog(
            '${isFavoriteMode ? "Favorite" : "My"} Spots loaded: ${spots.length} spots');
      } else {
        errorMessage = _repository.errorMessage.isNotEmpty
            ? _repository.errorMessage
            : 'Failed to load spots';
        appLog('Failed to load spots: $errorMessage');
      }
    } catch (e) {
      isLoading = false;
      errorMessage = 'An error occurred while loading spots';
      appLog('Error loading spots: $e');
    }

    update();
  }

  /// Handle spot tap - navigate to details
  void onSpotTap(SpotData spot) {
    appLog('Tapped on spot: ${spot.title}');

    // Navigate to spot details screen
    Get.toNamed(AppRoutes.sunsetPointDetailsScreen, arguments: spot);
    // For now, just show a message
    Fluttertoast.showToast(
      msg: 'Opening ${spot.title}',
      backgroundColor: const Color(0xFF2E4F3E),
      textColor: Colors.white,
    );
  }

  /// Toggle favorite for a spot
  void toggleFavorite(SpotData spot) async {
    try {
      final success = await _repository.toggleFavorite(
        id: spot.id,
        type: 'Spot',
      );

      if (success) {
        // Update local state
        spot.isFavorite = !spot.isFavorite;
        update();

        Fluttertoast.showToast(
          msg: _repository.successMessage.isNotEmpty
              ? _repository.successMessage
              : 'Favorite updated successfully',
          backgroundColor: const Color(0xFF2E4F3E),
          textColor: Colors.white,
          toastLength: Toast.LENGTH_SHORT,
        );
      } else {
        Fluttertoast.showToast(
          msg: _repository.errorMessage.isNotEmpty
              ? _repository.errorMessage
              : 'Failed to update favorite',
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      appLog('Error toggling favorite: $e');
      Fluttertoast.showToast(
        msg: 'An error occurred',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  /// Delete a spot
  Future<void> deleteSpot(SpotData spot) async {
    try {
      final success = await _repository.deleteSpot(spot.id);

      if (success) {
        // Remove from local list
        spots.removeWhere((s) => s.id == spot.id);
        update();

        Fluttertoast.showToast(
          msg: '${spot.title} deleted successfully',
          backgroundColor: const Color(0xFF2E4F3E),
          textColor: Colors.white,
        );
      } else {
        Fluttertoast.showToast(
          msg: _repository.errorMessage.isNotEmpty
              ? _repository.errorMessage
              : 'Failed to delete spot',
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      appLog('Error deleting spot: $e');
      Fluttertoast.showToast(
        msg: 'An error occurred while deleting',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  /// Navigate to add new spot screen
  void addNewSpot() {
    appLog('Add new spot tapped');
    Get.toNamed(AppRoutes.shareSpotScreen);
  }

  /// Format date string to readable format
  String formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  /// Get image URL with base domain
  String getImageUrl(String imagePath) {
    if (imagePath.isEmpty) {
      return '';
    }

    // If it's already a full URL, return as is
    if (imagePath.startsWith('http')) {
      return imagePath;
    }

    // Otherwise, prepend the domain
    return '${AppApiEndPoint.domain}$imagePath';
  }

  /// Load next page
  Future<void> loadNextPage() async {
    if (currentPage < totalPages && !isLoading) {
      await fetchMySpots(page: currentPage + 1);
    }
  }

  /// Refresh spots list
  Future<void> refreshSpots() async {
    await fetchMySpots(page: 1);
  }

  bool get isEmpty => spots.isEmpty && !isLoading;
  bool get hasMorePages => currentPage < totalPages;
}
