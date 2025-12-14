import 'package:get/get.dart';
import '../../../../utils/app_log/app_log.dart';
import '../../constant/api_end_point.dart';
import '../../service/api_service/api_services.dart';
import '../../service/storage/storage_key.dart';
import '../../service/storage/storage_service.dart';

class SignInApiController extends GetxController {
  bool _inProgress = false;
  bool get inProgress => _inProgress;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  String _successfullyMessage = '';
  String get successfullyMessage => _successfullyMessage;

  // Return status code instead of bool for better handling
  Future<int> signInApiCall({required signInModel, String? email}) async {
    _inProgress = true;
    _errorMessage = '';
    _successfullyMessage = '';
    update(); // Update UI for GetBuilder

    try {
      final response = await ApiService.postApi(
        AppApiEndPoint.authLogin,
        signInModel,
      );

      _inProgress = false;

      if (response.statusCode == 200) {
        // API returns JWT token directly as string in data field
        String jwtToken = response.body['data'] ?? "";

        LocalStorage.token = jwtToken;
        LocalStorage.setString(
          LocalStorageKeys.token,
          LocalStorage.token,
        );

        _successfullyMessage = response.message ?? "Login successful";

        appLog('Login successful, token saved');
        update(); // Update UI for GetBuilder
        return 200;
      } else if (response.statusCode == 407) {
        _errorMessage = response.message ?? "OTP verification required";
        appLog('OTP verification required');
        update(); // Update UI for GetBuilder
        return 407;
      } else {
        _errorMessage = response.message ?? "Login failed";
        appLog(
            'Login failed - Status: ${response.statusCode}, Message: ${response.message}');
        update(); // Update UI for GetBuilder
        return response.statusCode;
      }
    } catch (e) {
      _inProgress = false;
      _errorMessage = "Network error occurred";
      appLog('SignIn API Error: $e');
      update(); // Update UI for GetBuilder
      return 500; // Internal error
    }
  }
}
