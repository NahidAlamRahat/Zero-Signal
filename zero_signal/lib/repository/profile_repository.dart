import '../constant/api_end_point.dart';
import '../screen/profile/model/profile_model.dart';
import '../service/api_service/api_services.dart';
import '../utils/app_log/error_log.dart';
import '../widget/app_snack_bar/app_snack_bar.dart';

class ProfileRepository {
  Future<ProfileModel?> getProfileData() async {
    try {
      final response = await ApiService.getApi(
        AppApiEndPoint.getProfile,
      );

      if (response.statusCode == 200) {
        final body = response.body;

        if (body is Map<String, dynamic>) {
          return ProfileModel.fromJson(body);
        }
      }
      AppSnackBar.error(response.message);
      return null;
    } catch (e) {
      errorLog(e);
      // AppSnackBar.error(e.toString());
      return null;
    }
  }
}
