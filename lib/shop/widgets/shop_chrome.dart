import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../app_controller.dart';
import '../../core/services/tap_sound.dart';
import '../../core/theme/app_fonts.dart';
import '../../core/theme/app_images.dart';
import '../../data/local/shared_prefs.dart';
import '../../routes/app_routes.dart';
import 'shop_glass_card.dart';

/// Accent blue shared by every label in the shop flow.
const Color kShopBlue = Color(0xFF0288D1);

/// The store photo behind every shop screen, with the shopkeeper standing in
/// front of it. The start screen shows both sharp; the browsing screens blur
/// the store behind a white wash and drop the shopkeeper so the cards stay
/// legible.
class ShopBackground extends StatelessWidget {
  const ShopBackground({super.key, this.blurred = false, this.keeperHeight = 684});

  final bool blurred;

  /// Height of the shopkeeper layer (Figma: 684 on the start screen, 613 on
  /// the mystery-box shelf where the shelving covers her legs).
  final double keeperHeight;

  @override
  Widget build(BuildContext context) {
    final Widget store = Image.asset(AppImages.shopBackground, fit: BoxFit.cover);
    if (blurred) {
      return Positioned.fill(
        child: Stack(
          fit: StackFit.expand,
          children: [
            store,
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 7.5, sigmaY: 7.5),
              child: Container(color: Colors.white.withOpacity(0.3)),
            ),
          ],
        ),
      );
    }
    return Positioned.fill(
      child: Stack(
        fit: StackFit.expand,
        children: [
          store,
          Positioned(
            left: 0,
            right: 0,
            top: 51.h,
            height: keeperHeight.h,
            child: Image.asset(AppImages.shopKeeper, fit: BoxFit.contain),
          ),
        ],
      ),
    );
  }
}

/// Top bar of the shop flow: glass avatar, basket and coin balance, positioned
/// against the 390x844 Figma frame.
class ShopTopBar extends StatelessWidget {
  const ShopTopBar({super.key, this.coinAmount = "999,999"});

  final String coinAmount;

  Future<void> _openProfileOrLogin() async {
    final token = await SharedPref.getAccessToken();
    Get.toNamed(token != null ? AppRoutes.updateProfile : AppRoutes.loginScreen);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 20.w,
          top: 24.h,
          child: GestureDetector(
            onTap: _openProfileOrLogin,
            child: SizedBox(
              width: 50.w,
              height: 50.w,
              child: const ShopGlassCard(child: _ShopAvatar()),
            ),
          ),
        ),
        Positioned(
          left: 254.w,
          top: 37.h,
          child: GestureDetector(
            onTap: () => Get.toNamed(AppRoutes.shopCart),
            child: SvgPicture.asset(
              AppImages.shopBasket,
              width: 28.w,
              height: 28.w,
            ),
          ),
        ),
        Positioned(left: 291.w, top: 37.h, child: _CoinPill(amount: coinAmount)),
      ],
    );
  }
}

/// Profile picture inside the glass avatar card, falling back to the shop's
/// default character art when the user has no picture (or is signed out).
class _ShopAvatar extends StatelessWidget {
  const _ShopAvatar();

  @override
  Widget build(BuildContext context) {
    final appC = Get.find<AppController>();
    return ClipOval(
      child: Obx(() {
        final String pic =
            appC.hasData.value ? (appC.profileData?.profilePic ?? "") : "";
        if (pic.isEmpty) return const _AvatarFallback();
        return Image.network(
          pic,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const _AvatarFallback(),
        );
      }),
    );
  }
}

class _AvatarFallback extends StatelessWidget {
  const _AvatarFallback();

  @override
  Widget build(BuildContext context) {
    // The cutout is a full-body portrait — align to the top so the circle
    // frames her face rather than her apron.
    return Image.asset(
      AppImages.shopKeeper,
      fit: BoxFit.cover,
      alignment: const Alignment(0, -0.92),
    );
  }
}

/// Star + coin balance pill at the top right.
class _CoinPill extends StatelessWidget {
  const _CoinPill({required this.amount});

  final String amount;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 82.w,
      height: 25.h,
      child: ShopGlassCard(
        padding: EdgeInsets.only(left: 5.w, right: 8.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SvgPicture.asset(AppImages.shopStar, width: 16.w, height: 19.h),
            SizedBox(width: 8.w),
            Text(
              amount,
              style: TextStyle(
                fontFamily: AppFonts.family,
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
                color: kShopBlue,
                height: 1.56,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Floating glass "HOME" button pinned near the bottom of every shop screen.
class ShopHomePill extends StatelessWidget {
  const ShopHomePill({super.key, this.onTap});

  /// Defaults to popping back to whatever opened the shop.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => Get.back(),
      child: SizedBox(
        width: 78.w,
        height: 46.h,
        child: ShopGlassCard(
          boxShadow: kShopGlassShadow,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(AppImages.shopHome, width: 27.w, height: 18.h),
              SizedBox(height: 2.h),
              Text(
                "HOME",
                style: TextStyle(
                  fontFamily: AppFonts.family,
                  fontSize: 8.sp,
                  fontWeight: FontWeight.w700,
                  color: kShopBlue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The small white "< Back" link that sits above the home pill on the
/// browsing screens.
class ShopBackButton extends StatelessWidget {
  const ShopBackButton({super.key, this.onTap, this.color = Colors.white});

  final VoidCallback? onTap;

  /// White over the blurred store background, blue on the glass cards.
  final Color color;

  @override
  Widget build(BuildContext context) {
    // Back button: no global click sound (its own sound comes later).
    return NoTapSound(
      child: GestureDetector(
      onTap: onTap ?? () => Get.back(),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.arrow_back, size: 15.w, color: color),
          SizedBox(width: 6.w),
          Text(
            "Back",
            style: TextStyle(
              fontFamily: AppFonts.family,
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              color: color,
              height: 1.2,
            ),
          ),
        ],
      ),
    ),
    );
  }
}
