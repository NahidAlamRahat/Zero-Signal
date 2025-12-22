import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:zero_signal/repository/activity_repository.dart';
import 'package:zero_signal/screen/social_screen/modell/activity_feed_model.dart';

class SocialController extends GetxController {
  final ActivityRepository _repository = ActivityRepository();
  var isLoading = false.obs;
  var activityFeed = <ActivityFeedData>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchActivityFeed();
  }

  Future<void> fetchActivityFeed() async {
    isLoading.value = true;
    try {
      Position position = await _determinePosition();
      final response = await _repository.getActivityFeed(
        lat: position.latitude,
        lng: position.longitude,
      );

      if (response != null && response.data != null) {
        activityFeed.assignAll(response.data!);
      }
    } catch (e) {
      print("Error fetching activity feed: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Get.defaultDialog(
        title: "Location Disabled",
        middleText: "Please enable location services to see nearby activities.",
        textConfirm: "Settings",
        textCancel: "Cancel",
        confirmTextColor: Get.theme.colorScheme.onPrimary,
        onConfirm: () async {
          await Geolocator.openLocationSettings();
          Get.back();
        },
      );
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return Future.error('Location services are disabled.');
      }
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  String formatDate(String? dateString) {
    if (dateString == null) return "";
    try {
      DateTime date = DateTime.parse(dateString);
      return DateFormat('MMMM d').format(date);
    } catch (e) {
      return dateString;
    }
  }

  void removeItem(int index) {
    if (index >= 0 && index < activityFeed.length) {
      activityFeed.removeAt(index);
    }
  }
}
