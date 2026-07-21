import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:player/app_controller.dart';
import 'package:player/common_widgets.dart';
import 'package:player/core/theme/app_images.dart';
import 'package:player/game/game_controller.dart';
import 'package:player/game/merchant/GameMerchantList.dart';
import 'package:player/utils/app_utils.dart';

import '../../3dView/home_screen_player.dart';
import '../../3dView/home_top_bar.dart';
import '../../data/network/api_endpoints.dart';
import '../../map/game_tracker.dart';

/// Accent blue used for titles / values (matches the game detail screen).
const Color _accentBlue = Color(0xFF0288D1);

class SelectHalalNonHalal extends StatefulWidget {
  const SelectHalalNonHalal({super.key});

  @override
  State<SelectHalalNonHalal> createState() => _GameScreenState();
}

class _GameScreenState extends State<SelectHalalNonHalal> {
  final GameController controller = Get.put(GameController());

  static const String _sampleGame = "assets/images/home/ic_game_sample.png";

  void _openMerchantLocation() {
    controller.getGameDetail(
      controller.gameData?.gameUniqueId ?? "",
      controller.appController.selectHalalNonHalaValue,
      () {
        Get.to(
          LocationMap(
            outlets: controller.outletList,
            markerImageUrl: controller.outletList.first.initalImage.toString(),
            gameUniqueId: controller.gameData?.gameUniqueId ?? "",
          ),
        );
      },
    );
  }

  void _startGame() {
    final appC = Get.find<AppController>();
    appC.gameName = controller.gameData?.gameName ?? "";
    appC.gameUniqueId = controller.gameData?.gameUniqueId ?? "";
    Get.to(GameMerchantList());
  }

  @override
  Widget build(BuildContext context) {
    final data = controller.gameData!;
    final double w = MediaQuery.of(context).size.width;
    final double clipRight = ((w - 32 - 42) / 2).clamp(20, w);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const HomeBlurredBackground(),
          SafeArea(
            child: Column(
              children: [
                const HomeTopBar(showNotifications: false),
                SizedBox(height: 12.h),
                // Spendrathon logo (reused from the game detail screen).
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32.w),
                  child:
                      Image.asset(AppImages.spendrathonCard, fit: BoxFit.contain),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Headroom for the paperclip, which the card paints at a
                        // negative offset. It has to live inside the scroll view
                        // or the viewport clips the clip away once the content
                        // overflows on a short screen.
                        SizedBox(height: 40.w),
                        // Yellow frosted detail card with paperclip.
                        BlurContainerWrapper(
                          showClip: true,
                          blurSigma: 20,
                          minHeight: 0,
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          padding: const EdgeInsets.fromLTRB(18, 44, 18, 18),
                          borderRadius: BorderRadius.circular(28),
                          borderColor: Colors.white.withOpacity(0.6),
                          gradientColors: [
                            const Color(0xFFFDF7C0).withOpacity(0.92),
                            const Color(0xFFFCEFA0).withOpacity(0.94),
                          ],
                          clipWidth: 42,
                          clipTopOffset: -36,
                          clipRightOffset: clipRight,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Back + Home row.
                              Row(
                                children: [
                                  _CircleIconButton(
                                    icon: Icons.arrow_back,
                                    onTap: () => Get.back(),
                                  ),
                                  const Spacer(),
                                  _CircleIconButton(
                                    icon: Icons.home_rounded,
                                    onTap: () =>
                                        Get.offAll(HomeScreenPlayer()),
                                  ),
                                ],
                              ),
                              SizedBox(height: 18.h),
                              // Inner detail card (name + image + details).
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.fromLTRB(
                                    18.w, 20.h, 18.w, 24.h),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.18),
                                  borderRadius: BorderRadius.circular(20.r),
                                  border: Border.all(
                                      color: Colors.white.withOpacity(0.55)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: Text(
                                        data.gameName ?? "",
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.w800,
                                          color: _accentBlue,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 2.h),
                                    // Game banner image.
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(14.r),
                                      child: SizedBox(
                                        width: double.infinity,
                                        height: 100,
                                        child: (data.gamePoster ?? "")
                                                .toString()
                                                .isNotEmpty
                                            ? AppUtils.remoteImageLoader(
                                                ApiEndPoint.imageBaseUrl +
                                                    data.gamePoster)
                                            : Image.asset(_sampleGame,
                                                fit: BoxFit.cover),
                                      ),
                                    ),
                                    SizedBox(height: 26.w),
                                    _detailRow("Number Of Stations",
                                        data.totalOutlet.toString()),
                                    SizedBox(height: 12.w),
                                    _detailRow("Date Of Completion",
                                        data.gameEndDate ?? ""),
                                    SizedBox(height: 12.w),
                                    _detailRow(
                                        "Winner Prize", data.prize ?? ""),
                                  ],
                                ),
                              ),
                              SizedBox(height: 18.h),
                              // Center(
                              //   child: Text(
                              //     "Please select following options",
                              //     style: TextStyle(
                              //       fontFamily: 'Inter',
                              //       fontSize: 15.sp,
                              //       fontWeight: FontWeight.w700,
                              //       color: const Color(0xFF374151),
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                        SizedBox(height: 18.h),
                        // Merchant Location / Start Game buttons.
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              Expanded(
                                child: AppButton(
                                  title: "Merchant Location",
                                  height: 64,
                                  onPressed: _openMerchantLocation,
                                ),
                              ),
                              SizedBox(width: 14.w),
                              Expanded(
                                child: AppButton(
                                  title: "Start Game",
                                  height: 64,
                                  onPressed: _startGame,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14.sp,
              color: const Color(0xFF4B5563),
            ),
          ),
        ),

        Text(
          value,
          textAlign: TextAlign.right,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16.sp,
            fontWeight: FontWeight.w800,
            color: _accentBlue,
          ),
        ),
      ],
    );
  }
}

/// Circular translucent button used at the top of the detail card.
class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.35),
          border: Border.all(color: Colors.white.withOpacity(0.7)),
        ),
        child: Icon(icon, size: 20, color: const Color(0xFF374151)),
      ),
    );
  }
}
