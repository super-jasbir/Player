import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../3dView/home_top_bar.dart';
import '../common_widgets.dart';
import '../core/theme/app_fonts.dart';
import '../shop/widgets/shop_chrome.dart';
import '../shop/widgets/shop_glass_card.dart';
import 'quiz_controller.dart';
import 'quiz_result_screen.dart';
import 'widgets/quiz_chrome.dart';

/// The active-quiz screen: a progress header ("Completed Quiz  n/total"), the
/// current question and its A / B / C option cards, plus the NEXT button that
/// records the answer and advances (routing to the result on the last one).
class QuizQuestionScreen extends StatelessWidget {
  const QuizQuestionScreen({super.key});

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
                SizedBox(height: 10.h),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: ShopGlassCard(
                      radius: 20,
                      boxShadow: kShopGlassShadow,
                      padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 20.h),
                      child: Obx(() => _content(c)),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _content(QuizController c) {
    final q = c.current;
    final int number = c.currentIndex.value + 1;
    final double progress = number / c.total;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ---- Progress header ----
        Row(
          children: [
            Text(
              "Completed Quiz",
              style: _label(11.sp, FontWeight.w600),
            ),
            const Spacer(),
            Text(
              "$number/${c.total}",
              style: _label(11.sp, FontWeight.w700),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 6.h,
            backgroundColor: _blue.withOpacity(0.15),
            valueColor: const AlwaysStoppedAnimation<Color>(_blue),
          ),
        ),
        SizedBox(height: 22.h),

        // ---- Question ----
        Text(
          "$number. ${q.question}",
          style: TextStyle(
            fontFamily: AppFonts.family,
            fontSize: 15.sp,
            fontWeight: FontWeight.w700,
            color: _blue,
            height: 1.3,
          ),
        ),
        SizedBox(height: 20.h),

        // ---- Options ----
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.zero,
            itemCount: q.options.length,
            separatorBuilder: (_, __) => SizedBox(height: 14.h),
            itemBuilder: (_, i) => _OptionCard(
              label: String.fromCharCode(65 + i), // A, B, C ...
              text: q.options[i],
              selected: c.selectedOption.value == i,
              onTap: () => c.selectOption(i),
            ),
          ),
        ),
        SizedBox(height: 12.h),

        // ---- Next ----
        Center(
          child: AppButton(
            title: c.isLastQuestion ? "FINISH" : "NEXT",
            width: 165.w,
            height: 52,
            radius: 16,
            isDisabled: c.selectedOption.value == null,
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
            onPressed: () {
              final bool finished = c.submitAndAdvance();
              if (finished) {
                Get.off(() => const QuizResultScreen());
              }
            },
          ),
        ),
      ],
    );
  }

  TextStyle _label(double size, FontWeight weight) => TextStyle(
        fontFamily: AppFonts.family,
        fontSize: size,
        fontWeight: weight,
        color: _blue,
        height: 1.2,
      );
}

/// A single tappable answer card ("A. The Lion City"), highlighted when it is
/// the current selection.
class _OptionCard extends StatelessWidget {
  const _OptionCard({
    required this.label,
    required this.text,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String text;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: selected
              ? kShopBlue.withOpacity(0.12)
              : Colors.white.withOpacity(0.55),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? kShopBlue : Colors.white.withOpacity(0.8),
            width: selected ? 1.6 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Text(
            "$label. $text",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: AppFonts.family,
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: kShopBlue,
              height: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}
