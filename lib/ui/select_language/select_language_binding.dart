import 'package:get/get.dart';
import 'package:player/ui/select_language/select_language_controller.dart';

class SelectLanguageBinding extends Bindings{
  @override
  void dependencies() {
   Get.put(SelectLanguageController());
  }

}