import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../utils/app_color.dart';
import '../../base_controller.dart';
import '../../data/network/api_endpoints.dart';

class OtpVerificationController extends BaseController{
  var remainingTime = 60.obs;
  var showResend = false.obs;
  var otpC = "".obs;

  void startTimer() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingTime.value > 0) {
        remainingTime.value--;
      } else {
        timer.cancel();
        onTimerFinish();
      }
    });
  }

  void onTimerFinish() {
    showResend.value = true;
    // Add your callback logic here
  }
  @override
  void onInit() {
    startTimer();
    super.onInit();
  }
  Widget pinTextField(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(left: 22.0, right: 22),
        child: PinCodeTextField(
          // focusNode: node,
          appContext: context,

          length: 6,
          onChanged: (value) {

          },
          onCompleted: (value) {
            otpC.value = value;
           update();
          },
          pinTheme: PinTheme(
            shape: PinCodeFieldShape.box,
            borderRadius: BorderRadius.circular(5),
            borderWidth: 0.5,
            fieldHeight: 40,
            fieldWidth: 40,
            activeColor: Colors.white,
            inactiveColor: Colors.white,
            selectedColor: Colors.white,
          ),
          keyboardType: TextInputType.number,
          textStyle: const TextStyle(fontSize: 20, color: Colors.white),
          obscureText: false,
          obscuringCharacter: "*",
          animationType: AnimationType.fade,
          animationDuration: const Duration(milliseconds: 300),
        ),
      ),
    );
  }

  verifyOtp(String phoneNumber, String countryCode,String otp,String deviceType, String deviceToken,VoidCallback callback){
    var req = {
      "phone_number":phoneNumber,
      "country_code":"+"+ countryCode,
      "otp":otp,
      "device_token":deviceToken,
      "device_type":deviceType,
    };
    apiService.postRequest(ApiEndPoint.verifyOtp, req).then((value) {
      if(value.data !=null){
        callback.call();

      }else{
        Fluttertoast.showToast(msg: value.error??"something went wrong");
      }
    });
  }
}