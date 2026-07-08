
import 'package:get/get.dart';

import 'create_new_pass_controller.dart';

class CreateNewPassBinding extends Bindings{
  @override
  void dependencies() {
    Get.put(CreateNewPassController());
  }

}