import 'package:get/get.dart';
import 'package:zero_signal/screen/home_screen/home_screen.dart';
import '../condition_screen/terms_condition_screen.dart';
import '../my_spots_screen/my_spots_screen.dart';
import '../screen/auth/createa_password_screen/create_password_screen.dart';
import '../screen/auth/forgot_password_screen/forgot_password_screen.dart';
import '../screen/auth/reset_password_otp_verify_screen/reset_pass_otp_verify_screen.dart';
import '../screen/auth/sign_in_and_registration_screen/sign_in_and_registration_screen.dart';
import '../screen/auth/sign_in_screen/sign_in_screen.dart';
import '../screen/auth/sign_up_screen/sign_up_screen.dart';
import '../screen/button_nav_bar/button_nav_bar_screen.dart';
import '../screen/contact_support_screen/contact_support_screen.dart';
import '../screen/edit_profile_screen/edit_profile_screen.dart';
import '../screen/filters_screen/filters_screen.dart';
import '../screen/full_map_screen/full_map_screen.dart';
import 'package:zero_signal/screen/social_screen/social_screen.dart';
import '../screen/my_routes_screen/my_spots_screen.dart';
import '../screen/onboarding_screen/onboarding_screen.dart';
import '../screen/personal_information_screen/personal_information_screen.dart';
import '../screen/save_route_details_screen/save_route_details_screen.dart';
import '../screen/share_spot_screen/share_spot_screen.dart';
import '../screen/splash_screen/splash_screen.dart';
import '../screen/sport_details/sport_details_screen.dart';
import '../screen/update_information_screen/update_information_screen.dart';
import '../screen/view_profile_screen/view_profile_screen.dart';
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

 /* GetPage(
    name: AppRoutes.chooseLanguageScreen,
    // binding: SplashScreenBinding(),
    page: () => ChooseLanguageScreen(),
  ),*/

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

  GetPage(
    name: AppRoutes.filtersScreen,
    page: () => const FiltersScreen(),
    // binding: GeneralBindings(),
  ),

  GetPage(
    name: AppRoutes.saveRouteDetailsScreen,
    page: () => const SaveRouteDetailsScreen(),
    // binding: GeneralBindings(),
  ),

  GetPage(
    name: AppRoutes.viewProfileScreen,
    page: () => const ViewProfileScreen(),
    // binding: GeneralBindings(),
  ),

  GetPage(
    name: AppRoutes.fullMapScreen,
    page: () => const FullMapScreen(),
    // binding: GeneralBindings(),
  ),



  //Social Screen
  GetPage(
    name: AppRoutes.socialScreen,
    // binding: SplashScreenBinding(),
    page: () => const SocialScreen(),
  ),


  GetPage(
    name: AppRoutes.editProfileScreen,
    // binding: SplashScreenBinding(),
    page: () => const EditProfileScreen(),
  ),

  GetPage(
    name: AppRoutes.personalInformationScreen,
    // binding: SplashScreenBinding(),
    page: () => const PersonalInformationScreen(),
  ),
  GetPage(
    name: AppRoutes.mySpotsScreen,
    // binding: SplashScreenBinding(),
    page: () => MySpotsScreen(),
  ),


  GetPage(
    name: AppRoutes.myRoutesScreen,
    // binding: SplashScreenBinding(),
    page: () =>  MyRoutesScreen(),
  ),


  GetPage(
    name: AppRoutes.conditionsScreen,
    // binding: SplashScreenBinding(),
    page: () =>  ConditionsScreen(),
  ),


  GetPage(
    name: AppRoutes.onboardingScreen,
    // binding: SplashScreenBinding(),
    page: () =>  OnboardingScreen(),
  ),




  GetPage(
    name: AppRoutes.contactSupportScreen,
    // binding: SplashScreenBinding(),
    page: () =>  ContactSupportScreen(),
  ),


];
