import 'package:get/get.dart';
import '../../../repository/route_repository/route_repository.dart';
import '../../../widget/app_snack_bar/app_snack_bar.dart';
import '../model/route_model.dart';

class MyRoutesController extends GetxController {
  final RouteRepository _routeRepository = RouteRepository();

  // State
  bool isLoading = false;
  String errorMessage = '';
  List<RouteData> routes = [];

  // Pagination (if needed later, keeping simple for now)
  int page = 1;
  int limit = 10;
  bool hasMore = true;

  bool get isEmpty => !isLoading && routes.isEmpty && errorMessage.isEmpty;

  @override
  void onInit() {
    super.onInit();
    getRoutes();
  }

  Future<void> getRoutes({bool isRefresh = false}) async {
    if (isRefresh) {
      page = 1;
      routes.clear();
      hasMore = true;
    }

    if (isLoading) return;

    isLoading = true;
    errorMessage = '';
    update();

    try {
      final result = await _routeRepository.getRoutes(page: page, limit: limit);

      if (result != null && result.success == true) {
        if (result.data != null) {
          if (isRefresh) {
            routes = result.data!;
          } else {
            routes.addAll(result.data!);
          }
        }
      } else {
        errorMessage = result?.message ?? "Failed to load routes";
      }
    } catch (e) {
      errorMessage = "An error occurred: $e";
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> refreshRoutes() async {
    await getRoutes(isRefresh: true);
  }

  void addNewSpot() {
    // Navigate to add route screen or functionality
    // TODO: Implement navigation
    print("Add new route clicked");
  }

  void onRouteTap(RouteData route) {
    // Navigate to route details
    // TODO: Implement details navigation
    print("Route tapped: ${route.title}");
  }

  Future<void> toggleFavorite(RouteData route) async {
    if (route.sId == null) return;

    final result = await _routeRepository.toggleFavorite(
      id: route.sId!,
      type: "Route",
    );

    if (result) {
      route.isFavorite = !(route.isFavorite ?? false);
      AppSnackBar.success(
        route.isFavorite == true
            ? "Route added to favorites"
            : "Route removed from favorites",
      );
      update();
    } else {
      AppSnackBar.error(
        _routeRepository.errorMessage.isNotEmpty
            ? _routeRepository.errorMessage
            : "Failed to update favorite status",
      );
    }
  }

  void deleteRoute(RouteData route) {
    // Call delete api
    // TODO: Implement delete functionality
    print("Delete route: ${route.title}");
    // Optimistic update for demo
    routes.remove(route);
    update();
  }
}
