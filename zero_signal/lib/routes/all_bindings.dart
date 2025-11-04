import 'package:get/get.dart';
import '../screen/auth/choose_language_screen/controller/onboarding_controloler.dart';
import '../screen/auth/reset_password_otp_verify_screen/controller/forgot_pass_verify_otp_screen_controller.dart';
import '../screen/home_screen/conntroller/filter_controller.dart';
import '../screen/home_screen/conntroller/home_screen_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LanguageController());
    Get.lazyPut(() => ForgotPassVerifyOtpScreenController(),);
    Get.lazyPut(() => FilterController (),);
    Get.lazyPut(() => HomeScreenController (),);




  }

}