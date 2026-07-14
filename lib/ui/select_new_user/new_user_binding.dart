import 'package:get/get.dart';

import 'new_user_controller.dart';

class NewUserBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(NewUserController());
  }
}
