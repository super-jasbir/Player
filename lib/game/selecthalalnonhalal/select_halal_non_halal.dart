import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:player/app_controller.dart';
import 'package:player/game/game_controller.dart';
import 'package:player/game/merchant/GameMerchantList.dart';
import 'package:player/merchant/merchant_listing.dart';
import 'package:player/utils/app_utils.dart';

import '../../3dView/home_screen_player.dart';
import '../../data/network/api_endpoints.dart';
import '../../map/game_tracker.dart';
import '../../utils/app_components.dart';

class SelectHalalNonHalal extends StatefulWidget {
  const SelectHalalNonHalal({super.key});

  @override
  State<SelectHalalNonHalal> createState() => _GameScreenState();
}

class _GameScreenState extends State<SelectHalalNonHalal> {
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
                        color: Colors.yellow,
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
                            top: 50,
                            left: 40,
                            right: 40),
                        child: Image.asset(
                          "assets/images/m2/start_bg_logo.png",
                        ),
                      ),

                      /// glass transparent
                      /// main view
                      Container(
                        width: 327,
                        padding: EdgeInsets.only(bottom: 10),
                        margin: EdgeInsets.only(
                            top: 35,
                            left: 40,
                            right: 40),
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
                                    Expanded(child: AppComponents.text("Completion Date:",color: Colors.black)),
                                    SizedBox(width: 12,),
                                    AppComponents.text(data.gameEndDate??"",color: Colors.black)

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
                                  AppComponents.text("Please Select following options",color: Colors.white,fontWeight: FontWeight.w700,size: 16),
                                  Spacer()
                                ],
                              ),
                              SizedBox(height: 18,),
                              Row(
                                children: [
                                  Expanded(child: AppComponents.appButton("Merchant Location",textSize: 12,onTap: (){
                                    controller.getGameDetail(controller.gameData?.gameUniqueId??"", controller.appController.selectHalalNonHalaValue, () {

                                      Get.to(
                                          LocationMap(
                                            outlets: controller.outletList, markerImageUrl: controller.outletList.first.initalImage.toString(),
                                            gameUniqueId: controller.gameData?.gameUniqueId??"",
                                            // Optional user location
                                          )
                                      );
                                    });



                                  })),
                                  SizedBox(width: 12,),
                                  Expanded(child: AppComponents.appButton("Start Game",textSize: 14,onTap: (){
                                    var appC = Get.find<AppController>();
                                    appC.gameName  = controller.gameData?.gameName??"";
                                    appC.gameUniqueId  = controller.gameData?.gameUniqueId??"";
                                    Get.to(GameMerchantList());

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
