
import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../../../utils/dialogs/permission_dialog.dart';
import '../../base_controller.dart';
import '../../routes/app_routes.dart';

class PermissionController extends BaseController{

  askLocationPermission(BuildContext context){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PermissionDialog(
          showGif: true,
          image: 'assets/images/location_permission_image.svg',
          label: appConstant.locationPermissionRequired,
          description:appConstant.locationPermissionText,
          callback: (value){
            Get.back();
          askNotificationPermission(context);
          },
        );
      },
      barrierDismissible: false,
    );
  }

  askNotificationPermission(BuildContext context){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PermissionDialog(
          showGif: true,
          image: 'assets/images/notification_permission_image.svg',
          label: appConstant.notificationPermissionRequired,
          description:appConstant.notificationText,
          callback: (value){
            Get.offAllNamed(AppRoutes.homeScreen);
          },
        );
      },
      barrierDismissible: false,
    );
  }
  @override
  void onReady() {

    super.onReady();
    if(Get.context !=null){
      askLocationPermission(Get.context!);
    }
  }



}