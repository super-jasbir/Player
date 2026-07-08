
import 'package:get/get.dart';
import 'package:player/ui/permission_screen/permission_controller.dart';

class PermissionBinding extends Bindings{
  @override
  void dependencies() {
    Get.put(PermissionController());
  }

}