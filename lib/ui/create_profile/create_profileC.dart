
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
import 'package:player/data/modal/postalCode/get_postal_response.dart';
import 'package:player/data/network/api_service.dart';
import 'package:player/routes/app_routes.dart';
import 'package:player/ui/signup/signup_controller.dart';
import 'package:player/utils/app_components.dart';

import '../../data/network/api_endpoints.dart';
import '../../utils/app_color.dart';
import '../../utils/app_fonts.dart';

class CreateProfileController extends BaseController{
  TextEditingController mobileController =TextEditingController();
  TextEditingController emailC =TextEditingController();
  TextEditingController fullNameC =TextEditingController();
  TextEditingController nickNameC =TextEditingController();
  TextEditingController foodTypeC =TextEditingController();
  TextEditingController ageInYear =TextEditingController();
  TextEditingController orginOfCountry =TextEditingController();
  TextEditingController addressC =TextEditingController();
  TextEditingController postalC =TextEditingController();
  TextEditingController unitC =TextEditingController();
  TextEditingController userId =TextEditingController();
  TextEditingController passPortC =TextEditingController();

  AddressData? addressData;
  var signUpC = Get.find<SignupController>();
  var suffixIcon = "assets/images/pass_hide.png".obs;
  var selectedDialCode ="";
  var obscure = true.obs;
  var agree = false.obs;
  var path = "".obs;
  var selectedFoodType = "select".obs;
  var foodType =["Carnivorous","Omnivorous","Halal","Non-Halal"];
  var uploadedProfileImage = "";
  File? profilePic;
  TextEditingController dobC = TextEditingController();
  
  getPlayerUniqueId(){
    apiService.postRequest(ApiEndPoint.uniqueId, {}).then((value) {
      if(value.data !=null){
        var json = value.data;
        var data = json?["unique_id"];
        userId.text = data;
      }
    });
  }



  createProfile(){
    var req = {
      "name":fullNameC.text,
      "phone_number": signUpC.mobileController.text,
      "country_code": "+"+signUpC.selectedDialCode,
      "password":signUpC.passC.text,
      "password_confirmation":signUpC.confirmPassC.text,
      "nickName":nickNameC.text,
      "foodType":selectedFoodType.value,
      "dateOfBirth":dobC.text,
      "address":addressC.text,
      "originOfCountry":orginOfCountry.text,
      "userID": userId.text,
      "profilePic":appController.uploadedImage.value.isNotEmpty?appController.uploadedImage.value:uploadedProfileImage,
      "email":signUpC.email.text,
      "passportNumber":passPortC.text,
      "unit_number":unitC.text,

    };
    apiService.postRequest(ApiEndPoint.register, req).then((value) {
      if(value.data !=null){
        Get.offAllNamed(AppRoutes.loginScreen);
      }
    });
  }
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
    var apiService2 = ApiService2();


    String profilePath = "";
    try {
      final response =

      await apiService2.uploadFile(ApiEndPoint.uploadFile, 'image', image);
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
                initialCountryCode: selectedDialCode,
                disableLengthCheck: false,
                onChanged: (value) {},
                showCountryFlag: false,
                onCountryChanged: (value) {
                  selectedDialCode = value.dialCode;

                },
              ),
            )));
  }

  Widget mobileViewOnly(){
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey,width: .5)
      ),
      height: 52,
      child: Row(
        children: [
          SizedBox(width: 18,),
          AppComponents.text("+"+signUpC.selectedDialCode,size: 14),
          SizedBox(width: 6,),
          Icon(Icons.arrow_drop_down_rounded),
          SizedBox(width: 6,),
          AppComponents.text(signUpC.mobileController.text,color: Colors.grey,size: 14)
        ],
      ),
    );
  }

  getPostalCode(String code,VoidCallback callback){
    apiService.getRequest(ApiEndPoint.getPostal+"postal_code=$code",isBearer: false).then((value) {
      if(value.data!=null){
        var data = PostalCodeResponse.fromJson(value.data!);
        addressData = data.data;
        callback.call();
      }else{
        Fluttertoast.showToast(msg: value.error.toString());
      }
    });

  }

  @override
  void onInit() {

    getPlayerUniqueId();

    fullNameC.text = signUpC.fullName.text;
    emailC.text = signUpC.email.text;
    selectedDialCode = signUpC.selectedDialCode;
    mobileController.text = signUpC.mobileController.text;


    super.onInit();
  }

}