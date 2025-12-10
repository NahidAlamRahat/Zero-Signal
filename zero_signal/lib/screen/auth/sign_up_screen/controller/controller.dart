import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../repository/auth_repo/sign_up_repository.dart';
import '../../../../routes/app_routes.dart';
import '../../../../utils/app_log/app_log.dart';
import '../../../../widget/app_snack_bar/app_snack_bar.dart';
import '../model/sign_up_model.dart';

class SignUpController extends GetxController {
  var emailController = TextEditingController();
  var userNumberController = TextEditingController();
  var birthDateController = TextEditingController();
  var passwordController = TextEditingController();

  final GlobalKey<FormState> formKey =
      GlobalKey<FormState>(debugLabel: 'signUpForm');

  final SignUpApiController _signUpApiController =
      Get.find<SignUpApiController>();

  bool isLoading = false;

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

  // Validate Name
  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return "Enter Name";
    } else if (value.length < 3) {
      return "Name must be at least 3 characters";
    }
    return null;
  }

  // date of birth validation
  String? validateDateOfBirth(String? value) {
    if (value == null || value.isEmpty) {
      return "Enter Date of Birth";
    }
    return null;
  }

  // Validate Password
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Enter Password";
    } else if (value.length < 6) {
      return "Password must be at least 6 characters";
    }
    return null;
  }

  Future<void> onTapSignUpButton() async {
    if (formKey.currentState!.validate()) {
      RegisterRequestModel registerRequestModel = RegisterRequestModel(
          name: userNumberController.text.trim(),
          email: emailController.text.trim(),
          dateOfBirth: birthDateController.text,
          password: passwordController.text);

      isLoading = true;
      update(); // ✅ show loading

      final bool isSuccess =
          await _signUpApiController.userSignUp(registerRequestModel);

      isLoading = false;
      update(); // ✅ hide loading

      if (isSuccess) {
        AppSnackBar.success(
            _signUpApiController.successfullyMessage ?? 'Successful!');
        appLog(
            'success message => ${_signUpApiController.successfullyMessage}');

        Get.toNamed(
          AppRoutes.resetPassOtpVerifyScreen,
          arguments: {'email': emailController.text},
        );
      } else {
        AppSnackBar.message('${_signUpApiController.errorMessage}');
        appLog('error message => ${_signUpApiController.errorMessage}');
      }
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    userNumberController.dispose();
    birthDateController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
