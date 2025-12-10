import 'package:get/get.dart';
import 'package:zero_signal/repository/auth_repo/sign_up_repository.dart';
import '../screen/auth/choose_language_screen/controller/onboarding_controloler.dart';
import '../screen/auth/reset_password_otp_verify_screen/controller/forgot_pass_verify_otp_screen_controller.dart';
import '../screen/auth/sign_in_screen/controller/sign_in_controller.dart';
import '../screen/auth/sign_up_screen/controller/controller.dart';
import '../screen/home_screen/conntroller/filter_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LanguageController());
    Get.lazyPut(() => ForgotPassVerifyOtpScreenController(),);
    Get.lazyPut(() => FilterController (),);
    Get.lazyPut(() => SignInController(),fenix: true);
    Get.lazyPut(() => SignUpApiController(), fenix: true);
    Get.lazyPut(() => SignUpController(), fenix: true);
    




  }

}