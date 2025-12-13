import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../utils/app_log/app_log.dart';
import '../../../../constant/api_end_point.dart';
import '../../../../repository/auth_repo/verify_otp_repository.dart';
import '../../../../routes/app_routes.dart';
import '../../../../widget/app_snack_bar/app_snack_bar.dart';
import '../model/verify_otp_model.dart';

class ForgotPassVerifyOtpScreenController extends GetxController {
  final VerifyOtpRepository _verifyOtpController = Get.put(
    VerifyOtpRepository(),
  );

  late TextEditingController otpTextEditingController;

  bool isLoading = false;

  void _setLoading(bool value) {
    isLoading = value;
    update();
  }

  var remainingSeconds = 180.obs; // 2.5 minutes
  var canResend = false.obs;
  late String email;
  Timer? _timer;
  String? successRoute;

  @override
  void onInit() {
    super.onInit();
    otpTextEditingController = TextEditingController();
    startTimer();
    if (Get.arguments is Map<String, dynamic>) {
      final args = Get.arguments as Map<String, dynamic>;
      email = args['email'] ?? '';
      successRoute = args['successRoute'] as String?;
    } else {
      // Handle the error or provide a default value
      email = '';
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    otpTextEditingController.dispose();
    super.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds.value > 0) {
        remainingSeconds.value--;
      } else {
        canResend.value = true;
        appLog("Timer completed. You can resend the code now.");
        _timer?.cancel();
      }
    });
  }

  /// Resent Otp code
  void resendCode() async {
    try {
      bool isSuccess = /*await AuthRepository().resendOtp(email: email);*/ true;
      if (isSuccess) {
        AppSnackBar.success("A new OTP has been sent to your email.");
        remainingSeconds.value = 180; // Reset the timer
        canResend.value = false;
        startTimer(); // Restart the timer
      }
    } catch (e) {
      AppSnackBar.error("An error occurred. Please try again.");
    }
  }

  String formatTime() {
    final minutes = remainingSeconds.value ~/ 60;
    final remainingSec = remainingSeconds.value % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSec.toString().padLeft(2, '0')}';
  }

  /// OnTap Button
  Future<void> verifyOtpButton() async {
    try {
      _setLoading(true);
      int otp = int.parse(otpTextEditingController.text.trim());

      VerifyOtpModel verifyOtpModel = VerifyOtpModel(
        email: email.toString(),
        otp: otp,
      );
      var response = await _verifyOtpController.verifyOtp(
        verifyOtpModel: verifyOtpModel,
        url: AppApiEndPoint.verifyEmail,
      );

      appLog("response ==> $response");
      _setLoading(false);

      if (response != null) {
        // Get token from the data field
        // Handle both cases: data as string or data as object with resetToken
        String? token;
        if (response["data"] is String) {
          token = response["data"];
          token = response["response"];
        } else if (response["data"] is Map) {
          token = response["data"]?["resetToken"];
        }

        // Show the API success message
        AppSnackBar.success('${_verifyOtpController.successfullyMessage}');
        appLog(
          'success message => ${_verifyOtpController.successfullyMessage}',
        );

        // Navigate to the appropriate screen
        if (successRoute?.isNotEmpty ?? false) {
          if (successRoute == AppRoutes.createPasswordScreen) {
            Get.toNamed(
              AppRoutes.createPasswordScreen,
              arguments: {'token': token},
            );
          }

          else {
            Get.offAllNamed(
              successRoute!,
            );
          }
        }
      } else {
        AppSnackBar.message('${_verifyOtpController.errorMessage}');
        appLog('error message => ${_verifyOtpController.errorMessage}');
      }
    } catch (e) {
      AppSnackBar.message('${_verifyOtpController.errorMessage}');
      _setLoading(false);
    }
  }
}
