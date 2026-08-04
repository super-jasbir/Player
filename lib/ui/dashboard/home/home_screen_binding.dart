

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:player/ui/dashboard/home/home_screen_controller.dart';

class HomeScreenBinding extends Bindings{
  @override
  void dependencies() {
   Get.put(HomeScreenController());
  }

}
