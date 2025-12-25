import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constant/api_end_point.dart';
import '../../../service/api_service/api_services.dart';
import '../../../utils/app_log/app_log.dart';
import '../../../gen/assets.gen.dart';

class RouteDetailsController extends GetxController {
  // Route data from map screen
  var routeData = <String, dynamic>{}.obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  
  // Selected image for dialog
  var selectedImage = ''.obs;

  // Comments data
  var comments = <Map<String, dynamic>>[].obs;
  var isCommentsLoading = false.obs;
  var commentsErrorMessage = ''.obs;
  var commentController = TextEditingController();
  var isPostingComment = false.obs;

  // Images list - Using static images for demonstration (will be from API later)
  var images = <String>[
    Assets.images.image1.path,
    Assets.images.image2.path,
    Assets.images.image3.path,
    Assets.images.image4.path,
  ].obs;

  // Comments display
  var showAllComments = false.obs;
  var displayedComments = <Map<String, dynamic>>[].obs;

  // Set route data from map screen
  void setRouteData(Map<String, dynamic> data) {
    routeData.value = data;
    
    // Update images from route data if available
    if (data['images'] != null && data['images'] is List) {
      final routeImages = List<String>.from(data['images']);
      if (routeImages.isNotEmpty) {
        // Convert server paths to full URLs
        final imageUrls = routeImages.map((imagePath) {
          if (imagePath.startsWith('/')) {
            // Add base URL from API endpoint
            return 'https://shariful5000.binarybards.online$imagePath';
          }
          return imagePath;
        }).toList();
        images.value = imageUrls;
      }
    }
    
    update();
  }

  // Fetch route details by ID
  Future<void> fetchRouteDetails(String routeId) async {
    isLoading.value = true;
    errorMessage.value = '';
    update();

    try {
      final response = await ApiService.getApi(
        AppApiEndPoint.instance.routeDetailEndPoint(routeId),
      );
      
      if (response.statusCode == 200 && response.body['success'] == true) {
        final routeData = response.body['data'];
        setRouteData(routeData);
        appLog('Route details fetched successfully: ${routeData['title']}', type: LogType.info, source: 'ROUTE_DETAILS');
      } else {
        errorMessage.value = 'Route not found';
        appLog('Route not found for ID: $routeId', type: LogType.error, source: 'ROUTE_DETAILS');
      }
    } catch (e) {
      errorMessage.value = 'Failed to load route details';
      appLog('Error fetching route details: $e', type: LogType.error, source: 'ROUTE_DETAILS');
    } finally {
      isLoading.value = false;
      update();
    }
  }

  // Comments data
  var allComments = <Map<String, dynamic>>[
    {
      'name': 'Charolette Hanlin',
      'date': 'Feb 3, 2025',
      'comment':
          'Chill atmosphere, friendly crowd. Exactly the relaxed spot we were looking for on a Friday night. Loved it. 😍😍',
      'avatar': Colors.blue[100],
      'avatarIcon': Icons.person,
      'avatarIconColor': Colors.blue,
    },
    {
      'name': 'Olivia Gabriella Hernandez',
      'date': 'Apr 21, 2025',
      'comment':
          'Good music, but the service was slow. Maybe an off night? The overall vibe was still positive though. 😊😊',
      'avatar': Colors.green[100],
      'avatarIcon': Icons.person,
      'avatarIconColor': Colors.green,
    },
    {
      'name': 'Emma Victoria Lewis',
      'date': 'Mar 13, 2025',
      'comment':
          'Incredible vibes and even better cocktails. A bit crowded but that just adds to the fun. Highly recommend! 😍😍',
      'avatar': Colors.orange[100],
      'avatarIcon': Icons.person,
      'avatarIconColor': Colors.orange,
    },
    {
      'name': 'Emma Victoria Lewis',
      'date': 'Mar 13, 2025',
      'comment':
          'Incredible vibes and even better cocktails. A bit crowded but that just adds to the fun. Highly recommend! 😍😍',
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
    updateDisplayedComments();
  }

  void updateDisplayedComments() {
    if (comments.isEmpty) {
      displayedComments.value = [];
    } else {
      displayedComments.value = showAllComments.value ? comments : [comments.first];
    }
    update();
  }

  int get remainingCommentsCount =>
      comments.length > 1 ? comments.length - 1 : 0;

  // Fetch comments for a route
  Future<void> fetchComments(String routeId) async {
    isCommentsLoading.value = true;
    commentsErrorMessage.value = '';
    update();

    try {
      final response = await ApiService.getApi(
        AppApiEndPoint.commentEndPoint,
        queryParams: {'spot': routeId, 'type': 'Routes'},
      );
      
      if (response.statusCode == 200 && response.body['success'] == true) {
        final commentsData = response.body['data'] as List;
        comments.value = List<Map<String, dynamic>>.from(commentsData);
        updateDisplayedComments();
        appLog('Comments fetched successfully: ${comments.length} comments', type: LogType.info, source: 'ROUTE_DETAILS');
      } else {
        commentsErrorMessage.value = 'Failed to load comments';
        appLog('Failed to load comments for route: $routeId', type: LogType.error, source: 'ROUTE_DETAILS');
      }
    } catch (e) {
      commentsErrorMessage.value = 'Failed to load comments';
      appLog('Error fetching comments: $e', type: LogType.error, source: 'ROUTE_DETAILS');
    } finally {
      isCommentsLoading.value = false;
      update();
    }
  }

  // Post a new comment
  Future<void> postComment(String routeId) async {
    if (commentController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter a comment');
      return;
    }

    isPostingComment.value = true;
    update();

    try {
      final response = await ApiService.postApi(
        AppApiEndPoint.commentEndPoint,
        {
          'spot': routeId, // API expects 'spot' field
          'type': 'Routes', // Since this is a route, type should be 'Routes'
          'comment': commentController.text.trim(),
        },
      );
      
      if (response.statusCode == 200 && response.body['success'] == true) {
        // Clear the comment field
        commentController.clear();
        // Refresh comments
        await fetchComments(routeId);
        // Use simple print instead of Get.snackbar to avoid overlay issue
        print('Comment posted successfully');
        appLog('Comment posted successfully for route: $routeId', type: LogType.info, source: 'ROUTE_DETAILS');
      } else {
        print('Failed to post comment');
        appLog('Failed to post comment: ${response.body}', type: LogType.error, source: 'ROUTE_DETAILS');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to post comment');
      appLog('Error posting comment: $e', type: LogType.error, source: 'ROUTE_DETAILS');
    } finally {
      isPostingComment.value = false;
      update();
    }
  }

  @override
  void onInit() {
    super.onInit();
    updateDisplayedComments();
  }

  @override
  void onClose() {
    commentController.dispose();
    super.onClose();
  }
}
