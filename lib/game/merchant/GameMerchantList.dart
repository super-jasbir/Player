import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:player/app_controller.dart';
import 'package:player/data/network/api_endpoints.dart';
import 'package:player/game/game_list_screen.dart';
import 'package:player/game/merchant/merchant_qr.dart';
import 'package:player/merchant/merchant_controller.dart';
import 'package:player/merchant/merchant_detail_screen.dart';
import 'package:player/utils/app_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../3dView/home_screen_player.dart';
import '../../routes/app_routes.dart';
import '../../utils/app_color.dart';
import '../../utils/app_components.dart';
import '../game_controller.dart';

class GameMerchantList extends StatefulWidget {
  const GameMerchantList({super.key});

  @override
  State<GameMerchantList> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameMerchantList> {
  var controller = Get.put(GameController());
  var appC = Get.find<AppController>();

  late DateTime oldTime;
  late DateTime newTime;
  late Timer? _timer;
  Duration diff = Duration.zero;
  DateTime now = DateTime.now();

  @override
  void initState() {
    appC.selectedNation;

    controller.getGameDetail(controller.gameData?.gameUniqueId ?? "",
        controller.appController.selectHalalNonHalaValue, () {
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    if(controller.gameInfo.value.end_timer_count==null && controller.gameInfo.value.start_timer_count!=null){
      if(_timer!=null){
        _timer?.cancel();
      }
    }
    super.dispose();
  }

  String formatAsHHMMSS(Duration diff) {
    int hours = diff.inHours; // total hours (can exceed 24)
    int minutes = diff.inMinutes % 60;
    int seconds = diff.inSeconds % 60;

    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(seconds)}";
  }


  @override
  Widget build(BuildContext context) {

    if(controller.gameInfo.value.end_timer_count==null && controller.gameInfo.value.start_timer_count!=null){
      // Fixed old time
      oldTime = DateTime.parse(controller.gameInfo.value.start_timer_count ?? "00:00:00");

      // Update every second
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        setState(() {
          now = DateTime.now();
          diff = now.difference(oldTime);
        });
      });
    }
    else if(controller.gameInfo.value.end_timer_count!=null && controller.gameInfo.value.start_timer_count!=null){
      oldTime = DateTime.parse(controller.gameInfo.value.start_timer_count ?? "00:00:00");
      newTime = DateTime.parse(controller.gameInfo.value.end_timer_count ?? "00:00:00");

      diff = newTime.difference(oldTime);
    }

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
                  AppComponents.text("Merchant List",
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
                    left: 15,
                    bottom: 10,
                    top: MediaQuery.of(context).size.height * .27,
                    right: 15),
                // Set the desired width

                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/m3/merchant_bg.png"),
                    fit: BoxFit.fill,
                    colorFilter: ColorFilter.mode(
                      Colors.black, // Solid black color
                      BlendMode.srcIn, // Replaces the image with the color
                    ),
                  ),
                  // Rounded corners
                ),
                child: Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 30),
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(12)),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                controller.gameInfo.value.start_timer_count != null ? formatAsHHMMSS(diff) :
                                controller.gameInfo.value.end_timer_count != null ? formatAsHHMMSS(diff) : "00:00:00",
                                style: TextStyle(
                                    fontSize: 40, color: Colors.white),
                              ),
                            ),
                            Container(
                                height: MediaQuery.of(context).size.height * .7,
                                margin: EdgeInsets.only(
                                    left: 15, right: 15, top: 0, bottom: 30),
                                child: controller.outletList.isNotEmpty
                                    ? ListView.builder(
                                        itemCount: controller.outletList.length,
                                        itemBuilder: (context, index) {
                                          var data = controller.outletList[index];
                                          return InkWell(
                                            onTap: () {},
                                            child: Container(
                                              margin: EdgeInsets.only(top: 10,bottom: (index + 1) == controller.outletList.length ? 200 : 0),
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(12)),
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Container(
                                                    height: 50,
                                                    width: 50,
                                                    child: ClipOval(
                                                      child: AppUtils.remoteImageLoader(
                                                          ApiEndPoint
                                                                  .imageBaseUrl +
                                                              "merchant/" +
                                                              data.initalImage),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Expanded(child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      SizedBox(
                                                        height: 14,
                                                      ),

                                                      /// name
                                                      AppComponents.text(
                                                          data.outletName,
                                                          fontWeight:
                                                          FontWeight.w500,
                                                          textOverflow: TextOverflow.clip,
                                                          color: Colors.black),
                                                      SizedBox(
                                                        height: 6,
                                                      ),

                                                      AppComponents.text(
                                                          "Business Hours",
                                                          fontWeight:
                                                          FontWeight.w400,
                                                          color: Colors.black),
                                                      SizedBox(
                                                        height: 4,
                                                      ),

                                                      /// time
                                                      Row(
                                                        children: [
                                                          Icon(
                                                            Icons.timer,
                                                            color: Colors.grey,
                                                            size: 18,
                                                          ),
                                                          SizedBox(
                                                            width: 4,
                                                          ),
                                                          AppComponents.text(
                                                              data.startHours +
                                                                  " - " +
                                                                  data.endHours,
                                                              fontWeight:
                                                              FontWeight
                                                                  .w400,
                                                              color:
                                                              Colors.black,
                                                              size: 12)
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 6,
                                                      ),

                                                      Container(
                                                        width: 120,
                                                        margin: EdgeInsets.only(
                                                            right: 8),
                                                        child: AppComponents.text(
                                                            "Minimum Spending SG \$ ${data.minimumSpending}",
                                                            size: 13,
                                                            maxLine: 2,
                                                            fontWeight:
                                                            FontWeight.w500,
                                                            color:
                                                            Colors.black),
                                                      ),
                                                      SizedBox(
                                                        width: 8,
                                                      ),

                                                      /// location
                                                      // Row(
                                                      //   children: [
                                                      //     Icon(
                                                      //       Icons
                                                      //           .location_on_outlined,
                                                      //       color: Colors.grey,
                                                      //       size: 18,
                                                      //     ),
                                                      //     SizedBox(
                                                      //       width: 4,
                                                      //     ),
                                                      //     Container(
                                                      //       width: 120,
                                                      //       child:  AppComponents.text(
                                                      //           data.outletAddress,
                                                      //           maxLine: 3,
                                                      //           fontWeight:
                                                      //           FontWeight.w400,
                                                      //           color: Colors.black,
                                                      //           size: 12),
                                                      //     )
                                                      //   ],
                                                      // ),

                                                      SizedBox(
                                                        height: 4,
                                                      ),
                                                      InkWell(
                                                          onTap: () {
                                                            controller.outletDetail = data;
                                                            Get.toNamed(AppRoutes.merchantQR,arguments: {
                                                              "game_unique_id":controller.gameData?.gameUniqueId,
                                                            })?.then((v){
                                                              controller.getGameDetail(controller.gameData?.gameUniqueId ?? "",
                                                                  controller.appController.selectHalalNonHalaValue, () {
                                                                    setState(() {
                                                                      if(controller.gameInfo.value.end_timer_count==null && controller.gameInfo.value.start_timer_count!=null){
                                                                        // Fixed old time
                                                                        oldTime = DateTime.parse(controller.gameInfo.value.start_timer_count ?? "00:00:00");

                                                                        // Update every second
                                                                        _timer = Timer.periodic(const Duration(seconds: 1), (_) {
                                                                          setState(() {
                                                                            now = DateTime.now();
                                                                            diff = now.difference(oldTime);
                                                                          });
                                                                        });
                                                                      }
                                                                      else if(controller.gameInfo.value.end_timer_count!=null && controller.gameInfo.value.start_timer_count!=null){
                                                                        oldTime = DateTime.parse(controller.gameInfo.value.start_timer_count ?? "00:00:00");
                                                                        newTime = DateTime.parse(controller.gameInfo.value.end_timer_count ?? "00:00:00");
                                                                        if(_timer!=null){
                                                                          _timer?.cancel();
                                                                        }
                                                                        diff = newTime.difference(oldTime);
                                                                      }
                                                                    });
                                                                  });
                                                            });
                                                          },
                                                          child: AppComponents.text(
                                                              "Click To Start",
                                                              enableUnderLine: true,
                                                              color: AppColors.darkGreen)),
                                                      SizedBox(
                                                        height: 10,
                                                      )
                                                    ],
                                                  )),
                                                  data.isGameStarted == 1
                                                      ? Container(
                                                    height: 25,
                                                    margin: EdgeInsets.only(right: 15,left: 15),
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape
                                                            .circle,
                                                        border: Border.all(
                                                            color: Colors
                                                                .green,
                                                            width: 1)),
                                                    child: Center(
                                                        child: Icon(
                                                          Icons.check,
                                                          color: Colors.green,
                                                          size: 13,
                                                        )),
                                                  ) : Container(),
                                                ],
                                              ),
                                            ),
                                          );
                                        })
                                    : Align(
                                        alignment: Alignment.center,
                                        child: AppComponents.text(
                                            "   No Merchant Available In This Zone    ",
                                            color: Colors.black)))
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
