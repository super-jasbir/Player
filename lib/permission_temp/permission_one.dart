import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:player/permission_temp/permission_two.dart';

import '../utils/app_color.dart';

class PermissionOne extends StatefulWidget {
  const PermissionOne({super.key});

  @override
  State<PermissionOne> createState() => _PermissionOneState();
}

class _PermissionOneState extends State<PermissionOne> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Stack(
        children: [
          InkWell(
            onTap: (){
              Get.to(PermissionTwo());
            },
            child: Container(
              width: double.infinity,
              height: double.infinity,
              child: Image.asset(
                "assets/images/m2/temp_notification.png",
                fit: BoxFit.cover, // Adjust to BoxFit.fill, BoxFit.contain, etc., as needed
              ),
            ),
          ),
          InkWell(
            onTap: (){
              Get.to(PermissionTwo());
            },
            child: Container(
              alignment: Alignment.center,
              height: 100,
            ),
          )
          // Transparent Overlay


        ],
      ),
    );
  }
}
