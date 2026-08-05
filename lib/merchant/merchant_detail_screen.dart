import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:player/data/network/api_endpoints.dart';
import 'package:player/game/game_list_screen.dart';
import 'package:player/imagepreview/image_preview.dart';
import 'package:player/merchant/merchant_controller.dart';
import 'package:player/utils/app_utils.dart';

import '../utils/app_color.dart';
import '../utils/app_components.dart';
import 'package:player/core/services/tap_sound.dart';

class MerchantDetail extends StatefulWidget {
  const MerchantDetail({super.key});

  @override
  State<MerchantDetail> createState() => _GameScreenState();
}

class _GameScreenState extends State<MerchantDetail> {
  var controller = Get.put(MerchantController());

  @override
  Widget build(BuildContext context) {
    var data = controller.mData!;
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
                  AppComponents.text("Merchant Details".toUpperCase(),
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
                  left: 16,
                  right: 16),
              child: Container(
                height: 70,
                child: ListView.builder(
                    itemCount: data.outletImages.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      var image = data.outletImages[index];
                      return InkWell(
                        onTap: (){
                          Get.to(ImagePreview(imageUrl: ApiEndPoint.imageBaseUrl+"merchant/"+ image ));
                        },
                        child
                            : Container(
                          margin: EdgeInsets.only(left: 15),
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 3),
                              borderRadius: BorderRadius.circular(0)),
                          child: AppUtils.remoteImageLoader(
                              ApiEndPoint.imageBaseUrl+"merchant/"+ image),
                        ),
                      );
                    }),
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
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      /// merchant description
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                    "assets/images/m3/game_detail_bg.png"),
                                fit: BoxFit.fill),
                            borderRadius: BorderRadius.circular(12)),
                        child: Column(
                          children: [
                            SizedBox(height: 5,),
                            AppUtils.outlinedText(text: "Merchant Description",fontSize: 20),
                            SizedBox(height: 12,),
                            /// description
                            Container(
                              margin: EdgeInsets.all(8),
                                child: AppComponents.text(data.description.toString(),maxLine: 10,size: 14,fontWeight: FontWeight.w500,color: Colors.black,textAlign: TextAlign.center))

                          ],
                        ),
                        padding: EdgeInsets.all(10),
                      ),
                      SizedBox(height: 15,),
                      /// bonous hours
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                    "assets/images/m3/game_detail_bg.png"),
                                fit: BoxFit.fill),
                            borderRadius: BorderRadius.circular(12)),
                        child: Column(
                          children: [
                            AppUtils.outlinedText(text: "Business Hours",fontSize: 22),
                            SizedBox(height: 12,),
                            /// description
                            AppComponents.text("${data.startHours} - ${data.endHours} ",maxLine: 10,size: 18,fontWeight: FontWeight.w500,color: Colors.black)

                          ],
                        ),
                      ),
                      SizedBox(height: 15,),
                      /// specialising
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                    "assets/images/m3/game_detail_bg.png"),
                                fit: BoxFit.fill),
                            borderRadius: BorderRadius.circular(12)),
                        child: Column(
                          children: [
                            AppUtils.outlinedText(text: "Specializing",fontSize: 20),
                            SizedBox(height: 12,),
                            /// description
                            Container(
                              margin: EdgeInsets.all(2),
                                child: AppComponents.text("${data.specializedIn}",maxLine: 10,size: 14,fontWeight: FontWeight.w500,color: Colors.black))

                          ],
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
