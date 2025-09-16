import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'routes/app_routes.dart';
import 'routes/app_routes_file.dart';
import 'utils/app_size.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {


    AppSize.size = MediaQuery.of(context).size;
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Zero Signal',
      // initialRoute: AppRoutes.instance.initial,
      initialRoute: AppRoutes.splashScreen,
      getPages: appRootRoutesFile,
      enableLog: true,
      // initialBinding: AppBinding(),
    );
  }
}
