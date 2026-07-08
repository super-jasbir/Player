import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:player/app_controller.dart';
import 'package:player/settings.dart';
import 'package:player/utils/app_color.dart';
import 'package:player/utils/app_utils.dart';

import '../data/local/shared_prefs.dart';
import '../game/game_screen.dart';
import '../routes/app_routes.dart';
import '../ui/mysteryBox/mysterybox.dart';
import '../utils/app_components.dart';

class HomeScreenPlayer extends StatefulWidget {
  const HomeScreenPlayer({super.key});

  @override
  State<HomeScreenPlayer> createState() => _HomeScreenPlayerState();
}

class _HomeScreenPlayerState extends State<HomeScreenPlayer> {
  var appC = Get.find<AppController>();

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 1), () {
      appC.getProfile(() async {

      });
    });
    return Scaffold(

        body: Stack(
          children: [



            // /// spend logo
            // Container(
            //   margin: EdgeInsets.only(
            //       top: MediaQuery.of(context).size.height * .16,
            //       left: 20,
            //       right: 20),
            //   child: Image.asset(
            //     "assets/images/m2/start_bg_logo.png",
            //   ),
            // ),

            Container(
              width: double.infinity,
              height: double.infinity,
              child: Image.asset(
                "assets/images/m2/temp_3d_screen.jpeg",
                fit: BoxFit
                    .cover, // Adjust to BoxFit.fill, BoxFit.contain, etc., as needed
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: InkWell(
                onTap: (){

                },
                child: Container(),
              ),
            ),
            //login signup
            Positioned(
              bottom: MediaQuery.of(context).size.height * .3,
              left: MediaQuery.of(context).size.width * .01,
              child: Transform.rotate(
                angle: 0,
                child:  Obx(()=> appC.hasData.value ? Container(
                  // Set the desired width
                  height: 40,
                  width: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12), // Rounded corners
                  ),
                  child: InkWell(
                    onTap: (){
                      Get.toNamed(AppRoutes.updateProfile);
                      // Get.toNamed(AppRoutes.loginScreen);
                    },
                    child: Center(child: AppComponents.text("My Profile",color: Colors.black,fontWeight: FontWeight.w800),),
                  ),
                ) : Container(
                  // Set the desired width
                  height: 40,
                  width: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12), // Rounded corners
                  ),
                  child: InkWell(
                    onTap: (){
                      Get.toNamed(AppRoutes.loginScreen);
                    },
                    child: Center(child: AppComponents.text("Login/Signup",color: Colors.black,fontWeight: FontWeight.w800),),
                  ),
                )),
              ),
            ),
            // gaming
            Positioned(

              bottom: MediaQuery.of(context).size.height * .52,
              left: MediaQuery.of(context).size.width * .02,
              child: Transform.rotate(
                angle: 0,
                child: Container(
                  // Set the desired width
                  height: 40,
                  width: 100,

                  decoration: BoxDecoration(
                 // Semi-transparent color
                    color: Colors.white, // Semi-transparent color

                    borderRadius: BorderRadius.circular(8), // Rounded corners
                    // boxShadow: [
                    //   BoxShadow(
                    //     color: Colors.black,
                    //     offset: Offset(0, 4), // Shadow position
                    //     blurRadius: 10, // Blur radius for softness
                    //   ),
                    // ],
                  ),
                  child: InkWell(
                    onTap: ()async{
                      var token = await SharedPref.getAccessToken();
                      if(token!=null){
                        Get.to(GameScreen());
                      }else{
                      Fluttertoast.showToast(msg: "Please Login To Continue...");

                      }
                    },
                    child: Center(child: AppComponents.text("Start Game",color: Colors.black,fontWeight: FontWeight.w800),),
                  ),
                )
              ),
            ),
            // setting
            Positioned(

              bottom: MediaQuery.of(context).size.height * .3,
              right: MediaQuery.of(context).size.width * .02,
              child: Transform.rotate(
                angle: 0,
                child:  Container(
                  // Set the desired width
                  height: 40,
                  width: 120,

                  decoration: BoxDecoration(
                  color: Colors.white,
                    borderRadius: BorderRadius.circular(16), // Rounded corners

                  ),
                  child: InkWell(
                    onTap: (){
                      Get.to(MySteryBox());
                    },
                    child: Center(child: AppComponents.text("Mystery Box",color: Colors.black,fontWeight: FontWeight.w800),),
                  ),
                )
              ),
            ),
            // mystry box
            Positioned(

              bottom: MediaQuery.of(context).size.height * .52,
              right: MediaQuery.of(context).size.width * .12,
              child: Transform.rotate(
                angle: 0,
                child: Container(

                  // Set the desired width
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12), // Rounded corners

                  ),
                  child: InkWell(
                    onTap: (){
                      Get.to(SettingScreen());
                    },
                    child: Center(child: AppComponents.text("  Settings  ",color: Colors.black,fontWeight: FontWeight.w800),),
                  ),
                ),
              ),
            ),

          ],
        )
    );
  }
}
