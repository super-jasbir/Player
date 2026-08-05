import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:player/game/game_list_screen.dart';
import 'package:player/merchant/merchant_controller.dart';
import 'package:player/merchant/merchant_detail_screen.dart';
import 'package:player/utils/app_utils.dart';

import '../utils/app_color.dart';
import '../utils/app_components.dart';
import 'leaderboardDetail.dart';
import 'package:player/core/services/sound_service.dart';
import 'package:player/core/services/tap_sound.dart';

class Leaderboard extends StatefulWidget {
  String? title = "";

  Leaderboard({super.key,this.title});

  @override
  State<Leaderboard> createState() => _GameScreenState();
}

class _GameScreenState extends State<Leaderboard> {
  var controller = Get.put(MerchantController());
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    // Play the leaderboard sound when the screen opens.
    SoundService.instance.playLeaderboard();
    controller.leaderboardList(() {
      if (mounted) setState(() => _loading = false);
    });
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

            /// top navigation
            Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * .05,
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
                  top: MediaQuery.of(context).size.height * .14,
                  left: 40,
                  right: 40),
              child: Image.asset(
                "assets/images/m2/start_bg_logo.png",
              ),
            ),

            /// glass transparent
            /// main view
            Container(
                margin: EdgeInsets.only(
                    left: 20,
                    top: MediaQuery.of(context).size.height * .27,
                    bottom: 20,
                    right: 20),
                // Set the desired width
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
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(12)),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                height: MediaQuery.of(context).size.height * .7,
                                margin: EdgeInsets.only(left: 15, right: 15, top: 5),
                                child: _loading
                                    ? const Center(
                                        child: CircularProgressIndicator(
                                            color: Colors.white),
                                      )
                                    : controller.leaderList.isEmpty
                                    ? Center(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 24),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(Icons.emoji_events_outlined,
                                                  color: Colors.white
                                                      .withOpacity(0.9),
                                                  size: 48),
                                              const SizedBox(height: 12),
                                              AppComponents.text(
                                                controller.leaderListError.isNotEmpty
                                                    ? controller.leaderListError
                                                    : "You haven't participated in any game yet",
                                                color: Colors.white,
                                                size: 15,
                                                fontWeight: FontWeight.w600,
                                                textAlign: TextAlign.center,
                                                maxLine: 3,
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : ListView.builder(
                                    itemCount: controller.leaderList.length,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: (){
                                          Get.to(LeaderboardDetail(ID: controller.leaderList[index].gameUniqueId ?? "",
                                          title: widget.title,));
                                        },
                                        child : Container(
                                          padding: EdgeInsets.all(10),
                                          margin: EdgeInsets.only(top: 10),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(width: 1, color: AppColors.borderColor),
                                              borderRadius: BorderRadius.circular(12)),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 6,
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
                                                      controller.leaderList[index].gImage ?? ""),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 12,
                                              ),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  /// name
                                                  AppComponents.text(
                                                      controller.leaderList[index].gameName ?? "",
                                                      fontWeight: FontWeight.w500,
                                                      size: 15,
                                                      color: Colors.black),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }))
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
