import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:player/app_controller.dart';
import 'package:player/game/game_list_screen.dart';
import 'package:player/utils/app_utils.dart';

import '../utils/app_color.dart';
import '../utils/app_components.dart';

class SelectGameZone extends StatefulWidget {
  const SelectGameZone({super.key});

  @override
  State<SelectGameZone> createState() => _GameScreenState();
}

class _GameScreenState extends State<SelectGameZone> {
  var controller = Get.find<AppController>();

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
              color: Colors.grey
                  .withOpacity(0.2), // Adjust opacity and color as needed
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
                      onTap: () {
                        Get.back();
                      },
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                      )),
                  Spacer(),
                  AppComponents.text("Spendrathon Games",
                      fontWeight: FontWeight.w700,
                      size: 25,
                      color: Colors.white),
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
                margin: EdgeInsets.only(
                    left: 18,
                    top: MediaQuery.of(context).size.height * .27,
                    right: 18),
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
                          borderRadius: BorderRadius.circular(12)),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 23, right: 23),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  AppUtils.remoteImageLoader(
                                      "assets/images/m2/barline_v2.png"),

                                  SizedBox(
                                    height: 15,
                                  ),
                                  Align(
                                      alignment: Alignment.center,
                                      child: AppComponents.text(
                                          "Please Select The Game Zone",
                                          size: 20,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.white)),
                                  SizedBox(
                                    height: 10,
                                  ),

                                  /// all and east
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: AppComponents.zoneButton("ALL",onTap: (){
                                            controller.gameZone = "All";
                                            Get.to(GameListScreen());
                                          })),
                                      SizedBox(width: 12,),
                                      Expanded(
                                          child: AppComponents.zoneButton("EAST",onTap: (){
                                            controller.gameZone = "East";

                                            Get.to(GameListScreen());
                                          })),
                                    ],
                                  ),

                                  /// west and north
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: AppComponents.zoneButton("WEST",onTap: (){
                                            controller.gameZone = "West";

                                            Get.to(GameListScreen());
                                          })),
                                      SizedBox(width: 12,),
                                      Expanded(
                                          child: AppComponents.zoneButton("NORTH",onTap: (){
                                            controller.gameZone = "North";

                                            Get.to(GameListScreen());
                                          })),
                                    ],
                                  ),

                                  /// south and central
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: AppComponents.zoneButton("SOUTH",onTap: (){
                                            controller.gameZone = "South";

                                            Get.to(GameListScreen());
                                          })),
                                      SizedBox(width: 12,),
                                      Expanded(
                                          child: AppComponents.zoneButton("CENTRAL",onTap: (){
                                            controller.gameZone = "Central";

                                            Get.to(GameListScreen());
                                          })),
                                    ],
                                  ),

                                  SizedBox(
                                    height: 30,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
