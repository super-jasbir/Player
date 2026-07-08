import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:player/ui/login_screen/login_controller.dart';
import 'package:player/ui/signup/signup_controller.dart';
import 'package:player/utils/app_components.dart';

import '../../routes/app_routes.dart';
import '../../utils/app_color.dart';
import '../../utils/app_utils.dart';
import 'create_profileC.dart';

class CreateProfileScreen extends StatefulWidget {
  const CreateProfileScreen({super.key});

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  var controller = Get.put(CreateProfileController());

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
          Container(
            margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * .09,
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
                  top: MediaQuery.of(context).size.height * .19,
                  left: 40,
                  right: 40),
              child: Obx(() => controller.appController.uploadedImage.isNotEmpty
                  ? ClipOval(
                    child: Container(
                      height: 80,
                      width: 80,
                      child: Image.network(
                          controller.appController.uploadedImage.value),
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

          Container(
              margin: EdgeInsets.only(
                  left: 18,
                  top: MediaQuery.of(context).size.height * .32,
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
                                    controller: controller.fullNameC),

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
                                SizedBox(
                                  height: 16,
                                ),
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
                                controller.mobileViewOnly(),

                                /// email

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
                                              context,
                                                  (date, timeStamp)
                                              {
                                                controller.dobC.text = date;

                                                print(timeStamp.year+timeStamp.day+timeStamp.day);


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
                                AppComponents.textField("25",controller: controller.ageInYear),

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

                                ///country
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
                                AppComponents.textField(
                                    controller.appConstant.originOfCountry,
                                    controller: controller.orginOfCountry),

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
                                    controller: controller.userId),

                                /// passport

                               controller.appController.selectedNation =="outside_singapore"?
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
                               ): Column(
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
                                       controller: controller.passPortC),
                                 ],
                               ),

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
                                      if(controller.orginOfCountry.text.isEmpty){
                                        Fluttertoast.showToast(msg: "Please enter country origin");
                                        return;
                                      }

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
              )),


        ],
      )),
    );
  }
}
