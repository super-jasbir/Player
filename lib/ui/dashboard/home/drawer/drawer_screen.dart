import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../../../app_controller.dart';
import '../../../../data/local/shared_prefs.dart';
import '../../../../routes/app_routes.dart';
import '../../../../utils/app_color.dart';
import '../../../../utils/app_components.dart';


class DrawerScreen extends StatefulWidget {
  const DrawerScreen({super.key});

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  var appController = Get.find<AppController>();
  var clicked = false;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Container(
         color: AppColors.darkNavyBlue,
          child: Column(
            children: [
              Container(

                margin: const EdgeInsets.only(top: 18, left: 18),
                child: Row(
                  children: [
                    Container(
                      height: 58,
                      width: 58,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              width: .5, color: Colors.grey.withOpacity(.5))),
                      child: Padding(
                          padding: const EdgeInsets.all(4),
                          child:
                              AppComponents.text("")),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppComponents.text(appController.appConstant.spendRathone.toString().toUpperCase(),
                            color: AppColors.appColor, size: 16),
                        AppComponents.text(
                            "",
                            size: 14,
                            fontWeight: FontWeight.w500)
                      ],
                    )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 18, bottom: 5),
                height: 2,
                color: AppColors.lightGrey,
              ),
              Container(
                margin: const EdgeInsets.only(left: 18, right: 18, top: 24),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      "assets/images/language.svg",
                      color: Colors.white,
                      height: 24,
                      width: 24,
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    AppComponents.text(appController.appConstant.language,
                        size: 12, color: AppColors.white),
                    const Spacer(),
                    SvgPicture.asset(
                      "assets/images/right_arrow.svg",
                      color: Colors.white,
                      height: 24,
                      width: 24,
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              Container(
                margin: const EdgeInsets.only(left: 18, right: 18),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      "assets/images/change_pass.svg",
                      color: Colors.white,
                      height: 24,
                      width: 24,
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    AppComponents.text(appController.appConstant.changePassword,
                        size: 12, color: AppColors.white),
                    const Spacer(),
                    SvgPicture.asset(
                      "assets/images/right_arrow.svg",
                      height: 24,
                      width: 24,
                    )
                  ],
                ),
              ),

              Expanded(child: Container()),
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                height: 2.5,
                color: AppColors.lightGrey,
              ),
              InkWell(
                onTap: () async{
                setState(() {
                  clicked = true;
                });


                 await SharedPref.clearPref();
                  Get.offAllNamed(AppRoutes.loginScreen);
                },
                onHover: (value){
                  if(value){

                  }
                },
                child: Container(
                  height: 40,
                  color: clicked? Colors.black:null,

                  margin: const EdgeInsets.only( bottom: 28),
                  child: Container(
                    margin: EdgeInsets.only(left: 18,right: 18),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          "assets/images/logout.svg",
                          color: AppColors.appColor,
                          height: 24,
                          width: 24,
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        AppComponents.text(appController.appConstant.logout,
                            size: 14, color: AppColors.white)
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
