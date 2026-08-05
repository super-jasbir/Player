import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:player/merchant/merchant_controller.dart';
import 'package:player/utils/app_color.dart';
import 'package:share_plus/share_plus.dart';
import '../../utils/app_components.dart';
import 'data/local/shared_prefs.dart';
import 'package:player/core/services/tap_sound.dart';

class Referral extends StatefulWidget {
  String? title = "";

  Referral({super.key,this.title});

  @override
  State<Referral> createState() => _GameScreenState();
}

class _GameScreenState extends State<Referral> {
  var controller = Get.put(MerchantController());
  String referralPoint = "";
  String referralCode = "";
  getReferral() async {
    await SharedPref.getReferalPoints().then((v){
      setState(() {
        referralPoint = v ?? "";
      });
    });

    await SharedPref.getReferalCode().then((v){
      setState(() {
        referralCode = v ?? "";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 1), () {
      getReferral();
    });


    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Background Image
            Container(
              width: double.infinity,
              height: 200,
              margin: EdgeInsets.only(top: 70),
              child: Image.asset(
                "assets/images/m3/ic_referral_image.jpg",
                fit: BoxFit.cover, // Adjust to BoxFit.fill, BoxFit.contain, etc., as needed
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
                        top: MediaQuery.of(context).size.height * .02,
                        left: 18,
                        right: 18),
                    child: Row(
                      children: [
                        NoTapSound(
                          child: InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: Icon(
                              Icons.arrow_back_ios_new,
                              color: Colors.black,
                            )),
                        ),
                        Spacer(),
                        AppComponents.text("Referral",
                            fontWeight: FontWeight.bold,
                            size: 25,
                            color: Colors.black),
                        Spacer(),
                      ],
                    ),
                  ),
                  /// spend logo
                  Container(
                    margin: EdgeInsets.only(
                        top: 210,
                        left: 60,
                        right: 60),
                    child: Image.asset(
                      "assets/images/m2/start_bg_logo.png",
                    ),
                  ),
                  SizedBox(height: 15,),
                  AppComponents.text("Earn unlimited FREE Credits",
                      fontWeight: FontWeight.bold,
                      size: 15,
                      color: AppColors.darkGreen),
                  AppComponents.text("1 Referral = \$${referralPoint}",
                      fontWeight: FontWeight.bold,
                      size: 22,
                      color: AppColors.orange),
                  Row(
                    children: [
                      Expanded(child: InkWell(
                        child: Container(
                          margin: EdgeInsets.only(top: 15,left: 60),
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: AppColors.darkGreen, // change color as needed
                              width: 5, // thickness of border
                            ),
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                child: Image.asset(
                                  "assets/images/m3/ic_connections.png",
                                ),
                              ),
                              AppComponents.text("Refer your Friend\nClick Here",
                                  fontWeight: FontWeight.bold,
                                  enableUnderLine: true,
                                  textAlign: TextAlign.center,
                                  size: 11,
                                  color: AppColors.red)
                            ],
                          ),
                        ),
                        onTap: (){
                          SharePlus.instance.share(
                              ShareParams(text: "${referralCode} is my referral code, please use this code for registered as a player on Spendrathon App")
                          );
                        },
                      )),
                      Expanded(child: Column(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            margin: EdgeInsets.only(top: 25),
                            child: Image.asset(
                              "assets/images/m3/ic_referral.png",
                            ),
                          ),
                          AppComponents.text("\$${referralPoint} for you after\ntheir signup",
                              fontWeight: FontWeight.bold,
                              textAlign: TextAlign.center,
                              size: 11,
                              color: AppColors.black)
                        ],
                      )),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(children: [
                    Padding(padding: EdgeInsets.only(left: 50),
                    child: AppComponents.text("REFERRAL CODE",
                        fontWeight: FontWeight.bold,
                        size: 14,
                        color: AppColors.darkGray),)
                  ],),
                  Container(
                    height: 60,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppComponents.text("${referralCode}",
                            fontWeight: FontWeight.bold,
                            size: 20,
                            color: AppColors.white),
                        Spacer(),
                        InkWell(
                          child: Padding(padding: EdgeInsets.only(left: 50),
                            child: AppComponents.text("Tap to copy",
                                fontWeight: FontWeight.bold,
                                size: 17,
                                enableUnderLine: true,
                                color: AppColors.darkGrey),),
                          onTap: (){
                            Clipboard.setData(ClipboardData(text: referralCode));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Copied')),
                            );
                          },
                        )
                      ],
                    ),
                    padding: EdgeInsets.all(15),
                    margin: EdgeInsets.only(left: 50,top: 6,right: 50),
                    decoration: BoxDecoration(
                        color: AppColors.borderColor,
                        borderRadius: BorderRadius.circular(8)),)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
