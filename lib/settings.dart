import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:player/3dView/home_screen_player.dart';
import 'package:player/game/play_game_screen.dart';
import 'package:player/leaderboard/leaderboard.dart';
import 'package:player/merchant/merchant_listing.dart';
import 'package:player/my_qr/my_qr_screen.dart';
import 'package:player/permission_temp/permission_one.dart';
import 'package:player/permission_temp/permission_two.dart';
import 'package:player/referral.dart';
import 'package:player/ui/biometric/biometric_screen.dart';
import 'package:player/utils/app_utils.dart';

import '../utils/app_color.dart';
import '../utils/app_components.dart';
import 'data/local/shared_prefs.dart';
import 'merchant/merchant_controller.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<SettingScreen> {

  var controller = Get.put(MerchantController());

  // String referralCode = "";
  getReferral() async {
    await SharedPref.getReferalCode().then((v){
       controller.referralCode.value = v ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    getReferral();
    Timer(const Duration(seconds: 1), () {
      controller.getProfileInfo();
    });

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Background Image
            Container(
              width: double.infinity,
              height: double.infinity,
              child: Image.asset(
                "assets/images/m3/setting_bg.png",
                fit: BoxFit
                    .cover, // Adjust to BoxFit.fill, BoxFit.contain, etc., as needed
              ),
            ),
            // Transparent Overlay
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.grey.withOpacity(0.2), // Adjust opacity and color as needed
            ),

            /// top navigation
            Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * .05,
                  left: 18,
                  right: 18),
              child: Row(
                children: [
                  InkWell(
                      onTap: (){
                        Get.back();
                      },
                      child: Icon(Icons.arrow_back_ios_new,color: Colors.white,)),
                  Spacer(),
                  AppComponents.text("",fontWeight: FontWeight.w700,size: 25,color: Colors.white),
                  Spacer(),

                ],
              ),
            ),
            /// spend logo
            Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * .12,
                  left: 40,
                  right: 40),
              child: Image.asset(
                "assets/images/m2/start_bg_logo.png",
              ),
            ),
            /// glass transparent
            /// main view
            Container(
                margin: EdgeInsets.only(left: 18, top: MediaQuery
                    .of(context)
                    .size
                    .height * .24, right: 18),
                // Set the desired width

                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: AppColors.borderColor),
                  color: Colors.white.withOpacity(0.3),
                  // Semi-transparent color
                  borderRadius: BorderRadius.circular(16),
                  // Rounded corners
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4), // Shadow color
                      offset: Offset(0, 4), // Shadow position
                      blurRadius: 10, // Blur radius for softness
                    ),
                  ],
                ),

                child: Stack(
                  children: [
                    Container(

                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(12)
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [


                            Container(
                              margin: EdgeInsets.only(left: 23,right: 23),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 10,),
                                  AppUtils.remoteImageLoader("assets/images/m2/barline_v2.png"),
                                  SizedBox(height: 10,),

                                  /// location
                                  Container(
                                    margin: EdgeInsets.only(top: 10),
                                    child: AppComponents.appButton(
                                        "Location",
                                        height: 70,
                                        image: "assets/images/m3/ic_location.png",
                                        onTap: (){
                                          Get.to(PermissionTwo());
                                        }
                                    ),
                                  ),

                                  /// biometric
                                  Container(
                                    margin: EdgeInsets.only(top: 10),
                                    child: AppComponents.appButton(
                                        "Biometric",
                                        height: 70,
                                        image: "assets/images/m3/ic_biometric.png",
                                        onTap: (){
                                        }
                                    ),
                                  ),

                                  /// logout
                                  Obx(()=>controller.playername.value.isNotEmpty ?  Container(
                                    margin: EdgeInsets.only(top: 10),
                                    child: AppComponents.appButton(
                                        "Logout     ",
                                        height: 70,
                                        image: "assets/images/m3/ic_logout.png",
                                        onTap: (){
                                          // Get.offAll(HomeScreenPlayer());
                                          controller.logoutApi();
                                        }
                                    ),
                                  ) : Container()),
                                  /// logout
                                  Container(
                                    margin: EdgeInsets.only(top: 10),
                                    child: AppComponents.appButton(
                                        "Referral     ",
                                        height: 70,
                                        image: "assets/images/m3/ic_referral.png",
                                        onTap: (){
                                          if(controller.referralCode.value.isNotEmpty){
                                            Get.to(Referral());
                                          }
                                        }
                                    ),
                                  ),
                                  SizedBox(height: 30,)
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                )
            ),
          ],
        ),
      ),
    );
  }
}
