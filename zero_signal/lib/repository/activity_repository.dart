import 'package:zero_signal/constant/api_end_point.dart';
import 'package:zero_signal/screen/create_activity_screen/model/route_type_model.dart';
import 'package:zero_signal/screen/list_screen/model/activity_list_model.dart';
import 'package:zero_signal/screen/social_screen/modell/activity_feed_model.dart';
import 'package:zero_signal/service/api_service/api_services.dart';
import 'package:zero_signal/service/api_service/service_model/service_model.dart';
import 'package:zero_signal/widget/app_snack_bar/app_snack_bar.dart';

class ActivityRepository {
  Future<RouteTypeModel?> getRouteTypes() async {
    try {
      ApiResponseModel response = await ApiService.getApi(
        AppApiEndPoint.instance.routeTypeEndPoint(),
      );

      if (response.statusCode == 200) {
        return RouteTypeModel.fromJson(response.body as Map<String, dynamic>);
      } else {
        AppSnackBar.error(response.message);
        return null;
      }
    } catch (e) {
      AppSnackBar.error("Failed to load activity types");
      return null;
    }
  }

  Future<bool> createActivity({
    required Map<String, dynamic> body,
    required List<MultipartBody> images,
  }) async {
    try {
      ApiResponseModel response = await ApiService.postMultipartApi(
        AppApiEndPoint.activityEndPoint,
        body,
        multipartBody: images,
      );

      if (response.statusCode == 200) {
        AppSnackBar.success(response.message);
        return true;
      } else {
        AppSnackBar.error(response.message);
        return false;
      }
    } catch (e) {
      AppSnackBar.error("Failed to create activity");
      return false;
    }
  }

  Future<ActivityFeedModel?> getActivityFeed({
    required double lat,
    required double lng,
  }) async {
    try {
      ApiResponseModel response = await ApiService.getApi(
        AppApiEndPoint.instance.activityFeedEndPoint(lat, lng),
      );

      if (response.statusCode == 200) {
        return ActivityFeedModel.fromJson(
            response.body as Map<String, dynamic>);
      } else {
        AppSnackBar.error(response.message);
        return null;
      }
    } catch (e) {
      AppSnackBar.error("Failed to load activity feed");
      return null;
    }
  }

  Future<Map<String, dynamic>?> saveActivity({
    required String activityId,
  }) async {
    try {
      final response = await ApiService.postApi(
        AppApiEndPoint.activitySaveEndPoint,
        {"activity": activityId},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.body as Map<String, dynamic>;
      } else {
        AppSnackBar.error(response.message);
        return null;
      }
    } catch (e) {
      AppSnackBar.error("Failed to save activity");
      return null;
    }
  }

  Future<bool> joinActivity({
    required String activityId,
  }) async {
    try {
      final response = await ApiService.postApi(
        AppApiEndPoint.instance.activityJoinEndPoint(),
        {"activity": activityId},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        AppSnackBar.success(response.message);
        return true;
      } else {
        AppSnackBar.error(response.message);
        return false;
      }
    } catch (e) {
      AppSnackBar.error("Failed to join activity");
      return false;
    }
  }

  Future<ActivityListModel?> getActivitiesByType({
    required String type,
    int page = 1,
  }) async {
    try {
      final response = await ApiService.getApi(
        AppApiEndPoint.instance.activityByTypeEndPoint(type, page: page),
      );

      if (response.statusCode == 200) {
        return ActivityListModel.fromJson(
            response.body as Map<String, dynamic>);
      } else {
        AppSnackBar.error(response.message);
        return null;
      }
    } catch (e) {
      AppSnackBar.error("Failed to load activities");
      return null;
    }
  }

  Future<bool> leaveActivity({
    required String activityId,
  }) async {
    try {
      final response = await ApiService.postApi(
        AppApiEndPoint.instance.activityLeaveEndPoint(),
        {"activity": activityId},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        AppSnackBar.success(response.message);
        return true;
      } else {
        AppSnackBar.error(response.message);
        return false;
      }
    } catch (e) {
      AppSnackBar.error("Failed to leave activity");
      return false;
    }
  }

  Future<bool> updateActivity({
    required String activityId,
    required Map<String, dynamic> body,
  }) async {
    try {
      final response = await ApiService.patchApi(
        AppApiEndPoint.instance.activityUpdateEndPoint(activityId),
        body: body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        AppSnackBar.success(response.message);
        return true;
      } else {
        AppSnackBar.error(response.message);
        return false;
      }
    } catch (e) {
      AppSnackBar.error("Failed to update activity");
      return false;
    }
  }

  Future<ActivityListData?> getSingleActivity({
    required String activityId,
  }) async {
    try {
      final response = await ApiService.getApi(
        AppApiEndPoint.instance.getSingleActivityEndPoint(activityId),
      );

      if (response.statusCode == 200) {
        if (response.body['data'] != null) {
          return ActivityListData.fromJson(
              response.body['data'] as Map<String, dynamic>);
        }
        return null;
      } else {
        AppSnackBar.error(response.message);
        return null;
      }
    } catch (e) {
      AppSnackBar.error("Failed to load activity details");
      return null;
    }
  }
}
