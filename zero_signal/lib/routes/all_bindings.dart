import 'package:get/get.dart';
import '../screen/choose_language_screen/controller/onboarding_controloler.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LanguageController());
  }
}