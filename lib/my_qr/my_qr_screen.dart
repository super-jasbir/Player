import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:player/game/game_list_screen.dart';
import 'package:player/merchant/merchant_controller.dart';
import 'package:player/merchant/merchant_detail_screen.dart';
import 'package:player/utils/app_utils.dart';

import '../utils/app_color.dart';
import '../utils/app_components.dart';

class MyQrScreen extends StatefulWidget {
  const MyQrScreen({super.key});

  @override
  State<MyQrScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<MyQrScreen> {
  var controller = Get.put(MerchantController());

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
                  AppComponents.text("My Qr".toUpperCase(),
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
                margin: EdgeInsets.only(
                    left: 30,
                    top: MediaQuery.of(context).size.height * .27,
                    right: 30),
              child:   Container(
                  height: 275,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12)),
                child: Center(
                  child: AppUtils.remoteImageLoader("assets/images/m3/temp_qr.png"),
                ),

                ),),
          ],
        ),
      ),
    );
  }
}
