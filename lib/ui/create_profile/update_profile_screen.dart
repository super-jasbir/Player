import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:player/ui/create_profile/update_profile.dart';
import 'package:player/ui/login_screen/login_controller.dart';
import 'package:player/ui/signup/signup_controller.dart';
import 'package:player/utils/app_components.dart';

import '../../routes/app_routes.dart';
import '../../utils/app_color.dart';
import '../../utils/app_fonts.dart';
import '../../utils/app_utils.dart';
import 'create_profileC.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<UpdateProfileScreen> {
  var controller = Get.put(UpdateProfileController());

  @override
  void initState() {
    controller.postalC.addListener(() {
      if(controller.postalC.text.length == 6){
        controller.getPostalCode(controller.postalC.text,(){
          setState(() {
            controller.addressC.text = controller.addressData?.address??"";
          });
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: [
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
          Column(
            children: [
              Container(
                margin: EdgeInsets.only(
                    top: 40,
                    left: 40,
                    right: 40),
                child: Image.asset(
                  "assets/images/m2/start_bg_logo.png",
                ),
              ),

              Align(
                alignment: Alignment.topCenter,
                child: Container(

                  margin: EdgeInsets.only(
                      top: 20,
                      left: 40,
                      bottom: 20,
                      right: 40),
                  child: Obx(() => controller.appController.uploadedImage.isNotEmpty
                      ? ClipOval(
                    child: InkWell(
                      child: Container(
                        height: 110,
                        width: 110,
                        child: Image.network(
                            controller.appController.uploadedImage.value),
                      ),
                      onTap: (){
                        controller.pickImage(camera: false, context: context);
                      },
                    ),
                  )
                      : InkWell(
                    onTap: () {
                      controller.pickImage(camera: false, context: context);
                    },
                    child: SvgPicture.asset("assets/images/upload_image.svg"),
                  )),
                ),
              ),

              /// main view
              Expanded(child: SingleChildScrollView(child: Container(
                  margin: EdgeInsets.only(
                      left: 18,
                      bottom: 20,
                      right: 18),
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
                            borderRadius: BorderRadius.circular(12)),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Container(
                                margin: EdgeInsets.only(left: 18,right: 18),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 20,),
                                    Image.asset("assets/images/m2/barline.png"),

                                    Container(
                                        margin: EdgeInsets.only(top: 12),
                                        child: AppComponents.text(
                                            controller.appConstant.fullName,
                                            size: 14,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400)),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    AppComponents.textField(
                                        controller.appConstant.enterFullName,
                                        controller: controller.fullNameC, enable: false),

                                    /// nick name
                                    Container(
                                        margin: EdgeInsets.only(top: 12),
                                        child: AppComponents.text(
                                            controller.appConstant.nickName,
                                            size: 14,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400)),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    AppComponents.textField(
                                        controller.appConstant.nickName,
                                        controller: controller.nickNameC),

                                    /// food type
                                    Container(
                                        margin: EdgeInsets.only(top: 12),
                                        child: AppComponents.text(
                                            "Food Type",
                                            size: 14,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400)),
                                    AppUtils.dropDown(context, controller.selectedFoodType, controller.foodType),

                                    Container(
                                        margin: EdgeInsets.only(top: 12),
                                        child: AppComponents.text(
                                            controller.appConstant.phoneNumber,
                                            size: 14,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400)),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    /// email
                                    controller.mobileNumberTextField(),
                                    Container(
                                        margin: EdgeInsets.only(top: 12),
                                        child: AppComponents.text(
                                            controller.appConstant.emailAddress,
                                            size: 14,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400)),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    AppComponents.textField("Enter Email Address",
                                        controller: controller.emailC, enable: false),

                                    /// add dob
                                    SizedBox(
                                      height: 16,
                                    ),
                                    Container(
                                        child: AppComponents.text(
                                            controller.appConstant.dateOfBirth,
                                            size: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white)),
                                    InkWell(
                                      onTap: () {
                                        AppUtils.showDatePickerDialogWithCallback(
                                            context,
                                                (date, timeStamp)
                                            {

                                              controller.dobC.text = date;
                                              print(timeStamp.year);
                                              controller.ageInYear.text =   AppUtils.calculateAge(timeStamp).toString();



                                            },
                                            lastDate: DateTime.now());
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(top: 15),
                                        child: AppComponents.textField(
                                            controller.appConstant.dob,
                                            controller: controller.dobC,
                                            enable: false,
                                            suffixIcon: "assets/images/date_picker.png",
                                            onTapIcon: () {
                                              AppUtils.showDatePickerDialogWithCallback(
                                                  context, (date, timeStamp)
                                              {
                                                controller.dobC.text = date;

                                                print(timeStamp.year+timeStamp.day+timeStamp.day);
                                                controller.ageInYear.text =   AppUtils.calculateAge(timeStamp).toString();

                                              });
                                            }),
                                      ),
                                    ),
                                    ///age in year
                                    Container(
                                        margin: EdgeInsets.only(top: 15),
                                        child: AppComponents.text(
                                            controller.appConstant.ageInYear,
                                            size: 14,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400)),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    AppComponents.textField("0",controller: controller.ageInYear, enable: false),

                                    /// postal code

                                    Container(
                                        margin: EdgeInsets.only(top: 15),
                                        child: AppComponents.text(
                                            "Postal Code",
                                            size: 14,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400)),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    AppComponents.textField(
                                        "Enter Postal Code",
                                        controller: controller.postalC),

                                    ///address
                                    Container(
                                        margin: EdgeInsets.only(top: 15),
                                        child: AppComponents.text(
                                            controller.appConstant.address,
                                            size: 14,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400)),
                                    SizedBox(height: 10,),
                                    Container(
                                      height: 80,
                                      child
                                          : AppComponents.textField(
                                          controller.appConstant.address,
                                          controller: controller.addressC,
                                          maxLines: 3



                                      ),
                                    ),

                                    /// unit number

                                    Container(
                                        margin: EdgeInsets.only(top: 15),
                                        child: AppComponents.text(
                                            "Unit Number",
                                            size: 14,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400)),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    AppComponents.textField(
                                        "Enter Unit Number",
                                        controller: controller.unitC),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Container(
                                        margin: EdgeInsets.only(top: 15),
                                        child: AppComponents.text(
                                            controller.appConstant.originOfCountry,
                                            size: 14,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400)),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    Obx(() => Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: InkWell(
                                                onTap: () {
                                                  controller.appLanguage.value = "local";
                                                  controller.selectedNation.value = "singapore";
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(20),
                                                      border: Border.all(
                                                          color: controller.appLanguage
                                                              .value ==
                                                              "local"
                                                              ? Colors.white
                                                              : Colors.grey,
                                                          width: controller.appLanguage
                                                              .value ==
                                                              "local"
                                                              ? 1
                                                              : 1))
                                                  ,
                                                  child: AppUtils.remoteImageLoader(
                                                      boxFit: BoxFit.fill,
                                                      "assets/images/m3/singapore_bg.png"),
                                                  height: 130,
                                                  width: 120,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 21,
                                            ),
                                            Expanded(
                                                child: InkWell(
                                                  onTap: () {
                                                    controller.appLanguage.value = "global";
                                                    controller.selectedNation.value = "outside_singapore";
                                                  },
                                                  child: Container(

                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(20),
                                                        border: Border.all(
                                                            color: controller.appLanguage
                                                                .value ==
                                                                "global"
                                                                ? Colors.white
                                                                : Colors.grey,
                                                            width: controller.appLanguage
                                                                .value ==
                                                                "global"
                                                                ? 2
                                                                : 1)),
                                                    child: AppUtils.remoteImageLoader(
                                                        boxFit: BoxFit.fill,
                                                        "assets/images/m3/foreigners_bg.png"),
                                                    height: 130,
                                                    width: 120,
                                                  ),
                                                )),
                                          ],
                                        ),
                                      ],
                                    )),

                                    ///country
                                    /* Container(
                                    margin: EdgeInsets.only(top: 15),
                                    child: AppComponents.text(
                                        controller.appConstant.originOfCountry,
                                        size: 14,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400)),
                                SizedBox(
                                  height: 16,
                                ),*/

                                    /* AppComponents.textField(
                                    controller.appConstant.originOfCountry,
                                    controller: controller.orginOfCountry),*/

                                    ///user id
                                    Container(
                                        margin: EdgeInsets.only(top: 15),
                                        child: AppComponents.text(
                                            controller.appConstant.userId,
                                            size: 14,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400)),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    AppComponents.textField("ad22342sss",
                                        controller: controller.userId, enable: false),

                                    /// passport
                                    Obx(()=> controller.selectedNation.value == "outside_singapore" ?
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                            margin: EdgeInsets.only(top: 15),
                                            child: AppComponents.text(
                                                "Passport Number",
                                                size: 14,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700)),
                                        SizedBox(
                                          height: 16,
                                        ),
                                        AppComponents.textField("Enter Passport Number",
                                            controller: controller.passPortC),
                                      ],
                                    ):
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                            margin: EdgeInsets.only(top: 15),
                                            child: AppComponents.text(
                                                "NRIC Number",
                                                size: 14,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700)),
                                        SizedBox(
                                          height: 16,
                                        ),
                                        AppComponents.textField("Enter NRIC Number",
                                            controller: controller.nricC),
                                      ],
                                    )),
                                    SizedBox(
                                      height: 16,
                                    ),

                                    AppComponents.appButton(controller.appConstant.submit,
                                        onTap: () {
                                          if(controller.appController.uploadedImage.isEmpty){
                                            Fluttertoast.showToast(msg: "Please select profile image");
                                            return;
                                          }
                                          if(controller.fullNameC.text.isEmpty){
                                            Fluttertoast.showToast(msg: "Please enter full name");
                                            return;
                                          }
                                          if(controller.nickNameC.text.isEmpty){
                                            Fluttertoast.showToast(msg: "Please enter nickname");
                                            return;
                                          }
                                          if(controller.dobC.text.isEmpty){
                                            Fluttertoast.showToast(msg: "Please select date of birth");
                                            return;
                                          }
                                          if(controller.addressC.text.isEmpty){
                                            Fluttertoast.showToast(msg: "Please enter address");
                                            return;
                                          }
                                          if(controller.unitC.text.isEmpty){
                                            Fluttertoast.showToast(msg: "Please enter Unit number");
                                            return;
                                          }
                                          /*if(controller.orginOfCountry.text.isEmpty){
                                        Fluttertoast.showToast(msg: "Please enter country origin");
                                        return;
                                      }*/

                                          controller.createProfile();
                                        }),
                                  ],
                                ),
                              ),


                              const SizedBox(
                                height: 25,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )),)),
            ],
          )
        ],
      )),
    );
  }
}
