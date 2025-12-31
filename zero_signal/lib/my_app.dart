import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zero_signal/routes/all_bindings.dart';
import 'package:zero_signal/utils/languages.dart';
import 'routes/app_routes.dart';
import 'routes/app_routes_file.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(430, 932),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Zero Signal',
            initialRoute: AppRoutes.splashScreen,
            getPages: appRootRoutesFile,
            enableLog: true,
            initialBinding: AppBindings(),
          );
        });

    // designSize: const Size(430, 932), // Your design size
    // minTextAdapt: true,
    // splitScreenMode: true,
    // builder: (context, child) {
    //   return GetMaterialApp(
    //     debugShowCheckedModeBanner: false,
    //     title: 'Zero Signal',
    //     translations: Languages(),
    //     locale: const Locale('en', 'US'),
    //     fallbackLocale: const Locale('en', 'US'),
    //     initialRoute: AppRoutes.splashScreen,
    //     getPages: appRootRoutesFile,
    //     enableLog: true,
    //     initialBinding: AppBindings(),
    //   );
    // });
  }
}
