
import 'package:get/get.dart';

import 'forget_pass_controller.dart';

class ForgetPassBinding extends Bindings{
  @override
  void dependencies() {
    Get.put(ForgetPassController());
  }

}