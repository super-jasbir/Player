import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:player/common_widgets.dart';
import 'package:player/core/services/tap_sound.dart';
import 'package:player/core/theme/app_images.dart';
import 'package:player/game/game_controller.dart';
import 'package:player/game/selecthalalnonhalal/select_halal_non_halal.dart';
import 'package:player/utils/app_utils.dart';

import '../3dView/home_top_bar.dart';
import '../data/network/api_endpoints.dart';

/// Accent blue used for titles / values (matches the login screen).
const Color _accentBlue = Color(0xFF0288D1);

/// HALAL button gradient (Figma: light green -> green).
const List<Color> _halalGradient = [
  Color(0xFFE4FCB3),
  Color(0xFF85F629),
  Color(0xFF85D102),
];

/// NON-HALAL button gradient (Figma: light gold -> amber).
const List<Color> _nonHalalGradient = [
  Color(0xFFFCF6B3),
  Color(0xFFF6A429),
  Color(0xFFD18C02),
];

class GameDetailScreen extends StatefulWidget {
  const GameDetailScreen({super.key});

  @override
  State<GameDetailScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameDetailScreen> {
  final GameController controller = Get.put(GameController());
  bool isChecked = false;

  static const String _sampleGame = "assets/images/home/ic_game_sample.png";

  void _selectStation(String type) {
    if (!isChecked) {
      Fluttertoast.showToast(msg: "Please accept Terms & Conditions");
      return;
    }
    controller.getGameDetail(controller.gameData?.gameUniqueId ?? "", type, () {
      controller.appController.selectHalalNonHalaValue = type;
      Get.to(SelectHalalNonHalal());
    });
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
                // Spendrathon logo (reused from the splash/walkthrough).
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32.w),
                  child: Image.asset(AppImages.spendrathonCard, fit: BoxFit.contain),
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
                              // Circular back button.
                              _CircleBackButton(onTap: () => Get.back()),
                              SizedBox(height: 18.h),
                              // Inner detail card (name + image + details).
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.fromLTRB(18.w, 20.h, 18.w, 24.h),
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
                                    SizedBox(height: 12.h),
                                    _detailRow("Date Of Completion",
                                        data.gameEndDate ?? ""),
                                    SizedBox(height: 12.w),
                                    _detailRow("Winner Prize", data.prize ?? ""),
                                  ],
                                ),
                              ),
                              SizedBox(height: 22.h),
                              // Terms & Conditions checkbox.
                              Row(
                                children: [
                                  _CheckBox(
                                    value: isChecked,
                                    onTap: () =>
                                        setState(() => isChecked = !isChecked),
                                  ),
                                  SizedBox(width: 10.w),
                                  Text(
                                    "Please accept ",
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 14.sp,
                                      color: const Color(0xFF374151),
                                    ),
                                  ),
                                  Text(
                                    "Terms & Conditions",
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w700,
                                      color: _accentBlue,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 18.h),
                        // HALAL / NON-HALAL buttons.
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              Expanded(
                                child: AppButton(
                                  title: "HALAL",
                                  height: 64,
                                  gradientColors: _halalGradient,
                                  onPressed: () => _selectStation("Halal"),
                                ),
                              ),
                              SizedBox(width: 14.w),
                              Expanded(
                                child: AppButton(
                                  title: "NON-HALAL",
                                  height: 64,
                                  gradientColors: _nonHalalGradient,
                                  onPressed: () => _selectStation("Non-Halal"),
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

/// Circular translucent back button used at the top-left of the detail card.
class _CircleBackButton extends StatelessWidget {
  const _CircleBackButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // Back button: no global click sound (its own sound comes later).
    return NoTapSound(
      child: InkWell(
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
        child: const Icon(Icons.arrow_back, size: 20, color: Color(0xFF374151)),
      ),
    ),
    );
  }
}

/// Rounded checkbox matching the Figma (blue when checked).
class _CheckBox extends StatelessWidget {
  const _CheckBox({required this.value, required this.onTap});

  final bool value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          color: value ? _accentBlue : Colors.white.withOpacity(0.8),
          border: Border.all(color: _accentBlue, width: 1.5),
        ),
        child: value
            ? const Icon(Icons.check, size: 16, color: Colors.white)
            : null,
      ),
    );
  }
}
