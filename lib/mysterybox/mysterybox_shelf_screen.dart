import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../routes/app_routes.dart';
import '../shop/widgets/shop_chrome.dart';
import 'mysterybox_controller.dart';
import 'widgets/mysterybox_shelf.dart';

/// The mystery-box shop floor: the shopkeeper behind a shelving unit stocked
/// with boxes from the API. Tapping a box opens its detail screen.
class MysteryBoxShelfScreen extends StatelessWidget {
  const MysteryBoxShelfScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final MysteryBoxController controller = MysteryBoxController.to;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // The shelving covers her legs here, so the cutout is shorter.
          const ShopBackground(keeperHeight: 613),
          const ShopTopBar(),
          // The shelf wall scrolls, so it is anchored to the bottom of the
          // screen rather than given the design's fixed 409px height.
          Positioned(
            left: 12.w,
            right: 12.w,
            top: 306.h,
            bottom: 0,
            child: Obx(
              () => controller.loadingList.value && controller.boxes.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : MysteryBoxShelfWall(
                      boxes: controller.boxes,
                      onTap: (box) => Get.toNamed(
                        AppRoutes.mysteryBoxDetail,
                        arguments: box,
                      ),
                    ),
            ),
          ),
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
