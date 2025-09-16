import 'package:get/get.dart';
import '../screen/onboarding_screen/onboarding_screen.dart';
import '../screen/splash_screen/splash_screen.dart';
import 'app_routes.dart';

List<GetPage> appRootRoutesFile = <GetPage>[
  //   /////////////////  splash screen start
  // GetPage(
  //   name: AppRoutes.instance.profileScreen,
  //   // binding: SplashScreenBinding(),
  //   page: () => const SplashScreen(),
  //   transitionDuration: Duration(milliseconds: 800),
  //   opaque: false,
  // ),
  GetPage(
    name: AppRoutes.splashScreen,
    // binding: SplashScreenBinding(),
    page: () => const SplashScreen(),
  ),

  GetPage(
    name: AppRoutes.onBoardingScreen,
    // binding: SplashScreenBinding(),
    page: () => OnboardingScreen(),
  ),



];
