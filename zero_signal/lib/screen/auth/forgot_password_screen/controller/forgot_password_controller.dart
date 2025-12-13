import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../repository/auth_repo/forgot_pass_repository.dart';
import '../../../../routes/app_routes.dart';
import '../../../../utils/app_log/app_log.dart';
import '../../../../widget/app_snack_bar/app_snack_bar.dart';

class ForgotPasswordOnTapButtonController extends GetxController {
  final emailTEController = TextEditingController();

  final ForgotPassRepository _forgotPassRepository = Get.put(ForgotPassRepository());
  final RxBool isLoading = false.obs;

  @override
  void onClose() {
    emailTEController.dispose();
    super.onClose();
  }


  // Validate Email
  String? validateEmail(String? value) {
    bool emailValid =
    RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
        .hasMatch(value ?? "");
    if (value == null || value.isEmpty) {
      return "Enter Email";
    } else if (!emailValid) {
      return "Enter a valid Email";
    }
    return null;
  }



/// on Tap button

  Future<void> onTapSentPhoneOtpButton() async {

    if ( emailTEController.text.isNotEmpty) {
      final bool isSuccess = await _forgotPassRepository.forgotPass(
         email:  emailTEController.text.trim());

      _forgotPassRepository.inProgress == true;

      if (isSuccess) {
        _forgotPassRepository.inProgress == false;

        AppSnackBar.success(_forgotPassRepository.successfullyMessage ??
            'Verification Code Sent!');
        appLog('success message => ${_forgotPassRepository.errorMessage}');
        Get.toNamed(
          AppRoutes.resetPassOtpVerifyScreen,
          arguments: {
            'email': emailTEController.text.trim(),
            'successRoute':  AppRoutes.createPasswordScreen
          },
        );
      } else {
        _forgotPassRepository.inProgress == false;
        // error message
        AppSnackBar.message('${_forgotPassRepository.errorMessage}');
        appLog(
            'error message => ${_forgotPassRepository.errorMessage}');
      }
    } else {
      AppSnackBar.error("Please enter your phone number.");
    }
  }

}
