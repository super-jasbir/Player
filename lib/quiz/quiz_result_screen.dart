import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../3dView/home_top_bar.dart';
import '../common_widgets.dart';
import '../core/theme/app_fonts.dart';
import '../shop/widgets/shop_chrome.dart';
import '../shop/widgets/shop_glass_card.dart';
import 'quiz_controller.dart';
import 'widgets/quiz_chrome.dart';

/// The end-of-quiz result: a starburst badge with the number of correct
/// answers, a CONGRATULATION banner, the points earned and a DONE button that
/// closes the whole quiz flow.
class QuizResultScreen extends StatelessWidget {
  const QuizResultScreen({super.key});

  static const Color _blue = kShopBlue;

  @override
  Widget build(BuildContext context) {
    final QuizController c = Get.find<QuizController>();

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const QuizBackground(blurred: true),
          SafeArea(
            child: Column(
              children: [
                const HomeTopBar(showNotifications: false),
                SizedBox(height: 12.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 20.w),
                    child: const ShopBackButton(),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: ShopGlassCard(
                    radius: 20,
                    boxShadow: kShopGlassShadow,
                    padding: EdgeInsets.fromLTRB(24.w, 34.h, 24.w, 30.h),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _StarBadge(score: c.correctCount.value),
                        SizedBox(height: 26.h),
                        Text(
                          "CONGRATULATION",
                          style: TextStyle(
                            fontFamily: AppFonts.family,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w900,
                            color: _blue,
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          "You earned ${c.earnedPoints} points",
                          style: TextStyle(
                            fontFamily: AppFonts.family,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: _blue.withOpacity(0.85),
                          ),
                        ),
                        SizedBox(height: 24.h),
                        AppButton(
                          title: "DONE",
                          width: double.infinity,
                          height: 52,
                          radius: 16,
                          gradientColors: const [
                            Color(0xFFB3E5FC),
                            Color(0xFF29B6F6),
                            Color(0xFF0288D1),
                          ],
                          shadowColor: const Color(0x360288D1),
                          textStyle: TextStyle(
                            fontFamily: AppFonts.family,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            height: 1.2,
                          ),
                          // Close the whole quiz flow back to the home screen.
                          onPressed: () => Get.until((r) => r.isFirst),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// The gold spiky "star burst" badge with the score centred, matching the
/// Figma result card.
class _StarBadge extends StatelessWidget {
  const _StarBadge({required this.score});

  final int score;

  @override
  Widget build(BuildContext context) {
    final double size = 140.w;
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(QuizAssets.congratsBadge, width: size, fit: BoxFit.contain),
          Text(
            "$score",
            style: TextStyle(
              fontFamily: AppFonts.family,
              fontSize: 48.sp,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}
