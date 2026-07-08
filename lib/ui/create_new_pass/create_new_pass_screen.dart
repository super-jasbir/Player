import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:player/data/network/api_endpoints.dart';


import '../../../routes/app_routes.dart';
import '../../../utils/app_color.dart';
import '../../../utils/app_components.dart';
import '../../utils/common_constants.dart';
import 'create_new_pass_controller.dart';

class CreateNewPassScreen extends GetView<CreateNewPassController> {
  const CreateNewPassScreen({super.key});


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


            /// glass transparent
            /// main view
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
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(left: 18),
                                child: AppComponents.text(
                                    "Reset The Password".toUpperCase(),
                                    fontWeight: FontWeight.w700,
                                    size: 20,
                                    color: Colors.white),
                              ),

                              Container(
                                alignment: Alignment.center,

                                margin: EdgeInsets.only(left: 18),
                                child: AppComponents.text(
                                    "Must be at least 8 characters",
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                    size: 16,
                                    maxLine: 3),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 18, top: 12),
                                child: AppComponents.text(controller.appConstant.newPassword,
                                    fontWeight: FontWeight.w500,
                                    size: 14,
                                    color: Colors.white),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Obx(() =>    Container(
                                margin: EdgeInsets.only(left: 18, right: 18),
                                child: AppComponents.textField(
                                    controller.appConstant.enterNewPassword,
                                    controller: controller.enterPassC,
                                    obscure: controller.obscure.value, onTapIcon: () {
                                  if (controller.obscure.value) {
                                    controller.obscure.value = false;
                                    controller.suffixIcon.value = "assets/images/pass_show.png";
                                  } else {
                                    controller.obscure.value = true;
                                    controller.suffixIcon.value = "assets/images/pass_hide.png";
                                  }
                                }, suffixIcon: controller.suffixIcon.value),
                              ),),
                              Container(
                                margin: EdgeInsets.only(left: 18, top: 12),
                                child: AppComponents.text(controller.appConstant.confirmPassword,
                                    fontWeight: FontWeight.w500,
                                    size: 14,
                                    color:Colors.white),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Obx(() =>  Container(
                                margin: EdgeInsets.only(left: 18, right: 18),
                                child: AppComponents.textField(
                                    controller.appConstant.confirmNewPassword,
                                    controller: controller.enterConfirmPassC,
                                    obscure: controller.obscure2.value, onTapIcon: () {
                                  if (controller.obscure2.value) {
                                    controller.obscure2.value = false;
                                    controller.suffixIcon.value = "assets/images/pass_show.png";
                                  } else {
                                    controller.obscure2.value = true;
                                    controller.suffixIcon.value = "assets/images/pass_hide.png";
                                  }
                                }, suffixIcon: controller.suffixIcon.value),
                              ),),
                              const SizedBox(
                                height: 15,
                              ),

                              Container(
                                margin: EdgeInsets.only(left: 18, right: 18),
                                child: AppComponents.appButton(controller.appController.appConstant.submit,onTap: (){
                                  if (controller.enterPassC.text.isEmpty) {
                                    Fluttertoast.showToast(
                                        msg: CommonConstants.pleaseEnterNewPassword);
                                    return;
                                  }
                                  if (!controller.enterPassC.text
                                      .contains(RegExp(r'[A-Z]'))) {
                                    Fluttertoast.showToast(
                                        msg: CommonConstants.passWordMustContainAlphaNumeric);
                                    return;
                                  }
                                  if (controller.enterConfirmPassC.text.isEmpty) {
                                    Fluttertoast.showToast(
                                        msg: CommonConstants.pleaseConfirmNewPass);
                                    return;
                                  }
                                  if (!controller.enterConfirmPassC.text
                                      .contains(RegExp(r'[A-Z]'))) {
                                    Fluttertoast.showToast(
                                        msg: CommonConstants.passWordMustContainAlphaNumeric);
                                    return;
                                  }
                                  if (controller.enterPassC.text != controller.enterConfirmPassC.text) {
                                    Fluttertoast.showToast(
                                        msg: CommonConstants.passwordDoseNotMatch);
                                    return;
                                  }
                                  if (controller.enterPassC.text.length <7) {
                                    Fluttertoast.showToast(
                                        msg: CommonConstants.passwordMustBeGreater);
                                    return;
                                  }
                                  if (controller.enterConfirmPassC.text.length <7) {
                                    Fluttertoast.showToast(
                                        msg: CommonConstants.passwordMustBeGreater);
                                    return;
                                  }
                                  // Get.toNamed(AppRoutes.loginScreen);

                                  controller.resetPassword(controller.appController.id, context);

                                }),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              InkWell(
                                onTap: (){
                                  // Get.toNamed(AppRoutes.loginScreen);
                                },
                                child: Row(
                                  children: [
                                    Spacer(),
                                    Icon(Icons.arrow_back),
                                    SizedBox(width: 12,),
                                    AppComponents.text("Back to login ",color: Colors.black,fontWeight: FontWeight.w700,size: 18),
                                    Spacer(),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                            ],
                          ),
                        ),
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
