import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../common_widgets.dart';
import '../../core/theme/app_fonts.dart';
import '../../core/theme/app_images.dart';
import '../../shop/widgets/shop_chrome.dart';
import '../../shop/widgets/shop_glass_card.dart';
import 'package:player/core/services/tap_sound.dart';

/// Shared shell for the mystery-box modals: a dimming scrim with a frosted
/// card of the height the design calls for.
class MysteryBoxDialog extends StatelessWidget {
  const MysteryBoxDialog({
    super.key,
    required this.height,
    required this.child,
    this.top = 303,
  });

  final double height;
  final double top;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.18),
      child: Stack(
        children: [
          Positioned(
            left: 17.w,
            top: top.h,
            width: 356.w,
            // [height] is the Figma height, applied as a minimum: text that
            // wraps to an extra line grows the card instead of overflowing it.
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: height.h),
              child: ShopGlassCard(
                radius: 20,
                boxShadow: kShopGlassShadow,
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 16.h),
                child: child,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Title used across the mystery-box modals.
class MysteryBoxDialogTitle extends StatelessWidget {
  const MysteryBoxDialogTitle(this.text, {super.key, this.fontSize = 22});

  final String text;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: AppFonts.family,
        fontSize: fontSize.sp,
        fontWeight: FontWeight.w900,
        color: kShopBlue,
      ),
    );
  }
}

/// PAYMENT: pay with real money (orange) or with points (blue).
class MysteryBoxPaymentSheet extends StatelessWidget {
  const MysteryBoxPaymentSheet({
    super.key,
    required this.price,
    required this.onDirectBuy,
    required this.onPayWithPoints,
  });

  final String price;
  final VoidCallback onDirectBuy;
  final VoidCallback onPayWithPoints;

  @override
  Widget build(BuildContext context) {
    return MysteryBoxDialog(
      height: 239,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const MysteryBoxDialogTitle("PAYMENT"),
          SizedBox(height: 26.h),
          _DirectBuyButton(price: price, onPressed: onDirectBuy),
          SizedBox(height: 10.h),
          MysteryBoxGradientButton(
            onPressed: onPayWithPoints,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(AppImages.shopStar, width: 18.w, height: 21.h),
                SizedBox(width: 8.w),
                Text(
                  price,
                  style: TextStyle(
                    fontFamily: AppFonts.family,
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 14.h),
          NoTapSound(
            child: GestureDetector(
            onTap: () => Get.back(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.arrow_back, size: 13.w, color: const Color(0xFF6B7280)),
                SizedBox(width: 5.w),
                Text(
                  "Back",
                  style: TextStyle(
                    fontFamily: AppFonts.family,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
          ),
        ],
      ),
    );
  }
}

/// Gradient CTA that takes an arbitrary child. [AppButton] only accepts a
/// single text label, and these buttons stack two lines or an icon + value.
class MysteryBoxGradientButton extends StatelessWidget {
  const MysteryBoxGradientButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.gradientColors = const [
      Color(0xFFB3E5FC),
      Color(0xFF29B6F6),
      Color(0xFF0288D1),
    ],
    this.shadowColor = const Color(0x600288D1),
  });

  final Widget child;
  final VoidCallback onPressed;
  final List<Color> gradientColors;
  final Color shadowColor;

  @override
  Widget build(BuildContext context) {
    final BorderRadius radius = BorderRadius.circular(16.r);
    return Container(
      width: double.infinity,
      height: 56.h,
      decoration: BoxDecoration(
        borderRadius: radius,
        border: Border.all(color: Colors.white.withOpacity(0.6667)),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: gradientColors,
        ),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 20,
            spreadRadius: -2,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: radius,
        child: InkWell(
          borderRadius: radius,
          onTap: onPressed,
          child: Center(child: child),
        ),
      ),
    );
  }
}

/// The orange "DIRECT BUY / SGD n" button.
class _DirectBuyButton extends StatelessWidget {
  const _DirectBuyButton({required this.price, required this.onPressed});

  final String price;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return MysteryBoxGradientButton(
      onPressed: onPressed,
      gradientColors: const [Color(0xFFFFC64D), Color(0xFFEF9A0B)],
      shadowColor: const Color(0x60EF9A0B),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "DIRECT BUY",
            style: TextStyle(
              fontFamily: AppFonts.family,
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          Text(
            "SGD $price",
            style: TextStyle(
              fontFamily: AppFonts.family,
              fontSize: 17.sp,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

/// PAYMENT SUCCESS! confirmation.
class MysteryBoxSuccessDialog extends StatelessWidget {
  const MysteryBoxSuccessDialog({
    super.key,
    required this.pointsSpent,
    required this.onDone,
  });

  final String pointsSpent;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    return MysteryBoxDialog(
      height: 168,
      top: 338,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const MysteryBoxDialogTitle("PAYMENT SUCCESS!"),
          SizedBox(height: 10.h),
          Text(
            "You had spend ${pointsSpent}pts.",
            style: TextStyle(
              fontFamily: AppFonts.family,
              fontSize: 12.sp,
              color: const Color(0xFF6B7280),
            ),
          ),
          SizedBox(height: 14.h),
          AppButton(
            title: "DONE",
            height: 56,
            radius: 16,
            gradientColors: const [
              Color(0xFFB3E5FC),
              Color(0xFF29B6F6),
              Color(0xFF0288D1),
            ],
            textStyle: TextStyle(
              fontFamily: AppFonts.family,
              fontSize: 17.sp,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
            onPressed: onDone,
          ),
        ],
      ),
    );
  }
}

/// CONGRATULATION! — reveals the power card won from the box.
class MysteryBoxRewardDialog extends StatelessWidget {
  const MysteryBoxRewardDialog({
    super.key,
    required this.rewardName,
    required this.onUse,
    this.rewardImage,
  });

  final String rewardName;

  /// Remote artwork for the reward; falls back to a bolt badge.
  final String? rewardImage;
  final VoidCallback onUse;

  @override
  Widget build(BuildContext context) {
    return MysteryBoxDialog(
      height: 356,
      top: 244,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const MysteryBoxDialogTitle("CONGRATULATION!"),
          SizedBox(height: 12.h),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(
                fontFamily: AppFonts.family,
                fontSize: 12.sp,
                color: const Color(0xFF4B5563),
                height: 1.4,
              ),
              children: [
                const TextSpan(text: "Congratulation!\nYou get a power card - "),
                TextSpan(
                  text: rewardName,
                  style: const TextStyle(
                    color: Color(0xFFEF6C00),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          SizedBox(
            width: 141.w,
            height: 141.w,
            child: rewardImage == null || rewardImage!.isEmpty
                ? const _RewardPlaceholder()
                : Image.network(
                    rewardImage!,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const _RewardPlaceholder(),
                  ),
          ),
          // Fixed gap, not a Spacer: the card sizes to its content now, so
          // there is no free space for a flex child to claim.
          SizedBox(height: 20.h),
          AppButton(
            title: "USE",
            height: 56,
            radius: 16,
            gradientColors: const [
              Color(0xFFB3E5FC),
              Color(0xFF29B6F6),
              Color(0xFF0288D1),
            ],
            textStyle: TextStyle(
              fontFamily: AppFonts.family,
              fontSize: 17.sp,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
            onPressed: onUse,
          ),
          SizedBox(height: 10.h),
          GestureDetector(
            onTap: () => Get.back(),
            child: Text(
              "CLOSE",
              style: TextStyle(
                fontFamily: AppFonts.family,
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF6B7280),
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RewardPlaceholder extends StatelessWidget {
  const _RewardPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFFFFF3E0),
      ),
      alignment: Alignment.center,
      child: Icon(Icons.bolt_rounded, size: 80.w, color: const Color(0xFFEF6C00)),
    );
  }
}
