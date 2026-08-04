import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:player/base_controller.dart';
import 'package:player/data/modal/merchant/merchant_list.dart';
import '../data/local/shared_prefs.dart';
import '../data/modal/GetMerchantPaymentResponse.dart';
import '../data/modal/MySteryBoxDetailsResponse.dart';
import '../data/modal/MySteryBoxResponse.dart';
import '../data/modal/RedeemableItemResponse.dart';
import '../data/modal/game/PlayerDetailsResponse.dart';
import '../data/modal/leaderboard/LeaderboardDetailResponse.dart';
import '../data/modal/leaderboard/LeaderboardResponse.dart';
import '../data/modal/signup_response.dart';
import '../data/network/api_endpoints.dart';
import '../routes/app_routes.dart';
import '../data/network/api_service.dart';
import '../utils/app_color.dart';

class MerchantController extends BaseController {
  var selected = "halal".obs;
  var selectedValue = "Halal".obs;
  var mList = <MerchantData>[];
  var leaderList = <LeaderboardList>[];
  var mysteryList = <MySteryBoxList>[];
  var redeemList = <RedeemableItemList>[];
  var playername = "".obs;
  // var redeemListDetail = <RedeemableItemList>[];
  RedeemableDetails? redeemListDetail;
  var leaderDetail = <LeaderboardDetail>[];

  /// Error messages surfaced by the leaderboard screens. Empty when the last
  /// load succeeded. The screens show these inline instead of a bare toast.
  var leaderListError = "";
  var leaderDetailError = "";
  MerchantData? mData ;
  MySteryBoxDetails? mBoxData ;
  Rx<GetMerchantPaymentResponse>? merchantPaymentResponse = GetMerchantPaymentResponse().obs;
  var path = "".obs;
  var playerDetailsInfo = "".obs;
  var referralCode = "".obs;
  var uploadedProfileImage = "".obs;
  File? profilePic;

  logoutApi(){
    apiService.postRequestEmpty(ApiEndPoint.getLogout, isBearer: true).then((value) {
      if (value.data != null) {
        var data = LogoutResponse.fromJson(value.data!);
        // Fluttertoast.showToast(msg: data.message ?? "");
        // Clear the saved session and return to the login screen so the user
        // can sign in again.
        SharedPref.clearPref();
        Get.offAllNamed(AppRoutes.loginScreen);
      } else {
        Fluttertoast.showToast(msg: value.error.toString());
      }
    });
  }

  merchantList(String zoneName, String type,VoidCallback callback) {
    appController.getProfile(() {
      var data = appController.profileData;
      data;

      apiService.getRequest(ApiEndPoint.merchantList+"zoneName=$zoneName&merchantType=$type", isBearer: true)
          .then((value) {
        if (value.data != null) {
            mList = GetMerchantListResponse.fromJson(value.data!).data;

            callback.call();

        } else {
          Fluttertoast.showToast(msg: value.error.toString());
        }
      });
    });
  }

  getProfileInfo(){

    appController.getProfile(() async {
      playername.value = appController.profileData?.nickName ?? "";
    });

  }

  leaderboardList(VoidCallback callback) async {
    var userID =  await SharedPref.getID() ?? "";
    appController.getProfile(() {
      var data = appController.profileData;
      data;

      apiService.getRequest("${ApiEndPoint.leaderboardList}player_id=$userID", isBearer: true).then((value) {
        if (value.data != null) {
          leaderList = LeaderboardResponse.fromJson(value.data as Map<String, dynamic>).data as List<LeaderboardList>;
          leaderListError = "";
        } else {
          // e.g. 400 "You have not participated in any game yet" — surface the
          // server message inline rather than as a bare toast.
          leaderList = [];
          leaderListError = value.error ?? "Something went wrong";
        }
        callback.call();
      }).catchError((e) {
        leaderList = [];
        leaderListError = "Something went wrong";
        callback.call();
      });
    });
  }

  mysteryBoxList(VoidCallback callback) async {

    appController.getProfile(() {
      var data = appController.profileData;
      data;

      apiService.getRequest(ApiEndPoint.mySteryBoxList, isBearer: true).then((value) {
        if (value.data != null) {

          mysteryList = MySteryBoxResponse.fromJson(value.data as Map<String, dynamic>).data as List<MySteryBoxList>;
          callback.call();

        } else {
          Fluttertoast.showToast(msg: value.error.toString());
        }
      });
    });
  }

  redeemableList(VoidCallback callback) async {

    appController.getProfile(() {
      var data = appController.profileData;
      data;

      apiService.getRequest(ApiEndPoint.redeemableList, isBearer: true).then((value) {
        if (value.data != null) {

          redeemList = RedeemableItemResponse.fromJson(value.data as Map<String, dynamic>).data as List<RedeemableItemList>;
          callback.call();

        } else {
          Fluttertoast.showToast(msg: value.error.toString());
        }
      });
    });
  }

  mysteryBoxDetail(VoidCallback callback,String ID) async {

    apiService.getRequest("${ApiEndPoint.mySteryBoxDetail}mysteryBox_id=$ID", isBearer: true).then((value) {
      if (value.data != null) {

        mBoxData = MySteryBoxDetailsResponse.fromJson(value.data as Map<String, dynamic>).data as MySteryBoxDetails;
        callback.call();

      } else {
        Fluttertoast.showToast(msg: value.error.toString());
      }
    });
  }

  redeemableDetail(VoidCallback callback,String ID) async {

    apiService.getRequest("${ApiEndPoint.redeemableDetail}id=$ID", isBearer: true).then((value) {
      if (value.data != null) {

        redeemListDetail = RedeemableDetailsResponse.fromJson(value.data as Map<String, dynamic>).data as RedeemableDetails;
        callback.call();

      } else {
        Fluttertoast.showToast(msg: value.error.toString());
      }
    });
  }

  leaderboardDetail(String gameID,VoidCallback callback) async {
    appController.getProfile(() {
      var data = appController.profileData;
      data;

      apiService.getRequest("${ApiEndPoint.leaderboardDetail}game_unique_id=$gameID", isBearer: true).then((value) {
        if (value.data != null) {
          leaderDetail = LeaderboardDetailResponse.fromJson(value.data as Map<String, dynamic>).data as List<LeaderboardDetail>;
          leaderDetailError = "";
        } else {
          leaderDetail = [];
          leaderDetailError = value.error ?? "Something went wrong";
        }
        callback.call();
      }).catchError((e) {
        leaderDetail = [];
        leaderDetailError = "Something went wrong";
        callback.call();
      });
    });
  }

  getPlayerDetail(String gameId,String outletID,VoidCallback  callback) async {
    var userID =  await SharedPref.getUserID() ?? "";
    apiService.getRequest("${ApiEndPoint.getPlayerDetails}game_unique_id=$gameId&player_unique_id=$userID",isBearer: true).then((value) {
      if(value.data !=null){
        var data = PlayerDetailsResponse.fromJson(value.data!);
        data.data?.outletUnique_id = outletID;
        playerDetailsInfo.value = jsonEncode(data);
        callback.call();
      }else{
        Fluttertoast.showToast(msg: value.error.toString());
      }
    });
  }

  getPlayerUniqueId(VoidCallback  callback){
    apiService.postRequest(ApiEndPoint.uniqueId, {}).then((value) {
      if(value.data !=null){
        var json = value.data;
        // unique_id.value = json?["unique_id"];
        // unique_id.value = "SP032";
        callback.call();
      }
    });
  }

  getPlayerPaymentDetail(String gameId,String merchantId,VoidCallback  callback) async {
    var userID =  await SharedPref.getID() ?? "";
    apiService.getRequest("${ApiEndPoint.getPlayerPaymentDetails}game_unique_id=$gameId&player_id=$userID&merchant_id=$merchantId",isBearer: true).then((value) {
      if(value.data !=null){
        var data = GetMerchantPaymentResponse.fromJson(value.data!);
        merchantPaymentResponse?.value = data;
        callback.call();
      }else{
        // Fluttertoast.showToast(msg: value.error.toString());
      }
    });
  }

  pickImage({bool camera = false, BuildContext? context, bool insuranceCard = false}) async {
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
            hideBottomControls: false,
            lockAspectRatio: false,
            aspectRatioPresets: [
              CropAspectRatioPreset.square,
            ],
            statusBarColor: Colors.black, // avoids white text overlap
            initAspectRatio: CropAspectRatioPreset.original,
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
      uploadedProfileImage.value= result;
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

  gameComplete(String gameUniqueId,
            String? startGame,
            String? endGame,
            String gameName,
            bool lastIndex,
            String outletId,
            String outletName,
      VoidCallback  callback){
    appController.getProfile(() async {
      var data =  appController.profileData;
      var userID =  await SharedPref.getUserID() ?? "";

      var req =  Map<String, dynamic>();
      req["player_id"] = data?.id.toString();
      req["playerUniqueID"] = userID;
      req["gameUniqueID"] = gameUniqueId;
      req["game_name"] = gameName;
      req["merchantID"] = outletId;
      req["outlet_name"] = outletName;
      req["complete_status"] = "1";
      req["completion_datetime"] = DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now());

      if(startGame==null){
        req["start_timer_count"] = DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now());
      }

      if(endGame==null && startGame!=null && lastIndex){
        req["end_timer_count"] = DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now());
      }

      req["outletImage"] = uploadedProfileImage.value;

      apiService.postRequest(ApiEndPoint.gameCompletion,req,isBearer: true).then((value) {
        if(value.data !=null){
          callback.call();
        }else{
          Fluttertoast.showToast(msg: value.error.toString());
        }
      });
    });
  }
}