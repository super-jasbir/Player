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
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: PinCodeTextField(
          appContext: context,
          length: 6,
          onChanged: (value) {
            otpC.value = value;
          },
          onCompleted: (value) {
            otpC.value = value;
            update();
          },
          enableActiveFill: true,
          pinTheme: PinTheme(
            shape: PinCodeFieldShape.box,
            borderRadius: BorderRadius.circular(12),
            borderWidth: 1,
            fieldHeight: 54,
            fieldWidth: 46,
            activeColor: const Color(0xFF0288D1),
            inactiveColor: const Color(0xFFE5E7EB),
            selectedColor: const Color(0xFF29B6F6),
            activeFillColor: Colors.white,
            inactiveFillColor: Colors.white,
            selectedFillColor: Colors.white,
          ),
          keyboardType: TextInputType.number,
          textStyle: const TextStyle(
            fontSize: 20,
            color: Color(0xFF1A1A1A),
            fontWeight: FontWeight.w700,
          ),
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