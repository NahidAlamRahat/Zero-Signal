import 'package:get/get.dart';
import '../../my_spots_screen/model/spot_item.dart';

class MyRoutesController extends GetxController {
  final RxList<SpotItem> _spots = <SpotItem>[].obs;

  List<SpotItem> get spots => _spots;
  bool get isEmpty => _spots.isEmpty;

  void addNewSpot() {
    // TODO: Implement spot addition logic
    update();
  }

  void onSpotTap(SpotItem spot) {
    // TODO: Implement spot tap logic
    update();
  }

  void toggleFavorite(SpotItem spot) {
    final index = _spots.indexWhere((item) => item.id == spot.id);
    if (index != -1) {
      _spots[index].isFavorite = !_spots[index].isFavorite;
      update();
    }
  }

  void deleteSpot(SpotItem spot) {
    _spots.removeWhere((item) => item.id == spot.id);
    update();
    Get.back(); // Close the dialog
  }
}