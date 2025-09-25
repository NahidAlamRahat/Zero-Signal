import 'package:get/get.dart';
import 'package:zero_signal/screen/home_screen/home_screen.dart';
import '../screen/auth/choose_language_screen/choose_language_screen.dart';
import '../screen/auth/createa_password_screen/create_password_screen.dart';
import '../screen/auth/forgot_password_screen/forgot_password_screen.dart';
import '../screen/auth/reset_password_otp_verify_screen/controller/forgot_pass_verify_otp_screen_controller.dart';
import '../screen/auth/reset_password_otp_verify_screen/reset_pass_otp_verify_screen.dart';
import '../screen/auth/sign_in_and_registration_screen/sign_in_and_registration_screen.dart';
import '../screen/auth/sign_in_screen/sign_in_screen.dart';
import '../screen/auth/sign_up_screen/sign_up_screen.dart';
import '../screen/button_nav_bar/button_nav_bar_screen.dart';
import '../screen/onboarding_screen/onboarding_screen.dart';
import '../screen/share_spot_screen/share_spot_screen.dart';
import '../screen/splash_screen/splash_screen.dart';
import '../screen/sport_details/sport_details_screen.dart';
import 'all_bindings.dart';
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

  GetPage(
    name: AppRoutes.forgotPasswordScreen,
    // binding: SplashScreenBinding(),
    page: () => ForgotPasswordScreen(),
  ),

  GetPage(
    name: AppRoutes.resetPassOtpVerifyScreen,
    binding: AppBindings(),
    page: () => ResetPassOtpVerifyScreen(),
  ),

  GetPage(
    name: AppRoutes.createPasswordScreen,
    binding: AppBindings(),
    page: () => CreatePasswordScreen(),
  ),

  GetPage(
    name: AppRoutes.signUpScreen,
    binding: AppBindings(),
    page: () => SignUpScreen(),
  ),

  GetPage(
    name: AppRoutes.homeScreen,
    binding: AppBindings(),
    page: () => HomeScreen(),
  ),


  GetPage(
    name: AppRoutes.bottomNav,
    page: () => const BottomNav(),
    // binding: GeneralBindings(),
  ),

  GetPage(
    name: AppRoutes.shareSpotScreen,
    page: () => const ShareSpotScreen(),
    // binding: GeneralBindings(),
  ),

  GetPage(
    name: AppRoutes.spotDetailsScreen,
    page: () => const SpotDetailsScreen(),
    // binding: GeneralBindings(),
  ),

];
