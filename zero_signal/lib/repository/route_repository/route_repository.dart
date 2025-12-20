import '../../constant/api_end_point.dart';
import '../../repository/common_repository/common_repository.dart';
import '../../screen/my_routes_screen/model/route_model.dart';
import '../../service/api_service/api_services.dart';

class RouteRepository extends CommonRepository {
  Future<RouteModel?> getRoutes({int page = 1, int limit = 10}) async {
    final response = await ApiService.getApi(
      AppApiEndPoint.routeEndPoint,
      queryParams: {
        'page': page.toString(),
        'limit': limit.toString(),
      },
    );

    if (response.statusCode == 200 && response.body['success'] == true) {
      return RouteModel.fromJson(Map<String, dynamic>.from(response.body));
    }
    return null;
  }
}
