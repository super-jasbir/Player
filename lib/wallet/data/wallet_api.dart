import '../models/wallet_data.dart';

/// Data source for the wallet screen.
///
/// The screen talks only to this interface, so swapping the mock for the real
/// backend later is a one-line change in [WalletController] — implement
/// [WalletApi] with a `dio`/`ApiService` call that returns the same
/// [WalletData] shape and drop it in.
abstract class WalletApi {
  Future<WalletData> fetchWallet();
}

/// Temporary in-memory implementation used until the real endpoint exists.
///
/// Returns the exact values from the Figma design after a short delay so the
/// screen exercises its real loading state. Replace with a networked
/// implementation when the API is ready — the JSON below mirrors the expected
/// response body, so `WalletData.fromJson(response.data)` will drop straight
/// in.
class MockWalletApi implements WalletApi {
  const MockWalletApi();

  static const Map<String, dynamic> _mockResponse = {
    'totalBalance': '99,999.00',
    'points': '999,999',
    'maskedCardNumber': '**** **** **** 4829',
    'howToUse': [
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do '
          'eiusmod tempor incididunt ut labore et dolore magna aliqua.',
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do '
          'eiusmod tempor incididunt ut labore et dolore magna aliqua.',
    ],
    'transactions': [
      {
        'points': r'$50',
        'quantity': 2,
        'date': '16-01-2026',
        'time': '59:59:59',
        'item': 'T-shirt',
      },
      {
        'points': r'$100',
        'quantity': 2,
        'date': '25-01-2026',
        'time': '59:59:59',
        'item': 'Umbrella',
      },
      {
        'points': r'$50',
        'quantity': 2,
        'date': '10-02-2026',
        'time': '59:59:59',
        'item': 'Cap',
      },
    ],
  };

  @override
  Future<WalletData> fetchWallet() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return WalletData.fromJson(_mockResponse);
  }
}
