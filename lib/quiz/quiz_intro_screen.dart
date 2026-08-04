import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../3dView/home_top_bar.dart';
import '../common_widgets.dart';
import '../core/theme/app_fonts.dart';
import '../shop/widgets/shop_chrome.dart';
import '../shop/widgets/shop_glass_card.dart';
import 'quiz_controller.dart';
import 'quiz_how_to_play_screen.dart';
import 'quiz_question_screen.dart';
import 'widgets/quiz_chrome.dart';

/// Entry screen of the SPENDATHON quiz flow: the teacher host standing in the
/// classroom, a greeting card and the START QUIZ / INFO call-to-actions.
///
/// Laid out with absolute positions against the 390x844 Figma frame (the same
/// frame ScreenUtil is initialised with in main.dart) so `.w` / `.h` map 1:1
/// onto the design coordinates.
class QuizIntroScreen extends StatelessWidget {
  QuizIntroScreen({super.key});

  final QuizController quizC = Get.put(QuizController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Classroom backdrop.
          const QuizBackground(),

          // Host teacher standing in the classroom.
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            top: 70.h,
            child: Image.asset(
              QuizAssets.teacher,
              fit: BoxFit.contain,
              alignment: Alignment.bottomCenter,
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            ),
          ),

          // Top bar (profile avatar + coin balance only) pinned to the top.
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              bottom: false,
              child: HomeTopBar(showNotifications: false),
            ),
          ),

          // ---- Greeting ----
          Positioned(
            left: 16.w,
            top: 560.h,
            width: 358.w,
            child: const _GreetingCard(),
          ),

          // ---- Call-to-actions ----
          Positioned(
            left: 20.w,
            top: 676.h,
            child: AppButton(
              title: "START QUIZ",
              width: 190.w,
              height: 54,
              radius: 16,
              gradientColors: const [
                Color(0xFFB3E5FC),
                Color(0xFF29B6F6),
                Color(0xFF0288D1),
              ],
              shadowColor: const Color(0x360288D1),
              textStyle: _buttonStyle,
              onPressed: () {
                quizC.start();
                Get.to(() => const QuizQuestionScreen());
              },
            ),
          ),
          Positioned(
            left: 222.w,
            top: 676.h,
            child: AppButton(
              title: "INFO",
              width: 96.w,
              height: 54,
              radius: 16,
              gradientColors: const [
                Color(0xFFFFE0A3),
                Color(0xFFFFB74D),
                Color(0xFFF59E0B),
              ],
              shadowColor: const Color(0x36F59E0B),
              textStyle: _buttonStyle,
              onPressed: () => Get.to(() => const QuizHowToPlayScreen()),
            ),
          ),

          // ---- Home pill ----
          Positioned(
            top: 762.h,
            left: 0,
            right: 0,
            child: const Align(child: ShopHomePill()),
          ),
        ],
      ),
    );
  }

  static final TextStyle _buttonStyle = TextStyle(
    fontFamily: AppFonts.family,
    fontSize: 16.sp,
    fontWeight: FontWeight.w900,
    color: Colors.white,
    height: 1.2,
  );
}

/// The host's two-line greeting on a frosted card.
class _GreetingCard extends StatelessWidget {
  const _GreetingCard();

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontFamily: AppFonts.family,
      fontSize: 13.sp,
      fontWeight: FontWeight.w600,
      color: kShopBlue,
      height: 1.2,
    );
    return SizedBox(
      height: 96.h,
      child: ShopGlassCard(
        radius: 20,
        boxShadow: kShopGlassShadow,
        padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 26.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Hi. Welcome to  SPENDATHON QUIZ", style: style),
            SizedBox(height: 6.h),
            Text("May i know how can i help you?", style: style),
          ],
        ),
      ),
    );
  }
}
