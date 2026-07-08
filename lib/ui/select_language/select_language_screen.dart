import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:player/ui/select_language/select_language_controller.dart';

import '../../app_controller.dart';
import '../../routes/app_routes.dart';
import '../../utils/app_color.dart';
import '../../utils/app_components.dart';
import '../../utils/app_fonts.dart';


class SelectLanguageScreen extends GetView<SelectLanguageController> {
  const SelectLanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var appController = Get.find<AppController>();

    return Scaffold(
      body: SafeArea(
        child:Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              child: Image.asset(
                "assets/images/app_bg.png",
                fit: BoxFit.cover, // Adjust to BoxFit.fill, BoxFit.contain, etc., as needed
              ),
            ),
            // Transparent Overlay
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.blue.withOpacity(0.2), // Adjust opacity and color as needed
            ),
            /// spend logo
            Container(
                margin: EdgeInsets.only(left: 20,right: 20,top: 80),
                child: Image.asset("assets/images/logo.png")),

            ///main view
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,

              child: Container(
                margin:  EdgeInsets.only(left: 18, right: 18,top: MediaQuery.of(context).size.height*.1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height *.14,
                    ),
                    AppComponents.text(controller.appConstant.language,
                        size: 20, color: Colors.white,font: AppFonts.satoshiRegular,fontWeight: FontWeight.w900),
                    const SizedBox(
                      height: 12,
                    ),

                    AppComponents.text(controller.appConstant.selectYourLanguage,
                        size: 14, color: Colors.white,font: AppFonts.satoshiMedium,fontWeight: FontWeight.w500),
                    const SizedBox(
                      height: 43,
                    ),
                    Obx(() =>
                        Column(
                          children: [
                            Row(
                              children: [

                                Expanded(
                                  child: InkWell(
                                    onTap: (){
                                      controller.appLanguage.value = "english";
                                      appController.selectLanguage(controller.appLanguage.value);

                                    },
                                    child: Container(
                                      height: 164,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: AppColors.darkNavyBlue,
                                        border: Border.all(color: controller.appLanguage.value == "english"?Colors.green:Colors.grey,width: 2),

                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(.4), // Shadow color
                                            blurRadius: 20, // How soft the shadow is
                                            spreadRadius: 2, // How far the shadow spreads
                                            offset: Offset(0, 0), // Position of the shadow
                                          ),

                                        ],
                                      ),
                                      child:  Container(margin: EdgeInsets.all(22),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,

                                          boxShadow: [
                                            BoxShadow(
                                              color: Color(0xFF07E5FF), // Shadow color
                                              blurRadius: 50, // How soft the shadow is
                                              spreadRadius: 5, // How far the shadow spreads
                                              offset: Offset(0, 0), // Position of the shadow
                                            ),

                                          ],
                                        ),
                                        child: Center(child: AppComponents.text("English",color: Colors.white,fontWeight: FontWeight.w900,size: 20)),

                                      ),
                                    ),
                                  ),

                                ),
                                const SizedBox(width: 21,),

                                Expanded(child: InkWell(
                                  onTap: (){
                                    controller.appLanguage.value = "Chinese";
                                    appController.selectLanguage(controller.appLanguage.value);

                                  },
                                  child:  Container(
                                    height: 164,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: AppColors.darkNavyBlue.withOpacity(.6),
                                      border: Border.all(color: controller.appLanguage.value == "Chinese"?Colors.green:Colors.grey,width: 2),

                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(.4), // Shadow color
                                          blurRadius: 20, // How soft the shadow is
                                          spreadRadius: 2, // How far the shadow spreads
                                          offset: Offset(0, 0), // Position of the shadow
                                        ),

                                      ],
                                    ),
                                    child:  Container(margin: EdgeInsets.all(22),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,

                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.green, // Shadow color
                                            blurRadius: 50, // How soft the shadow is
                                            spreadRadius: 20, // How far the shadow spreads
                                            offset: Offset(0, 0), // Position of the shadow
                                          ),

                                        ],
                                      ),
                                      child: Center(child: AppComponents.text("Chinese",color: Colors.white,fontWeight: FontWeight.w900,size: 20)),

                                    ),
                                  ),
                                )),


                              ],
                            ),

                          ],
                        )
                    ),
                    Expanded(child: Container()),
                    AppComponents.appButton("Continue",onTap: (){
                      Get.toNamed(AppRoutes.loginScreen);
                    }),

                    const SizedBox(height: 30,)

                  ],
                ),
              ),
            )

          ],
        )

      ),
    );
  }
}


