import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:player/base_controller.dart';

import '../data/modal/RedeemableItemResponse.dart';
import '../data/network/api_endpoints.dart';
import 'models/shop_product.dart';

/// The three orderings offered by the "Sort by" dropdown in Figma.
enum ShopSort {
  priceLowToHigh("Price: lowest to high"),
  priceHighToLow("Price: high to lowest"),
  newest("Newest");

  const ShopSort(this.label);

  final String label;
}

/// Backs the shop grid and detail screen off the redeemable-item API
/// (`get-redeemableItem-list` / `get-redeemableItem-detail`), the same
/// endpoints the older redeemable screens use.
class ShopController extends BaseController {
  static ShopController get to => Get.isRegistered<ShopController>()
      ? Get.find<ShopController>()
      : Get.put(ShopController());

  final RxList<ShopProduct> catalogue = <ShopProduct>[].obs;
  final RxBool loadingList = false.obs;

  /// The product currently open on the detail screen, merged from the grid
  /// summary and the detail response.
  final Rx<ShopProduct?> selected = Rx<ShopProduct?>(null);
  final RxBool loadingDetail = false.obs;

  final RxString query = "".obs;
  final Rx<ShopSort?> sort = Rx<ShopSort?>(null);

  /// Whether the sort dropdown is currently open.
  final RxBool sortMenuOpen = false.obs;

  // onReady, not onInit: the controller is created during a build and
  // getProfile() writes observables synchronously, which would mark the top
  // bar's Obx dirty mid-build.
  @override
  void onReady() {
    super.onReady();
    fetchCatalogue();
  }

  Future<void> fetchCatalogue() async {
    loadingList.value = true;
    appController.getProfile(() {
      apiService
          .getRequest(ApiEndPoint.redeemableList, isBearer: true)
          .then((value) {
        loadingList.value = false;
        if (value.data != null) {
          final items = RedeemableItemResponse.fromJson(
                value.data as Map<String, dynamic>,
              ).data ??
              <RedeemableItemList>[];
          catalogue.assignAll(items.map(ShopProduct.fromListItem));
        } else {
          Fluttertoast.showToast(msg: value.error.toString());
        }
      });
    });
  }

  /// Opens [summary] on the detail screen and backfills it from the detail
  /// endpoint, so the screen shows the grid data immediately.
  Future<void> loadDetail(ShopProduct summary) async {
    selected.value = summary;
    if (summary.id.isEmpty) return;

    loadingDetail.value = true;
    apiService
        .getRequest("${ApiEndPoint.redeemableDetail}id=${summary.id}",
            isBearer: true)
        .then((value) {
      loadingDetail.value = false;
      if (value.data != null) {
        final details = RedeemableDetailsResponse.fromJson(
          value.data as Map<String, dynamic>,
        ).data;
        if (details != null) {
          selected.value = summary.mergedWith(ShopProduct.fromDetails(details));
        }
      } else {
        Fluttertoast.showToast(msg: value.error.toString());
      }
    });
  }

  /// The catalogue after the search filter and the chosen ordering.
  List<ShopProduct> get products {
    final String q = query.value.trim().toLowerCase();
    final List<ShopProduct> list = q.isEmpty
        ? List.of(catalogue)
        : catalogue.where((p) => p.name.toLowerCase().contains(q)).toList();

    switch (sort.value) {
      case ShopSort.priceLowToHigh:
        list.sort((a, b) => a.cashPrice.compareTo(b.cashPrice));
      case ShopSort.priceHighToLow:
        list.sort((a, b) => b.cashPrice.compareTo(a.cashPrice));
      // "Newest" keeps the API order, which is newest-first.
      case ShopSort.newest:
      case null:
        break;
    }
    return list;
  }

  void onQueryChanged(String value) => query.value = value;

  void toggleSortMenu() => sortMenuOpen.value = !sortMenuOpen.value;

  void selectSort(ShopSort value) {
    sort.value = value;
    sortMenuOpen.value = false;
  }
}
