import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:zero_signal/repository/activity_repository.dart';
import 'package:zero_signal/screen/list_screen/model/activity_list_model.dart';
import 'package:zero_signal/utils/app_log/app_log.dart';

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

  int _page = 1;
  bool _hasMore = true;
  bool _isLoadingMore = false;

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
    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    updateIndicatorFromKeys();
    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200 &&
        !isLoading.value &&
        !_isLoadingMore &&
        _hasMore &&
        selectedIndex != 0) {
      fetchActivities(isLoadMore: true);
    }
  }

  void select(int index) {
    if (selectedIndex == index) return;
    selectedIndex = index;
    update();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => updateIndicatorFromKeys());

    // Reset pagination
    _page = 1;
    _hasMore = true;
    activities.clear();
    fetchActivities();
  }

  Future<void> fetchActivities({bool isLoadMore = false}) async {
    if (isLoadMore) {
      _isLoadingMore = true;
    } else {
      isLoading.value = true;
      _page = 1;
      _hasMore = true;
    }

    try {
      if (selectedIndex == 0) {
        // Near Activities (Pagination logic not requested/implemented yet for this tab)
        try {
          LocationPermission permission = await Geolocator.checkPermission();
          if (permission == LocationPermission.denied) {
            permission = await Geolocator.requestPermission();
            if (permission == LocationPermission.denied) {
              isLoading.value = false;
              _isLoadingMore = false;
              return;
            }
          }

          if (permission == LocationPermission.deniedForever) {
            isLoading.value = false;
            _isLoadingMore = false;
            return;
          }

          final position = await Geolocator.getCurrentPosition();
          final response = await _repository.getActivityFeed(
            lat: position.latitude,
            lng: position.longitude,
          );

          if (response != null && response.data != null) {
            activities.assignAll(response.data!.map((feedData) {
              return ActivityListData(
                sId: feedData.sId,
                user: feedData.user != null
                    ? User(
                        sId: feedData.user?.sId,
                        name: feedData.user?.name,
                        email: feedData.user?.email,
                        image: feedData.user?.image,
                        address: feedData.user?.address,
                      )
                    : null,
                title: feedData.title,
                description: feedData.description,
                images: feedData.images,
                type: feedData.type,
                address: feedData.address,
                date: feedData.date,
                maxParticipants: feedData.maxParticipants,
                currentParticipants: feedData.currentParticipants,
                createdAt: feedData.createdAt,
                updatedAt: feedData.updatedAt,
                location: feedData.location != null
                    ? Location(
                        type: feedData.location!.type,
                        coordinates: feedData.location!.coordinates,
                      )
                    : null,
              );
            }).toList());
          } else {
            if (!isLoadMore) activities.clear();
          }
        } catch (e) {
          appLog("Error fetching location or feed: $e");
          if (!isLoadMore) activities.clear();
        }
      } else {
        // Other tabs
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

        final response = await _repository.getActivitiesByType(
          type: type,
          page: _page,
        );

        if (response != null && response.data != null) {
          if (isLoadMore) {
            activities.addAll(response.data!);
          } else {
            activities.assignAll(response.data!);
          }

          // Check if there are more pages
          // Assuming API returns pagination info, specifically 'totalPage' or checking list size
          if (response.pagination != null) {
            _hasMore = _page < (response.pagination!.totalPage ?? 1);
          } else {
            // Fallback if pagination info missing
            _hasMore = response.data!.isNotEmpty;
          }

          if (_hasMore) {
            _page++;
          }
        } else {
          if (!isLoadMore) activities.clear();
          _hasMore = false;
        }
      }
    } catch (e) {
      appLog("Error fetching activities: $e");
      if (!isLoadMore) activities.clear();
    } finally {
      isLoading.value = false;
      _isLoadingMore = false;
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
    if (box == null || headerBox == null || !box.hasSize || !headerBox.hasSize) {
      return;
    }

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

  Future<void> leaveActivity(String activityId) async {
    isLoading.value = true;
    final success = await _repository.leaveActivity(activityId: activityId);
    isLoading.value = false;
    if (success) {
      fetchActivities();
    }
  }
}
