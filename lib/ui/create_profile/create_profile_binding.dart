import 'package:get/get.dart';
import 'package:player/ui/create_profile/create_profileC.dart';
import 'package:player/ui/create_profile/create_profile_screen.dart';
import 'package:player/ui/create_profile/update_profile.dart';
import 'package:player/ui/login_screen/login_controller.dart';
import 'package:player/ui/signup/signup_controller.dart';

class CreateProfileBinding extends Bindings{
  @override
  void dependencies() {
  Get.put(CreateProfileController());
  }

}

class UpdateProfileBinding extends Bindings{
  @override
  void dependencies() {
    Get.put(UpdateProfileController());
  }

}