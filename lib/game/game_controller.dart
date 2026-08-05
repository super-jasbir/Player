import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:player/base_controller.dart';
import 'package:player/data/modal/game/game_detail_response.dart';
import 'package:player/data/modal/game/game_list_response.dart';
import 'package:player/data/network/api_service.dart';

import '../data/local/shared_prefs.dart';
import '../data/modal/game/PlayerDetailsResponse.dart';
import '../data/network/api_endpoints.dart';
import '../utils/app_color.dart';
import 'package:player/core/services/sound_service.dart';

class GameController extends BaseController{
  var selected = "tourism".obs;

  var gameList = <GameData>[].obs;
  var outletList = <OutletDetail>[].obs;
  var gameInfo = GameInfo().obs;
  OutletDetail? outletDetail;
  GameData? gameData;
  var path = "".obs;
  var playername = "".obs;
  var gameZoneData = "".obs;
  var resetFromList = false.obs;
  var uploadedProfileImage = "";
  File? profilePic;

  getGameList(String gameZone,VoidCallback  callback){
    gameZoneData.value = gameZone;
    apiService.getRequest(ApiEndPoint.getGameList+"$gameZone",isBearer: true).then((value) {
      if(value.data !=null){
        gameList.value = GetGameListResponse.fromJson(value.data!).data;
        callback.call();
      }else{
        Fluttertoast.showToast(msg: value.error.toString());
      }
    });
  }

  getProfileInfo(){
    appController.getProfile(() async {
      playername.value = appController.profileData?.nickName ?? "";
    });
  }

  gameComplete(String gameUniqueId,
      OutletDetail outletDetail,
      String? startGame,
      String? endGame,
      bool lastIndex,
      VoidCallback  callback){

    appController.getProfile(() async {
     var data =  appController.profileData;
     var userID =  await SharedPref.getUserID() ?? "";

     var req =  Map<String, dynamic>();
     req["player_id"] = data?.id.toString();
     req["playerUniqueID"] = userID;
     req["gameUniqueID"] = gameUniqueId;
     req["game_name"] = outletDetail.outletName;
     req["merchantID"] = outletDetail.outletId;
     req["outlet_name"] = outletDetail.outletName;
     req["complete_status"] = "1";
     req["completion_datetime"] = DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now());

     if(startGame!=null){
       req["start_timer_count"] = DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now());
     }

     if(endGame!=null){
       req["end_timer_count"] = DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now());
     }
     req["outletImage"] = uploadedProfileImage;

      apiService.postRequest(ApiEndPoint.gameCompletion,req,isBearer: true).then((value) {
        if(value.data !=null){
          SoundService.instance.playGameComplete();
          Fluttertoast.showToast(msg: "");
          callback.call();
        }else{
          Fluttertoast.showToast(msg: value.error.toString());
        }
      });
    });
  }

  getGameDetail(String gameId,String type,VoidCallback  callback){

    apiService.getRequest(ApiEndPoint.getGameDetail+"gameUniqueID=$gameId&outletType=$type",isBearer: true).then((value) {
      if(value.data !=null){
        outletList.value = GetGameDetailResponse.fromJson(value.data!).outletDetails;
        gameInfo.value = GetGameDetailResponse.fromJson(value.data!).gameInfo;

        callback.call();
      }else{
        Fluttertoast.showToast(msg: value.error.toString());
      }
    });
  }

  getResetGame(String gameID) async {
    var userID =  await SharedPref.getID() ?? "";
    apiService.getRequest("${ApiEndPoint.gameReset}$userID&game_unique_id=$gameID",isBearer: true).then((value) {
      if(value.data !=null){
        var outletList = GetGameResetResponse.fromJson(value.data!).success;
        var message = GetGameResetResponse.fromJson(value.data!).message;
        if(outletList == true){

          if(resetFromList.value){
            resetFromList.value = false;
            getGameList(gameZoneData.value, (){
              update();
            });
          }else{
            Get.back();
          }
        }
        Fluttertoast.showToast(msg: message ?? "");
      }else{
        Fluttertoast.showToast(msg: value.error.toString());
      }
    });
  }

  getResetGameFromList(String gameID) async {
    var userID =  await SharedPref.getID() ?? "";
    apiService.getRequest("${ApiEndPoint.resetCompletedGame}$userID&game_unique_id=$gameID",isBearer: true).then((value) {
      if(value.data !=null){
        var outletList = GetGameResetResponse.fromJson(value.data!).success;
        var message = GetGameResetResponse.fromJson(value.data!).message;
        if(outletList == true){

          if(resetFromList.value){
            resetFromList.value = false;
            getGameList(gameZoneData.value, (){
              update();
            });
          }else{
            Get.back();
          }
        }
        Fluttertoast.showToast(msg: message ?? "");
      }else{
        Fluttertoast.showToast(msg: value.error.toString());
      }
    });
  }

  pickImage(
      {bool camera = false,
        BuildContext? context,
        bool insuranceCard = false}) async {
    final ImagePicker picker = ImagePicker();
    try {
      XFile? pickedFile = await picker.pickImage(
        source: camera ? ImageSource.camera : ImageSource.gallery,
      );

      if (pickedFile == null) {
        // User did not pick an image, handle accordingly
        path.value = "";
        return;
      }

      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path ?? '',
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            aspectRatioPresets: [
              CropAspectRatioPreset.square,
            ],
          ),
          AndroidUiSettings(
            toolbarTitle: "Image Picker",
            toolbarColor: AppColors.appColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: false,
          ),
          IOSUiSettings(
            title: "Image Picker",
          ),
        ],
      );



      profilePic = File(croppedFile?.path ?? pickedFile.path);

      path.value = profilePic!.absolute.path;

      var result = await uploadProfilePicture(profilePic!);
      print("imageUploaded $result");
      uploadedProfileImage = result;
      appController.uploadedImage.value = result;
    } catch (e) {
      print(e);
    }
  }
  Future<String> uploadProfilePicture(File image) async {
    String profilePath = "";
    var apiService2 = ApiService2();
    try {
      final response =
      await apiService2.uploadFile(ApiEndPoint.uploadFile, 'image', image);
      if (response.statusCode == 200) {
        var image = response.data as Map<String, dynamic>;
        var d1 = image['image_url'];

        profilePath = d1;
        return profilePath;
      }
    } catch (ex) {
      print("imageError: $ex");
    }
    return profilePath;
  }
}