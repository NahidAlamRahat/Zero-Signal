import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:zero_signal/repository/activity_repository.dart';
import 'package:zero_signal/screen/list_screen/model/activity_list_model.dart';

class ListScreenController extends GetxController {
  final ActivityRepository _repository = ActivityRepository();

  final List<String> tabs = [
    'Near Activities',
    'Joined Activities',
    'Created Activities',
    'Saved'
  ];

  final ScrollController scrollController = ScrollController();
  late final List<GlobalKey> tabKeys;
  final GlobalKey headerKey = GlobalKey();

  int selectedIndex = 0;
  double indicatorLeft = 0;
  double indicatorWidth = 0;

  var isLoading = false.obs;
  var activities = <ActivityListData>[].obs;

  @override
  void onInit() {
    tabKeys = List<GlobalKey>.generate(tabs.length, (_) => GlobalKey());
    super.onInit();

    // Check for navigation arguments to set initial tab
    final args = Get.arguments;
    if (args != null && args is Map<String, dynamic>) {
      final initialTab = args['initialTab'];
      if (initialTab != null &&
          initialTab is int &&
          initialTab >= 0 &&
          initialTab < tabs.length) {
        selectedIndex = initialTab;
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      updateIndicatorFromKeys();
      fetchActivities();
    });
    scrollController.addListener(updateIndicatorFromKeys);
  }

  void select(int index) {
    if (selectedIndex == index) return;
    selectedIndex = index;
    update();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => updateIndicatorFromKeys());
    fetchActivities();
  }

  Future<void> fetchActivities() async {
    // Skip fetching for "Near Activities" tab (index 0)
    if (selectedIndex == 0) {
      activities.clear();
      return;
    }

    isLoading.value = true;
    try {
      String type = '';
      switch (selectedIndex) {
        case 1:
          type = 'joined';
          break;
        case 2:
          type = 'created';
          break;
        case 3:
          type = 'saved';
          break;
      }

      final response = await _repository.getActivitiesByType(type: type);
      if (response != null && response.data != null) {
        activities.assignAll(response.data!);
      } else {
        activities.clear();
      }
    } catch (e) {
      print("Error fetching activities: $e");
      activities.clear();
    } finally {
      isLoading.value = false;
    }
  }

  void updateIndicatorFromKeys() {
    if (selectedIndex < 0 || selectedIndex >= tabKeys.length) return;
    final key = tabKeys[selectedIndex];
    final ctx = key.currentContext;
    final headerCtx = headerKey.currentContext;
    if (ctx == null || headerCtx == null) return;
    final box = ctx.findRenderObject() as RenderBox?;
    final headerBox = headerCtx.findRenderObject() as RenderBox?;
    if (box == null || headerBox == null || !box.hasSize || !headerBox.hasSize)
      return;

    final Offset tabGlobal = box.localToGlobal(Offset.zero);
    final Offset headerGlobal = headerBox.localToGlobal(Offset.zero);
    final double leftInHeader = tabGlobal.dx - headerGlobal.dx;

    indicatorLeft = leftInHeader + 12;
    indicatorWidth = box.size.width - 24;
    update();

    Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      alignment: 0.3,
    );
  }
}
