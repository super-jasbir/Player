import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../core/theme/app_fonts.dart';
import '../core/theme/app_images.dart';
import '../routes/app_routes.dart';
import 'models/shop_product.dart';
import 'shop_controller.dart';
import 'widgets/shop_chrome.dart';
import 'widgets/shop_glass_card.dart';
import 'widgets/shop_widgets.dart';

/// The shop catalogue: a search + sort row above a two-column grid of glass
/// product cards, over the blurred store background.
class ShopListScreen extends StatelessWidget {
  const ShopListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ShopController controller = ShopController.to;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const ShopBackground(blurred: true),

          // Grid, clipped to the area between the search row and the bottom.
          Positioned(
            left: 17.w,
            right: 17.w,
            top: 146.h,
            bottom: 0,
            child: Obx(
              () => controller.loadingList.value && controller.catalogue.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : _ProductGrid(products: controller.products),
            ),
          ),

          const ShopTopBar(),

          // Search + sort row.
          Positioned(
            left: 17.w,
            top: 92.h,
            width: 356.w,
            child: _SearchRow(controller: controller),
          ),

          // Bottom navigation: "Back" link above the floating home pill.
          Positioned(
            left: 0,
            right: 0,
            top: 736.h,
            child: const Align(child: ShopBackButton()),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 761.h,
            child: const Align(child: ShopHomePill()),
          ),

          // Sort dropdown, drawn last so it floats above the grid.
          Positioned(
            right: 17.w,
            top: 128.h,
            child: Obx(
              () => controller.sortMenuOpen.value
                  ? _SortMenu(controller: controller)
                  : const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }
}

/// White pill search field plus the "Sort by" dropdown trigger.
class _SearchRow extends StatelessWidget {
  const _SearchRow({required this.controller});

  final ShopController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36.h,
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 36.h,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18.r),
                border: Border.all(color: const Color(0xFFF1F0F0)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: controller.onQueryChanged,
                      style: TextStyle(
                        fontFamily: AppFonts.family,
                        fontSize: 12.sp,
                        color: const Color(0xFF3A3A3A),
                      ),
                      decoration: const InputDecoration(
                        isCollapsed: true,
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  SvgPicture.asset(
                    AppImages.shopSearch,
                    width: 13.w,
                    height: 13.w,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 5.w),
          GestureDetector(
            onTap: controller.toggleSortMenu,
            child: Container(
              width: 76.w,
              height: 36.h,
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18.r),
                border: Border.all(color: const Color(0xFFF1F0F0)),
              ),
              // The label + caret are a hair wider than the 76px pill on some
              // densities, so scale them down instead of overflowing.
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Sort by",
                      style: TextStyle(
                        fontFamily: AppFonts.family,
                        fontSize: 10.sp,
                        color: const Color(0xFF848484),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Icon(
                      Icons.arrow_drop_down,
                      size: 14.w,
                      color: const Color(0xFF848484),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The dropdown that opens under "Sort by".
class _SortMenu extends StatelessWidget {
  const _SortMenu({required this.controller});

  final ShopController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final option in ShopSort.values)
            InkWell(
              onTap: () => controller.selectSort(option),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 9.h),
                decoration: BoxDecoration(
                  border: option == ShopSort.values.last
                      ? null
                      : const Border(
                          bottom: BorderSide(color: Color(0xFFEDEDED)),
                        ),
                ),
                child: Text(
                  option.label,
                  style: TextStyle(
                    fontFamily: AppFonts.family,
                    fontSize: 11.sp,
                    color: const Color(0xFF3A3A3A),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Two-column grid of 168x168 product cards with 20px gutters.
class _ProductGrid extends StatelessWidget {
  const _ProductGrid({required this.products});

  final List<ShopProduct> products;

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return Padding(
        padding: EdgeInsets.only(top: 40.h),
        child: Text(
          "No items found",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: AppFonts.family,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: kShopBlue,
          ),
        ),
      );
    }

    return GridView.builder(
      padding: EdgeInsets.only(bottom: 120.h),
      physics: const BouncingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 20.h,
        crossAxisSpacing: 20.w,
        childAspectRatio: 1,
      ),
      itemCount: products.length,
      itemBuilder: (_, i) => _ProductCard(product: products[i]),
    );
  }
}

/// A single glass product card: art, name and the coin / cash price pills.
class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product});

  final ShopProduct product;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.shopDetail, arguments: product),
      child: ShopGlassCard(
        radius: 20,
        boxShadow: kShopGlassShadow,
        child: Column(
          children: [
            SizedBox(height: 10.h),
            SizedBox(
              height: 70.h,
              child: ShopProductImage(url: product.image),
            ),
            SizedBox(height: 10.h),
            Expanded(
              child: Text(
                product.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppFonts.family,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: kShopBlue,
                  height: 1.15,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 14.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _PricePill(
                    label: "${product.coinPrice}",
                    icon: SvgPicture.asset(
                      AppImages.shopCoin,
                      width: 9.w,
                      height: 11.h,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  _PricePill(label: product.cashLabel),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Solid blue rounded pill used for both the coin and the cash price.
class _PricePill extends StatelessWidget {
  const _PricePill({required this.label, this.icon});

  final String label;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 16.h,
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      decoration: BoxDecoration(
        color: kShopBlue,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: const [
          BoxShadow(
            color: Color(0x304FC3F7),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[icon!, SizedBox(width: 4.w)],
          Text(
            label,
            style: TextStyle(
              fontFamily: AppFonts.family,
              fontSize: 10.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
