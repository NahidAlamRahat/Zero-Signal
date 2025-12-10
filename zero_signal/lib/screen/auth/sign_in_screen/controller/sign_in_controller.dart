import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../../repository/auth_repo/sign_in_repository.dart';
import '../../../../routes/app_routes.dart';
import '../../../../utils/app_log/app_log.dart';
import '../../../../widget/app_snack_bar/app_snack_bar.dart';
import '../model/sign_in_model.dart';

class SignInController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final SignInApiController _signInController = Get.put(SignInApiController());

  bool inProgress = false;

  // Validate Email
  String? validateEmail(String? value) {
    bool emailValid = RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
    ).hasMatch(value ?? "");
    if (value == null || value.isEmpty) {
      return "Enter Email";
    } else if (!emailValid) {
      return "Enter a valid Email";
    }
    return null;
  }

  // Validate Password
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Enter Password";
    } else if (value.length < 6) {
      return "Password length should be more than 8 characters";
    }
    return null;
  }

  Future<void> onTapSignInButton() async {
    if (formKey.currentState!.validate()) {
      try {
        inProgress = true;
        update(); // Update UI for GetBuilder

        SignInModel signInModel = SignInModel(
          email: emailController.text.trim(),
          password: passwordController.text,
        );

        appLog('Attempting login for: ${emailController.text.trim()}');

        final int statusCode = await _signInController.signInApiCall(
          signInModel: signInModel,
          email: emailController.text.trim(),
        );

        inProgress = false;
        update(); // Update UI for GetBuilder

        appLog('Login response status code: $statusCode');

        if (statusCode == 200) {
          // ✅ Success
          appLog('Login successful, navigating to business bottom nav');

          AppSnackBar.success(
            _signInController.successfullyMessage.isNotEmpty
                ? _signInController.successfullyMessage
                : 'Login Successful!',
          );

          // Clear form
          emailController.clear();
          passwordController.clear();

          // Navigate to business dashboard
          Get.offAllNamed(AppRoutes.bottomNav);
        } else if (statusCode == 407) {
          // 🚀 Special Case - OTP verification required
          appLog('OTP verification required');

          AppSnackBar.message(
            _signInController.errorMessage.isNotEmpty
                ? _signInController.errorMessage
                : "OTP verification required.",
          );

          // Get.toNamed(
          //   AppRoutes.verifyOtpScreen,
          //   arguments: {'email': emailController.text.trim()},
          // );
        } else {
          // ❌ Other errors
          appLog('Login failed with status code: $statusCode');

          AppSnackBar.message(
            _signInController.errorMessage.isNotEmpty
                ? _signInController.errorMessage
                : "Login failed. Please try again.",
          );
        }
      } catch (e, stackTrace) {
        inProgress = false;
        update(); // Update UI for GetBuilder

        appLog('Exception in SignIn: $e');
        appLog('StackTrace: $stackTrace');

        AppSnackBar.message('Something went wrong. Please try again.');
      }
    }
  }
}
