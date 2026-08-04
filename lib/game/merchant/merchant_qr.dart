import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:player/game/merchant/GameMerchantDetail.dart';
import 'package:player/merchant/merchant_controller.dart';
import 'package:player/utils/app_utils.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../utils/app_components.dart';
import '../game_controller.dart';


class MerchantQr extends StatefulWidget {
  const MerchantQr({super.key});

  @override
  State<MerchantQr> createState() => _GameScreenState();
}

class _GameScreenState extends State<MerchantQr> {
  var controller = Get.put(MerchantController());
  var gameC = Get.find<GameController>();
  late Timer? timer;

  @override
  void initState() {
    var argu = Get.arguments as Map<String, dynamic>;
    controller.getPlayerDetail(argu["game_unique_id"],gameC.outletDetail?.outletUniqueId.toString() ?? "", () {
      setState(() {
        timer = Timer.periodic(Duration(seconds: 5), (timer) {
          controller.getPlayerPaymentDetail(gameC.gameData?.gameUniqueId ?? "",
              gameC.outletDetail?.outletId.toString() ?? "", () {
                    if(controller.merchantPaymentResponse?.value.data?.amountPaid!=null &&
                        controller.merchantPaymentResponse?.value.data?.amountPaid?.isNotEmpty == true){
                      timer.cancel();
                      Get.to(GameMerchantDetail());
                    }
              });
        });
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
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
                "assets/images/m3/my_qr_bg.png",
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
            /// spend logo
            Column(
              children: [
                Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * .05,
                      left: 18,
                      right: 18),
                  child: Row(
                    children: [
                      InkWell(
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
                      Spacer(),
                      AppComponents.text("My Qr".toUpperCase(),
                          fontWeight: FontWeight.w700,
                          size: 25,
                          color: Colors.white),
                      Spacer(),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            top: 40,
                            left: 40,
                            right: 40),
                        child: Image.asset(
                          "assets/images/m2/start_bg_logo.png",
                        ),
                      ),
                      /// main view
                      Container(
                        margin: EdgeInsets.only(
                            left: 30,
                            top: 40,
                            right: 30),
                        child:   Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(25),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12)),
                          child: Obx(() => Column(
                            children: [
                              if(controller.playerDetailsInfo.value.isNotEmpty)...[
                                Padding(padding: EdgeInsets.all(0),child: QrImageView(
                                  data: controller.playerDetailsInfo.value,
                                  version: QrVersions.auto,
                                  size: 250,
                                  gapless: false,
                                ),),
                              ]else...[
                                Container(
                                  height: 150,
                                  width: 150,
                                  child: CupertinoActivityIndicator(
                                    color: Colors.black,
                                    radius: 30,
                                  ),
                                )
                              ],
                              SizedBox(height: 25,),
                              Row(
                                children: [
                                  SizedBox(width: 15,),
                                  Expanded(child: InkWell(
                                      onTap: (){

                                      },
                                      child: AppComponents.appButton("Back",onTap: (){
                                        Get.back();
                                      }))),
                                  SizedBox(width: 10,),
                                  Expanded(child: InkWell(
                                      onTap: (){

                                      },
                                      child: AppComponents.appButton("Next",onTap: (){
                                        timer?.cancel();
                                        Get.to(GameMerchantDetail());
                                      }))),
                                  SizedBox(width: 15,),

                                ],
                              )
                            ],
                          )),

                        ),),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
