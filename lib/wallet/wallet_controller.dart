import 'package:get/get.dart';

import 'data/wallet_api.dart';
import 'models/wallet_data.dart';

/// Backs the wallet screen. Loads [WalletData] from a [WalletApi] — currently
/// [MockWalletApi], swap it here once the real endpoint is wired up.
class WalletController extends GetxController {
  WalletController({WalletApi? api}) : _api = api ?? const MockWalletApi();

  final WalletApi _api;

  final Rx<WalletData?> wallet = Rx<WalletData?>(null);
  final RxBool loading = false.obs;

  /// Whether the "How to use" note on the balance card is expanded. Hidden by
  /// default; toggled by the info icon next to the balance.
  final RxBool showHowToUse = false.obs;

  void toggleHowToUse() => showHowToUse.toggle();

  @override
  void onInit() {
    super.onInit();
    fetchWallet();
  }

  Future<void> fetchWallet() async {
    loading.value = true;
    try {
      wallet.value = await _api.fetchWallet();
    } finally {
      loading.value = false;
    }
  }
}
