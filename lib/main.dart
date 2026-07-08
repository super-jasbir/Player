import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:player/routes/app_pages.dart';
import 'package:player/routes/app_routes.dart';
import 'package:player/ui/splash/splash_screen.dart';
import 'package:player/ui/splash/splash_screen_binding.dart';

import 'app_controller.dart';


void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_) {
    runApp( const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AppController(),permanent: true);
    return GetMaterialApp(
      builder: (context, child) {
        return MediaQuery(
          data:
          MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
          child: child!,
        );
      },
      theme: ThemeData.light(),
      initialBinding: SplashScreenBinding(),
      initialRoute: AppRoutes.splashScreen,
      getPages: AppPages.page,
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}