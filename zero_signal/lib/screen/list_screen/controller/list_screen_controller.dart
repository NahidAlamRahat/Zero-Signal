import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ListScreenController extends GetxController {
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

    WidgetsBinding.instance
        .addPostFrameCallback((_) => updateIndicatorFromKeys());
    scrollController.addListener(updateIndicatorFromKeys);
  }

  void select(int index) {
    if (selectedIndex == index) return;
    selectedIndex = index;
    update();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => updateIndicatorFromKeys());
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
