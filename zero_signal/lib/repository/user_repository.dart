import 'package:zero_signal/constant/api_end_point.dart';
import 'package:zero_signal/service/api_service/api_services.dart';
import 'package:zero_signal/utils/app_log/app_log.dart';

class UserRepository {
  Future<bool> likeUser({required String userId}) async {
    try {
      final Map<String, dynamic> payload = {
        "toUser": userId,
      };

      appLog("Like User Payload: $payload");

      final response = await ApiService.postApi(
        AppApiEndPoint.likeUserEndPoint,
        payload,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        appLog("Like user failed: ${response.message}");
        return false;
      }
    } catch (e) {
      appLog("Like user error: $e");
      return false;
    }
  }

  Future<Map<String, dynamic>?> getUserInfo({required String userId}) async {
    try {
      final response = await ApiService.getApi(
        AppApiEndPoint.instance.oneGetUserInfoEndPoint(userId),
      );

      if (response.statusCode == 200) {
        if (response.body is Map<String, dynamic>) {
          final body = response.body as Map<String, dynamic>;
          if (body.containsKey('data') &&
              body['data'] is Map<String, dynamic>) {
            return body['data'] as Map<String, dynamic>;
          }
          return body;
        } else if (response.data is Map<String, dynamic>) {
          final data = response.data as Map<String, dynamic>;
          if (data.containsKey('data') &&
              data['data'] is Map<String, dynamic>) {
            return data['data'] as Map<String, dynamic>;
          }
          return data;
        }
        return null;
      } else {
        appLog("Get user info failed: ${response.message}");
        return null;
      }
    } catch (e) {
      appLog("Get user info error: $e");
      return null;
    }
  }

  Future<List<dynamic>?> getUserSpots({required String userId}) async {
    try {
      final response = await ApiService.getApi(
        AppApiEndPoint.instance.oneGetSpotUserInfoEndPoint(userId),
      );

      if (response.statusCode == 200) {
        if (response.body is List) {
          return response.body as List<dynamic>;
        } else if (response.body is Map && response.body.containsKey('data')) {
          if (response.body['data'] is List) {
            return response.body['data'] as List<dynamic>;
          }
        }
        // Fallback if it returns a single object but we expect a list?
        // Or if response.body itself is the object (unlikely for "My Spots").
        // Based on other endpoints, it might be a list.
        return null;
      } else {
        appLog("Get user spots failed: ${response.message}");
        return null;
      }
    } catch (e) {
      appLog("Get user spots error: $e");
      return null;
    }
  }

  Future<List<dynamic>?> getUserRoutes({required String userId}) async {
    try {
      final response = await ApiService.getApi(
        AppApiEndPoint.instance.oneGetRouteUserInfoEndPoint(userId),
      );

      if (response.statusCode == 200) {
        if (response.body is List) {
          return response.body as List<dynamic>;
        } else if (response.body is Map && response.body.containsKey('data')) {
          if (response.body['data'] is List) {
            return response.body['data'] as List<dynamic>;
          }
        }
        return null;
      } else {
        appLog("Get user routes failed: ${response.message}");
        return null;
      }
    } catch (e) {
      appLog("Get user routes error: $e");
      return null;
    }
  }
}
