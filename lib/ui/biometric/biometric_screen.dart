import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'biometric_controller.dart';

class Biometric extends GetView<BiometricController> {
  const Biometric({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(BiometricController());

    return Scaffold(
        body: SafeArea(
      child: Container(

        child: Container(
          margin: EdgeInsets.only(left: 18, right: 18),

          // margin: EdgeInsets.only(left: 18,right: 18),
          child: Obx(() =>
              Center(child: controller.loadUi(controller.biometricType.value))),
        ),
      ),
    ));
  }
}
