import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:player/app_controller.dart';
import 'package:player/data/network/api_endpoints.dart';
import 'package:player/game/game_controller.dart';
import 'package:player/game/game_detail_screen.dart';
import 'package:player/utils/app_utils.dart';

import '../3dView/home_screen_player.dart';
import '../routes/app_routes.dart';
import '../utils/app_color.dart';
import '../utils/app_components.dart';

class GameListScreen extends StatefulWidget {
  const GameListScreen({super.key});

  @override
  State<GameListScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameListScreen> {
  var controller = Get.put(GameController());
  var appC= Get.find<AppController>();
  @override
  void initState() {

    controller.getGameList(appC.gameZone,(){
      setState(() {
        controller.getProfileInfo();
      });
    });
    super.initState();
  }


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
            Container(
              child: Column(
                children: [
                  /// top navigation
                  Container(
                    margin: EdgeInsets.only(
                        top: 30,
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

                  Container(
                    margin: EdgeInsets.only(
                        top: 30,
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
                          color: Colors.grey,
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

                  /// spend logo
                  Container(
                    margin: EdgeInsets.only(
                        top: 40,
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
                        top: 30,
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
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(12)),
                        child:  Container(
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
                              Container(
                                child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    itemCount: controller.gameList.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      var data = controller.gameList[index];
                                      return InkWell(
                                        onTap: (){
                                          if(data.status == "COMPLETED"){
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
                                                            "Do you really want to Restart the game? Your previously completed game data will be remain in system.",
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
                                                                    controller.resetFromList.value = true;
                                                                    controller.getResetGameFromList(data.gameUniqueId);
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

                                          }else{
                                            controller.gameData = data;
                                            Get.toNamed(AppRoutes.gameList)?.then((v){
                                              controller.getGameList(appC.gameZone,(){
                                                setState(() {

                                                });
                                              });
                                            });
                                          }
                                        },
                                        child: Container(
                                          margin: EdgeInsets.all(5),
                                          child: Container(
                                            padding: EdgeInsets.all(9),
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [AppColors.white, AppColors.darkGray], // gradient colors
                                                begin: Alignment.topCenter,             // gradient start point
                                                end: Alignment.bottomCenter,           // gradient end point
                                              ),
                                              borderRadius: BorderRadius.circular(16), // optional
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                data.gamePoster.isNotEmpty?
                                                Container(
                                                  margin: EdgeInsets.only(left: 10),
                                                  height: 80,
                                                  width: 80,
                                                  child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(12),
                                                      child: AppUtils.remoteImageLoader(ApiEndPoint.imageBaseUrl+data.gamePoster)),
                                                ):
                                                Container(
                                                  margin: EdgeInsets.only(left: 10),
                                                  height: 80,
                                                  width: 80,
                                                  child: AppUtils.remoteImageLoader("assets/images/m3/temp_game_bg.png"),
                                                ),
                                                SizedBox(width: 18,),
                                                Expanded(child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    AppComponents.text(data.gameName,color: Colors.black,size: 15),
                                                    SizedBox(height: 1,),
                                                    AppComponents.text(data.totalOutlet.toString()+" Stations",color: Colors.black,size: 13),
                                                    SizedBox(height: 1,),
                                                    AppUtils.ratingView(4),
                                                    AppComponents.text("Click here for more info",
                                                        color: Colors.black,enableUnderLine: true,textOverflow: TextOverflow.clip,size: 13),
                                                    SizedBox(height: 4,),
                                                    Row(
                                                      children: [
                                                        AppComponents.text(data.status ?? "",
                                                            color: data.status == "COMPLETED" ? AppColors.red : data.status == "GAME NOT STARTED YET" ? AppColors.darkGreen : AppColors.appYellowColor,
                                                            enableUnderLine: false,
                                                            textAlign: TextAlign.end,
                                                            size: 12),
                                                        if(data.status == "COMPLETED" && data.CompletedTime!=null && data.CompletedTime?.isNotEmpty == true)...[
                                                          Spacer(),
                                                          AppComponents.text(/*AppUtils().convertToAmPm(data.CompletedTime ?? "")*/data.CompletedTime ?? "",
                                                              color: AppColors.black, size: 10)
                                                        ],
                                                      ],
                                                    ),
                                                  ],
                                                ))
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                            ],
                          ),
                        )
                    ),),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}