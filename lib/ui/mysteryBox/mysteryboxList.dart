import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:player/merchant/merchant_controller.dart';
import '../../utils/app_color.dart';
import '../../utils/app_components.dart';
import '../../utils/app_utils.dart';
import 'mysteryboxDetail.dart';
import 'package:player/core/services/tap_sound.dart';

class MySteryBoxList extends StatefulWidget {
  String? title = "";

  MySteryBoxList({super.key,this.title});

  @override
  State<MySteryBoxList> createState() => _GameScreenState();
}

class _GameScreenState extends State<MySteryBoxList> {
  var controller = Get.put(MerchantController());

  @override
  void initState() {
    controller.mysteryBoxList(() {
      setState(() {

      });
    });
    super.initState();
  }

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
                        NoTapSound(
                          child: InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: Icon(
                              Icons.arrow_back_ios_new,
                              color: Colors.white,
                            )),
                        ),
                        Spacer(),
                        AppComponents.text("Mystery Box",
                            fontWeight: FontWeight.bold,
                            size: 25,
                            color: Colors.black),
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
                  Expanded(child: Padding(
                    padding: const EdgeInsets.only(top: 280,left: 10,right: 10),
                    child: GridView.builder(
                      shrinkWrap: true, // let ListView handle the height
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, // number of columns
                        crossAxisSpacing: 4,
                        mainAxisSpacing: 4,
                      ),
                      itemCount: controller.mysteryList.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3), // dim effect
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(width: 5, color: AppColors.darkGrey),
                            ),
                            alignment: Alignment.center,
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10), // set your corner radius
                                    child: Container(
                                      height: 65,
                                      width: 65,
                                      child: AppUtils.remoteImageLoader(
                                          controller.mysteryList[index].mysteryBoxImage ?? ""),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Container(
                                        height: 40,
                                        width: 100,
                                        child: Image.asset(
                                          "assets/images/m2/ic_price_view.png",
                                        ),
                                      ),
                                      AppComponents.text(
                                          "${controller.mysteryList[index].amountpaid}",
                                          fontWeight: FontWeight.bold,
                                          textAlign: TextAlign.center,
                                          size: 12,
                                          textOverflow: TextOverflow.clip,
                                          color: Colors.white),
                                    ],
                                  )
                                ],
                              ),
                              alignment: Alignment.center,
                            ),
                          ),
                          onTap: (){
                            Get.to(MySteryBoxDetail(title: "${controller.mysteryList[index].id}",));
                          },
                        );
                      },
                    ),
                  ),)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
