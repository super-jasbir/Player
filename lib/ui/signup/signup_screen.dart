import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:player/ui/login_screen/login_controller.dart';
import 'package:player/ui/signup/signup_controller.dart';
import 'package:player/utils/app_components.dart';

import '../../animation/splash_animation.dart';
import '../../routes/app_routes.dart';
import '../../utils/app_color.dart';

class SignupScreen extends GetView<SignupController> {
  const SignupScreen({super.key});

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
                  "assets/images/m2/start_bg.png",
                  fit: BoxFit
                      .cover, // Adjust to BoxFit.fill, BoxFit.contain, etc., as negeeded
                ),
              ),
              // Transparent Overlay
              Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.grey.withOpacity(
                    0.2), // Adjust opacity and color as needed
              ),

              SafeArea(
                child: Column(
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
                    Container(
                        margin: EdgeInsets.only(left: 35, right: 35, top: 50),
                        child: Image.asset("assets/images/m2/app_logo.png")),

                    /// glass transparent
                    /// main view
                    Expanded(child: Container(
                        margin: EdgeInsets.only(left: 18, top: 40, right: 18,bottom: 30),
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
                              margin: EdgeInsets.only(top: 18,left: 18,right: 18),
                              decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(12)
                              ),
                              child: SingleChildScrollView(
                                child: Container(
                                  margin: EdgeInsets.only(left: 18,right: 18,top: 50),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          margin: EdgeInsets.only(top: 12),
                                          child: AppComponents.text(controller.appConstant.fullName,
                                              size: 14,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600)),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      AppComponents.textField(controller.appConstant.enterFullName,controller: controller.fullName),
                                      Container(
                                          margin: EdgeInsets.only(top: 12),
                                          child: AppComponents.text(controller.appConstant.phoneNumber,
                                              size: 14,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400)),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      controller.mobileNumberTextField(),
                                      /// email
                                      Container(
                                          margin: EdgeInsets.only(top: 12),
                                          child: AppComponents.text(controller.appConstant.emailAddresses,
                                              size: 14,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400)),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      AppComponents.textField(controller.appConstant.enterEmailAddress,controller: controller.email),
                                      Container(
                                          margin: EdgeInsets.only(top: 12),
                                          child: AppComponents.text(controller.appConstant.password,
                                              size: 14,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400)),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Obx(() => AppComponents.textField(controller.appConstant.pleaseEnterYourPassword,
                                          obscure: controller.obscure.value,
                                          controller: controller.passC,
                                          suffixIcon: controller.suffixIcon.value, onTapIcon: () {
                                            if (controller.obscure.value) {
                                              controller.obscure.value = false;
                                              controller.suffixIcon.value = "assets/images/pass_show.png";
                                            } else {
                                              controller.obscure.value = true;
                                              controller.suffixIcon.value = "assets/images/pass_hide.png";
                                            }
                                          })),

                                      Container(
                                          margin: EdgeInsets.only(top: 12),
                                          child: AppComponents.text(controller.appConstant.confirmPassword,
                                              size: 14,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400)),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Obx(() => AppComponents.textField(controller.appConstant.enterConfirmPassword,
                                          obscure: controller.obscure.value,
                                          controller: controller.confirmPassC,
                                          suffixIcon: controller.suffixIcon.value, onTapIcon: () {
                                            if (controller.obscure.value) {
                                              controller.obscure.value = false;
                                              controller.suffixIcon.value = "assets/images/pass_show.png";
                                            } else {
                                              controller.obscure.value = true;
                                              controller.suffixIcon.value = "assets/images/pass_hide.png";
                                            }
                                          })),
                                      Container(
                                          margin: EdgeInsets.only(top: 12),
                                          child: AppComponents.text(controller.appConstant.referral,
                                              size: 14,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400)),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      AppComponents.textField(controller.appConstant.enterReferral,
                                        controller: controller.referralCode,),
                                      Row(
                                        children: [
                                          Obx(() => Checkbox(value:  controller.agree.value, onChanged: (value){
                                            controller.agree.value = value!;
                                          },activeColor: Colors.green,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(2.0),
                                            ),
                                            side: MaterialStateBorderSide.resolveWith(
                                                  (states) => BorderSide(width: 2.0, color: Colors.green),
                                            ),
                                          ),),
                                          AppComponents.text(controller.appConstant.iAgreeToTerms,
                                              size: 12,fontWeight: FontWeight.w600,color: Colors.white)

                                        ],
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      AppComponents.appButton("Sign Up",onTap: (){

                                        if(controller.fullName.text.isEmpty){
                                          Fluttertoast.showToast(msg: "Please enter full name");
                                          return;
                                        }
                                        if(controller.mobileController.text.isEmpty){
                                          Fluttertoast.showToast(msg: "Please enter your phone number");
                                          return;
                                        }
                                        if(controller.email.text.isEmpty){
                                          Fluttertoast.showToast(msg: "Please enter valid email");
                                          return;
                                        }
                                        if(controller.passC.text.isEmpty){
                                          Fluttertoast.showToast(msg: "Please enter password");
                                          return;
                                        }
                                        if(controller.confirmPassC.text.isEmpty){
                                          Fluttertoast.showToast(msg: "Please enter confirm password");
                                          return;
                                        }

                                        if(controller.confirmPassC.text.toString() != controller.passC.text.toString()){
                                          Fluttertoast.showToast(msg: "Confirm password not matched");
                                          return;
                                        }


                                        controller.signUp(() {
                                          Get.toNamed(AppRoutes.otpScreen,arguments: {"otpType":AppRoutes.signUpScreen});

                                        });
                                      }),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Container(
                                alignment: Alignment.center,
                                height: 68,
                                child: Image.asset("assets/images/m2/signup_top_view.png")),
                          ],
                        )
                    ),)
                  ],
                ),
              ),
              /// logo
            ],
          )
      ),
    );
  }
}