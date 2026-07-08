
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:player/base_controller.dart';

class HomeScreenController extends BaseController{
  final GlobalKey<ScaffoldState> homeKey = GlobalKey();
  var isValueLoaded = false.obs;
@override
  void onInit() {
    appController.getProfile((){
      isValueLoaded.value = true;

    });
    super.onInit();
  }
}