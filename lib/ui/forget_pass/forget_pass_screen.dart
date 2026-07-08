import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../../utils/app_color.dart';
import '../../../utils/app_components.dart';
import '../../app_controller.dart';
import '../../routes/app_routes.dart';
import '../../utils/app_utils.dart';
import '../../utils/common_constants.dart';
import 'forget_pass_controller.dart';

class ForgetPassScreen extends GetView<ForgetPassController> {
  const ForgetPassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var appC = Get.find<AppController>();
    return Scaffold(
      body: SafeArea(
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
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.grey.withOpacity(0.2), // Adjust opacity and color as needed
          ),
          SafeArea(
            child: Column(
              children: [
                SizedBox(
                  height: 25,
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
                      top: MediaQuery.of(context).size.height * .12,
                      left: 18,
                      right: 18,
                      bottom: 120, // To avoid overlap with bottom icons
                    ),
                    child: Column(
                      children: [
                        Image.asset("assets/images/m2/start_bg_logo.png"),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 24,
                            ),
                            Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(
                                  left: 18, top: 10),
                              child: AppComponents.text(controller.appConstant.forgetPassword,
                                  fontWeight: FontWeight.w900, size: 20, color: Colors.white),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * .8,
                              margin: EdgeInsets.only(left: 18),
                              child: AppComponents.text(
                                  controller.appConstant.pleaseEnterYourRegister,
                                  fontWeight: FontWeight.w500,
                                  size: 14,
                                  maxLine: 2,
                                  color: Colors.white,
                                  textAlign: TextAlign.center),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 1, color: AppColors.borderColor),
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.4),
                                offset: Offset(0, 4),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 20, right: 20),
                                    child: Image.asset("assets/images/m2/barline.png"),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 18, top: 8),
                                    child: AppComponents.text(
                                        controller.appConstant.phoneNumber,
                                        fontWeight: FontWeight.w500,
                                        size: 14,
                                        color: Colors.white),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Container(
                                      margin: EdgeInsets.only(left: 18, right: 18),
                                      child: controller.mobileNumberTextField()),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 18, right: 18),
                                    child: AppComponents.appButton("Reset Password",
                                        onTap: () {
                                          controller.forgetPassword(
                                              controller.selectedDialCode,
                                              controller.mobileController.text);
                                        }),
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                ],
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          /*/// spend logo
          Container(
            margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * .21,
                left: 40,
                right: 40),
            child: Image.asset(
              "assets/images/m2/start_bg_logo.png",
            ),
          ),*/

          /*
          Container(
              margin: EdgeInsets.only(
                  left: 18,
                  top: MediaQuery.of(context).size.height * .44,
                  right: 18),
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
              ),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(12)),
                    child: SingleChildScrollView(
                      child: Container(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 20, right: 20),
                            child: Image.asset("assets/images/m2/barline.png"),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 18, top: 8),
                            child: AppComponents.text(
                                controller.appConstant.phoneNumber,
                                fontWeight: FontWeight.w500,
                                size: 14,
                                color: Colors.white),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Container(
                              margin: EdgeInsets.only(left: 18, right: 18),
                              child: controller.mobileNumberTextField()),
                          const SizedBox(
                            height: 30,
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 18, right: 18),
                            child: AppComponents.appButton("Reset Password",
                                onTap: () {
                              controller.forgetPassword(
                                  controller.selectedDialCode,
                                  controller.mobileController.text);
                            }),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                        ],
                      )),
                    ),
                  ),
                ],
              )),*/
        ],
      )),
    );
  }
}
