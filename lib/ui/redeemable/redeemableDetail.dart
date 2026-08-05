import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:player/merchant/merchant_controller.dart';
import '../../data/network/api_endpoints.dart';
import '../../imagepreview/image_preview.dart';
import '../../utils/app_color.dart';
import '../../utils/app_components.dart';
import '../../utils/app_utils.dart';
import 'package:player/core/services/tap_sound.dart';

class RedeemableDetail extends StatefulWidget {
  String? title = "";

  RedeemableDetail({super.key,this.title});

  @override
  State<RedeemableDetail> createState() => _GameScreenState();
}

class _GameScreenState extends State<RedeemableDetail> {
  var controller = Get.put(MerchantController());

  @override
  void initState() {
    controller.redeemableDetail(() {
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
                        NoTapSound(
                          child: InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: Icon(
                              Icons.arrow_back_ios_new,
                              color: Colors.white,
                            )),
                        ),
                        Spacer(),
                        AppComponents.text("Redeemed Gifts Detail",
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
                        top: 30,
                        left: 60,
                        right: 60),
                    child: Image.asset(
                      "assets/images/m2/start_bg_logo.png",
                    ),
                  ),
                  if(controller.redeemListDetail!=null)...[
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
                                  margin: EdgeInsets.only(left: 13, right: 13),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 20,
                                      ),
                                      InkWell(
                                        child: Container(
                                          alignment: Alignment.center,
                                          height: 150,
                                          child: Image.network(
                                            controller.redeemListDetail?.redeemableItemImage ?? "",
                                          ),
                                        ),
                                        onTap: (){
                                          Get.to(ImagePreview(imageUrl: "${controller.redeemListDetail?.redeemableItemImage}" ));
                                        },
                                      ),
                                      SizedBox(height: 12,),
                                      Container(
                                        child: Container(
                                          height: 70,
                                          child: ListView.builder(
                                              itemCount: controller.redeemListDetail?.itemImages?.length,
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: (context, index) {
                                                var image = controller.redeemListDetail?.itemImages?[index];
                                                return InkWell(
                                                  onTap: (){
                                                    Get.to(ImagePreview(imageUrl: "$image" ));
                                                  },
                                                  child
                                                      : Container(
                                                    margin: EdgeInsets.only(left: 5),
                                                    height: 70,
                                                    width: 70,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(color: Colors.white, width: 1),
                                                        borderRadius: BorderRadius.circular(0)),
                                                    child: AppUtils.remoteImageLoader(
                                                        "$image"),
                                                  ),
                                                );
                                              }),
                                        ),
                                      ),
                                      SizedBox(height: 12,),
                                      Align(
                                          alignment: Alignment.center,
                                          child: AppComponents.text( controller.redeemListDetail?.itemNameEn ?? "",
                                              color: Colors.black,size: 16, fontWeight: FontWeight.w700,fontStyle: FontStyle.italic)),
                                      /// number of stations
                                      SizedBox(height: 5,),
                                      Row(children: [
                                        Expanded(child: AppComponents.text("Stock:",color: Colors.black,fontStyle: FontStyle.italic)),
                                        SizedBox(width: 5,),
                                        AppComponents.text(controller.redeemListDetail?.stock ?? "",color: Colors.black,fontStyle: FontStyle.italic)
                                      ],),
                                      SizedBox(height: 2,),
                                      /// winner prize
                                      Row(children: [
                                        Expanded(child: AppComponents.text("Price:",color: Colors.black,fontStyle: FontStyle.italic)),
                                        SizedBox(width: 12,),
                                        AppComponents.text("\$${controller.redeemListDetail?.amountPaid}",color: Colors.black,fontStyle: FontStyle.italic)
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
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 12,),
                                      Align(
                                          alignment: Alignment.topLeft,
                                          child: AppComponents.text( controller.redeemListDetail?.description ?? "",
                                              textOverflow: TextOverflow.clip,
                                              color: Colors.black,size: 16, fontWeight: FontWeight.w700,fontStyle: FontStyle.italic)),
                                      /// number of stations
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
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
