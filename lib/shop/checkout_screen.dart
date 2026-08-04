import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../common_widgets.dart';
import '../core/theme/app_fonts.dart';
import '../routes/app_routes.dart';
import 'cart_controller.dart';
import 'models/shop_product.dart';
import 'widgets/shop_cart_row.dart';
import 'widgets/shop_chrome.dart';
import 'widgets/shop_widgets.dart';

/// CHECK OUT: the order lines, the delivery address and the money summary.
class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

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
                  const ShopPanelHeader(title: "CHECK OUT"),
                  SizedBox(height: 24.h),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: ShopSectionLabel("Order", fontSize: 13),
                  ),
                  SizedBox(height: 5.h),
                  Expanded(
                    child: Obx(
                      () => ListView(
                        padding: EdgeInsets.only(bottom: 8.h),
                        physics: const BouncingScrollPhysics(),
                        children: [
                          for (final item in cart.items) ...[
                            ShopCartRow(
                              item: item,
                              showCoinPill: false,
                              onRemove: () => cart.remove(item),
                              onIncrease: () => cart.increase(item),
                              onDecrease: () => cart.decrease(item),
                            ),
                            SizedBox(height: 5.h),
                          ],
                          SizedBox(height: 10.h),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: ShopSectionLabel("Delivery Address", fontSize: 13),
                          ),
                          SizedBox(height: 5.h),
                          Obx(
                            () => _AddressCard(
                              address: cart.deliveryAddress,
                              onTap: () => Get.toNamed(AppRoutes.shopAddressList),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Obx(
                    () => Padding(
                      padding: EdgeInsets.symmetric(horizontal: 13.w),
                      child: Column(
                        children: [
                          ShopSummaryRow(
                            label: "Total",
                            note: "(${cart.itemCount} items)",
                            value: cart.money(cart.cashTotal),
                            suffix: "SGD",
                            showDivider: false,
                          ),
                          ShopSummaryRow(
                            label: "Shipping",
                            value: cart.money(CartController.shippingFee),
                            suffix: "SGD",
                          ),
                          ShopSummaryRow(
                            label: "Subtotal",
                            value: cart.money(cart.subtotal),
                            suffix: "SGD",
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  AppButton(
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
                    onPressed: () =>
                        Fluttertoast.showToast(msg: "Payment coming soon..."),
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

/// The delivery-address summary that opens the address list.
class _AddressCard extends StatelessWidget {
  const _AddressCard({required this.address, required this.onTap});

  final ShopAddress? address;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 88.h,
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: const Color(0xFFDCE6EF)),
        ),
        child: Row(
          children: [
            Expanded(
              child: address == null
                  ? Text(
                      "Add a delivery address",
                      style: TextStyle(
                        fontFamily: AppFonts.family,
                        fontSize: 12.sp,
                        color: const Color(0xFF9AA6B8),
                      ),
                    )
                  : ShopAddressBody(address: address!),
            ),
            Icon(Icons.chevron_right, color: kShopBlue, size: 22.w),
          ],
        ),
      ),
    );
  }
}
