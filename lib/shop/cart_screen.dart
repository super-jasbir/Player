import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../common_widgets.dart';
import '../core/theme/app_fonts.dart';
import '../routes/app_routes.dart';
import 'cart_controller.dart';
import 'widgets/shop_cart_row.dart';
import 'widgets/shop_chrome.dart';
import 'widgets/shop_glass_card.dart';
import 'widgets/shop_widgets.dart';

/// MY CART: the chosen line items with their totals, or the empty state.
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CartController cart = CartController.to;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const ShopBackground(blurred: true),
          const ShopTopBar(),
          Positioned(
            left: 10.w,
            top: 89.h,
            width: 370.w,
            height: 615.h,
            child: ShopGlassCard(
              radius: 20,
              boxShadow: kShopGlassShadow,
              padding: EdgeInsets.fromLTRB(13.w, 24.h, 13.w, 16.h),
              child: Obx(
                () => cart.items.isEmpty
                    ? const _EmptyCart()
                    : _CartBody(cart: cart),
              ),
            ),
          ),
          Positioned(
            left: 10.w,
            top: 751.h,
            width: 370.w,
            child: Obx(
              () => AppButton(
                title: "PROCEED TO PAYMENT",
                radius: 16,
                isDisabled: cart.items.isEmpty,
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
                onPressed: () => Get.toNamed(AppRoutes.shopCheckout),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CartBody extends StatelessWidget {
  const _CartBody({required this.cart});

  final CartController cart;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ShopPanelHeader(title: "MY CART"),
        SizedBox(height: 24.h),
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.zero,
            physics: const BouncingScrollPhysics(),
            itemCount: cart.items.length,
            separatorBuilder: (_, __) => SizedBox(height: 5.h),
            itemBuilder: (_, i) {
              final item = cart.items[i];
              return ShopCartRow(
                item: item,
                onRemove: () => cart.remove(item),
                onIncrease: () => cart.increase(item),
                onDecrease: () => cart.decrease(item),
              );
            },
          ),
        ),
        SizedBox(height: 12.h),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Total",
            style: TextStyle(
              fontFamily: AppFonts.family,
              fontSize: 11.sp,
              color: const Color(0xFF6B7280),
            ),
          ),
        ),
        SizedBox(height: 5.h),
        ShopSummaryRow(
          label: "Direct Buy",
          value: cart.money(cart.cashTotal),
          suffix: "SGD",
        ),
        ShopSummaryRow(
          label: "Points",
          value: "${cart.coinTotal}",
          showCoin: true,
        ),
      ],
    );
  }
}

/// Shown when there is nothing in the cart yet.
class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ShopPanelHeader(title: "MY CART"),
        SizedBox(height: 90.h),
        Text(
          "Your Cart is Empty",
          style: TextStyle(
            fontFamily: AppFonts.family,
            fontSize: 15.sp,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          "There is no item in your cart.",
          style: TextStyle(
            fontFamily: AppFonts.family,
            fontSize: 12.sp,
            color: const Color(0xFF9AA6B8),
          ),
        ),
        SizedBox(height: 18.h),
        AppButton(
          title: "CONTINUE SHOPPING",
          width: 220.w,
          height: 46,
          radius: 16,
          gradientColors: const [
            Color(0xFFB3E5FC),
            Color(0xFF29B6F6),
            Color(0xFF0288D1),
          ],
          textStyle: TextStyle(
            fontFamily: AppFonts.family,
            fontSize: 15.sp,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
          onPressed: () => Get.offNamed(AppRoutes.shopList),
        ),
        SizedBox(height: 14.h),
        GestureDetector(
          onTap: () => Get.until((route) => Get.currentRoute == AppRoutes.shopScreen),
          child: Text(
            "Back to Home page",
            style: TextStyle(
              fontFamily: AppFonts.family,
              fontSize: 11.sp,
              color: const Color(0xFF6B7280),
            ),
          ),
        ),
      ],
    );
  }
}
