
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../app_color.dart';
import '../app_components.dart';
import '../app_fonts.dart';



class CancelDialog extends StatelessWidget {
  final String image;
  final String label;
  final String description;
  final bool showGif;
  final double size;
  final Function(String)? callback;

  CancelDialog(
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
                AppComponents.text("Cancelation Reason",color: Colors.black,size: 18),
                Spacer(),
                InkWell(
                    onTap: (){
                      Get.back();
                    },
                    child: Icon(Icons.close))
              ],
            ),


            Container(
                margin: EdgeInsets.only(top: 20),
                height: 100,
                child: AppComponents.textField("Write Instructions")),
            const SizedBox(height: 8),
            Expanded(child: Container()),
            InkWell(
                onTap: (){
                  callback?.call("submit");
                },
                child: AppComponents.appButton("Submit",height: 42)),
            const SizedBox(height: 26),


          ],
        ),
      ),
    );
  }
}
