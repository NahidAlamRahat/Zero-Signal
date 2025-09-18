import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zero_signal/routes/all_bindings.dart';
import 'routes/app_routes.dart';
import 'routes/app_routes_file.dart';
import 'utils/app_size.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 882), // Your design size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        AppSize.size = MediaQuery.of(context).size;
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Zero Signal',
          initialRoute: AppRoutes.socialScreen,
          getPages: appRootRoutesFile,
          enableLog: true,
          initialBinding: AppBindings(),
        );
      },
    );
  }
}
