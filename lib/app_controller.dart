import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:player/app_constant/chinese_constants.dart';
import 'package:player/data/modal/get_profile_response.dart';
import 'package:player/data/modal/leaderboard/LeaderboardResponse.dart';
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

  /// Games the player has already participated in (game-participate-list API).
  var participatedGames = <LeaderboardList>[].obs;
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
        // Reaching the profile failed (e.g. no internet / DNS failure). Show a
        // dismissible message with a Retry action instead of failing silently.
        if (value.error != null) {
          showConnectionError(value.error!, onRetry: () => getProfile(callback));
        }
      }
    });
  }

  /// Shows a snackbar for a failed request with a RETRY action. Used for
  /// connectivity failures (see [kConnectionErrorMessage]) so the user can
  /// recover once the network is back, rather than being stuck on a blank
  /// screen. Only one snackbar is shown at a time.
  void showConnectionError(String message, {VoidCallback? onRetry}) {
    if (Get.isSnackbarOpen) return;
    Get.snackbar(
      "Connection problem",
      message,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(12),
      backgroundColor: const Color(0xFF323232),
      colorText: const Color(0xFFFFFFFF),
      duration: const Duration(seconds: 5),
      mainButton: onRetry == null
          ? null
          : TextButton(
              onPressed: () {
                if (Get.isSnackbarOpen) Get.back();
                onRetry();
              },
              child: const Text(
                "RETRY",
                style: TextStyle(
                  color: Color(0xFF4FC3F7),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
    );
  }

  /// Fetches the games the player has already participated in. Uses the id
  /// already obtained from [getProfile] — does NOT call the profile API again.
  getParticipateList(String playerId, VoidCallback callback){
    apiService
        .getRequest("${ApiEndPoint.leaderboardList}player_id=$playerId",
            isBearer: true)
        .then((value) {
      if (value.data != null) {
        participatedGames.value =
            LeaderboardResponse.fromJson(value.data as Map<String, dynamic>)
                    .data ??
                [];
      } else {
        participatedGames.value = [];
      }
      callback.call();
    });
  }
}