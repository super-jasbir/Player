import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:player/game/play_game_screen.dart';
import 'package:player/leaderboard/leaderboard.dart';
import 'package:player/merchant/merchant_zone.dart';
import 'package:player/utils/app_utils.dart';
import '../utils/app_color.dart';
import '../utils/app_components.dart';
import 'package:player/core/services/tap_sound.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Background Image
            Container(
              width: double.infinity,
              height: double.infinity,
              child: Image.asset(
                "assets/images/m2/game_bg.png",
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
                  NoTapSound(
                    child: InkWell(
                    onTap: (){
                      Get.back();
                    },
                      child: Icon(Icons.arrow_back_ios_new,color: Colors.white,)),
                  ),
                  Spacer(),
                  AppComponents.text("",fontWeight: FontWeight.w700,size: 25,color: Colors.white),
                  Spacer(),

                ],
              ),
            ),
            /// spend logo
            Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * .14,
                  left: 40,
                  right: 40),
              child: Image.asset(
                "assets/images/m2/start_bg_logo.png",
              ),
            ),
            /// glass transparent
            /// main view
            Container(
                margin: EdgeInsets.only(left: 18, top: MediaQuery.of(context).size.height * .27, right: 18),
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
                                  /// play games
                                  Container(
                                    margin: EdgeInsets.only(top: 10),
                                    child: AppComponents.appButton(
                                        "Play Games",
                                        height: 70,
                                        image: "assets/images/m3/ic_play_game.png",
                                        onTap: (){
                                            Get.to(SelectGameZone());
                                        }
                                    ),
                                  ),
                                  /// leader board
                                  Container(
                                    margin: EdgeInsets.only(top: 10),
                                    child: AppComponents.appButton(
                                        "Leaderboard",
                                        height: 70,
                                        image: "assets/images/m3/ic_leaderboard.png",
                                        onTap: (){
                                          Get.to(Leaderboard(title: "Leaderboard",));
                                        }
                                    ),
                                  ),
                                  /// mygames
                                  Container(
                                    margin: EdgeInsets.only(top: 10),
                                    child: AppComponents.appButton(
                                        "My Games     ",
                                        height: 70,
                                        image: "assets/images/m3/ic_my_games.png",
                                        onTap: (){
                                          Get.to(Leaderboard(title: "My Games",));
                                        }
                                    ),
                                  ),
                                  /*
                                  /// my qr
                                  Container(
                                    margin: EdgeInsets.only(top: 10),
                                    child: AppComponents.appButton(
                                        "My Qr            ",
                                        height: 70,
                                        image: "assets/images/m3/ic_my_qr.png",
                                        onTap: (){
                                          Get.to(MyQrScreen());

                                        }
                                    ),
                                  ),*/
                                 /*   /// my wallet
                                  Container(
                                    margin: EdgeInsets.only(top: 10),
                                    child: AppComponents.appButton(
                                        "My wallet    ",
                                        height: 70,
                                        image: "assets/images/m3/ic_my_wallet.png",
                                        onTap: (){
                                          Fluttertoast.showToast(msg: "In-progress...");

                                        }
                                    ),
                                  ),*/
                                  /// merchant
                                  Container(
                                    margin: EdgeInsets.only(top: 10),
                                    child: AppComponents.appButton(
                                        "Merchant Details",
                                        height: 70,
                                        image: "assets/images/m3/ic_merchant.png",
                                        onTap: (){
                                          Get.to(MerchantZone());
                                        },
                                      textSize: 18
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