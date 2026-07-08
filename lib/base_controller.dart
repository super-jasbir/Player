
import 'package:get/get.dart';

import 'app_controller.dart';
import 'data/network/api_service.dart';


class BaseController extends GetxController{
  ApiService apiService = ApiService();
  var appController = Get.find<AppController>();


  late dynamic appConstant;
  @override
  void onInit() {
    appConstant = appController.appConstant;

    super.onInit();
  }





}