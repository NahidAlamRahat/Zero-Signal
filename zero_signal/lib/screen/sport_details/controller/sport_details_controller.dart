import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zero_signal/constant/api_end_point.dart';
import 'package:zero_signal/repository/spot_repository.dart';

class SportDetailsController extends GetxController {
  final SpotRepository _repository = SpotRepository();

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
  final RxList<Map<String, dynamic>> comments = <Map<String, dynamic>>[].obs;

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
    return comments.length > 2 ? comments.length - 2 : 0;
  }

  // Method to select an image
  void selectImage(String imagePath) {
    selectedImage.value = imagePath;
  }

  /// Fetch full details from API
  Future<void> fetchSpotDetails() async {
    if (spotId.value.isEmpty) return;

    print("DEBUG: Fetching details for spot ID: ${spotId.value}");

    final spot = await _repository.fetchSpotDetails(spotId.value);

    if (spot != null) {
      spotTitle.value = spot.title;
      spotDescription.value = spot.description;
      spotAddress.value = spot.address;
      spotLatitude.value = spot.latitude;
      spotLongitude.value = spot.longitude;
      if (spot.images.isNotEmpty) {
        images.assignAll(spot.images);
        selectedImage.value = spot.images.first;
      }
      print("DEBUG: Updated spot details from API");

      await fetchComments();
    }
  }

  Future<void> fetchComments() async {
    print("DEBUG: Fetching comments for spot ID: ${spotId.value}");
    final fetchedComments = await _repository.fetchComments(spotId.value);

    if (fetchedComments != null) {
      comments.clear();
      for (var comment in fetchedComments) {
        comments.add({
          'name': comment.userName,
          'date':
              "${comment.createdAt.day}/${comment.createdAt.month}/${comment.createdAt.year}",
          'comment': comment.comment,
          'avatar': Colors.blueAccent,
          'avatarIcon': Icons.person,
          'avatarIconColor': const Color(0xFFFFFFFF),
          'imageUrl': (comment.userImage.isNotEmpty &&
                  !comment.userImage.startsWith('http'))
              ? "${AppApiEndPoint.domain}${comment.userImage}"
              : comment.userImage
        });
      }
      print(
          "DEBUG: Updated comments list with ${fetchedComments.length} items");
    }
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

      // Call API to get full details
      if (spotId.value.isNotEmpty) {
        fetchSpotDetails();
      }
    }
    // Initialize with sample images if needed
  }

  // Comment posting
  final TextEditingController commentController = TextEditingController();
  final RxBool isPostingComment = false.obs;

  Future<void> postComment() async {
    final commentText = commentController.text.trim();
    if (commentText.isEmpty) {
      Get.snackbar('Error', 'Please enter a comment',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    if (spotId.value.isEmpty) {
      Get.snackbar('Error', 'Spot ID is missing',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isPostingComment.value = true;

    final success = await _repository.createComment(
      comment: commentText,
      spotId: spotId.value,
    );

    isPostingComment.value = false;

    if (success) {
      commentController.clear();
      // Refresh comments to show the new one
      await fetchComments();
    }
  }

  @override
  void onClose() {
    commentController.dispose();
    super.onClose();
  }
}
