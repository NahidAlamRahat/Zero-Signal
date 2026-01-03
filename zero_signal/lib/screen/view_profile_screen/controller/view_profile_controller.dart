import 'package:get/get.dart';
import 'package:zero_signal/repository/user_repository.dart';
import 'package:zero_signal/routes/app_routes.dart';

class ViewProfileController extends GetxController {
  final UserRepository _repository = UserRepository();

  final RxBool isLoading = false.obs;
  // Using RxMap allowing direct .isEmpty check in UI
  final RxMap<String, dynamic> userData = <String, dynamic>{}.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
  }

  void _loadUserData() {
    final args = Get.arguments;
    if (args != null) {
      if (args is Map<String, dynamic>) {
        if (args.containsKey('_id') && args.length > 5) {
          // Likely full user object passed
          userData.value = args;
        } else if (args.containsKey('userId')) {
          // Passed as ID in map
          fetchUserDetails(args['userId']);
        } else if (args.containsKey('_id')) {
          // Passed as ID in map key _id
          fetchUserDetails(args['_id']);
        } else {
          // Trying to use it as user object anyway
          userData.value = args;
        }
      } else if (args is String) {
        // Passed as ID string
        fetchUserDetails(args);
      }
    }
  }

  Future<void> fetchUserDetails(String userId) async {
    isLoading.value = true;
    errorMessage.value = '';

    final data = await _repository.getUserInfo(userId: userId);

    isLoading.value = false;
    if (data != null) {
      userData.value = data;
    } else {
      errorMessage.value = "Failed to load user details";
    }
  }

  Future<void> fetchAndNavigateToSpots() async {
    final userId = userData['_id'];
    if (userId == null) {
      Get.snackbar("Error", "User ID not found");
      return;
    }

    isLoading.value = true;
    final spots = await _repository.getUserSpots(userId: userId);
    isLoading.value = false;

    if (spots != null) {
      Get.toNamed(AppRoutes.mySpotsScreen, arguments: spots);
    } else {
      Get.snackbar("Notice", "No spots found or failed to fetch.");
    }
  }

  Future<void> fetchAndNavigateToRoutes() async {
    final userId = userData['_id'];
    if (userId == null) {
      Get.snackbar("Error", "User ID not found");
      return;
    }

    isLoading.value = true;
    final routes = await _repository.getUserRoutes(userId: userId);
    isLoading.value = false;

    if (routes != null) {
      Get.toNamed(AppRoutes.myRoutesScreen, arguments: routes);
    } else {
      Get.snackbar("Notice", "No routes found or failed to fetch.");
    }
  }
}
