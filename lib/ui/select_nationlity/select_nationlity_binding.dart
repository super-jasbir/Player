import 'package:get/get.dart';
import 'package:player/ui/select_language/select_language_controller.dart';
import 'package:player/ui/select_nationlity/select_nationlity_controller.dart';

class SelectNationlityBinding extends Bindings{
  @override
  void dependencies() {
   Get.put(SelectNationlity());
  }

}