import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zero_signal/gen/assets.gen.dart';
import 'package:zero_signal/constant/api_end_point.dart';
import '../../../repository/route_repository/route_repository.dart';
import '../../../utils/app_log/app_log.dart';

class RouteDetailsController extends GetxController {
  // Route data from map screen
  var routeData = <String, dynamic>{}.obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  
  // Selected image for dialog
  var selectedImage = ''.obs;

  // Images list - Using static images for demonstration (will be from API later)
  var images = <String>[
    Assets.images.image1.path,
    Assets.images.image2.path,
    Assets.images.image3.path,
    Assets.images.image4.path,
  ].obs;

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
      final repository = RouteRepository();
      final result = await repository.getRouteDetails(routeId);
      
      if (result != null) {
        // Use the route data directly
        setRouteData(result);
        appLog('Route details fetched successfully: ${result['title']}', type: LogType.info, source: 'ROUTE_DETAILS');
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
  var showAllComments = false.obs;

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
  }

  List<Map<String, dynamic>> get displayedComments {
    if (allComments.isEmpty) return [];
    return showAllComments.value ? allComments : [allComments.first];
  }

  int get remainingCommentsCount =>
      allComments.length > 1 ? allComments.length - 1 : 0;

  @override
  void onInit() {
    super.onInit();
    // No need to pre-select an image here, it's handled when the dialog opens
    // TODO: Call API to fetch real data
    // fetchRouteImages();
  }

  // API call - for future use
  void fetchRouteImages() async {
    try {
      // Example API call
      // var response = await apiService.getRouteImages(routeId);
      // images.value = response.data.map((item) => item.imageUrl).toList();

      print('Images loaded: ${images.length}');
    } catch (e) {
      print('Error loading images: $e');
    }
  }
}
