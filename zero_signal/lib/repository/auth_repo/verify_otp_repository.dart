import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../routes/app_routes.dart';
import '../../../../utils/app_log/app_log.dart';
import '../../screen/auth/reset_password_otp_verify_screen/model/verify_otp_model.dart';
import '../../service/api_service/api_services.dart';

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
      verifyOtpModel.toJson(),
    );
    debugPrint("response == $response");
    debugPrint('url => $url');

    _inProgress = false;

    if (response.statusCode == 200) {
      appLog('success message => ${response.message}');

      appLog('message => ${response.body}');

      _successfullyMessage = response.message;
      Get.offAllNamed(AppRoutes.signInScreen);

      appLog('Success message ===> ${response.message} <===');

      update();
      appLog("response ${response.statusCode}");
      return true;
    } else {
      appLog('Error message ===> ${response.message} <===');
      _errorMessage = response.message;

      update();
      return false;
    }
  }
}
