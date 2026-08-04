import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../common_widgets.dart';
import '../core/theme/app_fonts.dart';
import '../data/modal/MySteryBoxResponse.dart';
import '../shop/widgets/shop_chrome.dart';
import '../shop/widgets/shop_glass_card.dart';
import 'mysterybox_controller.dart';
import 'widgets/mysterybox_dialogs.dart';

/// A single mystery box: artwork, name and description, then the payment
/// flow (payment sheet -> success -> reward reveal).
///
/// Receives the tapped [MySteryBoxList] through `Get.arguments` and loads the
/// full record from `get-mysterybox-detail`.
class MysteryBoxDetailScreen extends StatefulWidget {
  const MysteryBoxDetailScreen({super.key});

  @override
  State<MysteryBoxDetailScreen> createState() => _MysteryBoxDetailScreenState();
}

class _MysteryBoxDetailScreenState extends State<MysteryBoxDetailScreen> {
  final MysteryBoxController controller = MysteryBoxController.to;

  MySteryBoxList? get _box => Get.arguments as MySteryBoxList?;

  @override
  void initState() {
    super.initState();
    final id = _box?.id;
    if (id != null) controller.fetchDetail("$id");
  }

  String get _price => controller.priceOf(_box);

  /// payment sheet -> success -> reward. Each step replaces the previous
  /// dialog, matching the Figma frames.
  void _openPayment() {
    Get.dialog(
      MysteryBoxPaymentSheet(
        price: _price,
        onDirectBuy: _onPaid,
        onPayWithPoints: _onPaid,
      ),
      barrierColor: Colors.transparent,
    );
  }

  void _onPaid() {
    Get.back();
    Get.dialog(
      MysteryBoxSuccessDialog(pointsSpent: _price, onDone: _onDone),
      barrierColor: Colors.transparent,
    );
  }

  void _onDone() {
    Get.back();
    Get.dialog(
      MysteryBoxRewardDialog(
        rewardName: controller.nameOf(controller.detail.value),
        rewardImage: controller.detail.value?.mysteryBoxImage,
        onUse: () => Get.back(),
      ),
      barrierColor: Colors.transparent,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const ShopBackground(blurred: true),
          const ShopTopBar(),
          Positioned(
            left: 10.w,
            top: 250.h,
            width: 370.w,
            height: 345.h,
            child: Obx(() => _card()),
          ),
          Positioned(
            left: 10.w,
            top: 615.h,
            width: 370.w,
            child: AppButton(
              title: "PROCEED TO PAYMENT",
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
              onPressed: _openPayment,
            ),
          ),
        ],
      ),
    );
  }

  Widget _card() {
    final detail = controller.detail.value;
    final String image = detail?.mysteryBoxImage ?? _box?.mysteryBoxImage ?? "";

    return ShopGlassCard(
      radius: 20,
      boxShadow: kShopGlassShadow,
      child: Stack(
        children: [
          Positioned(
            left: 13.w,
            top: 21.h,
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.arrow_back, size: 15.w, color: kShopBlue),
                  SizedBox(width: 6.w),
                  Text(
                    "Back",
                    style: TextStyle(
                      fontFamily: AppFonts.family,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                      color: kShopBlue,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 78.w,
            top: 58.h,
            width: 214.w,
            height: 168.h,
            child: image.isEmpty
                ? const _BoxArtPlaceholder()
                : Image.network(
                    image,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const _BoxArtPlaceholder(),
                  ),
          ),
          Positioned(
            left: 16.w,
            top: 236.h,
            width: 338.w,
            child: Text(
              "MYSTERY BOX",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppFonts.family,
                fontSize: 28.sp,
                fontWeight: FontWeight.w900,
                color: kShopBlue,
              ),
            ),
          ),
          Positioned(
            left: 16.w,
            top: 284.h,
            width: 337.w,
            child: Column(
              children: [
                Text(
                  controller.nameOf(detail),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: AppFonts.family,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  controller.descriptionOf(detail),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: AppFonts.family,
                    fontSize: 12.sp,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BoxArtPlaceholder extends StatelessWidget {
  const _BoxArtPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.card_giftcard_rounded,
      size: 110.w,
      color: const Color(0xFFC8A165),
    );
  }
}
