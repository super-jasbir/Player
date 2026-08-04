import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:player/merchant/merchant_controller.dart';
import '../../utils/app_components.dart';
import '../redeemable/redeemable.dart';
import 'mysteryboxList.dart';

class MySteryBox extends StatefulWidget {
  String? title = "";

  MySteryBox({super.key,this.title});

  @override
  State<MySteryBox> createState() => _GameScreenState();
}

class _GameScreenState extends State<MySteryBox> {
  var controller = Get.put(MerchantController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Background Image
            Container(
              width: double.infinity,
              height: double.infinity,
              child: Image.asset(
                "assets/images/m3/my_qr_bg.png",
                fit: BoxFit.cover, // Adjust to BoxFit.fill, BoxFit.contain, etc., as needed
              ),
            ),
            // Transparent Overlay
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.grey
                  .withOpacity(0.2), // Adjust opacity and color as needed
            ),
            Container(
              child: Column(
                children: [
                  /// top navigation
                  Container(
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * .04,
                        left: 18,
                        right: 18),
                    child: Row(
                      children: [
                        InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: Icon(
                              Icons.arrow_back_ios_new,
                              color: Colors.white,
                            )),
                        Spacer(),
                        AppComponents.text("Mystery Box",
                            fontWeight: FontWeight.bold,
                            size: 25,
                            color: Colors.white),
                        Spacer(),
                      ],
                    ),
                  ),
                  /// spend logo
                  Container(
                    margin: EdgeInsets.only(
                        top: 30,
                        left: 60,
                        right: 60),
                    child: Image.asset(
                      "assets/images/m2/start_bg_logo.png",
                    ),
                  ),
                  Spacer(),
                  InkWell(
                    child: Container(
                      margin: EdgeInsets.only(
                          top: 30,
                          left: 60,
                          right: 60),
                      child: Image.asset(
                        "assets/images/m2/ms_box.png",
                      ),
                    ),
                    onTap: (){
                      Get.to(MySteryBoxList(title: "",));
                    },
                  ),
                  InkWell(
                    child: Container(
                      margin: EdgeInsets.only(
                          top: 30,
                          left: 60,
                          bottom: 50,
                          right: 60),
                      child: Image.asset(
                        "assets/images/m2/rd_box.png",
                      ),
                    ),
                    onTap: (){
                      Get.to(RedeemableList(title: "",));
                    },
                  ),

                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
