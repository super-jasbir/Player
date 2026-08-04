import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../3dView/home_top_bar.dart';
import '../core/theme/app_fonts.dart';
import '../shop/widgets/shop_chrome.dart';
import '../shop/widgets/shop_glass_card.dart';
import 'widgets/quiz_chrome.dart';

/// The "HOW TO PLAY" info screen reached from the INFO button on the quiz
/// intro: a scrollable glass panel with the Rules and Prizes sections.
class QuizHowToPlayScreen extends StatelessWidget {
  const QuizHowToPlayScreen({super.key});

  static const Color _blue = kShopBlue;

  // Placeholder copy — swap for the real rules / prizes text when finalised.
  static const String _rulesBody =
      "Reference site about Lorem Ipsum, giving information on its origins, "
      "as well as a random Lipsum generator. Reference site about Lorem Ipsum, "
      "giving information on its origins, as well as a random Lipsum generator.";

  static const String _prizesBody =
      "Reference site about Lorem Ipsum, giving information on its origins, "
      "as well as a random Lipsum generator. Reference site about Lorem Ipsum, "
      "giving information on its origins, as well as a random Lipsum generator.";

  @override
  Widget build(BuildContext context) {
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
                      padding: EdgeInsets.fromLTRB(22.w, 22.h, 22.w, 22.h),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                "HOW TO PLAY",
                                style: TextStyle(
                                  fontFamily: AppFonts.family,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w800,
                                  color: _blue,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            SizedBox(height: 24.h),
                            _section("Rules", _rulesBody),
                            SizedBox(height: 22.h),
                            _section("PRIZES", _prizesBody),
                          ],
                        ),
                      ),
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

  Widget _section(String title, String body) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: AppFonts.family,
            fontSize: 13.sp,
            fontWeight: FontWeight.w800,
            color: _blue,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          body,
          style: TextStyle(
            fontFamily: AppFonts.family,
            fontSize: 11.sp,
            fontWeight: FontWeight.w500,
            color: _blue.withOpacity(0.85),
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
