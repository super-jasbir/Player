
import 'package:get/get.dart';

import 'biometric_controller.dart';

class BiometricBinding extends Bindings{
  @override
  void dependencies() {
  Get.put(BiometricController());
  }

}