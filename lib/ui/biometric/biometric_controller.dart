import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';

import '../../base_controller.dart';
import '../../routes/app_routes.dart';
import '../../utils/app_color.dart';
import '../../utils/app_components.dart';
import '../../utils/common_constants.dart';

class BiometricController extends BaseController {
  String _authorized = "Not Authorized";
  var biometricType = "finger".obs;
  var isFingerPrintEnable = false.obs;
  var agreed = false.obs;

  detectBiometric() async {
    bool authenticated = false;
    final LocalAuthentication auth = LocalAuthentication();
    try {
      // Check if biometric authentication is available
      bool canCheckBiometrics = await auth.canCheckBiometrics;
      List<BiometricType> availableBiometrics =
          await auth.getAvailableBiometrics();

      // Check if the device has face recognition
      if (availableBiometrics.contains(BiometricType.face)) {
      } else if (availableBiometrics.contains(BiometricType.fingerprint)) {
        // Otherwise, fallback to fingerprint
      } else {
        Get.offAllNamed(AppRoutes.selectLanguage);
        // _authorized = "No biometric authentication available";
        // return;
      }
    } on PlatformException catch (e) {
      _authorized = "Error: ${e.message}";

      return;
    }
  }

  fingerPrint() async {
    final LocalAuthentication auth = LocalAuthentication();

    var result = await auth.authenticate(
      localizedReason: "Please authenticate with your fingerprint",
      options: const AuthenticationOptions(
        useErrorDialogs: true,
        stickyAuth: true,
      ),
    );
    if (result) {
      Get.offAllNamed(AppRoutes.selectLanguage);
    }
  }

  faceScan() async {
    final LocalAuthentication auth = LocalAuthentication();
    var result = await auth.authenticate(
      localizedReason: "Please authenticate with your face",
      options: const AuthenticationOptions(
        useErrorDialogs: true,
        stickyAuth: true,
      ),
    );
    if (result) {
      Get.offAllNamed(AppRoutes.selectLanguage);
    }
  }

  Widget loadUi(String biometricType) {
    switch (biometricType) {
      case "face":
        {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 12,
              ),
              AppComponents.text(appConstant.enableFaceId,
                  size: 16, color: Colors.black),
              const SizedBox(
                height: 32,
              ),
              SvgPicture.asset(
                "assets/images/face_authentication_image.svg",
                height: 120,
                width: 120,
              ),
              const SizedBox(
                height: 32,
              ),
              AppComponents.text(appConstant.enableFaceIdLogin,
                  size: 16, color: AppColors.black),
              const SizedBox(
                height: 12,
              ),
              AppComponents.text(appConstant.faceIdText,
                  size: 14,
                  fontWeight: FontWeight.w500,
                  textAlign: TextAlign.center),
              const SizedBox(
                height: 12,
              ),
              Container(
                height: 58,
                decoration: BoxDecoration(
                    color: AppColors.appColor.withOpacity(.4),
                    borderRadius: BorderRadius.circular(8)

                ),
                child: Row(
                  children: [
                    const SizedBox(width: 16,),
                    AppComponents.text(appConstant.enableFaceId,
                        size: 14, color: AppColors.black),
                    const Spacer(),
                    Transform.scale(
                      scale: .9,
                      child: Switch(value: isFingerPrintEnable.value, onChanged: (value){
                        isFingerPrintEnable.value = value;
                        update();
                      },activeColor: Colors.black,
                        trackOutlineColor: MaterialStatePropertyAll(AppColors.appColor),
                        inactiveTrackColor: Colors.grey.withOpacity(.5),
                        inactiveThumbColor: Colors.grey,

                      ),
                    ),
                    const SizedBox(width: 16,),


                  ],
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Align(
                alignment: AlignmentDirectional.topStart,
                child: AppComponents.text(appConstant.youCanTurnOffBiometricText,
                    size: 12,fontWeight: FontWeight.w500),
              ),
              Expanded(child: Container()),
              Row(
                children: [
                  Checkbox(value: agreed.value, onChanged: (value){
                    agreed.value = value!;
                    update();

                  },activeColor: AppColors.appColor,),
                  AppComponents.text(appConstant.iAgreeToTerms,
                      size: 12,fontWeight: FontWeight.w500,color: AppColors.black)

                ],
              ),
              SizedBox(height: 24,),
              AppComponents.appButton("Proceed",onTap: (){
                Get.offAllNamed(AppRoutes.selectLanguage);
              }),
              SizedBox(height: 30,)

            ],
          );
        }
      case "finger":
        {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 12,
              ),
              AppComponents.text(appConstant.enableBioMetric,
                  size: 20, color: Colors.white),
              const SizedBox(
                height: 32,
              ),
              SvgPicture.asset(
                "assets/images/finger_print_image.svg",
                height: 120,
                width: 120,
              ),
              const SizedBox(
                height: 32,
              ),
              AppComponents.text(appConstant.enableBioMetricLogin,
                  size: 16, color: Colors.black),
              const SizedBox(
                height: 12,
              ),
              AppComponents.text(appConstant.bioMetricText,
                  size: 14,
                  fontWeight: FontWeight.w500,
                  textAlign: TextAlign.center,
                maxLine: 2
              ),
              const SizedBox(
                height: 12,
              ),
              Container(
                height: 58,
                decoration: BoxDecoration(
                  color: AppColors.appColor.withOpacity(.8),
                  borderRadius: BorderRadius.circular(8)

                ),
                child: Row(
                  children: [
                   const SizedBox(width: 16,),
                    AppComponents.text(appConstant.enableBioMetric,
                        size: 14, color: Colors.white),
                   const Spacer(),
                    Transform.scale(
                      scale: .9,
                      child: Switch(value: isFingerPrintEnable.value, onChanged: (value){
                        isFingerPrintEnable.value = value;
                        if(value){
                          fingerPrint();
                        }
                        update();
                      },activeColor: AppColors.appColor,
                        trackOutlineColor: MaterialStatePropertyAll(Colors.white),
                        inactiveTrackColor: Colors.grey.withOpacity(.5),
                        inactiveThumbColor: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 16,),


                  ],
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Align(
                alignment: AlignmentDirectional.topStart,
                child: AppComponents.text(appConstant.youCanTurnOffBiometricText,
                    size: 12,fontWeight: FontWeight.w500),
              ),
              Expanded(child: Container()),
              Row(
                children: [
                  Checkbox(value: agreed.value, onChanged: (value){
                    agreed.value = value!;
                    update();

                  },activeColor: AppColors.appColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2.0),
                    ),
                    side: MaterialStateBorderSide.resolveWith(
                          (states) => BorderSide(width: 1.0, color: Colors.black),
                    ),
                  ),
                  AppComponents.text(appConstant.iAgreeToTerms,
                      size: 12,fontWeight: FontWeight.w500,color: Colors.black)

                ],
              ),
              SizedBox(height: 24,),
              AppComponents.appButton("Proceed",onTap: (){
                if(agreed.value){
                  Get.offAllNamed(AppRoutes.selectLanguage);

                }else{
                  Fluttertoast.showToast(msg:CommonConstants.pleaseAcceptTermsAndCondition );
                }
              }),
              SizedBox(height: 30,)

            ],
          );
        }
    }
    return Container();
  }
}
