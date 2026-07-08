
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:player/data/modal/forgot_password_response.dart';


import '../../../utils/app_fonts.dart';
import '../../base_controller.dart';
import '../../data/network/api_endpoints.dart';
import '../../routes/app_routes.dart';

class ForgetPassController extends BaseController{
  var selectedDialCode = "65";
  TextEditingController mobileController = TextEditingController();

  Widget mobileNumberTextField() {
    return Container(
        height: 52,
        decoration: BoxDecoration(
          color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: Colors.grey.withOpacity(.5), width: .5)),
        child: Theme(
            data: ThemeData(
              inputDecorationTheme: const InputDecorationTheme(
                border: InputBorder.none, // Remove default underline
              ),
            ),
            child: Center(
              child: IntlPhoneField(
                controller: mobileController,
                flagsButtonPadding: const EdgeInsets.only(left: 8, right: 0),
                dropdownIconPosition: IconPosition.trailing,
                dropdownTextStyle: const TextStyle(
                    fontSize: 16,
                    fontFamily: AppFonts.satoshiRegular,
                    color: Colors.black),
                style: const TextStyle(
                    fontSize: 16,
                    fontFamily: AppFonts.satoshiRegular,
                    color: Colors.black),
                autovalidateMode: AutovalidateMode.disabled,
                decoration: InputDecoration(
                  hintText: appConstant.enterYourPhoneNumber,
                  hintStyle: const TextStyle(
                      fontSize: 16,
                      fontFamily: AppFonts.satoshiRegular,
                      color: Colors.grey),
                  focusedBorder: InputBorder.none,
                  counterText: '',
                ),
                initialCountryCode: "SG",
                disableLengthCheck: true,
                onChanged: (value) {},
                showCountryFlag: false,
                onCountryChanged: (value) {
                  selectedDialCode = value.dialCode;
                },
              ),
            )));
  }

  forgetPassword( String countryCode,String phoneNumber)async{

    var result = await apiService.postRequest(ApiEndPoint.forgetPass+"country_code=$countryCode&phone_number=$phoneNumber",{});
    if(result.data != null){
      var data = ForgotPasswordResponse.fromJson(result.data!);
      appController.playerId = data.data.id.toString();
      appController.userId = data.data.userId;
      appController.deviceToken = data.data.deviceToken;
      appController.deviceType = data.data.deviceType;
      appController.id = data.data.id.toString();
      // success redirect

      Get.toNamed(AppRoutes.otpScreen,arguments: {
        "otpType":AppRoutes.createNewPassword,
        "playerId":data.data.id,
        "id":data.data.id.toString(),
        "number":mobileController.text,
        "countryCode":selectedDialCode,
        "otp":data.otp,
        "deviceToken":data.data.deviceToken,
        "deviceType":data.data.deviceType,
      });
    }else{
      Fluttertoast.showToast(msg: result.error.toString());
    }

  }
}