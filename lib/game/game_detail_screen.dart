import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:player/game/game_controller.dart';
import 'package:player/game/selecthalalnonhalal/select_halal_non_halal.dart';
import 'package:player/utils/app_utils.dart';

import '../3dView/home_screen_player.dart';
import '../data/network/api_endpoints.dart';
import '../map/game_tracker.dart';
import '../utils/app_color.dart';
import '../utils/app_components.dart';

class GameDetailScreen extends StatefulWidget {
  const GameDetailScreen({super.key});

  @override
  State<GameDetailScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameDetailScreen> {
  var controller = Get.put(GameController());
  var isChecked = false;

  @override
  Widget build(BuildContext context) {
    var data = controller.gameData!;
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
              color: Colors.grey
                  .withOpacity(0.2), // Adjust opacity and color as needed
            ),

            Column(
              children: [
                /// top navigation
                Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * .05,
                      left: 18,
                      right: 18),
                  child: Row(
                    children: [
                      InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.white,
                          )),
                      Spacer(),
                      AppComponents.text("Game Details",
                          fontWeight: FontWeight.w700,
                          size: 25,
                          color: Colors.white),
                      Spacer(),
                      /*if(controller.gameData?.start_timer_count != null)...[
                        InkWell(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Player'),
                                      content: const Text('Do you really want to reset your game? This action will remove all completed stations detail.'),
                                      actions: <Widget>[
                                        TextButton(
                                          child: const Text('cancel'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                            child: const Text('Reset'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              controller.getResetGame();
                                            }),
                                      ],
                                    );
                                  });
                            },
                            child: Container(
                              width: 25,
                              height: 25,
                              child: Image.asset(
                                "assets/images/ic_reset.jpg",
                              ),
                            )),
                        SizedBox(width: 10,),
                      ]*/
                      InkWell(
                          onTap: () {
                            Get.offAll(HomeScreenPlayer());
                          },
                          child: Icon(
                            Icons.home,
                            size: 30,
                            color: Colors.white,
                          )),
                    ],
                  ),
                ),
                /// steps
                Container(
                  margin: EdgeInsets.only(
                      top: 40,
                      left: 18,
                      right: 18),
                  child: Row(
                    children: [
                      SizedBox(width: 18,),
                      Expanded(child: Container(
                        color: Colors.yellow,
                        height: 4,

                      )),
                      SizedBox(width: 18,),
                      Expanded(child: Container(
                        color: Colors.yellow,
                        height: 4,

                      )),
                      SizedBox(width: 18,),
                      Expanded(child: Container(
                        color: Colors.grey,
                        height: 4,

                      )),
                      SizedBox(width: 18,),


                    ],
                  ),
                ),
                Expanded(child: SingleChildScrollView(
                  child: Column(
                    children: [
                      /// spend logo
                      Container(
                        margin: EdgeInsets.only(
                            top: 30,
                            left: 40,
                            right: 40),
                        child: Image.asset(
                          "assets/images/m2/start_bg_logo.png",
                        ),
                      ),
                      if(controller.gameData?.start_timer_count != null)...[
                        InkWell(
                            onTap: () {
                              var name = controller.playername.value;
                              showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (_) => Dialog(
                                  backgroundColor: Colors.transparent,
                                  insetPadding: const EdgeInsets.symmetric(horizontal: 24),
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      // Popup Body
                                      Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF2C2C2C),
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const SizedBox(height: 24),
                                            Text(
                                              name,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            const Text(
                                              "Do you really want to reset your game? This action will remove all completed stations detail.",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.white70,
                                                fontSize: 14,
                                              ),
                                            ),
                                            const SizedBox(height: 20),
                                            const Divider(color: Colors.white24),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text(
                                                      "Cancel",
                                                      style: TextStyle(
                                                        color: Colors.white70,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                      controller.getResetGame(data.gameUniqueId);
                                                    },
                                                    child: const Text(
                                                      "Reset",
                                                      style: TextStyle(
                                                        color: Colors.redAccent,
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),

                                      // Warning Icon
                                      Positioned(
                                        top: -35,
                                        left: 0,
                                        right: 0,
                                        child: CircleAvatar(
                                          backgroundColor: Colors.redAccent,
                                          radius: 35,
                                          child: const Icon(
                                            Icons.warning_amber_rounded,
                                            color: Colors.white,
                                            size: 30,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              width: 150,
                              height: 45,
                              padding: EdgeInsets.all(3),
                              margin: EdgeInsets.only(top: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                  borderRadius: BorderRadius.circular(50)),
                              child: Row(
                                children: [
                                  Image.asset(
                                    "assets/images/ic_reset.png",
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  AppComponents.text("Game reset",color: Colors.black)
                                ],
                              ),
                            )),
                      ],
                      /// glass transparent
                      /// main view
                      Container(
                        width: 327,
                        padding: EdgeInsets.only(bottom: 10),
                        margin: EdgeInsets.only(
                          top: 15,
                          left: 40,
                          right: 40,),
                        decoration: BoxDecoration(
                            image: DecorationImage(image: AssetImage("assets/images/m3/game_detail_bg.png"),fit: BoxFit.fill),
                            borderRadius: BorderRadius.circular(12)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 23, right: 23),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 15,
                                  ),

                                  Align(
                                    alignment: Alignment.center,
                                    child:   data.gamePoster.isNotEmpty?
                                    Container(
                                      margin: EdgeInsets.only(left: 18,right: 18),
                                      height: 120,

                                      child: ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: AppUtils.remoteImageLoader(ApiEndPoint.imageBaseUrl+data.gamePoster)),
                                    ):

                                    Container(
                                      margin: EdgeInsets.only(left: 18),
                                      height: 80,
                                      width: 80,
                                      child: AppUtils.remoteImageLoader("assets/images/m3/temp_game_bg.png"),
                                    ),
                                  ),
                                  SizedBox(height: 12,),
                                  Align(
                                      alignment: Alignment.center,
                                      child: AppComponents.text(data.gameName,color: Colors.black,size: 16, fontWeight: FontWeight.w700)),

                                  /// number of stations


                                  SizedBox(height: 12,),
                                  Row(children: [
                                    Expanded(child: AppComponents.text("Total Stations:",color: Colors.black)),
                                    SizedBox(width: 12,),
                                    AppComponents.text(data.totalOutlet.toString(),color: Colors.black)

                                  ],),
                                  SizedBox(height: 6,),
                                  // Divider(color: Colors.black,),
                                  /// date of competition
                                  SizedBox(height: 6,),
                                  Row(children: [
                                    Expanded(child: AppComponents.text("Game Period:",color: Colors.black)),
                                    SizedBox(width: 12,),
                                    AppComponents.text( data.gameEndDate??"",color: Colors.black)

                                  ],),
                                  SizedBox(height: 6,),

                                  // Divider(color: Colors.black,),
                                  /// winner prize
                                  SizedBox(height: 6,),
                                  Row(children: [
                                    Expanded(child: AppComponents.text("Winning Prize",color: Colors.black)),
                                    SizedBox(width: 12,),
                                    AppComponents.text(data.prize??"",color: Colors.black)
                                  ],),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.only(
                              top: 25,
                              left: 20,
                              right: 20),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  // Checkbox(value: isChecked, onChanged: (value){
                                  //   setState(() {
                                  //     isChecked = value!;
                                  //   });
                                  //
                                  // }, side: BorderSide(
                                  //   color: Colors.white, // Outline/border color
                                  //   width: 2, // Optional: thickness of the border
                                  // ),),
                                  Spacer(),
                                  AppComponents.text("Please Select Your Game Station Preference",color: Colors.white,fontWeight: FontWeight.w700,size: 16),
                                  Spacer()
                                ],
                              ),
                              SizedBox(height: 18,),
                              Row(
                                children: [
                                  Expanded(child: AppComponents.appButton("Halal Station",textSize: 12,onTap: (){
                                    controller.getGameDetail(controller.gameData?.gameUniqueId??"", "Halal", () {
                                      controller.appController.selectHalalNonHalaValue = "Halal";
                                      Get.to(SelectHalalNonHalal());
                                    });
                                  })),
                                  SizedBox(width: 12,),
                                  Expanded(child: AppComponents.appButton("Non Halal Station",textSize: 12,onTap: (){
                                    controller.getGameDetail(controller.gameData?.gameUniqueId??"", "Non-Halal", () {
                                      controller.appController.selectHalalNonHalaValue = "Non-Halal";
                                      Get.to(SelectHalalNonHalal());
                                    });
                                  })),
                                ],
                              )
                            ],
                          )
                      )
                    ],
                  ),
                ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
