import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:player/ui/select_nationlity/select_nationlity_controller.dart';
import 'package:player/utils/app_utils.dart';
import '../../app_controller.dart';
import '../../routes/app_routes.dart';
import '../../utils/app_color.dart';
import '../../utils/app_components.dart';
import '../../utils/app_fonts.dart';

class SelectNationlityScreen extends GetView<SelectNationlity> {
  const SelectNationlityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var appController = Get.find<AppController>();

    return Scaffold(
      body: SafeArea(
        child: Container(
            child: Stack(
          children: [
            // Background Image
            Container(
              width: double.infinity,
              height: double.infinity,
              child: Image.asset(
                "assets/images/m2/start_bg.png",
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
            Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                Container(
                  height: 30,
                  decoration: BoxDecoration(),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 18,
                      ),
                      InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.white,
                          )),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(
                      left: 18,
                      right: 18, // To avoid overlap with bottom icons
                    ),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                              top: 50,
                              left: 20,
                              right: 20),
                          child: Image.asset(
                            "assets/images/m2/start_bg_logo.png",
                          ),
                        ),
                        SizedBox(height: 30,),
                        Stack(
                          children: [
                            Container(
                              height: 400,
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
                              ),),
                            Container(
                              margin: EdgeInsets.only(left: 18, right: 18),
                              decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(12)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Image.asset("assets/images/m2/barline.png"),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                        child: AppComponents.text(
                                            controller.appConstant.signUp,
                                            size: 32,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w900)),
                                  ),
                                  SizedBox(
                                    height: 6,
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: AppComponents.text(
                                        controller.appConstant.pleaseSelectYourStatus,
                                        size: 18,
                                        color: Colors.white,
                                        font: AppFonts.satoshiMedium,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(
                                    height: 23,
                                  ),
                                  Obx(() => Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: InkWell(
                                              onTap: () {
                                                controller.appLanguage.value = "local";
                                                appController.selectedNation = "singapore";
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(20),
                                                    border: Border.all(
                                                        color: controller.appLanguage
                                                            .value ==
                                                            "local"
                                                            ? Colors.white
                                                            : Colors.grey,
                                                        width: controller.appLanguage
                                                            .value ==
                                                            "local"
                                                            ? 1
                                                            : 1))
                                                ,
                                                child: AppUtils.remoteImageLoader(
                                                  boxFit: BoxFit.fill,
                                                    "assets/images/m3/singapore_bg.png"),
                                                height: 130,
                                                width: 120,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 21,
                                          ),
                                          Expanded(
                                              child: InkWell(
                                                onTap: () {
                                                  controller.appLanguage.value = "global";
                                                  appController.selectedNation = "outside_singapore";
                                                },
                                                child: Container(

                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(20),
                                                      border: Border.all(
                                                          color: controller.appLanguage
                                                              .value ==
                                                              "global"
                                                              ? Colors.white
                                                              : Colors.grey,
                                                          width: controller.appLanguage
                                                              .value ==
                                                              "global"
                                                              ? 2
                                                              : 1)),
                                                  child: AppUtils.remoteImageLoader(
                                                      boxFit: BoxFit.fill,
                                                      "assets/images/m3/foreigners_bg.png"),
                                                  height: 130,
                                                  width: 120,
                                                ),
                                              )),
                                        ],
                                      ),
                                    ],
                                  )),
                                  SizedBox(
                                    height: 25,
                                  ),
                                  AppComponents.appButton(
                                      controller.appConstant.textContinue, onTap: () {
                                    if (controller.appLanguage.value.isEmpty) {
                                      Fluttertoast.showToast(
                                          msg: "Please select status to continue");
                                      return;
                                    } else {
                                      Get.toNamed(AppRoutes.signUpScreen);
                                    }
                                  }),
                                  SizedBox(
                                    height: 25,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            /// spend logo
          ],
        )),
      ),
    );
  }
}
