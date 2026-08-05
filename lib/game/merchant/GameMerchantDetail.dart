import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:player/app_controller.dart';
import 'package:player/game/game_controller.dart';
import 'package:player/merchant/merchant_controller.dart';
import 'package:player/utils/app_utils.dart';
import '../../utils/app_components.dart';
import '../game_list_screen.dart';
import 'GameMerchantList.dart';
import 'package:player/core/services/tap_sound.dart';

class GameMerchantDetail extends StatefulWidget {
  const GameMerchantDetail({super.key});

  @override
  State<GameMerchantDetail> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameMerchantDetail> {
  var controller = Get.find<MerchantController>();
  var gameC = Get.find<GameController>();
  var appC = Get.find<AppController>();

  @override
  void initState() {
    controller.getPlayerPaymentDetail(gameC.gameData?.gameUniqueId ?? "",
        gameC.outletDetail?.outletId.toString() ?? "", () {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    controller.uploadedProfileImage.value = "";
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
            SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * .05,
                        left: 18,
                        right: 18),
                    child: Row(
                      children: [
                        NoTapSound(
                          child: InkWell(
                          child: Container(
                            child: Icon(
                              Icons.arrow_back_ios_new,
                              color: Colors.white,
                            ),
                            width: 25,
                            height: 25,

                          ),
                          onTap: (){
                            Get.back();
                          },
                        ),
                        ),
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
                          left: 30,
                          top: 40,
                          right: 30),
                      // Set the desired width
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/images/m3/merchant_bg.png"),
                            fit: BoxFit.fill),
                        // Rounded corners
                      ),
                      child: Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(12)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                AppComponents.text(
                                    gameC.outletDetail?.outletName ?? "",
                                    color: Colors.black,
                                    size: 18,
                                    fontWeight: FontWeight.w900),
                                SizedBox(
                                  height: 16,
                                ),
                                AppComponents.text("Amount Spent",
                                    color: Colors.black, size: 16),
                                SizedBox(
                                  height: 4,
                                ),
                                if(controller.merchantPaymentResponse?.value.data!=null)...[
                                  Container(
                                      margin: EdgeInsets.only(left: 18, right: 18),
                                      child: AppComponents.textField("SG \$ ${controller.merchantPaymentResponse?.value.data?.amountPaid}",
                                          enable: false)),
                                ]else...[
                                  Container(
                                      margin: EdgeInsets.only(left: 18, right: 18),
                                      child: AppComponents.textField("SG \$ 0", enable: false)),
                                ],
                                SizedBox(
                                  height: 16,
                                ),
                                AppComponents.text("Point Received",
                                    color: Colors.black, size: 16),
                                SizedBox(
                                  height: 8,
                                ),
                                Container(
                                    margin: EdgeInsets.only(left: 18, right: 18),
                                    child: AppComponents.textField("80",
                                        enable: false)),
                                SizedBox(
                                  height: 16,
                                ),
                                AppComponents.text("Upload Image",
                                    color: Colors.black, size: 16),
                                SizedBox(
                                  height: 16,
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 18, right: 18),
                                  height: 38,
                                  child:
                                  AppComponents.appButton("Upload", onTap: () {
                                    controller.pickImage(camera: true);
                                  }, textSize: 14),
                                ),
                                SizedBox(
                                  height: 18,
                                ),

                                Obx(() => controller.uploadedProfileImage.isNotEmpty
                                    ? Container(
                                  height: 100,
                                  width: 200,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: AppUtils.remoteImageLoader(
                                          controller
                                              .uploadedProfileImage.value)),
                                ) : Container()),
                                SizedBox(
                                  height: 18,
                                ),
                                /// complete game
                                Container(
                                  margin: EdgeInsets.only(left: 18, right: 18),
                                  height: 38,
                                  child: AppComponents.appButton("Complete Game", onTap: () {

                                    if(controller.uploadedProfileImage.value.isEmpty){
                                      Fluttertoast.showToast(msg: "Please select image");
                                      return;
                                    }

                                    bool lastItem = false;
                                    int completedCount = gameC.outletList.where((item) => item.isGameStarted == 1).length;

                                    if(completedCount == (gameC.outletList.length -1)){
                                      lastItem = true;
                                    }

                                    print(lastItem);
                                    print("1010101010101");
                                    controller.gameComplete(
                                        gameC.gameData?.gameUniqueId ?? "",
                                        gameC.gameData?.start_timer_count,
                                        gameC.gameData?.end_timer_count,
                                        appC.gameName,lastItem,
                                        gameC.outletDetail?.outletId.toString() ?? "",
                                        gameC.outletDetail?.outletName ?? "", () {
                                      Get.back();
                                      Get.back();
                                    });
                                  }, textSize: 14),
                                ),
                                SizedBox(
                                  height: 18,
                                ),
                                // back
                                Container(
                                  margin: EdgeInsets.only(left: 18, right: 18),
                                  height: 38,
                                  child: AppComponents.appButton("Back", onTap: () {
                                    Get.back();
                                  }, textSize: 14),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            )
          ],
        ),top: true,bottom: true,
      ),
    );
  }
}
