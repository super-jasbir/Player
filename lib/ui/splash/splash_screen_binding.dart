
import 'package:get/get.dart';
import 'package:player/ui/splash/splash_screen_controller.dart';

class SplashScreenBinding extends Bindings{
  @override
  void dependencies() {
    Get.put(SplashScreenController());
  }

}