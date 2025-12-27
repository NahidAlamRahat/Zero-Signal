import 'package:get/get.dart';
import '../../list_screen/list_screen.dart';

class ListViewDetailsController extends GetxController {
  late ActivityItem activity;
  var currentImageIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is ActivityItem) {
      activity = Get.arguments;
    }
  }

  void updateImageIndex(int index) {
    currentImageIndex.value = index;
  }
}
