import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:player/data/network/api_endpoints.dart';
import 'package:player/permission_temp/permission_one.dart';
import 'package:player/routes/app_routes.dart';
import 'package:player/ui/login_screen/login_screen.dart';
import 'package:player/ui/signup/signup_screen.dart';
import 'package:player/utils/app_components.dart';
import 'package:player/utils/app_utils.dart';

/*class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(
              "assets/images/app_bg.png",
              fit: BoxFit
                  .cover, // Adjust to BoxFit.fill, BoxFit.contain, etc., as needed
            ),
          ),
          // Transparent Overlay
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.blue
                .withOpacity(0.2), // Adjust opacity and color as needed
          ),

          /// spend logo
          Container(
            margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * .17,
                left: 20,
                right: 20),
            child: Image.asset(
              "assets/images/spendrathonLogo.png",
              color: Colors.white,
            ),
          ),

          /// lifestyle logo
          Positioned(
              top: 0,
              right: 0,
              left: 0,
              bottom: 0,
              child: Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  child: Image.asset(
                    "assets/images/life_style_logo.png",
                    height: 35,
                    width: 270,
                  ))),

          Center(
              child: Container(
            margin: EdgeInsets.only(top: 260),
            child: CupertinoActivityIndicator(
              color: Colors.white,
              radius: 30,
            ),
          )),

          /// glass view
          Positioned(
            bottom: 0, // Align at the bottom
            left: 0, // Align to the start of the screen
            right: 0,
            child: Container(
              // Set the desired width
              height: 191, // Set the desired height
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3), // Semi-transparent color
                borderRadius: BorderRadius.circular(16), // Rounded corners
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4), // Shadow color
                    offset: Offset(0, 4), // Shadow position
                    blurRadius: 10, // Blur radius for softness
                  ),
                ],
              ),
            ),
          ),

          /// get started button
          Positioned(
              bottom: 50, // Align at the bottom
              left: 0, // Align to the start of the screen
              right: 0,
              child: AppComponents.appButton("Get Started", callback: () {
                Get.to(PermissionOne());
              })),
        ],
      ),
    );
  }
}*/


class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
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
                top: MediaQuery.of(context).size.height * .28,
                left: 20,
                right: 20),
            child: Image.asset(
              "assets/images/m2/start_bg_logo.png",
            ),
          ),
          Center(
            child: Row(
              children: [
                SizedBox(width: 30,),
                Expanded(
                  child: InkWell(
                    onTap: (){
                      Get.toNamed(AppRoutes.loginScreen);
                    },
                      child: Image.asset("assets/images/m2/login_bg.png")),
                ),
                SizedBox(width: 15,),
                Expanded(
                  child: InkWell(
                    onTap: (){
                      Get.toNamed(AppRoutes.signUpScreen);
                    },
                      child: Image.asset("assets/images/m2/signup_bg.png")),
                ),
                SizedBox(width: 30,),
              ],
            ),
          ),

          /// glass view
          Positioned(
            bottom: 0, // Align at the bottom
            left: 0, // Align to the start of the screen
            right: 0,
            child: AppUtils.glassView(),
          ),


        ],
      ),
    );
  }
}
