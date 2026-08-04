import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../app_color.dart';
import '../app_components.dart';
import '../app_fonts.dart';



class PermissionDialog extends StatelessWidget {
  final String image;
  final String label;
  final String description;
  final bool showGif;
  final double size;
  final Function(String)? callback;

  PermissionDialog(
      {required this.image,
        required this.label,
        required this.description,
        required this.showGif,

        this.size = 100,
        this.callback,
      }
      );

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        height: 360,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12)
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              image,
              width: size,
              height: size,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16),
            AppComponents.text(
              label,
              color: AppColors.black
                ,size: 16
            ),
            const SizedBox(height: 8),
            AppComponents.text(
              description,
              size: 14,
              fontWeight: FontWeight.w500,
              textAlign: TextAlign.center,
              maxLine: 2
            ),
            const SizedBox(height: 26),
            AppComponents.appButton("Allow",height: 42,onTap: (){
              callback?.call("allowed");
            }),
            const SizedBox(height: 20,),
            InkWell(
              onTap: (){
                callback?.call("notAllowed");

              },
                child: AppComponents.text("Not Now",fontWeight: FontWeight.normal,color: AppColors.appColor,size: 14))

          ],
        ),
      ),
    );
  }
}
