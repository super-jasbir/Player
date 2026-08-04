import 'package:get/get.dart';
import 'package:player/ui/login_screen/login_controller.dart';
import 'package:player/ui/signup/signup_controller.dart';

class SignupBinding extends Bindings{
  @override
  void dependencies() {
  Get.put(SignupController());
  }

}