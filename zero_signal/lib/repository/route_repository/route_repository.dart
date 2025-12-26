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

    // Debug: Print the actual response
    print('GET ROUTES RESPONSE: ${response.body}');
    print('STATUS CODE: ${response.statusCode}');

    if (response.statusCode == 200 && response.body['success'] == true) {
      return RouteModel.fromJson(Map<String, dynamic>.from(response.body));
    } else if (response.statusCode == 200) {
      // Try to parse even if success field is missing or false
      try {
        print('Trying to parse response without success field');
        final routeModel = RouteModel.fromJson(Map<String, dynamic>.from(response.body));
        print('Successfully parsed route model with ${routeModel.data?.length ?? 0} routes');
        return routeModel;
      } catch (e) {
        print('Error parsing response: $e');
      }
    }
    return null;
  }

  Future<Map<String, dynamic>?> getRouteDetails(String routeId) async {
    final response = await ApiService.getApi(
      '${AppApiEndPoint.routeEndPoint}/$routeId',
    );

    // Debug: Print the actual response
    print('GET ROUTE DETAILS RESPONSE: ${response.body}');
    print('STATUS CODE: ${response.statusCode}');

    if (response.statusCode == 200 && response.body['success'] == true) {
      // Return the data directly as Map<String, dynamic>
      return response.body['data'] as Map<String, dynamic>?;
    } else if (response.statusCode == 200) {
      // Try to get data even if success field is missing or false
      try {
        print('Trying to parse route details response');
        final data = response.body['data'] as Map<String, dynamic>?;
        if (data != null) {
          print('Successfully parsed route details');
          return data;
        }
      } catch (e) {
        print('Error parsing route details response: $e');
      }
    }
    return null;
  }

  Future<bool> deleteRoute(String id) async {
    inProgress = true;
    errorMessage = '';
    successMessage = '';
    update();

    try {
      final response = await ApiService.deleteApi(
        url: AppApiEndPoint.instance.routeDetailEndPoint(id),
        body: {},
      );

      inProgress = false;

      if (response.statusCode == 200) {
        successMessage = response.message.isNotEmpty
            ? response.message
            : "Route deleted successfully";
        update();
        return true;
      } else {
        errorMessage = response.message.isNotEmpty
            ? response.message
            : "Failed to delete route";
        update();
        return false;
      }
    } catch (e) {
      inProgress = false;
      errorMessage = "Network error occurred";
      update();
      return false;
    }
  }
}
