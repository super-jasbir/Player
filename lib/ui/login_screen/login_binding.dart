import 'package:get/get.dart';
import 'package:player/ui/login_screen/login_controller.dart';

class LoginBinding extends Bindings{
  @override
  void dependencies() {
  Get.put(LoginController());
  }

}