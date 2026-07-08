import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:player/ui/login_screen/login_controller.dart';
import 'package:player/ui/signup/signup_controller.dart';
import 'package:player/utils/app_components.dart';
import '../../routes/app_routes.dart';
import '../../utils/app_color.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: Image.asset(
              "assets/images/m2/start_bg.png",
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.grey.withOpacity(0.2),
            ),
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
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(
                      top: 40,
                      left: 18,
                      right: 18,
                      bottom: 100, // To avoid overlap with bottom icons
                    ),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                              left: 20,
                              right: 20),
                          child: Image.asset(
                            "assets/images/m2/start_bg_logo.png",
                          ),
                        ),
                        SizedBox(height: 25),
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset("assets/images/m2/barline.png"),
                              SizedBox(height: 20),
                              AppComponents.text(
                                controller.appController.appConstant.phoneNumber,
                                size: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                              ),
                              SizedBox(height: 8),
                              controller.mobileNumberTextField(),
                              SizedBox(height: 12),
                              AppComponents.text(
                                controller.appController.appConstant.password,
                                size: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                              ),
                              SizedBox(height: 8),
                              Obx(
                                    () => AppComponents.textField(
                                  controller.appController.appConstant
                                      .pleaseEnterYourPassword,
                                  hintColor: Colors.grey,
                                  obscure: controller.obscure.value,
                                  controller: controller.passwordC,
                                  suffixIcon: controller.suffixIcon.value,
                                  onTapIcon: () {
                                    controller.obscure.value =
                                    !controller.obscure.value;
                                    controller.suffixIcon.value =
                                    controller.obscure.value
                                        ? "assets/images/pass_hide.png"
                                        : "assets/images/pass_show.png";
                                  },
                                ),
                              ),
                              SizedBox(height: 12),
                              Row(
                                children: [
                                  Spacer(),
                                  InkWell(
                                    onTap: () {
                                      Get.toNamed(AppRoutes.forgetPassScreen);
                                    },
                                    child: AppComponents.text(
                                      controller.appController.appConstant
                                          .forgotPassword +
                                          "?",
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              AppComponents.appButton(
                                controller.appController.appConstant.login,
                                onTap: () {
                                  controller.login();
                                },
                              ),
                              SizedBox(height: 12),
                              Row(
                                children: [
                                  AppComponents.text(
                                    "Register New Account ",
                                    color: Colors.white,
                                  ),
                                  Spacer(),
                                  InkWell(
                                    onTap: () {
                                      Get.put(SignupController());
                                      Get.toNamed(AppRoutes.selectNation);
                                    },
                                    child: AppComponents.text(
                                      "Sign Up?",
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 25),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/images/m2/fb.png",
                          height: 67, width: 67),
                      SizedBox(width: 8),
                      Image.asset("assets/images/m2/xbox.png",
                          height: 67, width: 67),
                      SizedBox(width: 8),
                      Image.asset("assets/images/m2/apple.png",
                          height: 67, width: 67),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
