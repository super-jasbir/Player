import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:player/ui/signup/signup_controller.dart';
import 'package:player/utils/app_utils.dart';

import '../../routes/app_routes.dart';
import '../../utils/app_color.dart';
import '../../utils/app_components.dart';
import 'otp_verification_controller.dart';


class OtpVerificationScreen extends GetView<OtpVerificationController> {
  const OtpVerificationScreen({super.key});



  @override
  Widget build(BuildContext context) {
    var otpArgument = Get.arguments as Map<String, dynamic>;
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
            // Transparent Overlay
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.grey.withOpacity(0.2), // Adjust opacity and color as needed
            ),

            /// spend logo
            Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * .21,
                  left: 40,
                  right: 40),
              child: Image.asset(
                "assets/images/m2/start_bg_logo.png",
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                InkWell(
                  onTap: (){
                    Get.back();
                  },
                    child: Container(
                        margin: EdgeInsets.only(top: 40,left: 20),
                        child: Icon(Icons.arrow_back_ios_new,color: Colors.white,))),


              ],
            ),


            Container(
                margin: EdgeInsets.only(left: 18, top: MediaQuery
                    .of(context)
                    .size
                    .height * .32, right: 18),
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
                          borderRadius: BorderRadius.circular(12)
                      ),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 34,
                          ),
                          Container(
                              margin: const EdgeInsets.only(left: 18),
                              child: AppComponents.text(controller.appConstant.enterOtp,
                                  size: 20, color: Colors.white,fontWeight: FontWeight.w900)),
                          const SizedBox(
                            height: 4,
                          ),
                          Container(
                              margin: const EdgeInsets.only(left: 18),
                              child: AppComponents.text(
                                  controller.appConstant.pleaseEnterTheCodeToVerify,
                                  size: 14,
                                  fontWeight: FontWeight.w500,color: Colors.white)),
                          const SizedBox(
                            height: 30,
                          ),
                          controller.pinTextField(context),
                          Obx(
                                () => Container(
                              margin: const EdgeInsets.only(left: 18),
                              child: Row(
                                children: [
                                  Spacer(),
                                  controller.showResend.value
                                      ? InkWell(
                                    onTap: () {
                                      controller.remainingTime.value = 60;
                                      controller.showResend.value = false;
                                      controller.startTimer();
                                    },
                                    child: AppComponents.text(
                                        controller.appConstant.reSendOtp,
                                        size: 16,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.appColor),
                                  )
                                      : AppComponents.text(controller.appConstant.resendOtpIn,
                                      size: 15, fontWeight: FontWeight.w500,color: Colors.white),
                                  controller.showResend.value
                                      ? Container()
                                      : AppComponents.text(
                                      "${controller.remainingTime.value}s",
                                      size: 12,
                                      color: AppColors.appColor,
                                      fontWeight: FontWeight.w500),
                                  Spacer()
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 30,),
                          Container(
                              margin: const EdgeInsets.only(left: 18, right: 18),
                              child:
                              AppComponents.appButton(controller.appConstant.verify,onTap: (){
                                if (controller.otpC.value.isEmpty) {
                                  Fluttertoast.showToast(msg: controller.appConstant.pleaseEnterTheCodeToVerify);
                                  return;
                                }


                                switch (otpArgument["otpType"]) {
                                  case AppRoutes.signUpScreen:
                                    {
                                      var signupC = Get.find<SignupController>();

                                      controller.verifyOtp(
                                          signupC.mobileController.text,
                                          signupC.selectedDialCode,
                                          signupC.signUpOtp,
                                          "1",
                                          "abc",
                                              () {
                                            Get.toNamed(AppRoutes.createProfile);
                                          });

                                      // redirect to  createNewPassword
                                    }
                                  case AppRoutes.createNewPassword:{
                                    controller.verifyOtp(
                                        otpArgument["number"],
                                        otpArgument["countryCode"],
                                        otpArgument["otp"].toString(),
                                        otpArgument["deviceType"],
                                        otpArgument["deviceToken"],
                                            () {
                                          Get.toNamed(AppRoutes.createNewPassword);
                                        });
                                  }

                                }
                              })),
                          const SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    ),


                  ],
                )

            ),
          ],
        )
      ),
    );
  }
}
