import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:player/merchant/merchant_controller.dart';
import '../../utils/app_color.dart';
import '../../utils/app_components.dart';
import '../../utils/app_fonts.dart';
import '../../utils/app_utils.dart';

class MySteryBoxDetail extends StatefulWidget {
  String? title = "";

  MySteryBoxDetail({super.key,this.title});

  @override
  State<MySteryBoxDetail> createState() => _GameScreenState();
}

class _GameScreenState extends State<MySteryBoxDetail> {
  var controller = Get.put(MerchantController());

  @override
  void initState() {
    controller.mysteryBoxDetail(() {
      setState(() {

      });
    },widget.title ?? "");
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
                "assets/images/m3/my_qr_bg.png",
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
                        top: MediaQuery.of(context).size.height * .04,
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
                        AppComponents.text("Mystery Box Detail",
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
                        top: 20,
                        left: 60,
                        right: 60),
                    child: Image.asset(
                      "assets/images/m2/start_bg_logo.png",
                    ),
                  ),
                  Expanded(child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          width: 327,
                          padding: EdgeInsets.only(bottom: 10),
                          margin: EdgeInsets.only(
                              top: 10,
                              left: 40,
                              right: 40),
                          decoration: BoxDecoration(
                              border: Border.all(width: 5, color: AppColors.darkGrey),
                              image: DecorationImage(image: AssetImage("assets/images/m3/game_detail_bg.png"),fit: BoxFit.fill),
                              borderRadius: BorderRadius.circular(20)),
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
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(10), // set your corner radius
                                          child: Container(
                                            height: 150,
                                            width: 150,
                                            child: Image.network(
                                              fit: BoxFit.cover,
                                              controller.mBoxData?.mysteryBoxImage ?? "",
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 12,),
                                    Align(
                                        alignment: Alignment.center,
                                        child: AppComponents.text(controller.mBoxData?.mysteryBoxNameEn ?? "",
                                            color: Colors.black,size: 16, fontWeight: FontWeight.w700,
                                          font: AppFonts.satoshiMedium,)),
                                    /// number of stations
                                    SizedBox(height: 12,),
                                    Row(children: [
                                      Expanded(child: AppComponents.text("Game Name:",color: Colors.black,font: AppFonts.satoshiMedium,
                                      fontStyle: FontStyle.italic)),
                                      SizedBox(width: 12,),
                                      AppComponents.text(controller.mBoxData?.gameName ?? "",color: Colors.black,fontStyle: FontStyle.italic)
                                    ],),
                                    SizedBox(height: 6,),
                                    // Divider(color: Colors.black,),
                                    /// date of competition
                                    SizedBox(height: 6,),
                                    Row(children: [
                                      Expanded(child: AppComponents.text("Number Of Mysteries:",color: Colors.black,font: AppFonts.satoshiMedium,fontStyle: FontStyle.italic)),
                                      SizedBox(width: 12,),
                                      AppComponents.text("${controller.mBoxData?.numberOfMystery}",color: Colors.black,fontStyle: FontStyle.italic)
                                    ],),
                                    SizedBox(height: 6,),
                                    /// winner prize
                                    SizedBox(height: 6,),
                                    Row(children: [
                                      Expanded(child: AppComponents.text("Price:",color: Colors.black,font: AppFonts.satoshiMedium,fontStyle: FontStyle.italic)),
                                      SizedBox(width: 12,),
                                      AppComponents.text("\$${controller.mBoxData?.amountpaid}",color: Colors.black,fontStyle: FontStyle.italic)
                                    ],),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          width: 327,
                          padding: EdgeInsets.only(bottom: 10),
                          margin: EdgeInsets.only(
                              top: 10,
                              left: 40,
                              right: 40),
                          decoration: BoxDecoration(
                              border: Border.all(width: 5, color: AppColors.darkGrey),
                              image: DecorationImage(image: AssetImage("assets/images/m3/game_detail_bg.png"),fit: BoxFit.fill),
                              borderRadius: BorderRadius.circular(20)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 23, right: 23),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Align(
                                        alignment: Alignment.topLeft,
                                        child: AppComponents.text("Description: ",
                                            textOverflow: TextOverflow.clip,
                                            color: Colors.black,size: 16, fontWeight: FontWeight.bold,fontStyle: FontStyle.italic)),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Align(
                                        alignment: Alignment.center,
                                        child: AppComponents.text("${controller.mBoxData?.description}",
                                            textOverflow: TextOverflow.clip,
                                            color: Colors.black,size: 14, fontWeight: FontWeight.w500,fontStyle: FontStyle.italic)),
                                    /// number of stations
                                    SizedBox(height: 12,),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              left: 45,
                              top: 20,
                              bottom: 30,
                              right: 45),
                          child: AppComponents.appButton(
                              "Buy Now",
                              height: 60,
                              onTap: (){
                                // Get.to(Leaderboard(title: "Leaderboard",));
                              }
                          ),
                        ),
                      ],
                    ),
                  ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
