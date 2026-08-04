import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../common_widgets.dart';
import '../core/theme/app_fonts.dart';
import '../routes/app_routes.dart';
import 'cart_controller.dart';
import 'models/shop_product.dart';
import 'shop_controller.dart';
import 'widgets/shop_chrome.dart';
import 'widgets/shop_glass_card.dart';
import 'widgets/shop_widgets.dart';

/// Product detail: gallery, price, size / colour choices, description and the
/// quantity stepper, with ADD TO CART pinned below the glass card.
///
/// Opens with the summary passed through `Get.arguments` and backfills from
/// `get-redeemableItem-detail`.
class ShopDetailScreen extends StatefulWidget {
  const ShopDetailScreen({super.key});

  @override
  State<ShopDetailScreen> createState() => _ShopDetailScreenState();
}

class _ShopDetailScreenState extends State<ShopDetailScreen> {
  final CartController cart = CartController.to;
  final ShopController shop = ShopController.to;

  final PageController _gallery = PageController();
  int _page = 0;

  String? _size;
  String? _colour;
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    final summary = Get.arguments as ShopProduct?;
    if (summary != null) shop.loadDetail(summary);
  }

  @override
  void dispose() {
    _gallery.dispose();
    super.dispose();
  }

  void _addToCart(ShopProduct product) {
    cart.add(product, size: _size, colour: _colour, quantity: _quantity);
    Get.toNamed(AppRoutes.shopCart);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        final product = shop.selected.value;
        return Stack(
          fit: StackFit.expand,
          children: [
            const ShopBackground(blurred: true),
            const ShopTopBar(),
            Positioned(
              left: 10.w,
              top: 86.h,
              width: 370.w,
              height: 619.h,
              child: product == null
                  ? const Center(child: CircularProgressIndicator())
                  : _detailCard(product),
            ),
            Positioned(
              left: 10.w,
              top: 751.h,
              width: 370.w,
              child: AppButton(
                title: "ADD TO CART",
                radius: 16,
                isDisabled: product == null,
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
                onPressed: () => product == null ? null : _addToCart(product),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _detailCard(ShopProduct product) {
    // Sizes / colours only exist once the API sends swatches; until then the
    // sections collapse and everything below moves up.
    final bool hasSizes = product.sizes.isNotEmpty;
    final bool hasColours = product.colours.isNotEmpty;

    return ShopGlassCard(
      radius: 20,
      boxShadow: kShopGlassShadow,
      padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ShopBackButton(color: kShopBlue),
          SizedBox(height: 4.h),
          SizedBox(height: 170.h, child: _galleryView(product)),
          SizedBox(height: 10.h),
          _dots(product.gallery.length),
          SizedBox(height: 12.h),
          Text(
            product.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: AppFonts.family,
              fontSize: 24.sp,
              fontWeight: FontWeight.w900,
              color: kShopBlue,
              height: 1.15,
            ),
          ),
          SizedBox(height: 14.h),

          const ShopSectionLabel("Price"),
          SizedBox(height: 6.h),
          Row(
            children: [
              ShopBrandPill(
                label: "${product.coinPrice}",
                showCoin: true,
                width: 50,
              ),
              SizedBox(width: 10.w),
              ShopBrandPill(label: product.cashLabel, width: 61),
            ],
          ),

          if (hasSizes) ...[
            SizedBox(height: 14.h),
            const ShopSectionLabel("Sizes"),
            SizedBox(height: 6.h),
            _options(
              product.sizes,
              selected: _size,
              onSelect: (v) => setState(() => _size = v),
            ),
          ],
          if (hasColours) ...[
            SizedBox(height: 14.h),
            const ShopSectionLabel("Colour"),
            SizedBox(height: 6.h),
            _options(
              product.colours,
              selected: _colour,
              onSelect: (v) => setState(() => _colour = v),
            ),
          ],

          SizedBox(height: 16.h),
          const ShopSectionLabel("Description", fontSize: 13),
          SizedBox(height: 6.h),
          Expanded(
            child: Text(
              // The API description runs to hundreds of words; the card shows
              // a short preview only.
              _preview(product.description),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: AppFonts.family,
                fontSize: 12.sp,
                color: Colors.black,
                height: 1.35,
              ),
            ),
          ),

          Align(
            child: ShopQtyStepper(
              quantity: _quantity,
              onIncrease: () => setState(() => _quantity++),
              onDecrease: () =>
                  setState(() => _quantity = _quantity > 1 ? _quantity - 1 : 1),
            ),
          ),
        ],
      ),
    );
  }

  /// First paragraph of the description, collapsed to a single flowing line.
  String _preview(String description) {
    final String text = description.replaceAll('\r', '').trim();
    if (text.isEmpty) return "";
    final String firstParagraph = text.split('\n\n').first;
    return firstParagraph.replaceAll('\n', ' ').trim();
  }

  Widget _galleryView(ShopProduct product) {
    final images = product.gallery;
    if (images.isEmpty) return const ShopProductImage(url: "");
    return PageView.builder(
      controller: _gallery,
      itemCount: images.length,
      onPageChanged: (i) => setState(() => _page = i),
      itemBuilder: (_, i) => ShopProductImage(url: images[i]),
    );
  }

  Widget _dots(int count) {
    if (count < 2) return SizedBox(height: 5.w);
    return Align(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < count; i++)
            Container(
              width: 5.w,
              height: 5.w,
              margin: EdgeInsets.symmetric(horizontal: 2.5.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: i == _page ? kShopBlue : const Color(0xFFBFD7E5),
              ),
            ),
        ],
      ),
    );
  }

  Widget _options(
    List<String> values, {
    required String? selected,
    required ValueChanged<String> onSelect,
  }) {
    return Wrap(
      spacing: 10.w,
      runSpacing: 8.h,
      children: [
        for (final value in values)
          ShopBrandPill(
            label: value,
            width: 50,
            selected: value == selected,
            onTap: () => onSelect(value),
          ),
      ],
    );
  }
}
