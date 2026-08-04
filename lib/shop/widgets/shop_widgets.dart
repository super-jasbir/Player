import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../core/theme/app_fonts.dart';
import '../../core/theme/app_images.dart';
import '../models/shop_product.dart';
import 'shop_chrome.dart';

/// Pale background used by the checkout / address screens, which drop the
/// store photo for a near-white sheet.
class ShopLightBackground extends StatelessWidget {
  const ShopLightBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return const Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFBFDFF), Color(0xFFEAF4FB)],
          ),
        ),
      ),
    );
  }
}

/// "< Back" on the left with a centred screen title, as used by the cart,
/// checkout and address screens.
class ShopPanelHeader extends StatelessWidget {
  const ShopPanelHeader({
    super.key,
    required this.title,
    this.onBack,
    this.backColor = kShopBlue,
  });

  final String title;
  final VoidCallback? onBack;
  final Color backColor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: GestureDetector(
            onTap: onBack ?? () => Get.back(),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.arrow_back, size: 15.w, color: backColor),
                SizedBox(width: 6.w),
                Text(
                  "Back",
                  style: TextStyle(
                    fontFamily: AppFonts.family,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: backColor,
                  ),
                ),
              ],
            ),
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontFamily: AppFonts.family,
            fontSize: 18.sp,
            fontWeight: FontWeight.w900,
            color: kShopBlue,
          ),
        ),
      ],
    );
  }
}

/// Small blue capsule used for prices, sizes and colours. Filled when
/// [selected], outlined otherwise.
class ShopBrandPill extends StatelessWidget {
  const ShopBrandPill({
    super.key,
    required this.label,
    this.selected = true,
    this.showCoin = false,
    this.width,
    this.height = 20,
    this.fontSize = 14,
    this.onTap,
  });

  final String label;
  final bool selected;

  /// Prefix the label with the star/coin glyph (used by coin prices).
  final bool showCoin;
  final double? width;
  final double height;
  final double fontSize;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width?.w,
        height: height.h,
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? kShopBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: kShopBlue),
          boxShadow: const [
            BoxShadow(
              color: Color(0x304FC3F7),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        // Fixed-width pills (e.g. the 50px "White" swatch) must shrink their
        // label rather than overflow.
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showCoin) ...[
                SvgPicture.asset(
                  AppImages.shopCoin,
                  width: (fontSize * 0.85).w,
                  height: (fontSize * 1.05).h,
                ),
                SizedBox(width: 4.w),
              ],
              Text(
                label,
                style: TextStyle(
                  fontFamily: AppFonts.family,
                  fontSize: fontSize.sp,
                  fontWeight: FontWeight.w700,
                  color: selected ? Colors.white : kShopBlue,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The inset "+ n -" quantity control. Figma keeps plus on the left.
class ShopQtyStepper extends StatelessWidget {
  const ShopQtyStepper({
    super.key,
    required this.quantity,
    required this.onIncrease,
    required this.onDecrease,
    this.width = 93,
    this.height = 29,
    this.fontSize = 14,
  });

  final int quantity;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final double width;
  final double height;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final double icon = height * 0.55;
    return Container(
      width: width.w,
      height: height.h,
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6F9),
        borderRadius: BorderRadius.circular(height / 2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x40000000),
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _StepIcon(icon: Icons.add, size: icon, onTap: onIncrease),
          Text(
            "$quantity",
            style: TextStyle(
              fontFamily: AppFonts.family,
              fontSize: fontSize.sp,
              fontWeight: FontWeight.w500,
              color: kShopBlue,
            ),
          ),
          _StepIcon(icon: Icons.remove, size: icon, onTap: onDecrease),
        ],
      ),
    );
  }
}

class _StepIcon extends StatelessWidget {
  const _StepIcon({required this.icon, required this.size, required this.onTap});

  final IconData icon;
  final double size;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size.w,
        height: size.w,
        decoration: const BoxDecoration(
          color: Color(0xFFCFE7F5),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: (size * 0.7).w, color: kShopBlue),
      ),
    );
  }
}

/// One row of the Total / Direct Buy / Points style summary block: a label on
/// the left and a value on the right, with a hairline above it.
class ShopSummaryRow extends StatelessWidget {
  const ShopSummaryRow({
    super.key,
    required this.label,
    required this.value,
    this.suffix,
    this.note,
    this.showDivider = true,
    this.showCoin = false,
  });

  final String label;

  /// Emphasised value, e.g. "$25".
  final String value;

  /// Muted text after the value, e.g. "SGD".
  final String? suffix;

  /// Muted text before the value, e.g. "(5 items)".
  final String? note;
  final bool showDivider;

  /// Render the star glyph after the value instead of a [suffix].
  final bool showCoin;

  @override
  Widget build(BuildContext context) {
    final muted = TextStyle(
      fontFamily: AppFonts.family,
      fontSize: 11.sp,
      color: const Color(0xFF6B7280),
    );
    return Column(
      children: [
        if (showDivider)
          Divider(height: 1, thickness: 1, color: Colors.black.withOpacity(0.08)),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 6.h),
          child: Row(
            children: [
              Text(label, style: muted),
              const Spacer(),
              if (note != null) ...[Text(note!, style: muted), SizedBox(width: 8.w)],
              Text(
                value,
                style: TextStyle(
                  fontFamily: AppFonts.family,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: kShopBlue,
                ),
              ),
              if (showCoin) ...[
                SizedBox(width: 6.w),
                SvgPicture.asset(AppImages.shopStar, width: 13.w, height: 15.h),
              ],
              if (suffix != null) ...[SizedBox(width: 6.w), Text(suffix!, style: muted)],
            ],
          ),
        ),
      ],
    );
  }
}

/// Product artwork from the API, with a neutral placeholder while it loads or
/// when the URL is missing / broken.
class ShopProductImage extends StatelessWidget {
  const ShopProductImage({super.key, required this.url, this.fit = BoxFit.contain});

  final String url;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) return const _ProductImagePlaceholder();
    return Image.network(
      url,
      fit: fit,
      errorBuilder: (_, __, ___) => const _ProductImagePlaceholder(),
      loadingBuilder: (context, child, progress) =>
          progress == null ? child : const _ProductImagePlaceholder(),
    );
  }
}

class _ProductImagePlaceholder extends StatelessWidget {
  const _ProductImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Icon(
        Icons.image_outlined,
        size: 32.w,
        color: const Color(0xFFBFD7E5),
      ),
    );
  }
}

/// Section label above a group of fields / cards ("Order", "Price", "Sizes").
class ShopSectionLabel extends StatelessWidget {
  const ShopSectionLabel(this.text, {super.key, this.fontSize = 12});

  final String text;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: AppFonts.family,
        fontSize: fontSize.sp,
        fontWeight: FontWeight.w600,
        color: kShopBlue,
      ),
    );
  }
}

/// Name + phone on one line with the address body underneath, shared by the
/// checkout summary and the address list.
class ShopAddressBody extends StatelessWidget {
  const ShopAddressBody({super.key, required this.address, this.muted = false});

  final ShopAddress address;

  /// Greyed-out variant used for the non-selected saved addresses.
  final bool muted;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                address.name,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: AppFonts.family,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: muted ? const Color(0xFF9AA6B8) : Colors.black,
                ),
              ),
            ),
            SizedBox(width: 6.w),
            Flexible(
              child: Text(
                "(${address.phone})",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: AppFonts.family,
                  fontSize: 11.sp,
                  color: const Color(0xFF9AA6B8),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 4.h),
        // The cards are a fixed 88px tall, so a long address truncates rather
        // than overflowing the column.
        Flexible(
          child: Text(
            address.formatted,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: AppFonts.family,
              fontSize: 11.sp,
              height: 1.25,
              color: muted ? const Color(0xFFB6C2CF) : kShopBlue,
            ),
          ),
        ),
      ],
    );
  }
}

/// Rounded text field used by the address form.
class ShopTextField extends StatelessWidget {
  const ShopTextField({
    super.key,
    required this.hint,
    this.controller,
    this.keyboardType,
    this.prefix,
    this.suffix,
    this.width,
  });

  final String hint;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final Widget? prefix;
  final Widget? suffix;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width?.w,
      height: 44.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xFFDCE6EF)),
      ),
      child: Row(
        children: [
          if (prefix != null) ...[prefix!, SizedBox(width: 8.w)],
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              style: TextStyle(
                fontFamily: AppFonts.family,
                fontSize: 12.sp,
                color: const Color(0xFF1F2937),
              ),
              decoration: InputDecoration(
                isCollapsed: true,
                border: InputBorder.none,
                hintText: hint,
                hintStyle: TextStyle(
                  fontFamily: AppFonts.family,
                  fontSize: 12.sp,
                  color: const Color(0xFF9AA6B8),
                ),
              ),
            ),
          ),
          if (suffix != null) ...[SizedBox(width: 8.w), suffix!],
        ],
      ),
    );
  }
}

/// A labelled field: 10sp caption above a [ShopTextField]-sized control.
class ShopField extends StatelessWidget {
  const ShopField({super.key, required this.label, required this.child, this.width});

  final String label;
  final Widget child;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width?.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: AppFonts.family,
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              color: kShopBlue,
            ),
          ),
          SizedBox(height: 8.h),
          child,
        ],
      ),
    );
  }
}
