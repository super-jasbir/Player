import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:player/ui/dashboard/home/home_screen_controller.dart';

import '../../../map/location_screen.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/app_color.dart';
import '../../../utils/app_components.dart';
import '../../../utils/app_utils.dart';
import 'drawer/drawer_screen.dart';

class HomeScreen extends GetView<HomeScreenController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: controller.homeKey,
        drawer: const DrawerScreen(),
        body: SafeArea(
            child: Stack(
          children: [
            /// background

            Container(
              decoration: BoxDecoration(
                  color: Colors.black,
                  image: DecorationImage(
                      image: AssetImage("assets/images/bg7.png"),
                      fit: BoxFit.cover)),
            ),

            /// transparent layer
            Container(
              width: double.infinity,
              height: double.infinity,
              color: AppColors.darkNavyBlue
                  .withOpacity(0.4), // Adjust opacity and color as needed
            ),

            /// main view
            Column(
              children: [
                Expanded(child: ListView(
                  children: [
                    Container(
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: AppUtils.yellowGradiant(),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 18,
                          ),
                          InkWell(
                            onTap: (){
                              controller.homeKey.currentState!.openDrawer();
                            },
                            child
                                : Icon(
                              Icons.menu,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          InkWell(
                            onTap: () async {
                              Get.to(Maps());
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      "assets/images/location_image.svg",
                                      color: Colors.black,
                                    ),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    AppComponents.text(
                                        controller.appConstant.location,
                                        size: 12,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.black)
                                  ],
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                                Row(
                                  children: [
                                    Obx(() => AppComponents.text(
                                        controller.appController.currentLoc.value,
                                        size: 14,
                                        color: AppColors.black)),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    SvgPicture.asset(
                                        "assets/images/down_arrow.svg"),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              const SizedBox(
                                height: 8,
                              ),
                              SvgPicture.asset("assets/images/sun_image.svg"),
                              const SizedBox(
                                height: 3,
                              ),
                              AppComponents.text("28' C",
                                  size: 14, color: AppColors.black),
                            ],
                          ),
                          Spacer(),

                          Image.asset("assets/images/wallet.png"),
                          SizedBox(
                            width: 10,
                          ),
                          Image.asset("assets/images/notification.png"),
                          SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 140,
                      margin: EdgeInsets.only(left: 18, right: 18, top: 18),
                      decoration: BoxDecoration(
                        color: AppColors.lightGrey,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Container(
                        margin: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: AppColors.lightGrey,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: AppColors.darkNavyBlue.withOpacity(.4),
                                width: 2)),
                        child: Container(
                          margin: EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppComponents.text("Quote of the day",size: 18,color: Colors.black),
                              SizedBox(height: 6,),
                              AppComponents.text(
                                  "“Lorem ipsum dolor sit ametLorem ipsum dolor sit ametLorem em ipsum dolor sit ametLorem ipsum dolor”",
                                  maxLine: 5)
                            ],
                          ),
                        ),
                      ),
                    ),

                    /// banner
                    Container(
                        margin: EdgeInsets.only(left: 18, right: 18, top: 20),
                        child: Image.asset("assets/images/temp_banner.png")),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                          margin: EdgeInsets.only(left: 18, right: 18, top: 20),
                          child: Image.asset("assets/images/temp_dot.png")),
                    ),

                    /// profile

                  Obx(() =>   controller.appController.hasData.value?
                      Container(
                      height: 170,
                      margin: EdgeInsets.only(left: 20, right: 20,top: 20),
                      decoration: BoxDecoration(
                        color: AppColors.darkNavyBlue,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black,
                              spreadRadius: 5,
                              blurRadius: 10,
                              offset: Offset(0, 4))
                        ],
                      ),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              height: 20,
                              margin: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.green,
                                    // Shadow color
                                    blurRadius: 60,
                                    // How soft the shadow is
                                    spreadRadius: 30,
                                    // How far the shadow spreads
                                    offset: Offset(0, 0), // Position of the shadow
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 18, right: 18, top: 18),
                                // Set the desired width
                                height: 60, // Set the desired height
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.3),
                                  // Semi-transparent color
                                  borderRadius: BorderRadius.circular(16),
                                  // Rounded corners
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.4),
                                      // Shadow color
                                      offset: Offset(0, 4),
                                      // Shadow position
                                      blurRadius: 10, // Blur radius for softness
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    controller.appController.profileData != null
                                        ? Container(
                                      height: 80,
                                      width: 80,
                                      child: ClipOval(
                                        child: Image.network(controller
                                            .appController
                                            .profileData!
                                            .profilePic),
                                      ),
                                    )
                                        : Container(
                                      height: 80,
                                      width: 80,
                                      child: Icon(Icons.person),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 10,
                                        ),
                                        AppComponents.text(
                                            "Hello ${controller.appController.profileData?.nickName ?? "Sam"}",
                                            color: Colors.white),
                                        AppComponents.text(
                                            "User Id: ${controller.appController.profileData?.userId ?? "218829"}",
                                            color: Colors.white,size: 12)
                                      ],
                                    ),
                                    Spacer(),
                                    Icon(
                                      Icons.arrow_forward_ios_outlined,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 18,
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: 10,),
                              Row(
                                children: [
                                  Expanded(child:   Column(
                                    children: [
                                      SvgPicture.asset("assets/images/cake_image.svg",color: Colors.white,),
                                      SizedBox(height: 4,),
                                      AppComponents.text("Age",color: Colors.white),
                                      SizedBox(height: 4,),
                                      AppComponents.text("28",color: Colors.white)
                                    ],
                                  )),
                                  Expanded(child:   Column(
                                    children: [
                                      SvgPicture.asset("assets/images/gender_image.svg",color: Colors.white,),
                                      SizedBox(height: 4,),
                                      AppComponents.text("Gender",color: Colors.white),
                                      SizedBox(height: 4,),
                                      AppComponents.text("Male",color: Colors.white)
                                    ],
                                  )),
                                  Expanded(child:   Column(
                                    children: [
                                      Image.asset("assets/images/country.png",color: Colors.white,height: 20,width: 20,),
                                      SizedBox(height: 4,),
                                      AppComponents.text("Country",color: Colors.white),
                                      SizedBox(height: 4,),
                                      AppComponents.text("Singapore",color: Colors.white)
                                    ],
                                  )),

                                ],
                              )

                            ],
                          ),
                        ],
                      )
                  ):Container(
                      height: 170,
                      margin: EdgeInsets.only(left: 20, right: 20,top: 20),
                      decoration: BoxDecoration(
                        color: AppColors.darkNavyBlue,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black,
                              spreadRadius: 5,
                              blurRadius: 10,
                              offset: Offset(0, 4))
                        ],
                      ),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              height: 20,
                              margin: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.green,
                                    // Shadow color
                                    blurRadius: 60,
                                    // How soft the shadow is
                                    spreadRadius: 30,
                                    // How far the shadow spreads
                                    offset: Offset(0, 0), // Position of the shadow
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 18, right: 18, top: 18),
                                // Set the desired width
                                height: 60, // Set the desired height
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.3),
                                  // Semi-transparent color
                                  borderRadius: BorderRadius.circular(16),
                                  // Rounded corners
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.4),
                                      // Shadow color
                                      offset: Offset(0, 4),
                                      // Shadow position
                                      blurRadius: 10, // Blur radius for softness
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    controller.appController.profileData != null
                                        ? Container(
                                      height: 80,
                                      width: 80,
                                      child: ClipOval(
                                        child: Image.network(controller
                                            .appController
                                            .profileData!
                                            .profilePic),
                                      ),
                                    )
                                        : Container(
                                      height: 80,
                                      width: 80,
                                      child: Icon(Icons.person),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 10,
                                        ),
                                        AppComponents.text(
                                            "Hello ${controller.appController.profileData?.name ?? "Sam"}",
                                            color: Colors.white),
                                        AppComponents.text(
                                            "User Id: ${controller.appController.profileData?.userId ?? "218829"}",
                                            color: Colors.white)
                                      ],
                                    ),
                                    Spacer(),
                                    Icon(
                                      Icons.arrow_forward_ios_outlined,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 18,
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: 10,),
                              Row(
                                children: [
                                  Expanded(child:   Column(
                                    children: [
                                      SvgPicture.asset("assets/images/cake_image.svg",color: Colors.white,),
                                      SizedBox(height: 4,),
                                      AppComponents.text("Age",color: Colors.white),
                                      SizedBox(height: 4,),
                                      AppComponents.text("28",color: Colors.white)
                                    ],
                                  )),
                                  Expanded(child:   Column(
                                    children: [
                                      SvgPicture.asset("assets/images/gender_image.svg",color: Colors.white,),
                                      SizedBox(height: 4,),
                                      AppComponents.text("Gender",color: Colors.white),
                                      SizedBox(height: 4,),
                                      AppComponents.text("Male",color: Colors.white)
                                    ],
                                  )),
                                  Expanded(child:   Column(
                                    children: [
                                      Image.asset("assets/images/country.png",color: Colors.white,height: 20,width: 20,),
                                      SizedBox(height: 4,),
                                      AppComponents.text("Country",color: Colors.white),
                                      SizedBox(height: 4,),
                                      AppComponents.text("Singapore",color: Colors.white)
                                    ],
                                  )),

                                ],
                              )

                            ],
                          ),
                        ],
                      )
                  ),),

                    /// game bg
                    Container(
                        height: 170,
                        margin: EdgeInsets.only(left: 20, right: 20,top: 20),
                        decoration: BoxDecoration(
                          color: AppColors.darkNavyBlue,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black,
                                spreadRadius: 5,
                                blurRadius: 10,
                                offset: Offset(0, 4))
                          ],
                        ),
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                height: 20,
                                margin: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.red,
                                      // Shadow color
                                      blurRadius: 60,
                                      // How soft the shadow is
                                      spreadRadius: 30,
                                      // How far the shadow spreads
                                      offset: Offset(0, 0), // Position of the shadow
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 18, right: 18, top: 8),
                                  // Set the desired width
                                  height: 60, // Set the desired height
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.3),
                                    // Semi-transparent color
                                    borderRadius: BorderRadius.circular(16),
                                    // Rounded corners
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.4),
                                        // Shadow color
                                        offset: Offset(0, 4),
                                        // Shadow position
                                        blurRadius: 10, // Blur radius for softness
                                      ),
                                    ],
                                  ),
                                  child: Row(

                                    children: [
                                      SizedBox(width: 18,),
                                      AppComponents.text("Game wise performance",color: Colors.white,size: 18),

                                      Spacer(),
                                      Icon(
                                        Icons.arrow_forward_ios_outlined,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: 18,
                                      )
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    Expanded(child: Container(
                                      height: 100,
                                      width: 100,
                                      child:  Image.asset("assets/images/temp_game.png"),
                                    )),
                                    Expanded(child: Container(
                                      height: 100,
                                      width: 100,
                                      child:  Image.asset("assets/images/temp_game.png"),
                                    )),
                                    Expanded(child: Container(
                                      height: 100,
                                      width: 100,
                                      child:  Image.asset("assets/images/temp_game.png"),
                                    )),
                                  ],
                                ),

                              ],
                            ),
                          ],
                        )
                    ),
                  ],
                )),

                /// bottom nav
                ///

                Container(
                  height: 68,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 12,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 24),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 12,
                            ),
                            SvgPicture.asset(
                              "assets/images/home.svg",
                              height: 22,
                              width: 22,
                              color: AppColors.appColor,
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            AppComponents.text("Home",
                                size: 10, color: AppColors.black)
                          ],
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            // Get.toNamed(AppRoutes.appointmentScreen);
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 40),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 12,
                                ),
                                Icon(
                                  Icons.games,
                                  color: Colors.grey,
                                  size: 22,
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                AppComponents.text("Games",
                                    size: 10, color: AppColors.black)
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(left: 30, right: 20),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 12,
                              ),
                              Icon(
                                Icons.wallet,
                                color: Colors.grey,
                                size: 22,
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              AppComponents.text("Wallet",
                                  size: 10, color: AppColors.black)
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(left: 24, right: 24),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 12,
                              ),
                              Icon(
                                Icons.list_alt,
                                color: Colors.grey,
                                size: 22,
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              AppComponents.text("LeaderBoard",
                                  size: 10, color: AppColors.black)
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        )));
  }
}
