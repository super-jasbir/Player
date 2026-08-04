import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:player/base_controller.dart';

import '../data/modal/MySteryBoxDetailsResponse.dart';
import '../data/modal/MySteryBoxResponse.dart';
import '../data/network/api_endpoints.dart';

/// Backs the new mystery-box UI. It talks to the same endpoints the old
/// [MerchantController] screens used (`get-mysterybox-list` /
/// `get-mysterybox-detail`) so the API contract is unchanged.
class MysteryBoxController extends BaseController {
  /// Shared between the shelf and the detail screen. Going through `Get.put`
  /// in each `build` would replace the instance and re-fetch the list on
  /// every rebuild.
  static MysteryBoxController get to => Get.isRegistered<MysteryBoxController>()
      ? Get.find<MysteryBoxController>()
      : Get.put(MysteryBoxController());

  final RxList<MySteryBoxList> boxes = <MySteryBoxList>[].obs;
  final Rx<MySteryBoxDetails?> detail = Rx<MySteryBoxDetails?>(null);

  final RxBool loadingList = false.obs;
  final RxBool loadingDetail = false.obs;

  /// Shelf slots in the design: 3 columns x 4 rows.
  static const int shelfSlots = 12;

  // onReady, not onInit: the controller is created during a build, and
  // fetchList() -> getProfile() writes an observable synchronously, which
  // would mark the top bar's Obx dirty mid-build. onReady runs after the
  // first frame instead.
  @override
  void onReady() {
    super.onReady();
    fetchList();
  }

  Future<void> fetchList() async {
    loadingList.value = true;
    appController.getProfile(() {
      apiService
          .getRequest(ApiEndPoint.mySteryBoxList, isBearer: true)
          .then((value) {
        loadingList.value = false;
        if (value.data != null) {
          final parsed = MySteryBoxResponse.fromJson(
            value.data as Map<String, dynamic>,
          ).data;
          boxes.assignAll(parsed ?? <MySteryBoxList>[]);
        } else {
          Fluttertoast.showToast(msg: value.error.toString());
        }
      });
    });
  }

  Future<void> fetchDetail(String id) async {
    loadingDetail.value = true;
    detail.value = null;
    apiService
        .getRequest("${ApiEndPoint.mySteryBoxDetail}mysteryBox_id=$id",
            isBearer: true)
        .then((value) {
      loadingDetail.value = false;
      if (value.data != null) {
        detail.value = MySteryBoxDetailsResponse.fromJson(
          value.data as Map<String, dynamic>,
        ).data;
      } else {
        Fluttertoast.showToast(msg: value.error.toString());
      }
    });
  }

  /// Price shown on the shelf tag / payment sheet, defaulting to the design's
  /// placeholder when the API has not answered yet.
  String priceOf(MySteryBoxList? box) => box?.amountpaid ?? "5";

  String nameOf(MySteryBoxDetails? box) =>
      (box?.mysteryBoxNameEn?.isNotEmpty ?? false)
          ? box!.mysteryBoxNameEn!
          : "Time Controller";

  String descriptionOf(MySteryBoxDetails? box) =>
      (box?.description?.isNotEmpty ?? false)
          ? box!.description!
          : "it's a power that help you boost your time.";
}
