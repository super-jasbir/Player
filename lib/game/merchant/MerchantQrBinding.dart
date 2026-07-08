
import 'package:get/get.dart';
import 'package:get/get_instance/src/bindings_interface.dart';

import '../../merchant/merchant_controller.dart';

class MerchantQrBinding extends Bindings{
  @override
  void dependencies() {
    Get.put(MerchantController());
  }
}