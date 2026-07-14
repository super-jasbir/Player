
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:player/base_controller.dart';
import 'package:player/data/modal/signup_response.dart';
import 'package:player/data/network/api_service.dart';

import '../../data/network/api_endpoints.dart';
import '../../utils/app_color.dart';
import '../../utils/app_fonts.dart';

class SignupController extends BaseController{
  TextEditingController mobileController =TextEditingController();
  TextEditingController fullName =TextEditingController();
  TextEditingController email =TextEditingController();
  TextEditingController passC =TextEditingController();
  TextEditingController confirmPassC =TextEditingController();
  TextEditingController referralCode =TextEditingController();
  var path = "".obs;
  var suffixIcon = "assets/images/pass_hide.png".obs;
  var selectedDialCode ="65";
  var obscure = true.obs;
  var agree = false.obs;
  var signUpOtp = "";
  var uploadedProfileImage = "";
  File? profilePic;


  pickImage(
      {bool camera = false,
        BuildContext? context,
        bool insuranceCard = false}) async {
    final ImagePicker picker = ImagePicker();
    try {
      XFile? pickedFile = await picker.pickImage(
        source: camera ? ImageSource.camera : ImageSource.gallery,
      );

      if (pickedFile == null) {
        // User did not pick an image, handle accordingly
        path.value = "";
        return;
      }

      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path ?? '',
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            aspectRatioPresets: [
              CropAspectRatioPreset.square,
            ],
          ),
          AndroidUiSettings(
            toolbarTitle: "Image Picker",
            toolbarColor: AppColors.appColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: false,
          ),
          IOSUiSettings(
            title: "Image Picker",
          ),
        ],
      );

      profilePic = File(croppedFile?.path ?? pickedFile.path);

      path.value = profilePic!.absolute.path;

      var result = await uploadProfilePicture(profilePic!);
      print("imageUploaded $result");
      uploadedProfileImage = result;
      appController.uploadedImage.value = result;
    } catch (e) {
      print(e);
    }
  }
  Future<String> uploadProfilePicture(File image) async {
    String profilePath = "";
    try {
      final response =
      await ApiService2().uploadFile(ApiEndPoint.uploadFile, 'image', image);
      if (response.statusCode == 200) {
        var image = response.data as Map<String, dynamic>;
        var d1 = image['image_url'];

        profilePath = d1;
        return profilePath;
      }
    } catch (ex) {
      print("imageError: $ex");
    }
    return profilePath;
  }



  Widget mobileNumberTextField() {
    return Container(
        height: 56,
        decoration: BoxDecoration(
          color: Colors.white,
            borderRadius: BorderRadius.circular(14.0),
            border: Border.all(color: const Color(0xFFE0D5F0), width: 1)),
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
                      fontSize: 13,
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
  SignUpData ? signUpData;
  signUp(VoidCallback callback){
    var req ={
      "profilePic":"https://healthcareapp-bucket.s3.me-south-1.amazonaws.com/profile_image/1734706134_57188.jpg",
      "name":fullName.text,
      "email":email.text,
      "phone_number":mobileController.text,
      "country_code": "+"+selectedDialCode,
      "password":passC.text,
      "password_confirmation":confirmPassC.text,
      "referral_code":referralCode.text,
    };
    apiService.postRequest(ApiEndPoint.signUp, req).then((value) {
      if(value.data !=null){
        var data = SignupResponse.fromJson(value.data!);
        signUpData = data.data;
        signUpOtp = data.otp.toString();
      callback.call();

      }else{
        Fluttertoast.showToast(msg: value.error.toString());
      }
    });
  }

}