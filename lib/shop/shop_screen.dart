import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../common_widgets.dart';
import '../core/theme/app_fonts.dart';
import '../routes/app_routes.dart';
import 'widgets/shop_chrome.dart';
import 'widgets/shop_glass_card.dart';

/// Entry screen of the shop flow: the shopkeeper standing in the store, a
/// greeting dialogue card and the SHOP / MYSTERY BOX call-to-actions.
///
/// Laid out with absolute positions against the 390x844 Figma frame (the same
/// frame ScreenUtil is initialised with in main.dart), so `.w` / `.h` map 1:1
/// onto the design coordinates.
class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const ShopBackground(),
          const ShopTopBar(),

          // ---- Shopkeeper greeting ----
          Positioned(
            left: 11.w,
            top: 552.h,
            width: 368.w,
            child: const _GreetingCard(),
          ),

          // ---- Call-to-actions ----
          Positioned(
            left: 21.w,
            top: 669.h,
            child: _ShopButton(
              title: "SHOP",
              onPressed: () => Get.toNamed(AppRoutes.shopList),
            ),
          ),
          Positioned(
            left: 203.w,
            top: 669.h,
            child: _ShopButton(
              title: "MYSTERY BOX",
              onPressed: () => Get.toNamed(AppRoutes.mysteryBoxShelf),
            ),
          ),

          // ---- Home pill ----
          Positioned(
            top: 761.h,
            left: 0,
            right: 0,
            child: const Align(child: ShopHomePill()),
          ),
        ],
      ),
    );
  }
}

/// The shopkeeper's two-line greeting on a frosted card.
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
      height: 102.h,
      child: ShopGlassCard(
        radius: 20,
        boxShadow: kShopGlassShadow,
        padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 30.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Hi. Welcome to  SPENDRATHON SHOP", style: style),
            SizedBox(height: 6.h),
            Text("May i know how can i help you?", style: style),
          ],
        ),
      ),
    );
  }
}

/// A shop call-to-action: the shared [AppButton] at the shop's fixed size,
/// three-stop blue gradient and heavy uppercase label.
class _ShopButton extends StatelessWidget {
  const _ShopButton({required this.title, required this.onPressed});

  final String title;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return AppButton(
      title: title,
      onPressed: onPressed,
      width: 165.w,
      height: 56,
      radius: 16,
      gradientColors: const [
        Color(0xFFB3E5FC),
        Color(0xFF29B6F6),
        Color(0xFF0288D1),
      ],
      shadowColor: const Color(0x360288D1), // #0288D1 @ 21%
      textStyle: TextStyle(
        fontFamily: AppFonts.family,
        fontSize: 17.sp,
        fontWeight: FontWeight.w900,
        color: Colors.white,
        height: 1.2,
      ),
    );
  }
}
