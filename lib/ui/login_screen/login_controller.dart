
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:player/3dView/home_screen_player.dart';
import 'package:player/base_controller.dart';
import 'package:player/data/local/shared_prefs.dart';
import 'package:player/data/network/api_endpoints.dart';
import '../../utils/app_fonts.dart';

class LoginController extends BaseController{
  TextEditingController mobileController =TextEditingController();
  TextEditingController passwordC =TextEditingController();
  var suffixIcon = "assets/images/pass_hide.png".obs;
  var selectedDialCode ="+65";
  var obscure = true.obs;
  Widget mobileNumberTextField() {
    return Container(
        height: 56,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.0),
            color: Colors.white,
            border: Border.all(color: const Color(0xFFE5E7EB), width: 1)),
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
                textAlignVertical: TextAlignVertical.center,
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
  login(){
    var req ={
      "phone_number":mobileController.text,
      "country_code":selectedDialCode,
      "password":passwordC.text
    };
    apiService.postRequest(ApiEndPoint.login, req).then((value) {
      if(value.data !=null){
        var json = value.data;
        var token = json?["token"];
        var userID = json?["data"]["userID"];
        var ID = json?["data"]["id"];
        var referalCode = json?["data"]["referal_code"];
        var referalPoints = json?["data"]["referal_points"];
        SharedPref.saveAccessToken(token);
        SharedPref.saveUserID(userID);
        SharedPref.saveID(ID.toString());
        SharedPref.saveReferalCode(referalCode.toString());
        SharedPref.saveReferalPoints(referalPoints.toString());

        Get.offAll(HomeScreenPlayer());
      }else{
        Fluttertoast.showToast(msg: value.error.toString());
      }
    });
  }
}