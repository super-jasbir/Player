import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:player/generated/l10n/app_localizations.dart';
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
        // Figma design frame (matches minimart) — drives .sp/.w/.h/.r sizing.
        ScreenUtil.init(context, designSize: const Size(390, 844));
        return MediaQuery(
          data:
          MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
          child: child!,
        );
      },
      theme: ThemeData.light(),
      // Localization (English + Malay + Chinese) — strings in lib/l10n/*.arb
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialBinding: SplashScreenBinding(),
      initialRoute: AppRoutes.splashScreen,
      getPages: AppPages.page,
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}