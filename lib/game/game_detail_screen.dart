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

  @override
  void initState() {
    super.initState();
    // Populate the player name so the reset dialog can show it. Deferred to
    // after the first frame — getProfileInfo synchronously updates an
    // observable, which would otherwise rebuild an Obx during build.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getProfileInfo();
    });
  }

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
                              // Back button, plus a "Reset Game" button at the
                              // top-right — only once at least one station of
                              // this game has been completed
                              // (start_timer_count is set on the first
                              // completion, so it doubles as "any shop done?").
                              Row(
                                children: [
                                  _CircleBackButton(onTap: () => Get.back()),
                                  const Spacer(),
                                  if (controller.gameData?.start_timer_count !=
                                      null)
                                    // Nudge the reset button up so it sits
                                    // nearer the top edge of the card.
                                    Transform.translate(
                                      offset: Offset(0, -20.h),
                                      child: _resetGameButton(),
                                    ),
                                ],
                              ),
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

  /// Red pill button shown at the top-right of the detail card. Reuses the same
  /// reset dialog flow as the game list screen.
  Widget _resetGameButton() {
    return InkWell(
      onTap: _showResetDialog,
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: const Color(0xFFE53935).withOpacity(0.92),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: Colors.white.withOpacity(0.7)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.refresh, size: 16, color: Colors.white),
            SizedBox(width: 6.w),
            Text(
              "Reset Game",
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Same reset dialog used across the app: dark card + warning badge. Resets
  /// the in-progress game (getResetGame), which pops back to the game list on
  /// success.
  void _showResetDialog() {
    final data = controller.gameData!;
    final name = controller.playername.value;
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
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
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Do you really want to reset your game? This action will remove all completed stations detail.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 20),
                  const Divider(color: Colors.white24),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            "Cancel",
                            style: TextStyle(color: Colors.white70, fontSize: 16),
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            controller.getResetGame(data.gameUniqueId);
                          },
                          child: const Text(
                            "Reset",
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
