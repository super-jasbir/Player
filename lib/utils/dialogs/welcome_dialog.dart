
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../app_color.dart';
import '../app_components.dart';
import '../app_fonts.dart';



class WelcomeDialog extends StatelessWidget {
  final String image;
  final String label;
  final String description;
  final bool showGif;
  final double size;
  final Function(String)? callback;

  WelcomeDialog(
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

        height: 300,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/images/m2/home_page_bg.png"),fit: BoxFit.fill),
            color: Colors.white,
            borderRadius: BorderRadius.circular(12)
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [

            const SizedBox(height: 16),
            Row(
              children: [
                Spacer(),
                AppComponents.text("Welcome To City",color: Colors.white,size: 18),
                Spacer(),
              ],
            ),



            const SizedBox(height: 8),
            Expanded(child: Container()),
           ElevatedButton(onPressed: (){
             callback?.call("");
           }, child: Text("Visit City")),
            const SizedBox(height: 26),


          ],
        ),
      ),
    );
  }
}
