import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:player/merchant/merchant_controller.dart';
import 'package:player/merchant/merchant_detail_screen.dart';
import 'package:player/utils/app_utils.dart';
import '../ui/mysteryBox/mysterybox.dart';
import '../utils/app_color.dart';
import '../utils/app_components.dart';

class LeaderboardDetail extends StatefulWidget {
  String? ID = "";
  String? title = "";

  LeaderboardDetail({super.key,this.ID,this.title});

  @override
  State<LeaderboardDetail> createState() => _GameScreenState();
}

class _GameScreenState extends State<LeaderboardDetail> {
  var controller = Get.put(MerchantController());

  @override
  void initState() {
    controller.leaderboardDetail(widget.ID ?? "",() {
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
                "assets/images/m2/game_bg.png",
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

            /// glass transparent
            /// main view
            Container(
              child: Column(
                children: [
                  /// top navigation
                  Container(
                    margin: EdgeInsets.only(
                        top: 30,
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
                        AppComponents.text(widget.title?.toUpperCase() ?? "",
                            fontWeight: FontWeight.w700,
                            size: 25,
                            color: Colors.white),
                        Spacer(),
                      ],
                    ),
                  ),

                  /// spend logo
                  Container(
                    margin: EdgeInsets.only(
                        top: 40,
                        left: 40,
                        right: 40),
                    child: Image.asset(
                      "assets/images/m2/start_bg_logo.png",
                    ),
                  ),
                  Expanded(child: Stack(
                    children: [
                      SingleChildScrollView(
                        child: Container(
                          margin: EdgeInsets.only(
                              left: 20,
                              top: 30,
                              right: 20),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: AppColors.borderColor),
                            color: Colors.white.withOpacity(0.3),
                            // Semi-transparent color
                            borderRadius: BorderRadius.circular(16),
                            // Rounded corners
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.4), // Shadow color
                                offset: Offset(0, 4), // Shadow position
                                blurRadius: 10, // Blur radius for softness
                              ),
                            ],
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(12)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    height: MediaQuery.of(context).size.height * .7,
                                    margin: EdgeInsets.only(left: 15, right: 15, top: 12),
                                    child: ListView.builder(
                                        itemCount: controller.leaderDetail.length,
                                        itemBuilder: (context, index) {
                                          return InkWell(
                                            onTap: (){
                                              showDialog(
                                                context: context,
                                                barrierDismissible: true,
                                                builder: (_) => Dialog(
                                                  backgroundColor: Colors.transparent,
                                                  insetPadding: const EdgeInsets.symmetric(horizontal: 24),
                                                  child: Stack(
                                                    clipBehavior: Clip.none,
                                                    children: [
                                                      // Popup Body
                                                      Container(
                                                        decoration: BoxDecoration(
                                                          color: const Color(0xFF2C2C2C),
                                                          borderRadius: BorderRadius.circular(16),
                                                        ),
                                                        padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
                                                        child: Column(
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: [
                                                            const SizedBox(height: 24),
                                                            Text(
                                                              "Player",
                                                              style: TextStyle(
                                                                color: Colors.white,
                                                                fontSize: 18,
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                            ),
                                                            const SizedBox(height: 8),
                                                            const Text(
                                                              "Do You really want to see your completion time or many more? Please go to mystery box for redeem.",
                                                              textAlign: TextAlign.center,
                                                              style: TextStyle(
                                                                color: Colors.white70,
                                                                fontSize: 14,
                                                              ),
                                                            ),
                                                            const SizedBox(height: 20),
                                                            const Divider(color: Colors.white24),
                                                            Row(
                                                              children: [
                                                                Expanded(
                                                                  child: TextButton(
                                                                    onPressed: () {
                                                                      Navigator.pop(context);
                                                                    },
                                                                    child: const Text(
                                                                      "Cancel",
                                                                      style: TextStyle(
                                                                        color: Colors.white70,
                                                                        fontSize: 16,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child: TextButton(
                                                                    onPressed: () {
                                                                      Navigator.of(context).pop();
                                                                      Navigator.of(context).pop();
                                                                      Navigator.of(context).pop();
                                                                      Navigator.of(context).pop();
                                                                      Get.to(MySteryBox());
                                                                    },
                                                                    child: const Text(
                                                                      "Mystery box",
                                                                      style: TextStyle(
                                                                        color: Colors.redAccent,
                                                                        fontSize: 16,
                                                                        fontWeight: FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),

                                                      // Warning Icon
                                                      Positioned(
                                                        top: -35,
                                                        left: 0,
                                                        right: 0,
                                                        child: CircleAvatar(
                                                          backgroundColor: Colors.redAccent,
                                                          radius: 35,
                                                          child: const Icon(
                                                            Icons.warning_amber_rounded,
                                                            color: Colors.white,
                                                            size: 30,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                            child : Container(
                                              padding: EdgeInsets.all(8),
                                              width: double.infinity,
                                              margin: EdgeInsets.only(top: 5),
                                              decoration: BoxDecoration(
                                                  border: Border.all(width: 1, color: AppColors.borderColor),
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(12)),
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                    width: 3,
                                                  ),
                                                  AppComponents.text("${controller.leaderDetail[index].rank}",
                                                      fontWeight: FontWeight.w500,
                                                      size: 20,
                                                      color: Colors.black),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Container(
                                                    height: 75,
                                                    width: 75,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                        color: AppColors.borderColor,
                                                        width: 2, // thickness of border
                                                      ),
                                                    ),
                                                    child: ClipOval(
                                                      child: AppUtils.remoteImageLoader(
                                                          controller.leaderDetail[index].playerImage ?? ""),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 15,
                                                  ),
                                                  Expanded(child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          AppComponents.text(
                                                              controller.leaderDetail[index].playerName ?? "",
                                                              fontWeight: FontWeight.w500,
                                                              size: 18,
                                                              color: Colors.black),
                                                        ],
                                                      ),
                                                      AppComponents.text(
                                                          "Timing",
                                                          fontWeight: FontWeight.w500,
                                                          color: Colors.black),
                                                      AppComponents.text(
                                                          "___:___:___",
                                                          fontWeight: FontWeight.w500,
                                                          color: Colors.black),
                                                      SizedBox(
                                                        height: 4,
                                                      ),
                                                      Row(
                                                        crossAxisAlignment: CrossAxisAlignment.end,
                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                        children: [
                                                          Expanded(child: AppComponents.text(
                                                              "Tap here for more info",
                                                              size: 11,
                                                              textAlign: TextAlign.end,
                                                              enableUnderLine: true,
                                                              fontWeight: FontWeight.bold,
                                                              color: AppColors.red)),
                                                        ],
                                                      )
                                                    ],
                                                  )),
                                                ],
                                              ),
                                            ),
                                          );
                                        }))
                              ],
                            ),
                          ),),
                      )
                    ],
                  )),
                  Container(
                    margin: EdgeInsets.only(
                        left: 30,
                        top: 20,
                        bottom: 20,
                        right: 30),
                    child: AppComponents.appButton(
                        "Unlock",
                        height: 60,
                        onTap: (){
                          // Get.to(Leaderboard(title: "Leaderboard",));
                        }
                    ),
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
