import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/theme/app_fonts.dart';
import '../models/shop_product.dart';
import 'shop_chrome.dart';
import 'shop_glass_card.dart';
import 'shop_widgets.dart';

/// One 344x105 line item, shared by the cart and the checkout order list:
/// thumbnail, name, chosen options, price pills and the quantity stepper.
///
/// The checkout list hides the coin pill ([showCoinPill] = false).
class ShopCartRow extends StatelessWidget {
  const ShopCartRow({
    super.key,
    required this.item,
    required this.onRemove,
    required this.onIncrease,
    required this.onDecrease,
    this.showCoinPill = true,
  });

  final ShopCartItem item;
  final VoidCallback onRemove;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final bool showCoinPill;

  @override
  Widget build(BuildContext context) {
    final optionStyle = TextStyle(
      fontFamily: AppFonts.family,
      fontSize: 11.sp,
      color: const Color(0xFF4B5563),
    );

    return SizedBox(
      height: 105.h,
      child: ShopGlassCard(
        radius: 20,
        boxShadow: kShopGlassShadow,
        child: Stack(
          children: [
            // Thumbnail on a white tile.
            Positioned(
              left: 15.w,
              top: 10.h,
              child: Container(
                width: 70.w,
                height: 70.w,
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: ShopProductImage(url: item.product.image),
              ),
            ),

            Positioned(
              left: 95.w,
              top: 10.h,
              width: 190.w,
              child: Text(
                item.product.name.replaceAll('\n', ' '),
                style: TextStyle(
                  fontFamily: AppFonts.family,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: kShopBlue,
                  height: 1.15,
                ),
              ),
            ),
            if (item.size != null)
              Positioned(
                left: 95.w,
                top: 46.h,
                child: Text("Size : ${item.size}", style: optionStyle),
              ),
            if (item.colour != null)
              Positioned(
                left: 95.w,
                top: 62.h,
                child: Text("Colour : ${item.colour}", style: optionStyle),
              ),

            // Price pills.
            Positioned(
              left: 95.w,
              top: 80.h,
              child: Row(
                children: [
                  if (showCoinPill) ...[
                    ShopBrandPill(
                      label: "${item.coinTotal}",
                      showCoin: true,
                      height: 16,
                      fontSize: 10,
                    ),
                    SizedBox(width: 5.w),
                  ],
                  ShopBrandPill(
                    label: "${item.product.currency} ${item.cashTotal % 1 == 0 ? item.cashTotal.toInt() : item.cashTotal}",
                    height: 16,
                    fontSize: 10,
                  ),
                ],
              ),
            ),

            // Remove.
            Positioned(
              right: 12.w,
              top: 10.h,
              child: GestureDetector(
                onTap: onRemove,
                child: Icon(Icons.close, size: 15.w, color: const Color(0xFF6B7280)),
              ),
            ),

            // Quantity.
            Positioned(
              left: 281.w,
              top: 78.h,
              child: ShopQtyStepper(
                quantity: item.quantity,
                onIncrease: onIncrease,
                onDecrease: onDecrease,
                width: 50,
                height: 16,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
