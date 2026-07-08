import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:player/3dView/home_screen_player.dart';
import 'package:player/routes/app_routes.dart';
import 'package:player/ui/select_language/select_language_screen.dart';
import 'package:player/v2/home.dart';

import '../utils/app_color.dart';

class PermissionTwo extends StatefulWidget {
  const PermissionTwo({super.key});

  @override
  State<PermissionTwo> createState() => _PermissionOneState();
}

class _PermissionOneState extends State<PermissionTwo> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Stack(
        children: [
          InkWell(
            onTap: (){
              Get.offAll(HomeScreenPlayer());
            },
            child: Container(
              width: double.infinity,
              height: double.infinity,
              child: Image.asset(
                "assets/images/m2/temp_location.png",
                fit: BoxFit.cover, // Adjust to BoxFit.fill, BoxFit.contain, etc., as needed
              ),
            ),
          ),
          // Transparent Overlay


        ],
      ),
    );
  }
}
