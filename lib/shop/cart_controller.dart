import 'package:get/get.dart';

import 'models/shop_product.dart';

/// Holds the cart and the saved delivery addresses for the shop flow.
///
/// Everything lives in memory for now — persistence / the orders API can be
/// dropped in behind these same methods.
class CartController extends GetxController {
  /// The one shared cart. Screens must go through this instead of `Get.put`,
  /// which would register a fresh (empty) controller on every rebuild.
  static CartController get to => Get.isRegistered<CartController>()
      ? Get.find<CartController>()
      : Get.put(CartController(), permanent: true);

  static const num shippingFee = 2.99;

  final RxList<ShopCartItem> items = <ShopCartItem>[].obs;
  final RxList<ShopAddress> addresses = <ShopAddress>[...kDemoAddresses].obs;
  final RxInt selectedAddress = 0.obs;

  ShopAddress? get deliveryAddress =>
      addresses.isEmpty ? null : addresses[selectedAddress.value];

  /// Total number of units, not lines — matches the "(5 items)" label.
  int get itemCount => items.fold(0, (sum, i) => sum + i.quantity);

  num get cashTotal => items.fold<num>(0, (sum, i) => sum + i.cashTotal);

  int get coinTotal => items.fold(0, (sum, i) => sum + i.coinTotal);

  num get subtotal => items.isEmpty ? 0 : cashTotal + shippingFee;

  void add(ShopProduct product, {String? size, String? colour, int quantity = 1}) {
    final existing =
        items.firstWhereOrNull((i) => i.matches(product, size, colour));
    if (existing != null) {
      existing.quantity += quantity;
      items.refresh();
      return;
    }
    items.add(
      ShopCartItem(
        product: product,
        size: size,
        colour: colour,
        quantity: quantity,
      ),
    );
  }

  void increase(ShopCartItem item) {
    item.quantity++;
    items.refresh();
  }

  /// Decreasing past one leaves the line at one; use [remove] to delete it.
  void decrease(ShopCartItem item) {
    if (item.quantity <= 1) return;
    item.quantity--;
    items.refresh();
  }

  void remove(ShopCartItem item) => items.remove(item);

  void addAddress(ShopAddress address) {
    addresses.add(address);
    selectedAddress.value = addresses.length - 1;
  }

  void selectAddress(int index) => selectedAddress.value = index;

  String money(num value) => "\$${value.toStringAsFixed(value % 1 == 0 ? 0 : 2)}";
}
