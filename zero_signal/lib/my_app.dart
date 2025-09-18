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


    AppSize.size = MediaQuery.of(context).size;

    return ScreenUtilInit(
        designSize: const Size(430, 932),
        ensureScreenSize: true,
        minTextAdapt: true,
        splitScreenMode: true,
      builder: (_, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Zero Signal',
          initialRoute: AppRoutes.splashScreen,
          getPages: appRootRoutesFile,
          enableLog: true,
          initialBinding: AppBindings(),
        );
      }
    );
  }
}
