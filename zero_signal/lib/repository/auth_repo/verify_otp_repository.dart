import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../routes/app_routes.dart';
import '../../../../utils/app_log/app_log.dart';
import '../../screen/auth/reset_password_otp_verify_screen/model/verify_otp_model.dart';
import '../../service/api_service/api_services.dart';
import '../../service/storage/storage_key.dart';
import '../../service/storage/storage_service.dart';

class VerifyOtpRepository extends GetxController {
  late bool _inProgress = false;

  bool get inProgress => _inProgress;

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  String? _successfullyMessage;

  String? get successfullyMessage => _successfullyMessage;

  verifyOtp({required VerifyOtpModel verifyOtpModel, required url}) async {
    _inProgress = true;
    _errorMessage = null;
    _successfullyMessage = null;
    update();

    var response = await ApiService.postApi(
      url,
      verifyOtpModel,
    );
    debugPrint("response == $response");
    debugPrint('url => $url');

    _inProgress = false;

    if (response.statusCode == 200) {
      // String accessToken = response.body['data']?['accessToken'] ?? "";
      // String refreshToken = response.body['data']?['refreshToken'] ?? "";
      // String role = response.body['data']?['role'] ?? "";

      // LocalStorage.token = accessToken;

      // LocalStorage.refreshToken = refreshToken;
      // LocalStorage.myRole = role;

      // LocalStorage.userId =userProfileController. profile.value?.sId ?? '';

      // LocalStorage.setString(
      //   LocalStorageKeys.token,
      //   LocalStorage.token,
      // );
      // LocalStorage.setString(
      //     LocalStorageKeys.refreshToken, LocalStorage.refreshToken);

      appLog('success message => ${response.message}');

      appLog('message => ${response.body}');

      _successfullyMessage = response.message;

      appLog('Success message ===> ${response.message} <===');

      update();
      appLog("response ${response.statusCode}");
      return response.body;
    } else {
      appLog('Error message ===> ${response.message} <===');
      _errorMessage = response.message;

      update();
      return false;
    }
  }
}
