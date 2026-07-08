import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:player/ui/splash/splash_screen_controller.dart';

import '../../utils/progress_bar/progress_loader.dart';

class SplashScreen extends StatefulWidget {

  SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreen();
}

class _SplashScreen extends State<SplashScreen> {

  var controller = Get.put(SplashScreenController());

  @override
  Widget build(BuildContext context) {

    controller.splashDelay();

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(left: 25,right: 25),
                  child: Image.asset("assets/images/spendrathonLogo.png",color: Colors.black,)),
              SizedBox(height: 40,),
              CupertinoActivityIndicator(
                color: Colors.black,
                radius: 30,
              )
            ],
          )

      /*    Container(

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/images/mouse.gif", height: 200, width: 200),
                    const SizedBox(width: 20),
                    Image.asset("assets/images/coin.gif", height: 80, width: 80),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  height: 66,
                  margin: EdgeInsets.only(left: 20,right: 20),

                  child: HorizontalBarLoader(durationInSeconds: 4),
                ),
              ],
            ),
          ),*/
        ),
      ),
    );
  }
}
