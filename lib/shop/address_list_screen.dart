import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../common_widgets.dart';
import '../core/theme/app_fonts.dart';
import '../routes/app_routes.dart';
import 'cart_controller.dart';
import 'models/shop_product.dart';
import 'widgets/shop_chrome.dart';
import 'widgets/shop_widgets.dart';

/// ADDRESS: the saved delivery addresses, with the selected one highlighted
/// and a dashed "Add New Address" row.
class AddressListScreen extends StatelessWidget {
  const AddressListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CartController cart = CartController.to;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const ShopLightBackground(),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 23.w),
              child: Column(
                children: [
                  SizedBox(height: 20.h),
                  const ShopPanelHeader(title: "ADDRESS"),
                  SizedBox(height: 24.h),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: ShopSectionLabel("Current Address", fontSize: 13),
                  ),
                  SizedBox(height: 5.h),
                  Expanded(
                    child: Obx(
                      () => ListView(
                        physics: const BouncingScrollPhysics(),
                        children: [
                          for (int i = 0; i < cart.addresses.length; i++) ...[
                            _AddressTile(
                              address: cart.addresses[i],
                              selected: i == cart.selectedAddress.value,
                              onTap: () => cart.selectAddress(i),
                            ),
                            SizedBox(height: 5.h),
                          ],
                          GestureDetector(
                            onTap: () => Get.toNamed(AppRoutes.shopAddressForm),
                            child: const _AddNewAddressTile(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  AppButton(
                    title: "SAVE",
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
                    onPressed: () => Get.back(),
                  ),
                  SizedBox(height: 16.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AddressTile extends StatelessWidget {
  const _AddressTile({
    required this.address,
    required this.selected,
    required this.onTap,
  });

  final ShopAddress address;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 88.h,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: selected ? kShopBlue : const Color(0xFFDCE6EF),
            width: selected ? 2 : 1,
          ),
        ),
        child: ShopAddressBody(address: address, muted: !selected),
      ),
    );
  }
}

class _AddNewAddressTile extends StatelessWidget {
  const _AddNewAddressTile();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        // Dashed in Figma; a soft solid outline is the closest cheap match.
        border: Border.all(color: const Color(0xFF9ECFEA)),
      ),
      child: Text(
        "Add New Address",
        style: TextStyle(
          fontFamily: AppFonts.family,
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: kShopBlue,
        ),
      ),
    );
  }
}
