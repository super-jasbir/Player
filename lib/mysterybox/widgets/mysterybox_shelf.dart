import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/theme/app_fonts.dart';
import '../../core/theme/app_images.dart';
import '../../data/modal/MySteryBoxResponse.dart';
import '../../shop/widgets/shop_chrome.dart';

/// A scrollable wall of shelving for the mystery boxes.
///
/// The rack artwork ([AppImages.mysteryBoxShelf]) is the repeating unit: it
/// holds [MysteryBoxRack.slots] boxes, and the wall stacks as many racks as
/// the item count needs. That way twelve boxes and a hundred boxes both lay
/// out correctly — the list simply grows and scrolls.
class MysteryBoxShelfWall extends StatelessWidget {
  const MysteryBoxShelfWall({
    super.key,
    required this.boxes,
    required this.onTap,
  });

  final List<MySteryBoxList> boxes;
  final ValueChanged<MySteryBoxList> onTap;

  @override
  Widget build(BuildContext context) {
    // Always show at least one rack so the shelf never looks broken while the
    // list is still loading.
    final int rackCount =
        boxes.isEmpty ? 1 : (boxes.length / MysteryBoxRack.slots).ceil();

    return ListView.builder(
      padding: EdgeInsets.only(bottom: 90.h),
      physics: const BouncingScrollPhysics(),
      itemCount: rackCount,
      itemBuilder: (_, rack) {
        final int start = rack * MysteryBoxRack.slots;
        final int end =
            (start + MysteryBoxRack.slots).clamp(0, boxes.length).toInt();
        return MysteryBoxRack(
          boxes: start >= boxes.length ? const [] : boxes.sublist(start, end),
          onTap: onTap,
        );
      },
    );
  }
}

/// A single rack: the shelving photo with its bays filled left-to-right,
/// top-to-bottom. Slot positions are fractions of the artwork, so the rack
/// scales with the screen without any hard-coded pixel offsets.
class MysteryBoxRack extends StatelessWidget {
  const MysteryBoxRack({super.key, required this.boxes, required this.onTap});

  final List<MySteryBoxList> boxes;
  final ValueChanged<MySteryBoxList> onTap;

  /// Artwork aspect (1170x1227 source).
  static const double _aspect = 1227 / 1170;

  /// Where each green board's top edge sits, as a fraction of the artwork
  /// height — a box in that bay stands on this line. Measured off the source
  /// PNG (bands at y=295/580/863/1148 of 1227).
  static const List<double> _boardTop = [0.2404, 0.4727, 0.7033, 0.9356];

  /// Usable width of a bay, as fractions of the artwork width (the rack's
  /// opaque area runs 0.065..0.932; inset slightly for the side rails).
  static const double _bayLeft = 0.085;
  static const double _bayRight = 0.915;

  static const int columns = 3;
  static int get rows => _boardTop.length;
  static int get slots => rows * columns;

  /// Box height as a fraction of the artwork height. A bay is ~0.232 tall, so
  /// this leaves a little headroom above each box.
  static const double _boxHeight = 0.17;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        final double height = width * _aspect;
        final double columnWidth = (_bayRight - _bayLeft) / columns * width;
        final double boxHeight = _boxHeight * height;

        return SizedBox(
          width: width,
          height: height,
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(AppImages.mysteryBoxShelf, fit: BoxFit.fill),
              ),
              for (int i = 0; i < boxes.length && i < slots; i++)
                Positioned(
                  left: _bayLeft * width + (i % columns) * columnWidth,
                  // Sit the box on the board rather than floating above it.
                  bottom: height - _boardTop[i ~/ columns] * height - 2,
                  width: columnWidth,
                  height: boxHeight,
                  child: _ShelfBox(
                    box: boxes[i],
                    onTap: () => onTap(boxes[i]),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

/// A gift box on the shelf with its coin price tag.
class _ShelfBox extends StatelessWidget {
  const _ShelfBox({required this.box, required this.onTap});

  final MySteryBoxList box;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final String image = box.mysteryBoxImage ?? "";
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Positioned.fill(
            child: image.isEmpty
                ? const _GiftArt()
                : Image.network(
                    image,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const _GiftArt(),
                  ),
          ),
          _PriceTag(amount: box.amountpaid ?? "0"),
        ],
      ),
    );
  }
}

class _GiftArt extends StatelessWidget {
  const _GiftArt();

  @override
  Widget build(BuildContext context) {
    return Image.asset(AppImages.mysteryBoxGift, fit: BoxFit.contain);
  }
}

/// White pill showing the box price in coins, overlaid on the box front.
class _PriceTag extends StatelessWidget {
  const _PriceTag({required this.amount});

  final String amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20.h,
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      margin: EdgeInsets.only(bottom: 6.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.94),
        borderRadius: BorderRadius.circular(6.r),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(AppImages.shopStar, width: 12.w, height: 15.h),
          SizedBox(width: 4.w),
          Text(
            amount,
            style: TextStyle(
              fontFamily: AppFonts.family,
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              color: kShopBlue,
            ),
          ),
        ],
      ),
    );
  }
}
