import 'dart:ui';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:player/3dView/home_screen_player.dart';
import '../../base_controller.dart';
import '../../data/local/shared_prefs.dart';
import '../../data/modal/SplashBannerResponse.dart';
import '../../data/network/api_endpoints.dart';
import 'WalkthroughImageApp.dart';

class SplashScreenController extends BaseController{

  var leaderList = <SplashBannerList>[];

  splashDelay() async {
    await Future.delayed(const Duration(seconds: 10));
    final token = await SharedPref.getAccessToken();
    if (token != null && token.isNotEmpty) {
      // Returning logged-in user: skip the walkthrough/login and go straight
      // to the home screen.
      Get.offAll(HomeScreenPlayer());
    } else {
      // Not logged in: load banners and show the walkthrough / login flow.
      mysteryBoxList(() {
        Get.offAll(WalkthroughImageApp());
      });
    }
  }

  mysteryBoxList(VoidCallback callback) async {
    apiService.getRequest(ApiEndPoint.getBanners, isBearer: true).then((value) {
      if (value.data != null) {
        leaderList.clear();
        leaderList = SplashBannerResponse.fromJson(value.data as Map<String, dynamic>).data as List<SplashBannerList>;
        callback.call();
      } else {
        Get.offAll(HomeScreenPlayer());
        // Fluttertoast.showToast(msg: value.error.toString());
      }
    });
  }
}