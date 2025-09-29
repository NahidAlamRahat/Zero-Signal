import 'package:get/get.dart';
import 'package:zero_signal/screen/choose_language_screen/choose_language_screen.dart';
import 'package:zero_signal/screen/sign_in_and_registration_screen/sign_in_and_registration_screen.dart';
import 'package:zero_signal/screen/social_screen/social_screen.dart';
import '../screen/onboarding_screen/onboarding_screen.dart';
import '../screen/sign_in_screen/sign_in_screen.dart';
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
    name: AppRoutes.chooseLanguageScreen,
    // binding: SplashScreenBinding(),
    page: () => ChooseLanguageScreen(),
  ),

  GetPage(
    name: AppRoutes.glassEffectBackground,
    // binding: SplashScreenBinding(),
    page: () => OnboardingScreen(),
  ),

  GetPage(
    name: AppRoutes.signInAndRegistrationScreen,
    // binding: SplashScreenBinding(),
    page: () => SignInAndRegistrationScreen(),
  ),

  GetPage(
    name: AppRoutes.signInScreen,
    // binding: SplashScreenBinding(),
    page: () => SignInScreen(),
  ),
  //Social Screen
  GetPage(
    name: AppRoutes.socialScreen,
    // binding: SplashScreenBinding(),
    page: () => const SocialScreen(),
  ),
];
