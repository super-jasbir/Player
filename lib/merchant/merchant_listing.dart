import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:player/app_controller.dart';
import 'package:player/data/network/api_endpoints.dart';
import 'package:player/game/game_list_screen.dart';
import 'package:player/merchant/merchant_controller.dart';
import 'package:player/merchant/merchant_detail_screen.dart';
import 'package:player/utils/app_utils.dart';

import '../utils/app_color.dart';
import '../utils/app_components.dart';
import 'package:player/core/services/tap_sound.dart';

class MerchantScreen extends StatefulWidget {
  const MerchantScreen({super.key});

  @override
  State<MerchantScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<MerchantScreen> {
  var controller = Get.put(MerchantController());
  var appC = Get.find<AppController>();

  @override
  void initState() {
    controller.merchantList(appC.merchantZone, controller.selectedValue.value, () {
      setState(() {

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
                  AppComponents.text("Merchant List",
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
              child:

                  /// tabs
                  Container(
                margin: EdgeInsets.only(left: 16, right: 16),
                height: 46,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: Colors.white, width: 2),
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color(0xFFC2C3C8),
                        Color(0xFF3B3B3B),
                      ],
                    )),
                child: Obx(
                  () => Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            controller.selected.value = "halal";
                            controller.selectedValue.value = "Halal";
                            controller.merchantList(appC.merchantZone, controller.selectedValue.value, () {
                              setState(() {

                              });
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 8),
                            height: 36,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(22),
                                color: controller.selected.value == "halal"
                                    ? Colors.white
                                    : null),
                            child: Center(
                              child: AppComponents.text("Halal Station",
                                  size: 12,
                                  fontWeight: FontWeight.w500,
                                  color: controller.selected.value == "halal"
                                      ? AppColors.black
                                      : Colors.white),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            controller.selected.value = "nonHalal";

                            controller.selectedValue.value = "Non-Halal";
                            controller.merchantList(appC.merchantZone, controller.selectedValue.value, () {
                              setState(() {

                              });
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 8),
                            height: 36,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(22),
                                color: controller.selected.value == "nonHalal"
                                    ? Colors.white
                                    : null),
                            child: Center(
                              child: AppComponents.text("Non-Halal Station",
                                  size: 12,
                                  fontWeight: FontWeight.w500,
                                  color: controller.selected.value == "past"
                                      ? AppColors.black
                                      : Colors.grey),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),

            Container(
                margin: EdgeInsets.only(
                    left: 30,
                    bottom: 10,
                    top: MediaQuery.of(context).size.height * .27,
                    right: 30),
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
                ),),
            /// glass transparent
            /// main view
            Container(
                margin: EdgeInsets.only(
                    left: 30,
                    bottom: 10,
                    top: MediaQuery.of(context).size.height * .27,
                    right: 30),
                // Set the desired width
                child: Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(12)),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if(controller.mList.isNotEmpty)...[
                          ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: controller.mList.length,
                              physics: ClampingScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                var data = controller.mList[index];
                                return InkWell(
                                  onTap: (){
                                    controller.mData = data;
                                    Get.to(MerchantDetail());
                                  },
                                  child : Container(
                                    margin: EdgeInsets.only(top: 10),
                                    padding: EdgeInsets.only(top: 10),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12)),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Container(
                                          height: 55,
                                          width: 55,
                                          child: ClipOval(
                                            child: AppUtils.remoteImageLoader(ApiEndPoint.imageBaseUrl+"merchant/"+data.initalImage),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            /// name
                                            AppComponents.text(
                                                      data.outletName,
                                                      textOverflow: TextOverflow.clip,
                                                      fontWeight: FontWeight.w500,
                                                      color: Colors.black),

                                            SizedBox(
                                              height: 2,
                                            ),
                                            /// location
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.location_on_outlined,
                                                  color: Colors.grey,
                                                  size: 18,
                                                ),
                                                SizedBox(
                                                  width: 4,
                                                ),
                                                Expanded(child: Container(
                                                  child:  AppComponents.text(
                                                      data.outletAddress,
                                                      maxLine: 3,
                                                      textOverflow: TextOverflow.clip,
                                                      fontWeight:
                                                      FontWeight.w400,
                                                      color: Colors.black,
                                                      size: 12),
                                                ))
                                              ],
                                            ),
                                            SizedBox(
                                              height: 6,
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
                                                    data.startHours +" - "+data.endHours,
                                                    fontWeight:
                                                    FontWeight.w400,
                                                    color: Colors.black,
                                                    size: 12)
                                              ],
                                            ),
                                            SizedBox(height: 10,),
                                            AppComponents.text("Click here for more info",color: AppColors.darkGreen,enableUnderLine: true,),
                                            SizedBox(height: 10,),
                                          ],
                                        ),)
                                      ],
                                    ),
                                  ),
                                );
                              })
                        ]else...[
                          Align(
                              alignment: Alignment.center,
                              child: AppComponents.text("   No Merchant Available In This Zone    ",color: Colors.black))
                        ],
                      ],
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
