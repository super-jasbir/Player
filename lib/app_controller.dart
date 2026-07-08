import 'dart:ui';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:player/app_constant/chinese_constants.dart';
import 'package:player/data/modal/get_profile_response.dart';
import 'package:player/data/network/api_endpoints.dart';
import 'package:player/data/network/api_service.dart';

import 'app_constant/english_constant.dart';

class AppController extends GetxController{
  dynamic appConstant = EnglishLanguage();
  var locationLatLng = "";
  var currentLoc = "".obs;
  var isEnglish = true;
  var apiService = ApiService();
  var playerId = "";
  var userId = "";
  var deviceType = "";
  var id = "";
  var deviceToken = "";
  var gameZone = "";
  var gameName = "";
  var gameUniqueId = "";
  var selectedNation = "";
  var merchantZone = "";
  var selectHalalNonHalaValue = "Non-Halal";
  ProfileData? profileData;
  var hasData = false.obs;
  var uploadedImage = "".obs;
  selectLanguage(String language){
    if(language =="Chinese"){
      /// chienese
      appConstant   = ChineseLanguage();
      isEnglish = false;
      update();
    }else{
      /// english
      appConstant = EnglishLanguage();
      isEnglish = true;
      update();

    }
  }

  getProfile(VoidCallback callback){
    hasData.value = false;
    apiService.getRequest(ApiEndPoint.getProfile,isBearer: true).then((value) {
      if(value.data !=null){
        profileData = GetProfileResponse.fromJson(value.data!).data;
        hasData.value  = true;
        callback.call();
      }else{
        hasData.value  = false;
      }
    });
  }
}